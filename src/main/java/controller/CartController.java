package controller;

import service.CartService;
import model.ShoppingCart;
import model.Customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(urlPatterns = { "/cart", "/cart/*" })
public class CartController extends HttpServlet {
  private static final Logger logger = Logger.getLogger(CartController.class.getName());
  private CartService cartService;

  @Override
  public void init() throws ServletException {
    this.cartService = new CartService();
  }

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    String pathInfo = request.getPathInfo();

    try {
      if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/view")) {
        handleViewCart(request, response);
      } else {
        response.sendError(HttpServletResponse.SC_NOT_FOUND);
      }
    } catch (Exception e) {
      logger.log(Level.SEVERE, "Error in cart controller", e);
      request.setAttribute("errorMessage", "Đã có lỗi xảy ra khi tải giỏ hàng");
      request.getRequestDispatcher("/WEB-INF/view/common/error.jsp").forward(request, response);
    }
  }

  /**
   * Display cart page
   */
  private void handleViewCart(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    HttpSession session = request.getSession();
    Customer customer = (Customer) session.getAttribute("customer");

    // Get or create cart
    ShoppingCart cart = cartService.getOrCreateCart(request);

    logger.info("Cart page requested - Cart: " + (cart != null ? cart.getCartId() : "null"));

    if (cart != null) {
      request.setAttribute("cart", cart);
      request.setAttribute("cartItems", cart.getCartItems());
      request.setAttribute("totalItemCount", cart.getTotalItemCount());
      logger.info("Cart items count: " + cart.getTotalItemCount());
    } else {
      logger.warning("Cart is null for session");
      // Create empty cart attributes to prevent JSP errors
      request.setAttribute("cart", null);
      request.setAttribute("cartItems", null);
      request.setAttribute("totalItemCount", 0);
    }

    // Set user information for breadcrumb/navigation
    if (customer != null) {
      request.setAttribute("isLoggedIn", true);
      request.setAttribute("customerName", customer.getFullName());
      logger.info("Logged in customer: " + customer.getFullName());
    } else {
      request.setAttribute("isLoggedIn", false);
      logger.info("Guest user viewing cart");
    }

    // Forward to cart page
    request.getRequestDispatcher("/WEB-INF/view/customer/cart/cart.jsp").forward(request, response);
  }
}