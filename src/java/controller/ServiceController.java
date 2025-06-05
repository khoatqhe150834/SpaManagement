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
import java.math.BigDecimal;
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
        } else if ("pre-insert".equals(action)) {
            int serviceTypeId = Integer.parseInt(request.getParameter("stypeId"));
            ServiceTypeDAO dao = new ServiceTypeDAO();
            ServiceType stype = dao.findById(serviceTypeId).orElse(null);

            if (stype == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Service Type not found");
                return;
            }

            request.setAttribute("stype", stype);
            request.getRequestDispatcher("WEB-INF/view/admin_pages/AddService.jsp").forward(request, response);
            return;
        } else {
            // ONLY sendError if không rơi vào case nào
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action.");
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("service");

        if ("insert".equals(action)) {
            int stypeId = Integer.parseInt(request.getParameter("stypeId"));
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String imageUrl = request.getParameter("imageUrl");
            boolean isActive = request.getParameter("isActive") != null;
            boolean bookableOnline = request.getParameter("bookableOnline") != null;
            boolean requiresConsultation = request.getParameter("requiresConsultation") != null;

            BigDecimal price = new BigDecimal(request.getParameter("price"));
            int duration = Integer.parseInt(request.getParameter("durationMinutes"));
            int buffer = Integer.parseInt(request.getParameter("bufferTimeAfterMinutes"));

            Service s = new Service();
            s.setName(name);
            s.setDescription(description);
            s.setImageUrl(imageUrl);
            s.setIsActive(isActive);
            s.setBookableOnline(bookableOnline);
            s.setRequiresConsultation(requiresConsultation);
            s.setPrice(price);
            s.setDurationMinutes(duration);
            s.setBufferTimeAfterMinutes(buffer);

            ServiceType stype = new ServiceTypeDAO().findById(stypeId).orElse(null);
            s.setServiceTypeId(stype);

            new ServiceDAO().save(s);

            response.sendRedirect("service?service=viewByServiceType&id=" + stypeId);
        }
    }

}
