package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Simple test controller to verify servlet functionality
 */
@WebServlet(name = "TestController", urlPatterns = { "/test" })
public class TestController extends HttpServlet {

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    response.setContentType("text/html;charset=UTF-8");
    PrintWriter out = response.getWriter();

    out.println("<!DOCTYPE html>");
    out.println("<html>");
    out.println("<head><title>Filter Diagnostic Test</title></head>");
    out.println("<body>");
    out.println("<h1>Filter System Diagnostic</h1>");
    out.println("<h2>Request Information:</h2>");
    out.println("<p><strong>Request URI:</strong> " + request.getRequestURI() + "</p>");
    out.println("<p><strong>Context Path:</strong> " + request.getContextPath() + "</p>");
    out.println("<p><strong>Servlet Path:</strong> " + request.getServletPath() + "</p>");
    out.println("<p><strong>Path Info:</strong> " + request.getPathInfo() + "</p>");

    out.println("<h2>Filter Attributes:</h2>");
    out.println("<p><strong>isAuthenticated:</strong> " + request.getAttribute("isAuthenticated") + "</p>");
    out.println("<p><strong>currentUser:</strong> " + request.getAttribute("currentUser") + "</p>");
    out.println("<p><strong>currentCustomer:</strong> " + request.getAttribute("currentCustomer") + "</p>");
    out.println("<p><strong>userType:</strong> " + request.getAttribute("userType") + "</p>");

    out.println("<h2>Session Information:</h2>");
    if (request.getSession(false) != null) {
      out.println("<p><strong>Session exists:</strong> Yes</p>");
      out.println("<p><strong>Session ID:</strong> " + request.getSession(false).getId() + "</p>");
      out.println("<p><strong>authenticated flag:</strong> " + request.getSession(false).getAttribute("authenticated")
          + "</p>");
    } else {
      out.println("<p><strong>Session exists:</strong> No</p>");
    }

    out.println("<h2>Test Links:</h2>");
    out.println("<p><a href='" + request.getContextPath() + "/login'>Go to Login Page</a></p>");
    out.println("<p><a href='" + request.getContextPath() + "/'>Go to Home Page</a></p>");

    out.println("</body>");
    out.println("</html>");
  }
}