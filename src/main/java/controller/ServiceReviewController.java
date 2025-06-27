package controller;

import dao.ServiceReviewDAO;
import dao.ServiceDAO;
import dao.CustomerDAO;
import dao.BookingAppointmentDAO;
import model.Service_Reviews;
import model.Service;
import model.Customer;
import model.BookingAppointment;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;
import java.util.Optional;

@WebServlet(name = "ServiceReviewController", urlPatterns = { "/service-review" })
public class ServiceReviewController extends HttpServlet {
    private final String MANAGER_URL = "/WEB-INF/view/admin_pages/ServiceReview/ServiceReviewManager.jsp";
    private final String ADD_URL = "/WEB-INF/view/admin_pages/ServiceReview/AddServiceReview.jsp";
    private final String UPDATE_URL = "/WEB-INF/view/admin_pages/ServiceReview/UpdateServiceReview.jsp";

    private ServiceReviewDAO reviewDAO = new ServiceReviewDAO();
    private ServiceDAO serviceDAO = new ServiceDAO();
    private CustomerDAO customerDAO = new CustomerDAO();
    private BookingAppointmentDAO appointmentDAO = new BookingAppointmentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        int limit = 5;
        int page = 1;
        try {
            if (request.getParameter("limit") != null)
                limit = Integer.parseInt(request.getParameter("limit"));
            if (request.getParameter("page") != null)
                page = Integer.parseInt(request.getParameter("page"));
        } catch (Exception ignored) {}
        int offset = (page - 1) * limit;

        switch (action) {
            case "add": {
                request.setAttribute("services", serviceDAO.findAll());
                request.setAttribute("customers", customerDAO.findAll());
                request.setAttribute("appointments", appointmentDAO.findAll());
                request.getRequestDispatcher(ADD_URL).forward(request, response);
                return;
            }
            case "edit": {
                int id = Integer.parseInt(request.getParameter("id"));
                Optional<Service_Reviews> reviewOpt = reviewDAO.findById(id);
                if (reviewOpt.isPresent()) {
                    request.setAttribute("review", reviewOpt.get());
                    request.setAttribute("services", serviceDAO.findAll());
                    request.setAttribute("customers", customerDAO.findAll());
                    request.setAttribute("appointments", appointmentDAO.findAll());
                    request.getRequestDispatcher(UPDATE_URL).forward(request, response);
                } else {
                    response.sendRedirect("/service-review?toastType=error&toastMessage=Review+not+found");
                }
                return;
            }
            case "delete": {
                int id = Integer.parseInt(request.getParameter("id"));
                reviewDAO.deleteById(id);
                response.sendRedirect("/service-review?toastType=success&toastMessage=Deleted+successfully");
                return;
            }
            default: {
                List<Service_Reviews> reviews = reviewDAO.findPaginated(offset, limit);
                int totalEntries = reviewDAO.countAll();
                int totalPages = (int) Math.ceil((double) totalEntries / limit);
                request.setAttribute("reviews", reviews);
                request.setAttribute("currentPage", page);
                request.setAttribute("totalPages", totalPages);
                request.setAttribute("totalEntries", totalEntries);
                request.setAttribute("limit", limit);
                request.getRequestDispatcher(MANAGER_URL).forward(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "add";

        int serviceId = Integer.parseInt(request.getParameter("service_id"));
        int customerId = Integer.parseInt(request.getParameter("customer_id"));
        int appointmentId = Integer.parseInt(request.getParameter("appointment_id"));
        int rating = Integer.parseInt(request.getParameter("rating"));
        String title = request.getParameter("title");
        String comment = request.getParameter("comment");
        Timestamp now = new Timestamp(System.currentTimeMillis());

        Service service = serviceDAO.findById(serviceId).orElse(null);
        Customer customer = customerDAO.findById(customerId).orElse(null);
        BookingAppointment appointment = appointmentDAO.findById(appointmentId).orElse(null);

        if (action.equals("add")) {
            Service_Reviews review = new Service_Reviews(0, service, customer, appointment, rating, title, comment, now, now);
            reviewDAO.save(review);
            response.sendRedirect("/admin/review?toastType=success&toastMessage=Added+successfully");
        } else if (action.equals("edit")) {
            int reviewId = Integer.parseInt(request.getParameter("review_id"));
            Service_Reviews review = new Service_Reviews(reviewId, service, customer, appointment, rating, title, comment, now, now);
            reviewDAO.update(review);
            response.sendRedirect("/service-review?toastType=success&toastMessage=Updated+successfully");
        }
    }
} 