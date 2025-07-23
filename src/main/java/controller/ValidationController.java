package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import dao.BedDAO;
import dao.CustomerDAO;
import dao.PaymentDAO;
import dao.RoomDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Bed;
import model.Payment;
import model.Room;

/**
 * ValidationController handles real-time validation API endpoints
 * for room and bed management in the spa system
 */
@WebServlet({
    "/api/validate/room/name",
    "/api/validate/room/name/*",
    "/api/validate/bed/name",
    "/api/validate/bed/name/*",
    "/api/validate/payment/customer",
    "/api/validate/payment/amount",
    "/api/validate/payment/reference"
})
public class ValidationController extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(ValidationController.class.getName());
    private final RoomDAO roomDAO;
    private final BedDAO bedDAO;
    private final CustomerDAO customerDAO;
    private final PaymentDAO paymentDAO;

    public ValidationController() {
        this.roomDAO = new RoomDAO();
        this.bedDAO = new BedDAO();
        this.customerDAO = new CustomerDAO();
        this.paymentDAO = new PaymentDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Set response content type to JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
       
        
        String pathInfo = request.getPathInfo();
        String servletPath = request.getServletPath();
        
        try {
            if (servletPath.equals("/api/validate/room/name")) {
                if (pathInfo == null || pathInfo.equals("/")) {
                    // Validate new room name
                    handleRoomNameValidation(request, response, null);
                } else {
                    // Validate room name for editing (exclude current room)
                    String roomIdStr = pathInfo.substring(1); // Remove leading slash
                    try {
                        int roomId = Integer.parseInt(roomIdStr);
                        handleRoomNameValidation(request, response, roomId);
                    } catch (NumberFormatException e) {
                        sendErrorResponse(response, "ID phòng không hợp lệ", 400);
                    }
                }
            } else if (servletPath.equals("/api/validate/bed/name")) {
                if (pathInfo == null || pathInfo.equals("/")) {
                    // Validate new bed name
                    handleBedNameValidation(request, response, null);
                } else {
                    // Validate bed name for editing (exclude current bed)
                    String bedIdStr = pathInfo.substring(1); // Remove leading slash
                    try {
                        int bedId = Integer.parseInt(bedIdStr);
                        handleBedNameValidation(request, response, bedId);
                    } catch (NumberFormatException e) {
                        sendErrorResponse(response, "ID giường không hợp lệ", 400);
                    }
                }
            } else if (servletPath.equals("/api/validate/payment/customer")) {
                handlePaymentCustomerValidation(request, response);
            } else if (servletPath.equals("/api/validate/payment/amount")) {
                handlePaymentAmountValidation(request, response);
            } else if (servletPath.equals("/api/validate/payment/reference")) {
                handlePaymentReferenceValidation(request, response);
            } else {
                sendErrorResponse(response, "Endpoint không tồn tại", 404);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error during validation", e);
            sendErrorResponse(response, "Lỗi hệ thống. Vui lòng thử lại sau.", 500);
        }
    }
    
    /**
     * Handle room name validation with enhanced case-insensitive checking
     */
    private void handleRoomNameValidation(HttpServletRequest request, HttpServletResponse response, Integer excludeRoomId)
            throws IOException, SQLException {

        String roomName = request.getParameter("name");

        // Log validation attempt for audit purposes
        LOGGER.info(String.format("Room name validation requested: name='%s', excludeRoomId=%s",
                                 roomName, excludeRoomId));

        if (roomName == null || roomName.trim().isEmpty()) {
            sendValidationResponse(response, false, "Tên phòng không được để trống");
            return;
        }

        roomName = roomName.trim();

        // Check name length constraints
        if (roomName.length() < 2) {
            sendValidationResponse(response, false, "Tên phòng phải có ít nhất 2 ký tự");
            return;
        }

        if (roomName.length() > 50) {
            sendValidationResponse(response, false, "Tên phòng không được vượt quá 50 ký tự");
            return;
        }

        // Check for invalid characters (optional enhancement)
        if (!roomName.matches("^[a-zA-Z0-9\\s\\-_àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđĐ]+$")) {
            sendValidationResponse(response, false, "Tên phòng chỉ được chứa chữ cái, số, dấu gạch ngang và khoảng trắng");
            return;
        }

        // Enhanced duplicate checking with case-insensitive comparison
        boolean isDuplicate = false;
        String conflictingRoomName = null;

        try {
            List<Room> existingRooms = roomDAO.findAll();
            for (Room room : existingRooms) {
                // Skip current room when editing
                if (excludeRoomId != null && room.getRoomId() == excludeRoomId) {
                    continue;
                }

                // Case-insensitive comparison with trimmed names
                if (room.getName().trim().equalsIgnoreCase(roomName)) {
                    isDuplicate = true;
                    conflictingRoomName = room.getName();
                    break;
                }
            }

            if (isDuplicate) {
                String errorMessage = String.format("Tên phòng đã tồn tại (trùng với '%s'). Vui lòng chọn tên khác.",
                                                   conflictingRoomName);
                sendValidationResponse(response, false, errorMessage);
                LOGGER.info(String.format("Room name validation failed: duplicate name '%s' conflicts with '%s'",
                                         roomName, conflictingRoomName));
                return;
            }

            sendValidationResponse(response, true, "Tên phòng hợp lệ");
            LOGGER.info(String.format("Room name validation successful: '%s'", roomName));

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error during room name validation", e);
            sendValidationResponse(response, false, "Lỗi hệ thống khi kiểm tra tên phòng. Vui lòng thử lại.");
        }
    }
    
    /**
     * Handle bed name validation with enhanced case-insensitive checking within room scope
     */
    private void handleBedNameValidation(HttpServletRequest request, HttpServletResponse response, Integer excludeBedId)
            throws IOException, SQLException {

        String bedName = request.getParameter("name");
        String roomIdStr = request.getParameter("roomId");

        // Log validation attempt for audit purposes
        LOGGER.info(String.format("Bed name validation requested: name='%s', roomId='%s', excludeBedId=%s",
                                 bedName, roomIdStr, excludeBedId));

        if (bedName == null || bedName.trim().isEmpty()) {
            sendValidationResponse(response, false, "Tên giường không được để trống");
            return;
        }

        if (roomIdStr == null || roomIdStr.trim().isEmpty()) {
            sendValidationResponse(response, false, "Vui lòng chọn phòng");
            return;
        }

        bedName = bedName.trim();
        int roomId;

        try {
            roomId = Integer.parseInt(roomIdStr);
        } catch (NumberFormatException e) {
            sendValidationResponse(response, false, "ID phòng không hợp lệ");
            return;
        }

        // Check name length constraints
        if (bedName.length() < 2) {
            sendValidationResponse(response, false, "Tên giường phải có ít nhất 2 ký tự");
            return;
        }

        if (bedName.length() > 50) {
            sendValidationResponse(response, false, "Tên giường không được vượt quá 50 ký tự");
            return;
        }

        // Check for invalid characters (optional enhancement)
        if (!bedName.matches("^[a-zA-Z0-9\\s\\-_àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđĐ]+$")) {
            sendValidationResponse(response, false, "Tên giường chỉ được chứa chữ cái, số, dấu gạch ngang và khoảng trắng");
            return;
        }

        // Enhanced duplicate checking within room scope with case-insensitive comparison
        boolean isDuplicate = false;
        String conflictingBedName = null;

        try {
            // Verify room exists first
            if (!roomDAO.existsById(roomId)) {
                sendValidationResponse(response, false, "Phòng không tồn tại");
                return;
            }

            List<Bed> bedsInRoom = bedDAO.getBedsByRoomId(roomId);
            for (Bed bed : bedsInRoom) {
                // Skip current bed when editing
                if (excludeBedId != null && bed.getBedId().equals(excludeBedId)) {
                    continue;
                }

                // Case-insensitive comparison with trimmed names
                if (bed.getName().trim().equalsIgnoreCase(bedName)) {
                    isDuplicate = true;
                    conflictingBedName = bed.getName();
                    break;
                }
            }

            if (isDuplicate) {
                String errorMessage = String.format("Tên giường đã được sử dụng trong phòng này (trùng với '%s'). Vui lòng chọn tên khác.",
                                                   conflictingBedName);
                sendValidationResponse(response, false, errorMessage);
                LOGGER.info(String.format("Bed name validation failed: duplicate name '%s' conflicts with '%s' in room %d",
                                         bedName, conflictingBedName, roomId));
                return;
            }

            sendValidationResponse(response, true, "Tên giường hợp lệ");
            LOGGER.info(String.format("Bed name validation successful: '%s' in room %d", bedName, roomId));

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error during bed name validation", e);
            sendValidationResponse(response, false, "Lỗi hệ thống khi kiểm tra tên giường. Vui lòng thử lại.");
        }
    }
    
    /**
     * Send validation response as JSON
     */
    private void sendValidationResponse(HttpServletResponse response, boolean isValid, String message) 
            throws IOException {
        
        PrintWriter out = response.getWriter();
        String jsonResponse = String.format(
            "{\"valid\": %s, \"message\": \"%s\"}", 
            isValid, 
            message.replace("\"", "\\\"")
        );
        out.print(jsonResponse);
        out.flush();
    }
    
    /**
     * Handle payment customer validation
     */
    private void handlePaymentCustomerValidation(HttpServletRequest request, HttpServletResponse response)
            throws IOException, SQLException {

        String customerIdStr = request.getParameter("customerId");

        if (customerIdStr == null || customerIdStr.trim().isEmpty()) {
            sendValidationResponse(response, false, "Vui lòng chọn khách hàng");
            return;
        }

        try {
            int customerId = Integer.parseInt(customerIdStr);
            var customerOpt = customerDAO.findById(customerId);

            if (!customerOpt.isPresent()) {
                sendValidationResponse(response, false, "Khách hàng không tồn tại");
                return;
            }

            sendValidationResponse(response, true, "Khách hàng hợp lệ");

        } catch (NumberFormatException e) {
            sendValidationResponse(response, false, "ID khách hàng không hợp lệ");
        }
    }

    /**
     * Handle payment amount validation
     */
    private void handlePaymentAmountValidation(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String amountStr = request.getParameter("amount");

        if (amountStr == null || amountStr.trim().isEmpty()) {
            sendValidationResponse(response, false, "Vui lòng nhập số tiền");
            return;
        }

        try {
            // Remove formatting and parse
            String cleanAmount = amountStr.replaceAll("[^\\d]", "");
            double amount = Double.parseDouble(cleanAmount);

            if (amount <= 0) {
                sendValidationResponse(response, false, "Số tiền phải lớn hơn 0");
                return;
            }

            if (amount > 100000000) {
                sendValidationResponse(response, false, "Số tiền không được vượt quá 100,000,000 VNĐ");
                return;
            }

            sendValidationResponse(response, true, "Số tiền hợp lệ");

        } catch (NumberFormatException e) {
            sendValidationResponse(response, false, "Số tiền không hợp lệ");
        }
    }

    /**
     * Handle payment reference validation
     */
    private void handlePaymentReferenceValidation(HttpServletRequest request, HttpServletResponse response)
            throws IOException, SQLException {

        String reference = request.getParameter("reference");

        if (reference == null || reference.trim().isEmpty()) {
            sendValidationResponse(response, true, "Mã tham chiếu không bắt buộc");
            return;
        }

        reference = reference.trim();

        // Check length constraints
        if (reference.length() > 100) {
            sendValidationResponse(response, false, "Mã tham chiếu không được vượt quá 100 ký tự");
            return;
        }

        // Check for duplicate reference numbers
        try {
            List<Payment> existingPayments = paymentDAO.findAll();
            for (Payment payment : existingPayments) {
                if (payment.getReferenceNumber() != null &&
                    payment.getReferenceNumber().trim().equalsIgnoreCase(reference)) {
                    sendValidationResponse(response, false, "Mã tham chiếu đã tồn tại");
                    return;
                }
            }

            sendValidationResponse(response, true, "Mã tham chiếu hợp lệ");

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error during reference validation", e);
            sendValidationResponse(response, false, "Lỗi hệ thống khi kiểm tra mã tham chiếu");
        }
    }

    /**
     * Send error response as JSON
     */
    private void sendErrorResponse(HttpServletResponse response, String message, int statusCode)
            throws IOException {

        response.setStatus(statusCode);
        PrintWriter out = response.getWriter();
        String jsonResponse = String.format(
            "{\"error\": true, \"message\": \"%s\"}",
            message.replace("\"", "\\\"")
        );
        out.print(jsonResponse);
        out.flush();
    }
}
