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

@WebServlet(name = "ServiceTypeController", urlPatterns = {"/servicetype"})
@MultipartConfig(
    fileSizeThreshold = 0,
    maxFileSize = 2097152, // 2MB
    maxRequestSize = 2097152
)
public class ServiceTypeController extends HttpServlet {

    private final String SERVICE_TYPE_URL = "WEB-INF/view/admin_pages/Service_Type/ServiceTypeManager.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String service = request.getParameter("service");

        if (service == null) {
            service = "list-all";
        }

        if (service.equals("list-all")) {
            int page = 1;
            int limit = 5;

            if (request.getParameter("page") != null) {
                try {
                    page = Integer.parseInt(request.getParameter("page"));
                } catch (NumberFormatException ignored) {
                }
            }

            int offset = (page - 1) * limit;

            ServiceTypeDAO dao = new ServiceTypeDAO();
            List<ServiceType> serviceTypes = dao.findPaginated(offset, limit);
            int totalRecords = dao.countAll();
            int totalPages = (int) Math.ceil((double) totalRecords / limit);

            request.setAttribute("limit", limit);
            request.setAttribute("serviceTypes", serviceTypes);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalEntries", totalRecords); // optional: show "x of y entries"

            request.getRequestDispatcher(SERVICE_TYPE_URL).forward(request, response);
        }

        if (service.equals("pre-insert")) {
            request.getRequestDispatcher("WEB-INF/view/admin_pages/Service_Type/AddServiceType.jsp").forward(request, response);
        }

        if (service.equals("pre-update")) {
            int id = Integer.parseInt(request.getParameter("id"));
            ServiceTypeDAO dao = new ServiceTypeDAO();
            ServiceType st = dao.findById(id).orElse(null);
            request.setAttribute("stype", st);
            request.getRequestDispatcher("WEB-INF/view/admin_pages/Service_Type/UpdateServiceType.jsp").forward(request, response);
        }

        if (service.equals("delete")) {
            int id = Integer.parseInt(request.getParameter("id"));
            ServiceTypeDAO dao = new ServiceTypeDAO();
            dao.deleteById(id);
            response.sendRedirect("servicetype");
        }

        if (service.equals("searchByKeyword")) {
            String keyword = request.getParameter("keyword");
            List<ServiceType> serviceTypes = new ServiceTypeDAO().findByKeyword(keyword);

            if (serviceTypes == null || serviceTypes.isEmpty()) {
                request.setAttribute("notFoundServiceType", "Your keywords do not match with any Service Type");
                serviceTypes = (new ServiceTypeDAO()).findAll();
            }

            request.setAttribute("keyword", keyword);
            request.setAttribute("serviceTypes", serviceTypes);
            request.getRequestDispatcher(SERVICE_TYPE_URL).forward(request, response);
        }

        if (service.equals("searchByKeywordAndStatus")) {
            String keyword = request.getParameter("keyword");
            String status = request.getParameter("status"); // "active", "inactive", ""

            ServiceTypeDAO dao = new ServiceTypeDAO();
            List<ServiceType> serviceTypes = dao.searchByKeywordAndStatus(keyword, status);

            if (serviceTypes == null || serviceTypes.isEmpty()) {
                request.setAttribute("notFoundServiceType", "No matching service types found.");
                serviceTypes = dao.findAll(); // fallback
            }

            request.setAttribute("keyword", keyword);
            request.setAttribute("status", status);
            request.setAttribute("serviceTypes", serviceTypes);
            request.setAttribute("limit", serviceTypes.size()); // optional
            request.setAttribute("currentPage", 1);
            request.setAttribute("totalPages", 1);
            request.setAttribute("totalEntries", serviceTypes.size());

            request.getRequestDispatcher(SERVICE_TYPE_URL).forward(request, response);
        }

        if (service.equals("deactiveById")) {
            int id = Integer.parseInt(request.getParameter("id"));
            ServiceTypeDAO dao = new ServiceTypeDAO();
            int n = dao.deactiveById(id);

            if (n == 1) {
                request.setAttribute("toastType", "success");
                request.setAttribute("toastMessage", "Deactivate Service Type (Id = " + id + ") done!");
            } else {
                request.setAttribute("toastType", "error");
                request.setAttribute("toastMessage", "Failed to deactivate Service Type (Id = " + id + ") because it is associated with an order.");
            }

            // 👇 Gọi lại logic phân trang y như "list-all"
            int page = 1;
            int limit = 5;
            int offset = (page - 1) * limit;

            List<ServiceType> serviceTypes = dao.findPaginated(offset, limit);
            int totalRecords = dao.countAll();
            int totalPages = (int) Math.ceil((double) totalRecords / limit);

            request.setAttribute("limit", limit);
            request.setAttribute("serviceTypes", serviceTypes);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalEntries", totalRecords);

            request.getRequestDispatcher(SERVICE_TYPE_URL).forward(request, response);
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String service = request.getParameter("service");

        if (service.equals("insert") || service.equals("update")) {
            // Xử lý upload file
            Part filePart = request.getPart("image");
            String fileName = getSubmittedFileName(filePart);

            String imageUrl = request.getParameter("image_url"); // Giá trị mặc định là ảnh cũ hoặc nhập tay
            if (fileName != null && !fileName.isEmpty() && filePart.getSize() > 0) {
                // Nếu có upload file mới thì lưu file và lấy đường dẫn mới
                String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
                String uploadPath = getServletContext().getRealPath("/assets/uploads/service-types/");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                filePart.write(uploadPath + File.separator + uniqueFileName);
                imageUrl = request.getContextPath() + "/assets/uploads/service-types/" + uniqueFileName;
            }

            String name = request.getParameter("name");
            String description = request.getParameter("description");
            boolean isActive = request.getParameter("is_active") != null;

            ServiceType st = new ServiceType();
            if (service.equals("update")) {
                st.setServiceTypeId(Integer.parseInt(request.getParameter("id")));
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
