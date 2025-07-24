package controller;

import dao.ServiceReviewDAO;
import model.ServiceReview;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "ServiceReviewController", urlPatterns = {"/manager/service-review"})
public class ServiceReviewController extends HttpServlet {
    private final ServiceReviewDAO reviewDAO = new ServiceReviewDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("list".equals(action)) {
                int serviceId = Integer.parseInt(request.getParameter("serviceId"));
                List<ServiceReview> reviews = reviewDAO.getReviewsByService(serviceId);
                request.setAttribute("reviews", reviews);
                request.getRequestDispatcher("/WEB-INF/view/customer/reviews/my-reviews.jsp").forward(request, response);
            } else if ("detail".equals(action)) {
                int reviewId = Integer.parseInt(request.getParameter("reviewId"));
                ServiceReview review = reviewDAO.getReviewById(reviewId);
                request.setAttribute("review", review);
                request.getRequestDispatcher("/WEB-INF/view/customer/reviews/review-details.jsp").forward(request, response);
            } else if ("edit".equals(action)) {
                int reviewId = Integer.parseInt(request.getParameter("id"));
                ServiceReview review = reviewDAO.getReviewById(reviewId);
                request.setAttribute("review", review);
                request.getRequestDispatcher("/WEB-INF/view/admin_pages/ServiceReview/ReviewRespond.jsp").forward(request, response);
            } else {
                // Nếu không có action, lấy toàn bộ review và forward về trang quản lý review cho manager
                List<ServiceReview> reviews = reviewDAO.getAllReviews();
                request.setAttribute("reviews", reviews);
                request.getRequestDispatcher("/WEB-INF/view/admin_pages/ServiceReview/ServiceReviewManager.jsp").forward(request, response);
            }
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);
        try {
            if ("add".equals(action)) {
                // Khách hàng tạo review
                ServiceReview review = new ServiceReview();
                review.setServiceId(Integer.parseInt(request.getParameter("serviceId")));
                review.setCustomerId(Integer.parseInt(request.getParameter("customerId")));
                review.setBookingId(Integer.parseInt(request.getParameter("bookingId")));
                review.setTherapistUserId(Integer.parseInt(request.getParameter("therapistUserId")));
                review.setRating(Integer.parseInt(request.getParameter("rating")));
                review.setTitle(request.getParameter("title"));
                review.setComment(request.getParameter("comment"));
                review.setVisible(true);
                review.setManagerReply("");
                boolean success = reviewDAO.addReview(review);
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/manager/service-review?action=list&serviceId=" + review.getServiceId());
                } else {
                    request.setAttribute("error", "Không thể thêm review. Vui lòng thử lại.");
                    request.getRequestDispatcher("/WEB-INF/view/customer/reviews/write-review.jsp").forward(request, response);
                }
            } else if ("reply".equals(action)) {
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
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/view/error.jsp").forward(request, response);
        }
    }
} 