package controller;

import dao.CustomerDAO;
import dao.EmailVerificationTokenDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Optional;
import model.Customer;
import model.EmailVerificationToken;

/**
 * Servlet to handle email verification when users click the verification link
 */
@WebServlet(name = "EmailVerificationController", urlPatterns = { "/verify-email" })
public class EmailVerificationController extends HttpServlet {

  private final EmailVerificationTokenDAO tokenDAO;
  private final CustomerDAO customerDAO;

  public EmailVerificationController() {
    this.tokenDAO = new EmailVerificationTokenDAO();
    this.customerDAO = new CustomerDAO();
  }

  /**
   * Handles the HTTP <code>GET</code> method for email verification
   */
  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    String token = request.getParameter("token");

    // Check if token parameter exists
    if (token == null || token.trim().isEmpty()) {
      request.setAttribute("error", "Token xác thực không hợp lệ.");
      request.getRequestDispatcher("/WEB-INF/view/auth/verification-result.jsp").forward(request, response);
      return;
    }

    try {
      // Find the token in database
      EmailVerificationToken verificationToken = tokenDAO.findByToken(token);

      if (verificationToken == null) {
        request.setAttribute("error", "Token xác thực không tồn tại hoặc đã hết hạn.");
        request.getRequestDispatcher("/WEB-INF/view/auth/verification-result.jsp").forward(request, response);
        return;
      }

      // Check if token is valid (not expired and not used)
      if (!tokenDAO.isValid(token)) {
        request.setAttribute("error", "Token xác thực đã hết hạn hoặc đã được sử dụng.");
        request.getRequestDispatcher("/WEB-INF/view/auth/verification-result.jsp").forward(request, response);
        return;
      }

      // Get customer by email
      Optional<Customer> customerOpt = customerDAO.findCustomerByEmail(verificationToken.getUserEmail());

      if (customerOpt.isEmpty()) {
        request.setAttribute("error", "Không tìm thấy tài khoản với email này.");
        request.getRequestDispatcher("/WEB-INF/view/auth/verification-result.jsp").forward(request, response);
        return;
      }

      Customer customer = customerOpt.get();

      // Check if customer is already verified
      if (customer.getIsVerified() != null && customer.getIsVerified()) {
        request.setAttribute("success", "Tài khoản của bạn đã được xác thực trước đó.");
        request.setAttribute("email", customer.getEmail());
        request.getRequestDispatcher("/WEB-INF/view/auth/verification-result.jsp").forward(request, response);
        return;
      }

      // Update customer verification status
      customer.setIsVerified(true);
      customerDAO.update(customer);

      // Mark token as used
      tokenDAO.markAsUsed(token);

      // Success response
      request.setAttribute("success", "Xác thực email thành công! Tài khoản của bạn đã được kích hoạt.");
      request.setAttribute("email", customer.getEmail());
      request.setAttribute("canLogin", true);

      // Forward to result page
      request.getRequestDispatcher("/WEB-INF/view/auth/verification-result.jsp").forward(request, response);

    } catch (SQLException e) {
      e.printStackTrace();
      request.setAttribute("error", "Có lỗi xảy ra trong quá trình xác thực. Vui lòng thử lại sau.");
      request.getRequestDispatcher("/WEB-INF/view/auth/verification-result.jsp").forward(request, response);
    }
  }

  /**
   * Handle POST requests (redirect to GET)
   */
  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    doGet(request, response);
  }

  @Override
  public String getServletInfo() {
    return "Email Verification Controller";
  }
}