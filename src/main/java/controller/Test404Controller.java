package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Test controller to manually trigger 404 error for testing the error page
 */
@WebServlet(name = "Test404Controller", urlPatterns = { "/test-404" })
public class Test404Controller extends HttpServlet {

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    // Manually trigger a 404 error to test the error page
    response.sendError(HttpServletResponse.SC_NOT_FOUND, "This is a test 404 error");
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    doGet(request, response);
  }
}