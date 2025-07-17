package controller;

import dao.BedDAO;
import dao.RoomDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Bed;
import model.Room;
import model.User;

/**
 * Controller for room and bed management functionality
 * Handles room management, room details, and bed operations for manager role
 * 
 * @author G1_SpaManagement Team
 */
@WebServlet(name = "RoomController", urlPatterns = {
    "/manager/rooms-management",
    "/manager/room-details",
    "/manager/room-details/*"
})
public class RoomController extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(RoomController.class.getName());
    private final RoomDAO roomDAO;
    private final BedDAO bedDAO;
    
    public RoomController() {
        this.roomDAO = new RoomDAO();
        this.bedDAO = new BedDAO();
    }

    /**
     * Handles GET requests for room management operations
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String pathInfo = request.getServletPath();
        String additionalPath = request.getPathInfo();
        
        // Security check - ensure user is logged in and has manager role
        if (!isAuthorized(request, response)) {
            return;
        }
        
        try {
            if (pathInfo.equals("/manager/rooms-management")) {
                handleRoomsManagement(request, response);
            } else if (pathInfo.equals("/manager/room-details")) {
                if (additionalPath != null && additionalPath.length() > 1) {
                    // Handle /manager/room-details/{roomId}
                    String roomIdStr = additionalPath.substring(1); // Remove leading slash
                    handleRoomDetailsById(request, response, roomIdStr);
                } else {
                    // Handle /manager/room-details with roomId parameter
                    handleRoomDetails(request, response);
                }
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in RoomController", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                "An error occurred while processing your request.");
        }
    }
    
    /**
     * Handles rooms management page - displays all rooms in DataTable format
     */
    private void handleRoomsManagement(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            LOGGER.info("=== ROOMS MANAGEMENT DEBUG ===");
            
            // Get all rooms from database
            List<Room> rooms = roomDAO.findAll();
            LOGGER.info("Retrieved " + rooms.size() + " rooms from database");
            
            // Get room statistics
            int totalRooms = roomDAO.count();
            int activeRooms = roomDAO.getActiveRoomCount();
            int inactiveRooms = roomDAO.getInactiveRoomCount();
            int totalBeds = bedDAO.count();
            
            LOGGER.info("Room statistics - Total: " + totalRooms + ", Active: " + activeRooms + 
                       ", Inactive: " + inactiveRooms + ", Total Beds: " + totalBeds);
            
            // Set attributes for JSP
            request.setAttribute("rooms", rooms);
            request.setAttribute("totalRooms", totalRooms);
            request.setAttribute("activeRooms", activeRooms);
            request.setAttribute("inactiveRooms", inactiveRooms);
            request.setAttribute("totalBeds", totalBeds);
            
            // Forward to JSP
            request.getRequestDispatcher("/WEB-INF/view/manager/rooms-management.jsp")
                   .forward(request, response);
                   
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in rooms management", e);
            request.setAttribute("errorMessage", "Lỗi khi tải dữ liệu phòng. Vui lòng thử lại.");
            request.getRequestDispatcher("/WEB-INF/view/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Handles room details page with roomId parameter
     */
    private void handleRoomDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String roomIdStr = request.getParameter("roomId");
        if (roomIdStr == null || roomIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Room ID is required");
            return;
        }
        
        handleRoomDetailsById(request, response, roomIdStr);
    }
    
    /**
     * Handles room details page by room ID
     */
    private void handleRoomDetailsById(HttpServletRequest request, HttpServletResponse response, String roomIdStr)
            throws ServletException, IOException {
        
        try {
            LOGGER.info("=== ROOM DETAILS DEBUG ===");
            LOGGER.info("Requested room ID: " + roomIdStr);
            
            // Parse room ID
            int roomId;
            try {
                roomId = Integer.parseInt(roomIdStr);
            } catch (NumberFormatException e) {
                LOGGER.warning("Invalid room ID format: " + roomIdStr);
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid room ID format");
                return;
            }
            
            // Get room details
            Optional<Room> roomOpt = roomDAO.findById(roomId);
            if (!roomOpt.isPresent()) {
                LOGGER.warning("Room not found with ID: " + roomId);
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Room not found");
                return;
            }
            
            Room room = roomOpt.get();
            LOGGER.info("Found room: " + room.getName() + " (ID: " + room.getRoomId() + ")");
            
            // Get beds for this room
            List<Bed> beds = bedDAO.getBedsByRoomId(roomId);
            LOGGER.info("Found " + beds.size() + " beds for room " + roomId);
            
            // Set room information in beds for display
            for (Bed bed : beds) {
                bed.setRoom(room);
            }
            
            // Set attributes for JSP
            request.setAttribute("room", room);
            request.setAttribute("beds", beds);
            request.setAttribute("bedCount", beds.size());
            
            // Forward to JSP
            request.getRequestDispatcher("/WEB-INF/view/manager/room-details.jsp")
                   .forward(request, response);
                   
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in room details", e);
            request.setAttribute("errorMessage", "Lỗi khi tải chi tiết phòng. Vui lòng thử lại.");
            request.getRequestDispatcher("/WEB-INF/view/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Checks if the user is authorized to access room management features
     */
    private boolean isAuthorized(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String userType = (String) session.getAttribute("userType");
        
       
        
        // Check if user is logged in
        if (user == null || userType == null) {
            LOGGER.warning("Unauthorized access attempt - no user in session");
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        
        // Check if user has manager or admin role
        if (!"MANAGER".equals(userType) && !"ADMIN".equals(userType)) {
            LOGGER.warning("Unauthorized access attempt - user type: " + userType);
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied. Manager role required.");
            return false;
        }
        
        return true;
    }
    
    /**
     * Handles POST requests for room management operations (future implementation)
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Security check
        if (!isAuthorized(request, response)) {
            return;
        }
        
        // Future implementation for room CRUD operations
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "POST operations not yet implemented");
    }
}
