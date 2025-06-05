package controller;

import dao.CustomerDAO;
import dao.UserDAO;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import model.Customer;
import model.User;

@WebServlet(name = "ProfileController", urlPatterns = { "/profile", "/profile/edit" })
public class ProfileController extends HttpServlet {

  private CustomerDAO customerDAO;
  private UserDAO userDAO;

  @Override
  public void init(ServletConfig config) throws ServletException {
    super.init(config);
    customerDAO = new CustomerDAO();
    userDAO = new UserDAO();
  }

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    // Check authentication
    HttpSession session = request.getSession(false);
    if (session == null || !Boolean.TRUE.equals(session.getAttribute("authenticated"))) {
      response.sendRedirect(request.getContextPath() + "/login");
      return;
    }

    String action = getActionFromPath(request.getServletPath());

    switch (action) {
      case "profile":
        showProfile(request, response);
        break;
      case "edit":
        showEditProfile(request, response);
        break;
      default:
        showProfile(request, response);
    }
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    // Check authentication
    HttpSession session = request.getSession(false);
    if (session == null || !Boolean.TRUE.equals(session.getAttribute("authenticated"))) {
      response.sendRedirect(request.getContextPath() + "/login");
      return;
    }

    String action = getActionFromPath(request.getServletPath());

    if ("edit".equals(action)) {
      updateProfile(request, response);
    } else {
      showProfile(request, response);
    }
  }

  private void showProfile(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    request.getRequestDispatcher("/WEB-INF/view/profile/profile.jsp").forward(request, response);
  }

  private void showEditProfile(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    request.getRequestDispatcher("/WEB-INF/view/profile/edit-profile.jsp").forward(request, response);
  }

  private void updateProfile(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    HttpSession session = request.getSession();
    User user = (User) session.getAttribute("user");
    Customer customer = (Customer) session.getAttribute("customer");

    try {
      if (user != null) {
        updateUserProfile(user, request, session);
      } else if (customer != null) {
        updateCustomerProfile(customer, request, session);
      }

      request.setAttribute("success", "Thông tin cá nhân đã được cập nhật thành công!");

    } catch (SQLException e) {
      request.setAttribute("error", "Đã xảy ra lỗi khi cập nhật thông tin. Vui lòng thử lại.");
      e.printStackTrace();
    }

    request.getRequestDispatcher("/WEB-INF/view/profile/edit-profile.jsp").forward(request, response);
  }

  private void updateUserProfile(User user, HttpServletRequest request, HttpSession session) throws SQLException {
    String fullName = request.getParameter("fullName");
    String phoneNumber = request.getParameter("phoneNumber");
    String gender = request.getParameter("gender");
    String birthdayStr = request.getParameter("birthday");

    // Update user object
    user.setFullName(fullName);
    user.setPhoneNumber(phoneNumber);
    user.setGender(gender);

    if (birthdayStr != null && !birthdayStr.trim().isEmpty()) {
      try {
        java.sql.Date birthday = java.sql.Date.valueOf(birthdayStr);
        user.setBirthday(birthday);
      } catch (IllegalArgumentException e) {
        // Handle invalid date format
      }
    }

    // Update in database
    boolean success = userDAO.updateProfile(user);
    if (success) {
      // Update session with new info
      session.setAttribute("user", user);
    }
  }

  private void updateCustomerProfile(Customer customer, HttpServletRequest request, HttpSession session)
      throws SQLException {
    String fullName = request.getParameter("fullName");
    String phoneNumber = request.getParameter("phoneNumber");
    String gender = request.getParameter("gender");
    String birthdayStr = request.getParameter("birthday");
    String address = request.getParameter("address");

    // Update customer object
    customer.setFullName(fullName);
    customer.setPhoneNumber(phoneNumber);
    customer.setGender(gender);
    customer.setAddress(address);

    if (birthdayStr != null && !birthdayStr.trim().isEmpty()) {
      try {
        java.sql.Date birthday = java.sql.Date.valueOf(birthdayStr);
        customer.setBirthday(birthday);
      } catch (IllegalArgumentException e) {
        // Handle invalid date format
      }
    }

    // Update in database
    boolean success = customerDAO.updateProfile(customer);
    if (success) {
      // Update session with new info
      session.setAttribute("customer", customer);
    }
  }

  private String getActionFromPath(String path) {
    if (path.endsWith("/edit")) {
      return "edit";
    }
    return "profile";
  }

  @Override
  public String getServletInfo() {
    return "Profile Management Controller";
  }
}