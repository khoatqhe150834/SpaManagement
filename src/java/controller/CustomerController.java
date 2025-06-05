package controller;

import dao.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Customer;
import org.mindrot.jbcrypt.BCrypt;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@WebServlet(urlPatterns = {"/customer/*"})
public class CustomerController extends HttpServlet {
    private CustomerDAO customerDAO;

    @Override
    public void init() throws ServletException {
        customerDAO = new CustomerDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        System.out.println("CustomerController.doGet called with pathInfo: " + pathInfo);
        System.out.println("Request URI: " + req.getRequestURI());
        System.out.println("Context Path: " + req.getContextPath());
        System.out.println("Servlet Path: " + req.getServletPath());
        
        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                System.out.println("Calling listCustomer for root path");
                listCustomer(req, resp);
                return;
            }

            String[] pathParts = pathInfo.substring(1).split("/");
            String action = pathParts[0].toLowerCase();

            switch (action) {
                case "list":
                    System.out.println("Calling listCustomer for 'list' action");
                    listCustomer(req, resp);
                    break;
                case "create":
                    showCreateForm(req, resp);
                    break;
                case "edit":
                    showEditForm(req, resp);
                    break;
                case "delete":
                    deleteCustomer(req, resp);
                    break;
                case "search":
                    searchCustomer(req, resp);
                    break;
                case "view": // Thêm chức năng View
                    viewCustomer(req, resp);
                    break;
                default:
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Invalid path: " + pathInfo);
                    break;
            }
        } catch (Exception e) {
            req.setAttribute("error", "An error occurred: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/view/error.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        try {
            switch (action != null ? action.toLowerCase() : "") {
                case "create":
                    createCustomer(req, resp);
                    break;
                case "update":
                    updateCustomer(req, resp);
                    break;
                default:
                    resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
                    break;
            }
        } catch (Exception e) {
            req.setAttribute("error", "An error occurred: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/view/customer/form.jsp").forward(req, resp);
        }
    }

  private void listCustomer(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {
    try {
        int page = req.getParameter("page") != null ? Integer.parseInt(req.getParameter("page")) : 1;
        int pageSize = req.getParameter("pageSize") != null ? Integer.parseInt(req.getParameter("pageSize")) : 10;
        
        // Handle status filter
        String status = req.getParameter("status");
        List<Customer> list;
        int totalCustomers;
        
        if (status != null && !status.trim().isEmpty()) {
            // Filter by status
            List<Customer> allCustomers = customerDAO.findAll();
            if ("active".equals(status)) {
                list = allCustomers.stream()
                    .filter(c -> c.getIsActive() != null && c.getIsActive())
                    .collect(java.util.stream.Collectors.toList());
            } else if ("inactive".equals(status)) {
                list = allCustomers.stream()
                    .filter(c -> c.getIsActive() == null || !c.getIsActive())
                    .collect(java.util.stream.Collectors.toList());
            } else {
                list = allCustomers;
            }
            totalCustomers = list.size();
            
            // Apply pagination to filtered results
            int startIndex = (page - 1) * pageSize;
            int endIndex = Math.min(startIndex + pageSize, list.size());
            list = list.subList(startIndex, endIndex);
        } else {
            // No status filter
            list = customerDAO.findAll(page, pageSize);
            totalCustomers = customerDAO.getTotalCustomers();
        }
        
        int totalPages = (int) Math.ceil((double) totalCustomers / pageSize);
        
        req.setAttribute("listCustomer", list);
        req.setAttribute("currentPage", page);
        req.setAttribute("pageSize", pageSize);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalCustomers", totalCustomers);
        req.setAttribute("status", status);

        System.out.println("DEBUG: Forwarding to customer_list.jsp with " + list.size() + " customers");
        
        // Using original JSP with fixes applied:
        req.getRequestDispatcher("/WEB-INF/view/admin_pages/customer_list.jsp").forward(req, resp);
        
        // Test JSPs (working correctly):
        // req.getRequestDispatcher("/property_test.jsp").forward(req, resp);
        
    } catch (Exception e) {
        System.err.println("ERROR in listCustomer: " + e.getMessage());
        e.printStackTrace();
        req.setAttribute("error", "Error loading customer list: " + e.getMessage());
        req.getRequestDispatcher("/WEB-INF/view/admin_pages/customer_list.jsp").forward(req, resp);
    }
}

    private void showCreateForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/view/customer/form.jsp").forward(req, resp);
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            Optional<Customer> customerOpt = customerDAO.findById(id);
            if (customerOpt.isPresent()) {
                req.setAttribute("customer", customerOpt.get());
                req.getRequestDispatcher("/WEB-INF/view/customer/form.jsp").forward(req, resp);
            } else {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Customer not found");
            }
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid customer ID");
        }
    }

    private void viewCustomer(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            Optional<Customer> customerOpt = customerDAO.findById(id);
            if (customerOpt.isPresent()) {
                req.setAttribute("customer", customerOpt.get());
                req.getRequestDispatcher("/WEB-INF/view/customer/view.jsp").forward(req, resp);
            } else {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Customer not found");
            }
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid customer ID");
        }
    }

    private void createCustomer(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            String name = req.getParameter("name");
            String email = req.getParameter("email");
            String phone = req.getParameter("phone");
            String password = req.getParameter("password");
            String gender = req.getParameter("gender");
            String birthdayStr = req.getParameter("birthday");
            String address = req.getParameter("address");
            String isActive = req.getParameter("isActive");

            if (name == null || email == null || password == null || name.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty()) {
                throw new IllegalArgumentException("Name, email, and password are required");
            }
            if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
                throw new IllegalArgumentException("Invalid email format");
            }
            if (phone != null && !phone.trim().isEmpty() && !phone.matches("^[0-9]{10,11}$")) {
                throw new IllegalArgumentException("Invalid phone number format");
            }

            Customer customer = new Customer();
            customer.setFullName(name);
            customer.setEmail(email);
            customer.setHashPassword(BCrypt.hashpw(password, BCrypt.gensalt()));
            customer.setPhoneNumber(phone);
            customer.setGender(gender);
            customer.setAddress(address);
            customer.setIsActive(isActive != null && isActive.equals("on"));
            customer.setRoleId(1);
            customer.setLoyaltyPoints(0);
            if (birthdayStr != null && !birthdayStr.trim().isEmpty()) {
                customer.setBirthday(Date.valueOf(birthdayStr));
            }

            customerDAO.save(customer);
            resp.sendRedirect(req.getContextPath() + "/customer");
        } catch (IllegalArgumentException e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/WEB-INF/view/customer/form.jsp").forward(req, resp);
        }
    }

    private void updateCustomer(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            String name = req.getParameter("name");
            String email = req.getParameter("email");
            String phone = req.getParameter("phone");
            String gender = req.getParameter("gender");
            String birthdayStr = req.getParameter("birthday");
            String address = req.getParameter("address");
            String password = req.getParameter("password");
            String isActive = req.getParameter("isActive");
            String loyaltyPointsStr = req.getParameter("loyaltyPoints");

            if (name == null || email == null || name.trim().isEmpty() || email.trim().isEmpty()) {
                throw new IllegalArgumentException("Name and email are required");
            }
            if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
                throw new IllegalArgumentException("Invalid email format");
            }
            if (phone != null && !phone.trim().isEmpty() && !phone.matches("^[0-9]{10,11}$")) {
                throw new IllegalArgumentException("Invalid phone number format");
            }

            Optional<Customer> customerOpt = customerDAO.findById(id);
            if (!customerOpt.isPresent()) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Customer not found");
                return;
            }

            Customer customer = customerOpt.get();
            customer.setFullName(name);
            customer.setEmail(email);
            customer.setPhoneNumber(phone);
            customer.setGender(gender);
            customer.setAddress(address);
            customer.setIsActive(isActive != null && isActive.equals("on"));
            customer.setLoyaltyPoints(loyaltyPointsStr != null ? Integer.parseInt(loyaltyPointsStr) : 0);
            
            if (password != null && !password.trim().isEmpty()) {
                customer.setHashPassword(BCrypt.hashpw(password, BCrypt.gensalt()));
            }
            customer.setUpdatedAt(LocalDateTime.now());
            
            if (birthdayStr != null && !birthdayStr.trim().isEmpty()) {
                customer.setBirthday(Date.valueOf(birthdayStr));
            }

            customerDAO.update(customer);
            resp.sendRedirect(req.getContextPath() + "/customer");
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid customer ID or loyalty points");
        } catch (IllegalArgumentException e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/WEB-INF/view/customer/form.jsp").forward(req, resp);
        }
    }

    private void deleteCustomer(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            Optional<Customer> customerOpt = customerDAO.findById(id);
            if (customerOpt.isPresent()) {
                customerDAO.delete(customerOpt.get());
                resp.sendRedirect(req.getContextPath() + "/customer");
            } else {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Customer not found");
            }
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid customer ID");
        }
    }

    private void searchCustomer(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String searchType = req.getParameter("searchType");
        String searchValue = req.getParameter("searchValue");
        int page = req.getParameter("page") != null ? Integer.parseInt(req.getParameter("page")) : 1;
        int pageSize = req.getParameter("pageSize") != null ? Integer.parseInt(req.getParameter("pageSize")) : 10;
        List<Customer> list;
        int totalCustomers;
        int totalPages;

        if (searchValue == null || searchValue.trim().isEmpty()) {
            list = customerDAO.findAll(page, pageSize);
            totalCustomers = customerDAO.getTotalCustomers();
            totalPages = (int) Math.ceil((double) totalCustomers / pageSize);
        } else {
            switch (searchType != null ? searchType.toLowerCase() : "") {
                case "name":
                    list = customerDAO.findByNameContain(searchValue);
                    break;
                case "phone":
                    list = customerDAO.findByPhoneContain(searchValue);
                    break;
                case "email":
                    list = customerDAO.findByEmailContain(searchValue);
                    break;
                default:
                    list = customerDAO.findAll(page, pageSize);
                    break;
            }
            totalCustomers = list.size();
            totalPages = (int) Math.ceil((double) totalCustomers / pageSize);
            list = list.subList((page - 1) * pageSize, Math.min(page * pageSize, list.size()));
        }

        req.setAttribute("listCustomer", list);
        req.setAttribute("searchType", searchType);
        req.setAttribute("searchValue", searchValue);
        req.setAttribute("currentPage", page);
        req.setAttribute("pageSize", pageSize);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalCustomers", totalCustomers);
        req.getRequestDispatcher("/WEB-INF/view/admin_pages/customer_list.jsp").forward(req, resp);
    }
}