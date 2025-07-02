package controller.api;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/api/cart/*")
public class CartApiServlet extends HttpServlet {
  private final Gson gson = new GsonBuilder().create();

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");

    String pathInfo = request.getPathInfo();

    try (PrintWriter out = response.getWriter()) {
      if ("/current-user".equals(pathInfo)) {
        // Return current user info for cart management
        HttpSession session = request.getSession(false);
        Map<String, Object> result = new HashMap<>();

        if (session != null && session.getAttribute("user") != null) {
          User user = (User) session.getAttribute("user");
          result.put("id", user.getUserId());
          result.put("name", user.getFullName());
          result.put("email", user.getEmail());
          result.put("isAuthenticated", true);
        } else {
          result.put("isAuthenticated", false);
        }

        out.print(gson.toJson(result));

      } else {
        response.sendError(HttpServletResponse.SC_NOT_FOUND);
      }
    }
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");

    String pathInfo = request.getPathInfo();

    try (PrintWriter out = response.getWriter()) {
      if ("/merge".equals(pathInfo)) {
        // Handle cart merging (if needed server-side)
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "Cart merged successfully");
        out.print(gson.toJson(result));

      } else {
        response.sendError(HttpServletResponse.SC_NOT_FOUND);
      }
    }
  }

  @Override
  protected void doDelete(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");

    String pathInfo = request.getPathInfo();

    try (PrintWriter out = response.getWriter()) {
      if ("/clear".equals(pathInfo)) {
        // Handle cart clearing (if needed server-side)
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "Cart cleared successfully");
        out.print(gson.toJson(result));

      } else {
        response.sendError(HttpServletResponse.SC_NOT_FOUND);
      }
    }
  }
}