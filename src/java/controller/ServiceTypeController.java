package controller;

import dao.ServiceTypeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.ServiceType;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ServiceTypeController", urlPatterns = {"/servicetype"})
public class ServiceTypeController extends HttpServlet {

    private final String SERVICE_TYPE = "test_service.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String service = request.getParameter("service");
        if (service == null || service.equals("list-all")) {
            List<ServiceType> serviceTypes = (new ServiceTypeDAO()).findAll();
            request.setAttribute("serviceTypes", serviceTypes);
            request.getRequestDispatcher(SERVICE_TYPE).forward(request, response);
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String service = request.getParameter("service");

        if (service != null && service.equals("insert")) {
            // Lấy dữ liệu từ form gửi lên
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String imageUrl = request.getParameter("image_url");
            boolean isActive = request.getParameter("is_active") != null;

            ServiceType st = new ServiceType();
            st.setName(name);
            st.setDescription(description);
            st.setImageUrl(imageUrl);
            st.setActive(isActive);

            new ServiceTypeDAO().save(st);

            // Chuyển hướng về danh sách sau khi thêm thành công
            response.sendRedirect("servicetype");
        } else {
            // Nếu không phải action hợp lệ, có thể redirect hoặc báo lỗi
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action in POST");
        }
    }

    @Override
    public String getServletInfo() {
        return "Controller for managing ServiceType CRUD operations";
    }
}
