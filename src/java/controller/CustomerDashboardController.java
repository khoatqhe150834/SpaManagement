package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Customer;

/**
 * Customer Dashboard Controller
 * Handles all customer dashboard related routes and pages
 */
@WebServlet(name = "CustomerDashboardController", urlPatterns = { "/customer-dashboard/*" })
public class CustomerDashboardController extends HttpServlet {

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    // Check if customer is logged in
    HttpSession session = request.getSession(false);
    if (session == null || !Boolean.TRUE.equals(session.getAttribute("authenticated"))) {
      response.sendRedirect(request.getContextPath() + "/login");
      return;
    }

    // Get customer from session
    Customer customer = (Customer) session.getAttribute("customer");
    if (customer == null) {
      response.sendRedirect(request.getContextPath() + "/login");
      return;
    }

    // Set customer attribute for JSP access
    request.setAttribute("customer", customer);

    // Get the path info to determine which page to show
    String path = request.getPathInfo();

    try {
      if (path == null || path.equals("/") || path.equals("/dashboard")) {
        // Main dashboard page
        handleDashboard(request, response);
      } else if (path.startsWith("/appointments")) {
        // Appointment related pages
        handleAppointments(request, response, path);
      } else if (path.startsWith("/treatments")) {
        // Treatment history pages
        handleTreatments(request, response, path);
      } else if (path.startsWith("/rewards")) {
        // Rewards and points pages
        handleRewards(request, response, path);
      } else if (path.startsWith("/recommendations")) {
        // Recommendations pages
        handleRecommendations(request, response, path);
      } else if (path.startsWith("/reviews")) {
        // Reviews pages
        handleReviews(request, response, path);
      } else if (path.startsWith("/billing")) {
        // Billing and payments pages
        handleBilling(request, response, path);
      } else if (path.startsWith("/dashboard")) {
        // Dashboard sub-pages (profile, notifications)
        handleDashboardSubPages(request, response, path);
      } else {
        // Default to main dashboard
        handleDashboard(request, response);
      }
    } catch (Exception e) {
      // Log error and show error page
      request.setAttribute("error", "Đã xảy ra lỗi khi tải trang: " + e.getMessage());
      request.getRequestDispatcher("/WEB-INF/view/common/error.jsp").forward(request, response);
    }
  }

  /**
   * Handle main dashboard page
   */
  private void handleDashboard(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    // TODO: Load dashboard data (upcoming appointments, points, recent treatments,
    // etc.)
    // For now, just forward to the dashboard JSP
    request.getRequestDispatcher("/WEB-INF/view/customer/dashboard/dashboard.jsp").forward(request, response);
  }

  /**
   * Handle appointment related pages
   */
  private void handleAppointments(HttpServletRequest request, HttpServletResponse response, String path)
      throws ServletException, IOException {
    if (path.equals("/appointments/booking")) {
      // TODO: Load available services, therapists, time slots
      request.getRequestDispatcher("/WEB-INF/view/customer/appointments/booking.jsp").forward(request, response);
    } else if (path.equals("/appointments/upcoming")) {
      // TODO: Load upcoming appointments for the customer
      request.getRequestDispatcher("/WEB-INF/view/customer/appointments/upcoming.jsp").forward(request, response);
    } else if (path.equals("/appointments/history")) {
      // TODO: Load appointment history for the customer
      request.getRequestDispatcher("/WEB-INF/view/customer/appointments/history.jsp").forward(request, response);
    } else if (path.equals("/appointments/details")) {
      // TODO: Load specific appointment details
      request.getRequestDispatcher("/WEB-INF/view/customer/appointments/details.jsp").forward(request, response);
    } else if (path.equals("/appointments/reschedule")) {
      // TODO: Handle appointment rescheduling
      request.getRequestDispatcher("/WEB-INF/view/customer/appointments/reschedule.jsp").forward(request, response);
    } else {
      // Default to upcoming appointments
      request.getRequestDispatcher("/WEB-INF/view/customer/appointments/upcoming.jsp").forward(request, response);
    }
  }

  /**
   * Handle treatment history pages
   */
  private void handleTreatments(HttpServletRequest request, HttpServletResponse response, String path)
      throws ServletException, IOException {
    if (path.equals("/treatments/history")) {
      // TODO: Load treatment history for the customer
      request.getRequestDispatcher("/WEB-INF/view/customer/treatments/history.jsp").forward(request, response);
    } else if (path.equals("/treatments/details")) {
      // TODO: Load specific treatment details
      request.getRequestDispatcher("/WEB-INF/view/customer/treatments/details.jsp").forward(request, response);
    } else if (path.equals("/treatments/feedback")) {
      // TODO: Handle treatment feedback submission
      request.getRequestDispatcher("/WEB-INF/view/customer/treatments/feedback.jsp").forward(request, response);
    } else {
      // Default to treatment history
      request.getRequestDispatcher("/WEB-INF/view/customer/treatments/history.jsp").forward(request, response);
    }
  }

  /**
   * Handle rewards and points pages
   */
  private void handleRewards(HttpServletRequest request, HttpServletResponse response, String path)
      throws ServletException, IOException {
    if (path.equals("/rewards/points")) {
      // TODO: Load customer's points balance and history
      request.getRequestDispatcher("/WEB-INF/view/customer/rewards/points.jsp").forward(request, response);
    } else if (path.equals("/rewards/rewards-list")) {
      // TODO: Load available rewards for redemption
      request.getRequestDispatcher("/WEB-INF/view/customer/rewards/rewards-list.jsp").forward(request, response);
    } else if (path.equals("/rewards/redeem")) {
      // TODO: Handle reward redemption
      request.getRequestDispatcher("/WEB-INF/view/customer/rewards/redeem.jsp").forward(request, response);
    } else {
      // Default to points page
      request.getRequestDispatcher("/WEB-INF/view/customer/rewards/points.jsp").forward(request, response);
    }
  }

  /**
   * Handle recommendations pages
   */
  private void handleRecommendations(HttpServletRequest request, HttpServletResponse response, String path)
      throws ServletException, IOException {
    if (path.equals("/recommendations/services")) {
      // TODO: Load personalized service recommendations
      request.getRequestDispatcher("/WEB-INF/view/customer/recommendations/services.jsp").forward(request, response);
    } else if (path.equals("/recommendations/personalized")) {
      // TODO: Load personalized recommendations based on history
      request.getRequestDispatcher("/WEB-INF/view/customer/recommendations/personalized.jsp").forward(request,
          response);
    } else {
      // Default to services recommendations
      request.getRequestDispatcher("/WEB-INF/view/customer/recommendations/services.jsp").forward(request, response);
    }
  }

  /**
   * Handle reviews pages
   */
  private void handleReviews(HttpServletRequest request, HttpServletResponse response, String path)
      throws ServletException, IOException {
    if (path.equals("/reviews/my-reviews")) {
      // TODO: Load customer's reviews
      request.getRequestDispatcher("/WEB-INF/view/customer/reviews/my-reviews.jsp").forward(request, response);
    } else if (path.equals("/reviews/write-review")) {
      // TODO: Handle new review submission
      request.getRequestDispatcher("/WEB-INF/view/customer/reviews/write-review.jsp").forward(request, response);
    } else if (path.equals("/reviews/review-details")) {
      // TODO: Load specific review details
      request.getRequestDispatcher("/WEB-INF/view/customer/reviews/review-details.jsp").forward(request, response);
    } else {
      // Default to my reviews
      request.getRequestDispatcher("/WEB-INF/view/customer/reviews/my-reviews.jsp").forward(request, response);
    }
  }

  /**
   * Handle billing and payments pages
   */
  private void handleBilling(HttpServletRequest request, HttpServletResponse response, String path)
      throws ServletException, IOException {
    if (path.equals("/billing/payments")) {
      // TODO: Load payment history for the customer
      request.getRequestDispatcher("/WEB-INF/view/customer/billing/payments.jsp").forward(request, response);
    } else if (path.equals("/billing/invoices")) {
      // TODO: Load invoices for the customer
      request.getRequestDispatcher("/WEB-INF/view/customer/billing/invoices.jsp").forward(request, response);
    } else if (path.equals("/billing/payment-methods")) {
      // TODO: Handle payment method management
      request.getRequestDispatcher("/WEB-INF/view/customer/billing/payment-methods.jsp").forward(request, response);
    } else {
      // Default to payment history
      request.getRequestDispatcher("/WEB-INF/view/customer/billing/payments.jsp").forward(request, response);
    }
  }

  /**
   * Handle dashboard sub-pages (profile, notifications)
   */
  private void handleDashboardSubPages(HttpServletRequest request, HttpServletResponse response, String path)
      throws ServletException, IOException {
    if (path.equals("/dashboard/profile")) {
      // TODO: Load customer profile data
      request.getRequestDispatcher("/WEB-INF/view/customer/dashboard/profile.jsp").forward(request, response);
    } else if (path.equals("/dashboard/notifications")) {
      // TODO: Load customer notifications
      request.getRequestDispatcher("/WEB-INF/view/customer/dashboard/notifications.jsp").forward(request, response);
    } else {
      // Default to main dashboard
      handleDashboard(request, response);
    }
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    // Check if customer is logged in
    HttpSession session = request.getSession(false);
    if (session == null || !Boolean.TRUE.equals(session.getAttribute("authenticated"))) {
      response.sendRedirect(request.getContextPath() + "/login");
      return;
    }

    // Get customer from session
    Customer customer = (Customer) session.getAttribute("customer");
    if (customer == null) {
      response.sendRedirect(request.getContextPath() + "/login");
      return;
    }

    // Set customer attribute for JSP access
    request.setAttribute("customer", customer);

    // Get the path info to determine which action to handle
    String path = request.getPathInfo();

    try {
      if (path != null && path.startsWith("/dashboard/profile")) {
        // Handle profile updates
        handleProfileUpdate(request, response);
      } else if (path != null && path.startsWith("/appointments/booking")) {
        // Handle appointment booking
        handleAppointmentBooking(request, response);
      } else if (path != null && path.startsWith("/reviews/write-review")) {
        // Handle review submission
        handleReviewSubmission(request, response);
      } else if (path != null && path.startsWith("/rewards/redeem")) {
        // Handle reward redemption
        handleRewardRedemption(request, response);
      } else {
        // For other POST requests, redirect to GET
        doGet(request, response);
      }
    } catch (Exception e) {
      // Log error and show error page
      request.setAttribute("error", "Đã xảy ra lỗi khi xử lý yêu cầu: " + e.getMessage());
      request.getRequestDispatcher("/WEB-INF/view/common/error.jsp").forward(request, response);
    }
  }

  /**
   * Handle profile update submissions
   */
  private void handleProfileUpdate(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    // TODO: Implement profile update logic
    // For now, redirect back to profile page with success message
    request.setAttribute("successMessage", "Thông tin cá nhân đã được cập nhật thành công!");
    request.getRequestDispatcher("/WEB-INF/view/customer/dashboard/profile.jsp").forward(request, response);
  }

  /**
   * Handle appointment booking submissions
   */
  private void handleAppointmentBooking(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    // TODO: Implement appointment booking logic
    // For now, redirect back to booking page with success message
    request.setAttribute("successMessage", "Lịch hẹn đã được đặt thành công!");
    request.getRequestDispatcher("/WEB-INF/view/customer/appointments/booking.jsp").forward(request, response);
  }

  /**
   * Handle review submission
   */
  private void handleReviewSubmission(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    // TODO: Implement review submission logic
    // For now, redirect back to reviews page with success message
    request.setAttribute("successMessage", "Đánh giá của bạn đã được gửi thành công!");
    request.getRequestDispatcher("/WEB-INF/view/customer/reviews/my-reviews.jsp").forward(request, response);
  }

  /**
   * Handle reward redemption
   */
  private void handleRewardRedemption(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    // TODO: Implement reward redemption logic
    // For now, redirect back to rewards page with success message
    request.setAttribute("successMessage", "Phần thưởng đã được đổi thành công!");
    request.getRequestDispatcher("/WEB-INF/view/customer/rewards/points.jsp").forward(request, response);
  }
}