package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "CustomerDashboardTestController", urlPatterns = { "/cust/*" })
public class CustomerDashboardTestController extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    String path = request.getPathInfo();
    if (path == null || path.equals("/") || path.equals("/dashboard")) {
      request.getRequestDispatcher("/WEB-INF/view/customer/dashboard/dashboard.jsp").forward(request, response);
    } else if (path.startsWith("/appointments")) {
      if (path.equals("/appointments/booking")) {
        request.getRequestDispatcher("/WEB-INF/view/customer/appointments/booking.jsp").forward(request, response);
      } else if (path.equals("/appointments/details")) {
        request.getRequestDispatcher("/WEB-INF/view/customer/appointments/details.jsp").forward(request, response);
      } else if (path.equals("/appointments/reschedule")) {
        request.getRequestDispatcher("/WEB-INF/view/customer/appointments/reschedule.jsp").forward(request, response);
      } else {
        request.getRequestDispatcher("/WEB-INF/view/customer/appointments/list.jsp").forward(request, response);
      }
    } else if (path.startsWith("/treatments")) {
      if (path.equals("/treatments/details")) {
        request.getRequestDispatcher("/WEB-INF/view/customer/treatments/details.jsp").forward(request, response);
      } else if (path.equals("/treatments/feedback")) {
        request.getRequestDispatcher("/WEB-INF/view/customer/treatments/feedback.jsp").forward(request, response);
      } else {
        request.getRequestDispatcher("/WEB-INF/view/customer/treatments/history.jsp").forward(request, response);
      }
    } else if (path.startsWith("/rewards")) {
      if (path.equals("/rewards/points")) {
        request.getRequestDispatcher("/WEB-INF/view/customer/rewards/points.jsp").forward(request, response);
      } else if (path.equals("/rewards/rewards-list")) {
        request.getRequestDispatcher("/WEB-INF/view/customer/rewards/rewards-list.jsp").forward(request, response);
      } else if (path.equals("/rewards/redeem")) {
        request.getRequestDispatcher("/WEB-INF/view/customer/rewards/redeem.jsp").forward(request, response);
      } else {
        request.getRequestDispatcher("/WEB-INF/view/customer/rewards/points.jsp").forward(request, response);
      }
    } else if (path.startsWith("/recommendations")) {
      if (path.equals("/recommendations/services")) {
        request.getRequestDispatcher("/WEB-INF/view/customer/recommendations/services.jsp").forward(request, response);
      } else if (path.equals("/recommendations/personalized")) {
        request.getRequestDispatcher("/WEB-INF/view/customer/recommendations/personalized.jsp").forward(request,
            response);
      } else {
        request.getRequestDispatcher("/WEB-INF/view/customer/recommendations/services.jsp").forward(request, response);
      }
    } else if (path.startsWith("/reviews")) {
      if (path.equals("/reviews/my-reviews")) {
        request.getRequestDispatcher("/WEB-INF/view/customer/reviews/my-reviews.jsp").forward(request, response);
      } else if (path.equals("/reviews/write-review")) {
        request.getRequestDispatcher("/WEB-INF/view/customer/reviews/write-review.jsp").forward(request, response);
      } else if (path.equals("/reviews/review-details")) {
        request.getRequestDispatcher("/WEB-INF/view/customer/reviews/review-details.jsp").forward(request, response);
      } else {
        request.getRequestDispatcher("/WEB-INF/view/customer/reviews/my-reviews.jsp").forward(request, response);
      }
    } else if (path.startsWith("/billing")) {
      if (path.equals("/billing/payments")) {
        request.getRequestDispatcher("/WEB-INF/view/customer/billing/payments.jsp").forward(request, response);
      } else if (path.equals("/billing/invoices")) {
        request.getRequestDispatcher("/WEB-INF/view/customer/billing/invoices.jsp").forward(request, response);
      } else if (path.equals("/billing/payment-methods")) {
        request.getRequestDispatcher("/WEB-INF/view/customer/billing/payment-methods.jsp").forward(request, response);
      } else {
        request.getRequestDispatcher("/WEB-INF/view/customer/billing/payments.jsp").forward(request, response);
      }
    } else if (path.startsWith("/dashboard/profile")) {
      request.getRequestDispatcher("/WEB-INF/view/customer/dashboard/profile.jsp").forward(request, response);
    } else if (path.startsWith("/dashboard/notifications")) {
      request.getRequestDispatcher("/WEB-INF/view/customer/dashboard/notifications.jsp").forward(request, response);
    } else {
      // Default to dashboard
      request.getRequestDispatcher("/WEB-INF/view/customer/dashboard/dashboard.jsp").forward(request, response);
    }
  }
}