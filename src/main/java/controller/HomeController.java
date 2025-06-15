package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Home Controller to handle the root path
 * Maps to "/" and "/index" to serve the main page
 */
@WebServlet(name = "HomeController", urlPatterns = { "/", "/index" })
public class HomeController extends HttpServlet {

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    // For now, just send a simple HTML response to test if servlet mapping works
    response.setContentType("text/html");
    response.setCharacterEncoding("UTF-8");

    response.getWriter().println("<!DOCTYPE html>");
    response.getWriter().println("<html>");
    response.getWriter().println("<head><title>G1 Spa Management</title></head>");
    response.getWriter().println("<body>");
    response.getWriter().println("<h1>🏛️ G1 Spa Management System</h1>");
    response.getWriter().println("<p>Welcome to our Spa Management System!</p>");
    response.getWriter().println("<p><a href='/test'>Test Servlet</a> | <a href='/login'>Login</a></p>");
    response.getWriter().println("</body>");
    response.getWriter().println("</html>");
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    doGet(request, response);
  }
}