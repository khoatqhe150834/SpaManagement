package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Home Controller to handle the root path
 * Maps to "/" and "/index" to serve the main page
 */
public class HomeController extends HttpServlet {

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    // The JSP will have access to the session attributes for this request.
    // We don't need to do anything special here to pass them.
    // They will be removed from the session after this request cycle
    // if they were displayed. Let's try to remove the removal logic
    // from footer.jsp and see if the toast appears.
    // The previous analysis was a bit flawed. The scriptlet in the JSP
    // does run, but it runs after the HTML is sent to the client, which is
    // why the notification should have appeared.
    // Let's re-examine app.js
    request.getRequestDispatcher("/index.jsp").forward(request, response);
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    doGet(request, response);
  }
}