package controller;

import dao.CustomerDAO;
import dao.EmailVerificationTokenDAO;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Customer;
import model.EmailVerificationToken;

/**
 * Controller for handling email verification requests
 * Processes email verification tokens and updates customer verification status
 */
@WebServlet(name = "EmailVerificationController", urlPatterns = { "/verify-email" })
public class EmailVerificationController extends HttpServlet {

  private static final Logger LOGGER = Logger.getLogger(EmailVerificationController.class.getName());

  private CustomerDAO customerDAO;
  private EmailVerificationTokenDAO tokenDAO;

  @Override
  public void init(ServletConfig config) throws ServletException {
    super.init(config);
    customerDAO = new CustomerDAO();
    tokenDAO = new EmailVerificationTokenDAO();
  }

  /**
   * Handles GET requests for email verification
   */
  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    String token = request.getParameter("token");

    if (token == null || token.trim().isEmpty()) {
      LOGGER.warning("Email verification attempted without token");
      request.setAttribute("error", "Token xác thực không hợp lệ hoặc bị thiếu.");
      forwardToResult(request, response);
      return;
    }

    try {
      // Find the token in database
      EmailVerificationToken verificationToken = tokenDAO.findByToken(token);

      if (verificationToken == null) {
        LOGGER.warning("Token not found: " + token);
        request.setAttribute("error", "Token xác thực không tồn tại hoặc đã hết hạn.");
        forwardToResult(request, response);
        return;
      }

      // Check if token is valid (not expired and not used)
      if (!tokenDAO.isValid(token)) {
        LOGGER.warning("Invalid or expired token: " + token);
        request.setAttribute("error",
            "Token xác thực đã hết hạn hoặc đã được sử dụng. Vui lòng yêu cầu gửi lại email xác thực.");
        forwardToResult(request, response);
        return;
      }

      // Find the customer by email
      String userEmail = verificationToken.getUserEmail();
      Customer customer = customerDAO.findCustomerByEmail(userEmail).orElse(null);

      if (customer == null) {
        LOGGER.warning("Customer not found for email: " + userEmail);
        request.setAttribute("error", "Không tìm thấy tài khoản khách hàng tương ứng với email này.");
        forwardToResult(request, response);
        return;
      }

      // Check if customer is already verified
      if (customer.getIsVerified() != null && customer.getIsVerified()) {
        LOGGER.info("Customer already verified: " + userEmail);
        request.setAttribute("success",
            "Email của bạn đã được xác thực trước đó. Bạn có thể đăng nhập và sử dụng dịch vụ.");
        request.setAttribute("email", userEmail);
        forwardToResult(request, response);
        return;
      }

      // Update customer verification status
      boolean updateSuccess = customerDAO.updateCustomerVerificationStatus(userEmail, true);

      if (!updateSuccess) {
        LOGGER.severe("Failed to update customer verification status for: " + userEmail);
        request.setAttribute("error", "Có lỗi xảy ra khi cập nhật trạng thái xác thực. Vui lòng thử lại sau.");
        forwardToResult(request, response);
        return;
      }

      // Mark token as used
      tokenDAO.markAsUsed(token);

      LOGGER.info("Successfully verified email for customer: " + userEmail);
      request.setAttribute("success",
          "Email của bạn đã được xác thực thành công! Bạn có thể đăng nhập và sử dụng tất cả các dịch vụ của chúng tôi.");
      request.setAttribute("email", userEmail);

      // Store login data in session for auto-prefill after verification
      HttpSession session = request.getSession();
      session.setAttribute("verificationLoginEmail", userEmail);
      // Don't store password here as it's not available in verification flow

    } catch (SQLException e) {
      LOGGER.log(Level.SEVERE, "Database error during email verification for token: " + token, e);
      request.setAttribute("error", "Có lỗi hệ thống xảy ra. Vui lòng thử lại sau hoặc liên hệ hỗ trợ.");
    } catch (Exception e) {
      LOGGER.log(Level.SEVERE, "Unexpected error during email verification for token: " + token, e);
      request.setAttribute("error", "Có lỗi không mong đợi xảy ra. Vui lòng thử lại sau.");
    }

    forwardToResult(request, response);
  }

  /**
   * Handle POST requests by redirecting to GET
   */
  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    doGet(request, response);
  }

  /**
   * Forward request to verification result page
   */
  private void forwardToResult(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    request.getRequestDispatcher("/WEB-INF/view/auth/verification-result.jsp").forward(request, response);
  }
}