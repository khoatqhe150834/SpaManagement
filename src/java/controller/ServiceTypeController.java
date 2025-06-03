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

    private final String SERVICE_TYPE_URL = "WEB-INF/view/admin_pages/ServiceTypeManager.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String service = request.getParameter("service");

        if (service == null) {
            service = "list-all";
        }

        if (service.equals("list-all")) {
            List<ServiceType> serviceTypes = (new ServiceTypeDAO()).findAll();
            request.setAttribute("serviceTypes", serviceTypes);
            request.getRequestDispatcher(SERVICE_TYPE_URL).forward(request, response);
        }

        if (service.equals("pre-insert")) {
            request.getRequestDispatcher("WEB-INF/view/admin_pages/AddServiceType.jsp").forward(request, response);
        }

        if (service.equals("pre-update")) {
            int id = Integer.parseInt(request.getParameter("id"));
            ServiceTypeDAO dao = new ServiceTypeDAO();
            ServiceType st = dao.findById(id).orElse(null);
            request.setAttribute("stype", st);
            request.getRequestDispatcher("WEB-INF/view/admin_pages/UpdateServiceType.jsp").forward(request, response);
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

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String service = request.getParameter("service");

        if (service.equals("insert")) {
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
            response.sendRedirect("servicetype");

        } else if (service.equals("update")) {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String imageUrl = request.getParameter("image_url");
            boolean isActive = request.getParameter("is_active") != null;

            ServiceType st = new ServiceType();
            st.setServiceTypeId(id);
            st.setName(name);
            st.setDescription(description);
            st.setImageUrl(imageUrl);
            st.setActive(isActive);

            new ServiceTypeDAO().update(st);
            response.sendRedirect("servicetype");

        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action in POST");
        }
    }

    @Override
    public String getServletInfo() {
        return "Controller for managing ServiceType CRUD operations";
    }
}
