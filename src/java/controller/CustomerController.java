/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Customer;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * @author Admin
 */
@WebServlet("/customer")
public class CustomerController extends HttpServlet {
    private CustomerDAO customerDAO;

    @Override
    public void init() throws ServletException {
        customerDAO = new CustomerDAO(); // Inject DAO
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        try {
            switch (action != null ? action : "list") {
                
                case "edit":
                    showEditForm(req, resp);
                    break;
                case "delete":
                    deleteCustomer(req, resp);
                    break;
                case "search":
                    searchCustomer(req, resp);
                    break;
                default:
                    listCustomer(req, resp);
                    break;
            }
        } catch (Exception e) {
            req.setAttribute("error", "An error occurred: " + e.getMessage());
            req.getRequestDispatcher("error.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        try {
            switch (action != null ? action : "") {
                
                case "update":
                    updateCustomer(req, resp);
                    break;
                default:
                    resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
                    break;
            }
        } catch (Exception e) {
            req.setAttribute("error", "An error occurred: " + e.getMessage());
            req.getRequestDispatcher("error.jsp").forward(req, resp);
        }
    }

    // ========= CRUD Methods ========= //

    private void listCustomer(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Customer> list = customerDAO.findAll();
        req.setAttribute("listCustomer", list);
        req.getRequestDispatcher("/customer/list.jsp").forward(req, resp);
    }

    private void showCreateForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/customer/form.jsp").forward(req, resp);
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            Optional<Customer> customerOpt = customerDAO.findById(id);
            if (customerOpt.isPresent()) {
                req.setAttribute("customer", customerOpt.get());
                req.getRequestDispatcher("/customer/form.jsp").forward(req, resp);
            } else {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Customer not found");
            }
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid customer ID");
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

            // Validate inputs
            if (name == null || email == null || name.trim().isEmpty() || email.trim().isEmpty()) {
                throw new IllegalArgumentException("Name and email are required");
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
            if (password != null && !password.trim().isEmpty()) {
                customer.setHashPassword(password); // In production, hash the password
            }
            customer.setUpdatedAt(LocalDateTime.now());

            if (birthdayStr != null && !birthdayStr.trim().isEmpty()) {
                customer.setBirthday(Date.valueOf(birthdayStr));
            } else {
                customer.setBirthday(null);
            }

            customerDAO.update(customer);
            resp.sendRedirect("customer");
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid customer ID");
        } catch (IllegalArgumentException e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/customer/form.jsp").forward(req, resp);
        }
    }

    private void deleteCustomer(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            Optional<Customer> customerOpt = customerDAO.findById(id);
            if (customerOpt.isPresent()) {
                customerDAO.delete(customerOpt.get());
                resp.sendRedirect("customer");
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
        List<Customer> list;

        if (searchValue == null || searchValue.trim().isEmpty()) {
            list = customerDAO.findAll();
        } else {
            switch (searchType != null ? searchType : "") {
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
                    list = customerDAO.findAll();
                    break;
            }
        }

        req.setAttribute("listCustomer", list);
        req.setAttribute("searchType", searchType);
        req.setAttribute("searchValue", searchValue);
        req.getRequestDispatcher("/customer/list.jsp").forward(req, resp);
    }
    
    
    
    
    
    
}