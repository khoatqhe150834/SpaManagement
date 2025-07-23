package controller;

import dao.ServiceDAO;
import dao.ServiceTypeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.ServiceType;

import java.io.File;
import java.io.IOException;
import java.util.List;
import model.Service;
import util.ImageUploadUtil;
import util.CloudinaryConfig;

@WebServlet(name = "ServiceTypeController", urlPatterns = { "/manager/servicetype" })
@MultipartConfig(fileSizeThreshold = 0, maxFileSize = 2097152, // 2MB
        maxRequestSize = 2097152)
public class ServiceTypeController extends HttpServlet {

    private final String SERVICE_TYPE_URL = "/WEB-INF/view/admin_pages/Service_Type/ServiceTypeManager.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String service = request.getParameter("service");

        if (service == null || service.isEmpty()) {
            service = "list-all";
        }

        ServiceTypeDAO dao = new ServiceTypeDAO();

        int limit = 5; // Giá trị mặc định
        String limitParam = request.getParameter("limit");
        if (limitParam != null && !limitParam.isEmpty()) {
            try {
                limit = Integer.parseInt(limitParam);
            } catch (NumberFormatException ignored) {
            }
        }

        switch (service) {
            case "list-all": {
                int page = 1;
                if (request.getParameter("page") != null) {
                    try {
                        page = Integer.parseInt(request.getParameter("page"));
                    } catch (NumberFormatException ignored) {
                    }
                }
                int offset = (page - 1) * limit;

                List<ServiceType> serviceTypes = dao.findPaginated(offset, limit);
                int totalRecords = dao.countAll();
                int totalPages = (int) Math.ceil((double) totalRecords / limit);

                int start = totalRecords == 0 ? 0 : offset + 1;
                int end = Math.min(offset + serviceTypes.size(), totalRecords);

                request.setAttribute("limit", limit);
                request.setAttribute("serviceTypes", serviceTypes);
                request.setAttribute("currentPage", page);
                request.setAttribute("totalPages", totalPages);
                request.setAttribute("totalEntries", totalRecords);
                request.setAttribute("start", start);
                request.setAttribute("end", end);

                request.getRequestDispatcher(SERVICE_TYPE_URL).forward(request, response);
                break;
            }

            case "pre-insert": {
                String page = request.getParameter("page");
                String keyword = request.getParameter("keyword");
                String status = request.getParameter("status");
                request.setAttribute("page", page);
                request.setAttribute("limit", limit);
                request.setAttribute("keyword", keyword);
                request.setAttribute("status", status);
                request.getRequestDispatcher("/WEB-INF/view/admin_pages/Service_Type/AddServiceType.jsp")
                        .forward(request, response);
                break;
            }

            case "pre-update": {
                int id = Integer.parseInt(request.getParameter("id"));
                ServiceType st = dao.findById(id).orElse(null);
                String page = request.getParameter("page");
                String keyword = request.getParameter("keyword");
                String status = request.getParameter("status");
                request.setAttribute("stype", st);
                request.setAttribute("page", page);
                request.setAttribute("limit", limit);
                request.setAttribute("keyword", keyword);
                request.setAttribute("status", status);
                request.getRequestDispatcher("/WEB-INF/view/admin_pages/Service_Type/UpdateServiceType.jsp")
                        .forward(request, response);
                break;
            }

            case "delete": {
                int id = Integer.parseInt(request.getParameter("id"));
                dao.deleteById(id);
                response.sendRedirect("servicetype");
                break;
            }

            case "searchByKeywordAndStatus": {
                String keyword = request.getParameter("keyword");
                String status = request.getParameter("status");

                // Thêm phân trang cho kết quả tìm kiếm
                int page = 1;
                if (request.getParameter("page") != null) {
                    try {
                        page = Integer.parseInt(request.getParameter("page"));
                    } catch (NumberFormatException ignored) {
                    }
                }
                int offset = (page - 1) * limit;

                List<ServiceType> serviceTypes = dao.searchByKeywordAndStatus(keyword, status, offset, limit);
                int totalRecords = dao.countSearchResult(keyword, status);
                int totalPages = (int) Math.ceil((double) totalRecords / limit);

                int start = totalRecords == 0 ? 0 : offset + 1;
                int end = Math.min(offset + serviceTypes.size(), totalRecords);

                request.setAttribute("keyword", keyword);
                request.setAttribute("status", status);
                request.setAttribute("serviceTypes", serviceTypes);
                request.setAttribute("limit", limit);
                request.setAttribute("currentPage", page);
                request.setAttribute("totalPages", totalPages);
                request.setAttribute("totalEntries", totalRecords);
                request.setAttribute("start", start);
                request.setAttribute("end", end);

                request.getRequestDispatcher(SERVICE_TYPE_URL).forward(request, response);
                break;
            }

            case "deactiveById": {
                int id = Integer.parseInt(request.getParameter("id"));
                int n = dao.deactiveById(id);

                if (n == 1) {
                    request.setAttribute("toastType", "success");
                    request.setAttribute("toastMessage", "Deactivate Service Type (Id = " + id + ") done!");
                } else {
                    request.setAttribute("toastType", "error");
                    request.setAttribute("toastMessage", "Failed to deactivate Service Type (Id = " + id
                            + ") because it is associated with an order.");
                }

                // Lấy tham số truy vấn để redirect giữ nguyên trang
                String page = request.getParameter("page");
                String keyword = request.getParameter("keyword");
                String status = request.getParameter("status");
                StringBuilder redirectUrl = new StringBuilder("servicetype?service=list-all");
                if (page != null)
                    redirectUrl.append("&page=").append(page);
                if (limitParam != null)
                    redirectUrl.append("&limit=").append(limitParam);
                if (keyword != null && !keyword.isEmpty())
                    redirectUrl.append("&keyword=").append(keyword);
                if (status != null && !status.isEmpty())
                    redirectUrl.append("&status=").append(status);
                response.sendRedirect(redirectUrl.toString());
                break;
            }

            case "activateById": {
                int id = Integer.parseInt(request.getParameter("id"));
                dao.activateById(id);

                // Lấy tham số truy vấn để redirect giữ nguyên trang
                String page = request.getParameter("page");
                String keyword = request.getParameter("keyword");
                String status = request.getParameter("status");
                StringBuilder redirectUrl = new StringBuilder("servicetype?service=list-all");
                if (page != null)
                    redirectUrl.append("&page=").append(page);
                if (limitParam != null)
                    redirectUrl.append("&limit=").append(limitParam);
                if (keyword != null && !keyword.isEmpty())
                    redirectUrl.append("&keyword=").append(keyword);
                if (status != null && !status.isEmpty())
                    redirectUrl.append("&status=").append(status);
                response.sendRedirect(redirectUrl.toString());
                break;
            }

            case "check-duplicate-name": {
                String name = request.getParameter("name");
                String idParam = request.getParameter("id");
                boolean isDuplicate;
                if (idParam != null && !idParam.isEmpty()) {
                    int id = Integer.parseInt(idParam);
                    isDuplicate = dao.existsByNameExceptId(name, id);
                } else {
                    isDuplicate = dao.existsByName(name);
                }
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                String message = isDuplicate ? "Tên này đã tồn tại trong hệ thống." : "Tên có thể sử dụng.";
                response.getWriter().write("{\"valid\": " + !isDuplicate + ", \"message\": \"" + message + "\"}");
                break;
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String service = request.getParameter("service");

        if (service.equals("insert") || service.equals("update")) {
            Part filePart = request.getPart("image");
            String fileName = getSubmittedFileName(filePart);

            String imageUrl = request.getParameter("image_url"); // Default: old image or manual input
            boolean isUpdate = service.equals("update");
            Integer serviceTypeId = null;
            if (isUpdate) {
                serviceTypeId = Integer.parseInt(request.getParameter("id"));
            }
            // Validate and upload to Cloudinary if a new file is provided
            if (fileName != null && !fileName.isEmpty() && filePart.getSize() > 0) {
                // Validate file
                util.ImageUploadUtil.ValidationResult validation = util.ImageUploadUtil.validateFile(filePart);
                if (!validation.isValid()) {
                    request.setAttribute("toastType", "error");
                    request.setAttribute("toastMessage", validation.getErrorsAsString());
                    request.getRequestDispatcher("/WEB-INF/view/admin_pages/Service_Type/AddServiceType.jsp").forward(request, response);
                    return;
                }
                // Validate image dimensions
                util.ImageUploadUtil.ValidationResult dimensionValidation = util.ImageUploadUtil.validateImageDimensions(filePart.getInputStream());
                if (!dimensionValidation.isValid()) {
                    request.setAttribute("toastType", "error");
                    request.setAttribute("toastMessage", dimensionValidation.getErrorsAsString());
                    request.getRequestDispatcher("/WEB-INF/view/admin_pages/Service_Type/AddServiceType.jsp").forward(request, response);
                    return;
                }
                // If update, delete old Cloudinary image if exists
                if (isUpdate && imageUrl != null && imageUrl.contains("cloudinary.com")) {
                    try {
                        util.CloudinaryConfig.deleteImageByUrl(imageUrl);
                    } catch (Exception e) {
                        // Log and continue
                    }
                }
                // Upload to Cloudinary
                byte[] fileBytes;
                try (java.io.InputStream inputStream = filePart.getInputStream();
                     java.io.ByteArrayOutputStream baos = new java.io.ByteArrayOutputStream()) {
                    byte[] buffer = new byte[8192];
                    int bytesRead;
                    while ((bytesRead = inputStream.read(buffer)) != -1) {
                        baos.write(buffer, 0, bytesRead);
                    }
                    fileBytes = baos.toByteArray();
                }
                String publicId;
                if (isUpdate && serviceTypeId != null) {
                    publicId = "service-types/" + serviceTypeId + "/" + java.util.UUID.randomUUID();
                } else {
                    publicId = "service-types/" + java.util.UUID.randomUUID();
                }
                java.util.Map<String, Object> uploadResult = util.CloudinaryConfig.uploadImage(fileBytes, publicId);
                imageUrl = (String) uploadResult.get("secure_url"); // Save Cloudinary URL
            }

            String name = request.getParameter("name");
            String description = request.getParameter("description");
            boolean isActive = request.getParameter("is_active") != null;

            ServiceType st = new ServiceType();
            if (isUpdate) {
                st.setServiceTypeId(serviceTypeId);
            }
            st.setName(name);
            st.setDescription(description);
            st.setImageUrl(imageUrl);
            st.setActive(isActive);

            if (service.equals("insert")) {
                new ServiceTypeDAO().save(st);
            } else {
                new ServiceTypeDAO().update(st);
            }

            response.sendRedirect("servicetype");
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action in POST");
        }
    }

    private String getSubmittedFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }

    @Override
    public String getServletInfo() {
        return "Controller for managing ServiceType CRUD operations";
    }
}
