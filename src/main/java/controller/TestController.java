package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Simple test controller to verify servlet functionality
 */
@WebServlet(name = "TestController", urlPatterns = { "/test" })
public class TestController extends HttpServlet {

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    // Forward to the demo dashboard JSP
    request.getRequestDispatcher("/WEB-INF/view/demo-dashboard.jsp").forward(request, response);
  }
}