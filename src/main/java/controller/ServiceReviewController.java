package controller;

import dao.ServiceReviewDAO;
import model.ServiceReview;
import model.User;
import dao.BookingDAO;
import model.Booking;
import dao.ServiceTypeDAO;
import model.ServiceType;
import dao.ServiceDAO;
import model.Service;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "ServiceReviewController", urlPatterns = {"/manager/service-review", "/customer/service-review/add"})
public class ServiceReviewController extends HttpServlet {
    private ServiceReviewDAO reviewDAO = new ServiceReviewDAO();
    private ServiceTypeDAO serviceTypeDAO = new ServiceTypeDAO();
    private ServiceDAO serviceDAO = new ServiceDAO();
    private BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        String action = request.getParameter("action");
        if (action == null) action = "list";

        // Xử lý cho customer add review
        if ("/customer/service-review/add".equals(path)) {
            String bookingIdStr = request.getParameter("bookingId");
            if (bookingIdStr == null) {
                response.sendRedirect(request.getContextPath() + "/customer/booking-history");
                return;
            }
            int bookingId = Integer.parseInt(bookingIdStr);
            Booking booking = null;
            try {
                booking = bookingDAO.findById(bookingId).orElse(null);
            } catch (Exception e) {
                booking = null;
            }
            ServiceReview review = null;
            try {
                review = reviewDAO.getReviewByBookingId(bookingId);
            } catch (Exception e) {
                review = null;
            }
            if (booking == null) {
                response.sendRedirect(request.getContextPath() + "/customer/booking-history");
                return;
            }
            request.setAttribute("booking", booking);
            request.setAttribute("review", review); // null nếu chưa có
            request.getRequestDispatcher("/WEB-INF/view/admin_pages/ServiceReview/AddServiceReview.jsp").forward(request, response);
            return;
        }

        // Ưu tiên xử lý action=edit trước
        if ("/manager/service-review".equals(path) && "edit".equals(action)) {
            String ridStr = request.getParameter("rid");
            if (ridStr != null) {
                try {
                    int reviewId = Integer.parseInt(ridStr);
                    ServiceReview review = reviewDAO.getReviewById(reviewId);
                    if (review != null) {
                        request.setAttribute("review", review);
                        request.getRequestDispatcher("/WEB-INF/view/admin_pages/ServiceReview/ReviewRespond.jsp").forward(request, response);
                        return;
                    }
                } catch (Exception e) {
                    // log lỗi nếu cần
                }
            }
            response.sendRedirect(request.getContextPath() + "/manager/service-review");
            return;
        }

        // Các action khác (list, ...)
        switch (action) {
            case "list":
            default: {
                int limit = 5;
                int page = 1;
                String limitParam = request.getParameter("limit");
                if (limitParam != null && !limitParam.isEmpty()) {
                    try { limit = Integer.parseInt(limitParam); } catch (Exception ignored) {}
                }
                String pageParam = request.getParameter("page");
                if (pageParam != null && !pageParam.isEmpty()) {
                    try { page = Integer.parseInt(pageParam); } catch (Exception ignored) {}
                }
                int offset = (page - 1) * limit;
                String keyword = request.getParameter("keyword");
                String serviceIdParam = request.getParameter("serviceId");
                Integer serviceId = null;
                if (serviceIdParam != null && !serviceIdParam.isEmpty()) {
                    try { serviceId = Integer.parseInt(serviceIdParam); } catch (Exception ignored) {}
                }
                String replyStatus = request.getParameter("replyStatus");
                try {
                    List<ServiceReview> reviews = reviewDAO.searchReviews(keyword, serviceId, offset, limit, replyStatus);
                    int totalRecords = reviewDAO.countSearchResult(keyword, serviceId, replyStatus);
                    int totalPages = (int) Math.ceil((double) totalRecords / limit);
                    List<Service> services = serviceDAO.findAll();
                    request.setAttribute("reviews", reviews);
                    request.setAttribute("services", services);
                    request.setAttribute("keyword", keyword);
                    request.setAttribute("serviceId", serviceId);
                    request.setAttribute("replyStatus", replyStatus);
                    request.setAttribute("currentPage", page);
                    request.setAttribute("totalPages", totalPages);
                    request.setAttribute("totalEntries", totalRecords);
                    request.setAttribute("limit", limit);
                    int start = totalRecords == 0 ? 0 : offset + 1;
                    int end = Math.min(offset + reviews.size(), totalRecords);
                    request.setAttribute("start", start);
                    request.setAttribute("end", end);
                } catch (Exception e) {
                    request.setAttribute("errorMessage", "Lỗi tải danh sách đánh giá: " + e.getMessage());
                }
                request.getRequestDispatcher("/WEB-INF/view/admin_pages/ServiceReview/ServiceReviewManager.jsp").forward(request, response);
                break;
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        HttpSession session = request.getSession(false);
        try {
            if ("/customer/service-review/add".equals(path)) {
                int bookingId = Integer.parseInt(request.getParameter("bookingId"));
                int serviceId = Integer.parseInt(request.getParameter("serviceId"));
                int therapistUserId = Integer.parseInt(request.getParameter("therapistUserId"));
                int rating = Integer.parseInt(request.getParameter("rating"));
                String title = request.getParameter("title");
                String comment = request.getParameter("comment");
                // Lấy customerId từ session/customer object nếu cần
                Integer customerId = null;
                if (session != null && session.getAttribute("customer") != null) {
                    model.Customer customer = (model.Customer) session.getAttribute("customer");
                    customerId = customer.getCustomerId();
                } else {
                    customerId = Integer.parseInt(request.getParameter("customerId"));
                }
                ServiceReview existingReview = null;
                try {
                    existingReview = reviewDAO.getReviewByBookingId(bookingId);
                } catch (Exception e) { existingReview = null; }
                boolean success = false;
                if (existingReview != null) {
                    // Update review
                    existingReview.setRating(rating);
                    existingReview.setTitle(title);
                    existingReview.setComment(comment);
                    existingReview.setTherapistUserId(therapistUserId);
                    existingReview.setServiceId(serviceId);
                    existingReview.setVisible(true);
                    success = reviewDAO.updateReview(existingReview); // cần thêm hàm này
                } else {
                    // Add review mới
                    ServiceReview review = new ServiceReview();
                    review.setServiceId(serviceId);
                    review.setCustomerId(customerId);
                    review.setBookingId(bookingId);
                    review.setTherapistUserId(therapistUserId);
                    review.setRating(rating);
                    review.setTitle(title);
                    review.setComment(comment);
                    review.setVisible(true);
                    review.setManagerReply("");
                    success = reviewDAO.addReview(review);
                }
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/customer/booking-history");
                } else {
                    request.setAttribute("error", "Không thể lưu đánh giá. Vui lòng thử lại.");
                    Booking booking = bookingDAO.findById(bookingId).orElse(null);
                    ServiceReview review = reviewDAO.getReviewByBookingId(bookingId);
                    request.setAttribute("booking", booking);
                    request.setAttribute("review", review);
                    request.getRequestDispatcher("/WEB-INF/view/admin_pages/ServiceReview/AddServiceReview.jsp").forward(request, response);
                }
                return;
            } else if ("/manager/service-review".equals(path) && "reply".equals(request.getParameter("action"))) {
                // Chỉ MANAGER được phản hồi review
                User user = (User) session.getAttribute("user");
                if (user == null || user.getRoleId() != 2) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }
                int reviewId = Integer.parseInt(request.getParameter("reviewId"));
                String reply = request.getParameter("managerReply");
                boolean success = reviewDAO.updateManagerReply(reviewId, reply);
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/manager/service-review");
                } else {
                    request.setAttribute("error", "Không thể cập nhật phản hồi.");
                    doGet(request, response);
                }
                return;
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/view/error.jsp").forward(request, response);
        }
    }
} 