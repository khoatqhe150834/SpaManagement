package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import dao.ServiceDAO;
import dao.ServiceImageDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.Service;
import model.ServiceImage;
import util.ImageUploadUtil;
import util.ImageUploadUtil.ProcessedImageResult;
import util.ImageUploadUtil.ValidationResult;
import util.ErrorHandler;

/**
 * Controller for handling service image uploads
 * Supports both single service and batch upload functionality
 */
@WebServlet(name = "ServiceImageUploadController", urlPatterns = {"/manager/service-images/*"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,     // 1MB
    maxFileSize = 2 * 1024 * 1024,       // 2MB
    maxRequestSize = 10 * 1024 * 1024    // 10MB for batch uploads
)
public class ServiceImageUploadController extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(ServiceImageUploadController.class.getName());
    private ServiceDAO serviceDAO;
    private ServiceImageDAO serviceImageDAO;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        serviceDAO = new ServiceDAO();
        serviceImageDAO = new ServiceImageDAO();
        gson = new Gson();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        String action = pathInfo != null ? pathInfo.substring(1) : "";
        
        switch (action) {
            case "single-upload":
                showSingleUploadPage(request, response);
                break;
            case "batch-upload":
                showBatchUploadPage(request, response);
                break;
            case "manage":
                showImageManagementPage(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/manager/service");
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        String action = pathInfo != null ? pathInfo.substring(1) : "";
        
        switch (action) {
            case "upload-single":
                handleSingleUpload(request, response);
                break;
            case "upload-batch":
                handleBatchUpload(request, response);
                break;
            case "set-primary":
                handleSetPrimary(request, response);
                break;
            case "update-order":
                handleUpdateOrder(request, response);
                break;
            case "delete":
                handleDeleteImage(request, response);
                break;
            default:
                sendErrorResponse(response, "Invalid action");
                break;
        }
    }
    
    /**
     * Shows the single service image upload page
     */
    private void showSingleUploadPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String serviceIdParam = request.getParameter("serviceId");
        if (serviceIdParam == null) {
            response.sendRedirect(request.getContextPath() + "/manager/service");
            return;
        }
        
        try {
            Integer serviceId = Integer.parseInt(serviceIdParam);
            Optional<Service> serviceOpt = serviceDAO.findById(serviceId);
            
            if (!serviceOpt.isPresent()) {
                response.sendRedirect(request.getContextPath() + "/manager/service");
                return;
            }
            
            Service service = serviceOpt.get();
            List<ServiceImage> existingImages = serviceImageDAO.findByServiceId(serviceId);
            
            request.setAttribute("service", service);
            request.setAttribute("existingImages", existingImages);
            request.getRequestDispatcher("/WEB-INF/view/admin_pages/Service/SingleImageUpload.jsp")
                   .forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/manager/service");
        }
    }
    
    /**
     * Shows the batch upload page
     */
    private void showBatchUploadPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Service> services = serviceDAO.findAll();
        request.setAttribute("services", services);
        request.getRequestDispatcher("/WEB-INF/view/admin_pages/Service/BatchImageUpload.jsp")
               .forward(request, response);
    }
    
    /**
     * Shows the image management page
     */
    private void showImageManagementPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String serviceIdParam = request.getParameter("serviceId");
        if (serviceIdParam != null) {
            try {
                Integer serviceId = Integer.parseInt(serviceIdParam);
                Optional<Service> serviceOpt = serviceDAO.findById(serviceId);
                List<ServiceImage> images = serviceImageDAO.findByServiceId(serviceId);
                
                request.setAttribute("service", serviceOpt.orElse(null));
                request.setAttribute("images", images);
            } catch (NumberFormatException e) {
                // Invalid service ID
            }
        }
        
        List<Service> services = serviceDAO.findAll();
        request.setAttribute("services", services);
        request.getRequestDispatcher("/WEB-INF/view/admin_pages/Service/ImageManagement.jsp")
               .forward(request, response);
    }
    
    /**
     * Handles single service image upload
     */
    private void handleSingleUpload(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            String serviceIdParam = request.getParameter("serviceId");
            JsonObject paramError = ErrorHandler.validateRequiredParameter(serviceIdParam, "Service ID");
            if (paramError != null) {
                sendJsonErrorResponse(response, paramError);
                return;
            }
            
            Integer serviceId = Integer.parseInt(serviceIdParam);
            Optional<Service> serviceOpt = serviceDAO.findById(serviceId);
            
            if (!serviceOpt.isPresent()) {
                sendErrorResponse(response, "Service not found");
                return;
            }
            
            // Ensure upload directories exist
            String webappPath = getServletContext().getRealPath("");
            ImageUploadUtil.ensureDirectoriesExist(webappPath);
            
            Collection<Part> fileParts = request.getParts();
            List<JsonObject> results = new ArrayList<>();
            int successCount = 0;
            int errorCount = 0;

            // Log the number of parts received
            LOGGER.info("Received " + fileParts.size() + " parts for service ID: " + serviceId);

            // Get the starting sort order for this batch
            Integer baseSortOrder = getNextSortOrder(serviceId);
            int sortOrderOffset = 0;

            LOGGER.info("Starting sort order: " + baseSortOrder);

            for (Part filePart : fileParts) {
                if (!"images".equals(filePart.getName()) || filePart.getSize() == 0) {
                    LOGGER.info("Skipping part: name=" + filePart.getName() + ", size=" + filePart.getSize());
                    continue;
                }

                String fileName = ImageUploadUtil.getSubmittedFileName(filePart);
                LOGGER.info("Processing file: " + fileName + " with sort order: " + (baseSortOrder + sortOrderOffset));

                JsonObject result = processImageUpload(filePart, serviceId, webappPath, baseSortOrder + sortOrderOffset);
                results.add(result);

                // Count successes and failures
                if (result.get("success").getAsBoolean()) {
                    successCount++;
                    sortOrderOffset++; // Only increment for successful uploads
                } else {
                    errorCount++;
                }
            }

            // Determine overall success based on individual results
            boolean overallSuccess = errorCount == 0 && successCount > 0;
            String message;
            if (overallSuccess) {
                message = String.format("All %d images uploaded successfully!", successCount);
            } else if (successCount > 0) {
                message = String.format("Partial success: %d uploaded, %d failed", successCount, errorCount);
            } else {
                message = "All uploads failed. Please check your files and try again.";
            }

            JsonObject response_obj = new JsonObject();
            response_obj.addProperty("success", overallSuccess);
            response_obj.addProperty("message", message);
            response_obj.addProperty("successCount", successCount);
            response_obj.addProperty("errorCount", errorCount);
            response_obj.addProperty("totalFiles", results.size());
            response_obj.add("results", gson.toJsonTree(results));
            
            PrintWriter out = response.getWriter();
            out.print(gson.toJson(response_obj));
            out.flush();
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in single upload", e);
            sendErrorResponse(response, "Upload failed: " + e.getMessage());
        }
    }
    
    /**
     * Processes a single image upload
     */
    private JsonObject processImageUpload(Part filePart, Integer serviceId, String webappPath) {
        return processImageUpload(filePart, serviceId, webappPath, null);
    }

    /**
     * Processes a single image upload with specified sort order
     */
    private JsonObject processImageUpload(Part filePart, Integer serviceId, String webappPath, Integer sortOrder) {
        JsonObject result = new JsonObject();
        
        try {
            // Validate file
            ValidationResult validation = ImageUploadUtil.validateFile(filePart);
            if (!validation.isValid()) {
                return ErrorHandler.handleFileValidationError(validation, ImageUploadUtil.getSubmittedFileName(filePart));
            }
            
            // Validate image dimensions
            ValidationResult dimensionValidation = ImageUploadUtil.validateImageDimensions(filePart.getInputStream());
            if (!dimensionValidation.isValid()) {
                return ErrorHandler.handleFileValidationError(dimensionValidation, ImageUploadUtil.getSubmittedFileName(filePart));
            }
            
            // Create ServiceImage entity first to get ID
            ServiceImage serviceImage = new ServiceImage();
            serviceImage.setServiceId(serviceId);
            serviceImage.setUrl(""); // Temporary, will be updated after processing
            serviceImage.setAltText("Service image");
            serviceImage.setIsPrimary(false);
            serviceImage.setSortOrder(sortOrder != null ? sortOrder : getNextSortOrder(serviceId));
            serviceImage.setIsActive(true);
            
            // Save to get the image ID
            ServiceImage savedImage = serviceImageDAO.save(serviceImage);
            if (savedImage == null || savedImage.getImageId() == null) {
                result.addProperty("success", false);
                result.addProperty("error", "Failed to save image record");
                return result;
            }
            
            // Process and save image files
            ProcessedImageResult processedResult = ImageUploadUtil.processAndSaveImage(
                filePart, webappPath, serviceId, savedImage.getImageId()
            );
            
            // Update the ServiceImage with the actual URL and metadata
            savedImage.setUrl(processedResult.getFullSizeUrl());
            savedImage.setFileSize(processedResult.getFileSize());
            serviceImageDAO.update(savedImage);
            
            result.addProperty("success", true);
            result.addProperty("imageId", savedImage.getImageId());
            result.addProperty("fileName", processedResult.getFileName());
            result.addProperty("fullSizeUrl", processedResult.getFullSizeUrl());
            result.addProperty("thumbnailUrl", processedResult.getThumbnailUrl());
            result.addProperty("fileSize", processedResult.getFileSize());
            
        } catch (Exception e) {
            return ErrorHandler.handleUploadError(e, ImageUploadUtil.getSubmittedFileName(filePart));
        }
        
        return result;
    }
    
    /**
     * Gets the next sort order for images of a service
     */
    private Integer getNextSortOrder(Integer serviceId) {
        List<ServiceImage> existingImages = serviceImageDAO.findByServiceId(serviceId);
        return existingImages.size();
    }
    
    /**
     * Handles batch upload for multiple services
     */
    private void handleBatchUpload(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            // Ensure upload directories exist
            String webappPath = getServletContext().getRealPath("");
            ImageUploadUtil.ensureDirectoriesExist(webappPath);

            Collection<Part> fileParts = request.getParts();
            List<JsonObject> results = new ArrayList<>();
            Map<String, String> serviceMapping = new HashMap<>();

            // Extract service mappings from request parameters
            for (String paramName : Collections.list(request.getParameterNames())) {
                if (paramName.startsWith("service_")) {
                    String fileName = paramName.substring(8); // Remove "service_" prefix
                    String serviceIdStr = request.getParameter(paramName);
                    if (serviceIdStr != null && !serviceIdStr.isEmpty()) {
                        serviceMapping.put(fileName, serviceIdStr);
                    }
                }
            }

            for (Part filePart : fileParts) {
                if (!"images".equals(filePart.getName()) || filePart.getSize() == 0) {
                    continue;
                }

                String fileName = ImageUploadUtil.getSubmittedFileName(filePart);
                JsonObject result = new JsonObject();
                result.addProperty("fileName", fileName);

                // Check if service is mapped for this file
                String serviceIdStr = serviceMapping.get(fileName);
                if (serviceIdStr == null || serviceIdStr.isEmpty()) {
                    result.addProperty("success", false);
                    result.addProperty("error", "No service selected for this file");
                    results.add(result);
                    continue;
                }

                try {
                    Integer serviceId = Integer.parseInt(serviceIdStr);
                    Optional<Service> serviceOpt = serviceDAO.findById(serviceId);

                    if (!serviceOpt.isPresent()) {
                        result.addProperty("success", false);
                        result.addProperty("error", "Service not found");
                        results.add(result);
                        continue;
                    }

                    // Process the image upload
                    JsonObject uploadResult = processImageUpload(filePart, serviceId, webappPath);
                    uploadResult.addProperty("serviceName", serviceOpt.get().getName());
                    results.add(uploadResult);

                } catch (NumberFormatException e) {
                    result.addProperty("success", false);
                    result.addProperty("error", "Invalid service ID");
                    results.add(result);
                }
            }

            // Calculate summary
            long successCount = results.stream().mapToLong(r -> r.get("success").getAsBoolean() ? 1 : 0).sum();
            long errorCount = results.size() - successCount;

            JsonObject response_obj = new JsonObject();
            response_obj.addProperty("success", true);
            response_obj.addProperty("message", String.format("Batch upload completed: %d successful, %d failed", successCount, errorCount));
            response_obj.addProperty("successCount", successCount);
            response_obj.addProperty("errorCount", errorCount);
            response_obj.add("results", gson.toJsonTree(results));

            PrintWriter out = response.getWriter();
            out.print(gson.toJson(response_obj));
            out.flush();

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in batch upload", e);
            sendErrorResponse(response, "Batch upload failed: " + e.getMessage());
        }
    }
    
    /**
     * Handles setting primary image
     */
    private void handleSetPrimary(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        
        try {
            String imageIdParam = request.getParameter("imageId");
            String serviceIdParam = request.getParameter("serviceId");
            
            if (imageIdParam == null || serviceIdParam == null) {
                sendErrorResponse(response, "Image ID and Service ID are required");
                return;
            }
            
            Integer imageId = Integer.parseInt(imageIdParam);
            Integer serviceId = Integer.parseInt(serviceIdParam);
            
            serviceImageDAO.setPrimaryImage(imageId, serviceId);
            
            JsonObject result = new JsonObject();
            result.addProperty("success", true);
            result.addProperty("message", "Primary image updated successfully");
            
            PrintWriter out = response.getWriter();
            out.print(gson.toJson(result));
            out.flush();
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error setting primary image", e);
            sendErrorResponse(response, "Failed to set primary image: " + e.getMessage());
        }
    }
    
    /**
     * Handles updating image order
     */
    private void handleUpdateOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        
        try {
            String orderParam = request.getParameter("order");
            if (orderParam == null) {
                sendErrorResponse(response, "Order parameter is required");
                return;
            }
            
            // Parse the order array (comma-separated image IDs)
            String[] imageIdStrings = orderParam.split(",");
            List<Integer> imageIds = new ArrayList<>();
            
            for (String idStr : imageIdStrings) {
                imageIds.add(Integer.parseInt(idStr.trim()));
            }
            
            serviceImageDAO.updateSortOrder(imageIds);
            
            JsonObject result = new JsonObject();
            result.addProperty("success", true);
            result.addProperty("message", "Image order updated successfully");
            
            PrintWriter out = response.getWriter();
            out.print(gson.toJson(result));
            out.flush();
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating image order", e);
            sendErrorResponse(response, "Failed to update image order: " + e.getMessage());
        }
    }
    
    /**
     * Handles image deletion
     */
    private void handleDeleteImage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        
        try {
            String imageIdParam = request.getParameter("imageId");
            if (imageIdParam == null) {
                sendErrorResponse(response, "Image ID is required");
                return;
            }
            
            Integer imageId = Integer.parseInt(imageIdParam);
            Optional<ServiceImage> imageOpt = serviceImageDAO.findById(imageId);
            
            if (imageOpt.isPresent()) {
                ServiceImage image = imageOpt.get();
                
                // Delete physical files
                String webappPath = getServletContext().getRealPath("");
                ImageUploadUtil.deleteImageFiles(webappPath, image.getUrl());
                
                // Delete database record
                serviceImageDAO.deleteById(imageId);
            }
            
            JsonObject result = new JsonObject();
            result.addProperty("success", true);
            result.addProperty("message", "Image deleted successfully");
            
            PrintWriter out = response.getWriter();
            out.print(gson.toJson(result));
            out.flush();
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error deleting image", e);
            sendErrorResponse(response, "Failed to delete image: " + e.getMessage());
        }
    }
    
    /**
     * Sends an error response in JSON format
     */
    private void sendErrorResponse(HttpServletResponse response, String message) throws IOException {
        ErrorHandler.sendJsonError(response, ErrorHandler.ERROR_INVALID_REQUEST, message);
    }

    /**
     * Sends a JSON error response object
     */
    private void sendJsonErrorResponse(HttpServletResponse response, JsonObject errorObject) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        out.print(gson.toJson(errorObject));
        out.flush();
    }
}
