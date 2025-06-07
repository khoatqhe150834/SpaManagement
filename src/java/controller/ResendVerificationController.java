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
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Customer;
import model.EmailVerificationToken;
import service.email.AsyncEmailService;

/**
 * Controller for resending email verification
 */
@WebServlet(name = "ResendVerificationController", urlPatterns = { "/resend-verification" })
public class ResendVerificationController extends HttpServlet {

  private CustomerDAO customerDAO;
  private EmailVerificationTokenDAO tokenDAO;
  private AsyncEmailService asyncEmailService;

  @Override
  public void init(ServletConfig config) throws ServletException {
    super.init(config);
    customerDAO = new CustomerDAO();
    tokenDAO = new EmailVerificationTokenDAO();
    asyncEmailService = new AsyncEmailService();
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");

    try (PrintWriter out = response.getWriter()) {
      HttpSession session = request.getSession();
      Customer customer = (Customer) session.getAttribute("customer");

      // Check if customer is logged in
      if (customer == null) {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        out.print("{\"success\": false, \"message\": \"Bạn cần đăng nhập để thực hiện chức năng này.\"}");
        return;
      }

      try {
        // Check if customer is already verified
        if (customerDAO.isCustomerVerified(customer.getEmail())) {
          response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
          out.print("{\"success\": false, \"message\": \"Email của bạn đã được xác thực.\"}");
          return;
        }

        // Check rate limiting - prevent sending emails within 60 seconds
        String lastSentKey = "lastVerificationSent_" + customer.getEmail();
        Long lastSentTime = (Long) session.getAttribute(lastSentKey);
        if (lastSentTime != null) {
          long timeSinceLastSent = (System.currentTimeMillis() - lastSentTime) / 1000;
          if (timeSinceLastSent < 60) {
            long remainingTime = 60 - timeSinceLastSent;
//            response.setStatus(HttpServletResponse.SC);
            out.print("{\"success\": false, \"message\": \"Vui lòng đợi " + remainingTime
                + " giây trước khi gửi lại email.\"}");
            return;
          }
        }

        // Delete any existing tokens for this email
        tokenDAO.deleteTokensByEmail(customer.getEmail());

        // Create new verification token
        EmailVerificationToken token = new EmailVerificationToken(customer.getEmail());
        tokenDAO.save(token);

        // Send verification email asynchronously
        String customerName = customerDAO.getCustomerNameByEmail(customer.getEmail());
        if (customerName == null) {
          customerName = customer.getFullName();
        }
        asyncEmailService.sendVerificationEmailAsync(customer.getEmail(), token.getToken(), customerName);

        // Store timestamp to prevent rapid resending
        session.setAttribute(lastSentKey, System.currentTimeMillis());

        // Return success response
        out.print("{\"success\": true, \"message\": \"Email xác thực đã được gửi lại thành công!\"}");

      } catch (SQLException ex) {
        Logger.getLogger(ResendVerificationController.class.getName()).log(Level.SEVERE,
            "Error resending verification email", ex);
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        out.print("{\"success\": false, \"message\": \"Có lỗi xảy ra khi gửi email. Vui lòng thử lại sau.\"}");
      } catch (Exception ex) {
        Logger.getLogger(ResendVerificationController.class.getName()).log(Level.SEVERE,
            "Unexpected error resending verification email", ex);
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        out.print("{\"success\": false, \"message\": \"Có lỗi không mong muốn xảy ra. Vui lòng thử lại sau.\"}");
      }
    }
  }

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    response.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    response.getWriter().print("{\"success\": false, \"message\": \"Method not allowed\"}");
  }
}