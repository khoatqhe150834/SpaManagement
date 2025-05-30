/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CustomerDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Customer;

/**
 *
 * @author Admin
 */
@WebServlet("/customer")
public class CustomerController extends HttpServlet {
    private CustomerDAO customerDAO;

    @Override
    public void init() throws ServletException {
        customerDAO = new CustomerDAO(); // inject DAO
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        try {
            switch (action != null ? action : "list") {
                case "new":
                    showCreateForm(req, resp);
                    break;
                case "edit":
                    showEditForm(req, resp);
                    break;
                case "delete":
                    deleteCustomer(req, resp);
                    break;
                default:
                    listCustomer(req, resp);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        try {
            switch (action) {
                case "insert":
                    insertCustomer(req, resp);
                    break;
                case "update":
                    updateCustomer(req, resp);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    // ========= CRUD Methods ========= //

    private void listCustomer(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        List<Customer> list = customerDAO.getAll();
        req.setAttribute("listCustomer", list);
        req.getRequestDispatcher("customer/list.jsp").forward(req, resp);
    }

    private void showCreateForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("customer/form.jsp").forward(req, resp);
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        int id = Integer.parseInt(req.getParameter("id"));
        Customer customer = customerDAO.getById(id);
        req.setAttribute("customer", customer);
        req.getRequestDispatcher("customer/form.jsp").forward(req, resp);
    }

    private void insertCustomer(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        Customer newCustomer = new Customer(0, name, email);
        customerDAO.insert(newCustomer);
        resp.sendRedirect("customer");
    }

    private void updateCustomer(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        int id = Integer.parseInt(req.getParameter("id"));
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        Customer customer = new Customer(id, name, email);
        customerDAO.update(customer);
        resp.sendRedirect("customer");
    }

    private void deleteCustomer(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        int id = Integer.parseInt(req.getParameter("id"));
        customerDAO.delete(id);
        resp.sendRedirect("customer");
    }
}
