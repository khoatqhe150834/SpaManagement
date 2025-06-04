package controller;

import dao.ServiceDAO;
import dao.ServiceTypeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Service;
import model.ServiceType;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ServiceController", urlPatterns = {"/service"})
public class ServiceController extends HttpServlet {

    private final ServiceDAO serviceDAO = new ServiceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("service");

        if ("viewByServiceType".equals(action)) {
            int serviceTypeId = Integer.parseInt(request.getParameter("id"));

            ServiceTypeDAO stDAO = new ServiceTypeDAO();
            ServiceType st = stDAO.findById(serviceTypeId).orElse(null);

            List<Service> services = serviceDAO.findByServiceTypeId(serviceTypeId);

            // Gán attribute sau khi đã lấy dữ liệu
            request.setAttribute("stype", st);
            request.setAttribute("services", services);

            request.getRequestDispatcher("WEB-INF/view/admin_pages/ViewServiceDetails.jsp")
                    .forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chưa dùng đến POST trong controller này
    }
}
