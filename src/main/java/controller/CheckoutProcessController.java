package controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Customer;
import model.Payment;
import model.User;
import service.CartPaymentService;
import service.CartPaymentService.CartItem;

/**
 * Controller for processing checkout when customer clicks "Tôi đã thanh toán"
 * Handles the complete checkout flow from cart data to database persistence
 * 
 * @author G1_SpaManagement Team
 */
@WebServlet(name = "CheckoutProcessController", urlPatterns = {"/checkout/process"})
public class CheckoutProcessController extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(CheckoutProcessController.class.getName());
    private final CartPaymentService cartPaymentService;
    private final Gson gson;
    
    public CheckoutProcessController() {
        this.cartPaymentService = new CartPaymentService();
        this.gson = new Gson();
    }

    /**
     * Handles POST requests for processing checkout
     * Expects JSON payload with cart items and payment details
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        PrintWriter out = response.getWriter();
        
        try {
            // 1. Validate user authentication
            Customer customer = (Customer) session.getAttribute("customer");
            User user = (User) session.getAttribute("user");
            
            Integer customerId = null;
            if (customer != null) {
                customerId = customer.getCustomerId();
            } else if (user != null) {
                // For staff users, we might need to handle differently
                // For now, require customer authentication
                sendErrorResponse(out, "Chỉ khách hàng mới có thể thực hiện thanh toán", 401);
                return;
            } else {
                sendErrorResponse(out, "Vui lòng đăng nhập để tiếp tục thanh toán", 401);
                return;
            }
            
            // 2. Parse request body
            StringBuilder requestBody = new StringBuilder();
            try (BufferedReader reader = request.getReader()) {
                String line;
                while ((line = reader.readLine()) != null) {
                    requestBody.append(line);
                }
            }
            
            if (requestBody.length() == 0) {
                sendErrorResponse(out, "Dữ liệu thanh toán không hợp lệ", 400);
                return;
            }
            
            // 3. Parse JSON data
            JsonObject requestData = JsonParser.parseString(requestBody.toString()).getAsJsonObject();
            
            // Extract cart items
            JsonArray cartItemsJson = requestData.getAsJsonArray("cartItems");
            if (cartItemsJson == null || cartItemsJson.size() == 0) {
                sendErrorResponse(out, "Giỏ hàng trống", 400);
                return;
            }
            
            // Extract and validate payment method
            String paymentMethodStr = requestData.has("paymentMethod") ?
                requestData.get("paymentMethod").getAsString() : "BANK_TRANSFER";
            Payment.PaymentMethod paymentMethod;
            try {
                paymentMethod = Payment.PaymentMethod.valueOf(paymentMethodStr.toUpperCase());
            } catch (IllegalArgumentException e) {
                sendErrorResponse(out, "Phương thức thanh toán không hợp lệ", 400);
                return;
            }

            // Extract and validate reference number and notes
            String referenceNumber = requestData.has("referenceNumber") ?
                requestData.get("referenceNumber").getAsString() : null;
            String notes = requestData.has("notes") ?
                requestData.get("notes").getAsString() : null;

            // Validate reference number format if provided
            if (referenceNumber != null && !referenceNumber.trim().isEmpty()) {
                referenceNumber = referenceNumber.trim();
                if (referenceNumber.length() > 50) {
                    sendErrorResponse(out, "Mã tham chiếu quá dài", 400);
                    return;
                }
                // Basic format validation (alphanumeric and some special chars)
                if (!referenceNumber.matches("^[A-Za-z0-9_-]+$")) {
                    sendErrorResponse(out, "Mã tham chiếu chứa ký tự không hợp lệ", 400);
                    return;
                }
            }

            // Validate notes length
            if (notes != null && notes.length() > 500) {
                sendErrorResponse(out, "Ghi chú quá dài", 400);
                return;
            }
            
            // 4. Convert JSON cart items to CartItem objects with validation
            List<CartItem> cartItems = new ArrayList<>();
            for (JsonElement itemElement : cartItemsJson) {
                JsonObject itemObj = itemElement.getAsJsonObject();

                // Validate required fields
                if (!itemObj.has("serviceId") || !itemObj.has("quantity")) {
                    sendErrorResponse(out, "Dữ liệu dịch vụ không hợp lệ", 400);
                    return;
                }

                Integer serviceId;
                Integer quantity;

                try {
                    serviceId = itemObj.get("serviceId").getAsInt();
                    quantity = itemObj.get("quantity").getAsInt();
                } catch (NumberFormatException | ClassCastException e) {
                    sendErrorResponse(out, "Dữ liệu dịch vụ không hợp lệ", 400);
                    return;
                }

                // Validate values
                if (serviceId <= 0) {
                    sendErrorResponse(out, "ID dịch vụ không hợp lệ", 400);
                    return;
                }

                if (quantity <= 0 || quantity > 10) {
                    sendErrorResponse(out, "Số lượng dịch vụ không hợp lệ (1-10)", 400);
                    return;
                }

                CartItem cartItem = new CartItem(serviceId, quantity);
                cartItems.add(cartItem);
            }

            // Validate total cart size
            if (cartItems.size() > 20) {
                sendErrorResponse(out, "Giỏ hàng có quá nhiều dịch vụ", 400);
                return;
            }
            
            // 5. Process the payment
            Payment payment = cartPaymentService.processCartPayment(
                customerId, cartItems, paymentMethod, notes);
            
            // 6. Update payment with reference number if provided
            if (referenceNumber != null && !referenceNumber.trim().isEmpty()) {
                payment.setReferenceNumber(referenceNumber.trim());
                // Note: You might want to update this in the database as well
            }
            
            // 7. Clear cart after successful payment
            // The frontend will handle clearing localStorage, but we can also clear any server-side cart data
            session.removeAttribute("cart_items");
            session.removeAttribute("cart_total");

            // 8. Send success response
            JsonObject responseData = new JsonObject();
            responseData.addProperty("success", true);
            responseData.addProperty("message", "Thanh toán thành công!");
            responseData.addProperty("paymentId", payment.getPaymentId());
            responseData.addProperty("referenceNumber", payment.getReferenceNumber());
            responseData.addProperty("totalAmount", payment.getTotalAmount().toString());
            responseData.addProperty("clearCart", true); // Signal frontend to clear cart

            out.print(gson.toJson(responseData));
            
            LOGGER.log(Level.INFO, "Checkout processed successfully for customer {0}, payment ID: {1}", 
                      new Object[]{customerId, payment.getPaymentId()});
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Database error during checkout processing", ex);
            sendErrorResponse(out, "Lỗi hệ thống. Vui lòng thử lại sau.", 500);
        } catch (IllegalArgumentException ex) {
            LOGGER.log(Level.WARNING, "Invalid argument during checkout processing", ex);
            sendErrorResponse(out, ex.getMessage(), 400);
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Unexpected error during checkout processing", ex);
            sendErrorResponse(out, "Đã xảy ra lỗi không mong muốn. Vui lòng thử lại.", 500);
        }
    }
    
    /**
     * Send error response in JSON format
     */
    private void sendErrorResponse(PrintWriter out, String message, int statusCode) {
        JsonObject errorResponse = new JsonObject();
        errorResponse.addProperty("success", false);
        errorResponse.addProperty("message", message);
        errorResponse.addProperty("statusCode", statusCode);
        
        out.print(gson.toJson(errorResponse));
    }
    
    /**
     * Handles GET requests - not supported for this endpoint
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        response.getWriter().write("{\"success\": false, \"message\": \"Method not allowed\"}");
    }
}
