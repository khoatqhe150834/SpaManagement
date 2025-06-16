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

    response.setContentType("text/html");
    response.setCharacterEncoding("UTF-8");

    PrintWriter out = response.getWriter();
    out.println("<!DOCTYPE html>");
    out.println("<html>");
    out.println("<head><title>Test Page</title></head>");
    out.println("<body>");
    out.println("<h1>🎉 Servlet Test Successful!</h1>");
    out.println("<p>Your G1 Spa Management System is working!</p>");
    out.println("<p><a href='/'>Go to Home Page</a></p>");
    out.println("<p><a href='/login'>Go to Login</a></p>");
    out.println("</body>");
    out.println("</html>");
  }
}