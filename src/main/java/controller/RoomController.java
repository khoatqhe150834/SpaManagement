package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

import dao.BedDAO;
import dao.RoomDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
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
    "/manager/room-details/*",
    "/manager/room/add",
    "/manager/room/edit/*",
    "/manager/room/update",
    "/manager/room/delete/*",
    "/manager/room/toggle-status/*",
    "/manager/bed/add/*",
    "/manager/bed/edit/*",
    "/manager/bed/update",
    "/manager/bed/delete/*",
    "/manager/bed/toggle-status/*"
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

        LOGGER.info("=== ROOM CONTROLLER DEBUG ===");
        LOGGER.info("Request URI: " + request.getRequestURI());
        LOGGER.info("Servlet Path: " + pathInfo);
        LOGGER.info("Path Info: " + additionalPath);
        LOGGER.info("Context Path: " + request.getContextPath());

        // Security check - ensure user is logged in and has manager role
        if (!isAuthorized(request, response)) {
            return;
        }
        
        try {
            if (pathInfo.equals("/manager/rooms-management")) {
                handleRoomsManagement(request, response);
            } else if (pathInfo.startsWith("/manager/room-details")) {
                if (additionalPath != null && additionalPath.length() > 1) {
                    // Handle /manager/room-details/{roomId}
                    String roomIdStr = additionalPath.substring(1); // Remove leading slash
                    handleRoomDetailsById(request, response, roomIdStr);
                } else {
                    // Handle /manager/room-details with roomId parameter
                    handleRoomDetails(request, response);
                }
            } else if (pathInfo.equals("/manager/room/add")) {
                handleAddRoomForm(request, response);
            } else if (pathInfo.startsWith("/manager/room/edit")) {
                if (additionalPath != null && additionalPath.length() > 1) {
                    String roomIdStr = additionalPath.substring(1);
                    handleEditRoomForm(request, response, roomIdStr);
                } else {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Room ID is required");
                }
            } else if (pathInfo.startsWith("/manager/room/delete")) {
                if (additionalPath != null && additionalPath.length() > 1) {
                    String roomIdStr = additionalPath.substring(1);
                    handleDeleteRoom(request, response, roomIdStr);
                } else {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Room ID is required");
                }
            } else if (pathInfo.startsWith("/manager/room/toggle-status")) {
                if (additionalPath != null && additionalPath.length() > 1) {
                    String roomIdStr = additionalPath.substring(1);
                    handleToggleRoomStatus(request, response, roomIdStr);
                } else {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Room ID is required");
                }
            } else if (pathInfo.startsWith("/manager/bed/add")) {
                if (additionalPath != null && additionalPath.length() > 1) {
                    String roomIdStr = additionalPath.substring(1);
                    handleAddBedForm(request, response, roomIdStr);
                } else {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Room ID is required");
                }
            } else if (pathInfo.startsWith("/manager/bed/edit")) {
                if (additionalPath != null && additionalPath.length() > 1) {
                    String bedIdStr = additionalPath.substring(1);
                    handleEditBedForm(request, response, bedIdStr);
                } else {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Bed ID is required");
                }
            } else if (pathInfo.startsWith("/manager/bed/delete")) {
                if (additionalPath != null && additionalPath.length() > 1) {
                    String bedIdStr = additionalPath.substring(1);
                    handleDeleteBed(request, response, bedIdStr);
                } else {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Bed ID is required");
                }
            } else if (pathInfo.startsWith("/manager/bed/toggle-status")) {
                if (additionalPath != null && additionalPath.length() > 1) {
                    String bedIdStr = additionalPath.substring(1);
                    handleToggleBedStatus(request, response, bedIdStr);
                } else {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Bed ID is required");
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
     * Handles add room form display
     */
    private void handleAddRoomForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        LOGGER.info("Displaying add room form");

        // Forward to add room JSP
        request.getRequestDispatcher("/WEB-INF/view/manager/room-add.jsp")
               .forward(request, response);
    }

    /**
     * Handles edit room form display
     */
    private void handleEditRoomForm(HttpServletRequest request, HttpServletResponse response, String roomIdStr)
            throws ServletException, IOException {

        try {
            LOGGER.info("Displaying edit room form for room ID: " + roomIdStr);

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
            LOGGER.info("Found room for editing: " + room.getName() + " (ID: " + room.getRoomId() + ")");

            // Set attributes for JSP
            request.setAttribute("room", room);

            // Forward to edit room JSP
            request.getRequestDispatcher("/WEB-INF/view/manager/room-edit.jsp")
                   .forward(request, response);

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in edit room form", e);
            request.setAttribute("errorMessage", "Lỗi khi tải thông tin phòng. Vui lòng thử lại.");
            request.getRequestDispatcher("/WEB-INF/view/error.jsp").forward(request, response);
        }
    }

    /**
     * Handles room deletion
     */
    private void handleDeleteRoom(HttpServletRequest request, HttpServletResponse response, String roomIdStr)
            throws ServletException, IOException {

        try {
            LOGGER.info("Deleting room with ID: " + roomIdStr);

            // Parse room ID
            int roomId;
            try {
                roomId = Integer.parseInt(roomIdStr);
            } catch (NumberFormatException e) {
                LOGGER.warning("Invalid room ID format: " + roomIdStr);
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid room ID format");
                return;
            }

            // Check if room exists
            Optional<Room> roomOpt = roomDAO.findById(roomId);
            if (!roomOpt.isPresent()) {
                LOGGER.warning("Room not found with ID: " + roomId);
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Room not found");
                return;
            }

            // Delete the room
            roomDAO.deleteById(roomId);

            LOGGER.info("Successfully deleted room with ID: " + roomId);
            request.getSession().setAttribute("successMessage", "Xóa phòng thành công!");

            // Redirect back to rooms management
            response.sendRedirect(request.getContextPath() + "/manager/rooms-management");

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in delete room", e);
            request.getSession().setAttribute("errorMessage", "Lỗi khi xóa phòng. Vui lòng thử lại.");
            response.sendRedirect(request.getContextPath() + "/manager/rooms-management");
        }
    }

    /**
     * Handles room status toggle
     */
    private void handleToggleRoomStatus(HttpServletRequest request, HttpServletResponse response, String roomIdStr)
            throws ServletException, IOException {

        try {
            LOGGER.info("Toggling status for room with ID: " + roomIdStr);

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

            // Toggle status
            boolean newStatus = !room.getIsActive();
            room.setIsActive(newStatus);

            // Update the room
            Room updatedRoom = roomDAO.update(room);

            if (updatedRoom != null) {
                String statusText = newStatus ? "Hoạt động" : "Bảo trì";
                LOGGER.info("Successfully toggled status for room ID: " + roomId + " to " + statusText);
                request.getSession().setAttribute("successMessage", "Cập nhật trạng thái phòng thành công!");
            } else {
                LOGGER.warning("Failed to toggle status for room ID: " + roomId);
                request.getSession().setAttribute("errorMessage", "Không thể cập nhật trạng thái phòng. Vui lòng thử lại.");
            }

            // Redirect back to rooms management
            response.sendRedirect(request.getContextPath() + "/manager/rooms-management");

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in toggle room status", e);
            request.getSession().setAttribute("errorMessage", "Lỗi khi cập nhật trạng thái phòng. Vui lòng thử lại.");
            response.sendRedirect(request.getContextPath() + "/manager/rooms-management");
        }
    }

    /**
     * Handles POST requests for room management operations
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Security check
        if (!isAuthorized(request, response)) {
            return;
        }

        String pathInfo = request.getServletPath();

        LOGGER.info("POST request to: " + pathInfo);

        try {
            if (pathInfo.equals("/manager/room/add")) {
                handleAddRoom(request, response);
            } else if (pathInfo.equals("/manager/room/update")) {
                handleUpdateRoom(request, response);
            } else if (pathInfo.equals("/manager/bed/add")) {
                handleAddBed(request, response);
            } else if (pathInfo.equals("/manager/bed/update")) {
                handleUpdateBed(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in RoomController POST", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "An error occurred while processing your request.");
        }
    }

    /**
     * Handles room creation from form submission
     */
    private void handleAddRoom(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get form parameters
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String capacityStr = request.getParameter("capacity");

            // Validate input
            if (name == null || name.trim().isEmpty()) {
                request.getSession().setAttribute("errorMessage", "Tên phòng không được để trống.");
                response.sendRedirect(request.getContextPath() + "/manager/room/add");
                return;
            }

            if (name.trim().length() < 2) {
                request.getSession().setAttribute("errorMessage", "Tên phòng phải có ít nhất 2 ký tự.");
                response.sendRedirect(request.getContextPath() + "/manager/room/add");
                return;
            }

            if (name.trim().length() > 50) {
                request.getSession().setAttribute("errorMessage", "Tên phòng không được vượt quá 50 ký tự.");
                response.sendRedirect(request.getContextPath() + "/manager/room/add");
                return;
            }

            // Check for duplicate room name
            List<Room> existingRooms = roomDAO.findAll();
            for (Room existingRoom : existingRooms) {
                if (existingRoom.getName().equalsIgnoreCase(name.trim())) {
                    request.getSession().setAttribute("errorMessage", "Tên phòng đã tồn tại. Vui lòng chọn tên khác.");
                    response.sendRedirect(request.getContextPath() + "/manager/room/add");
                    return;
                }
            }

            // Validate description length
            if (description != null && description.trim().length() > 200) {
                request.getSession().setAttribute("errorMessage", "Mô tả không được vượt quá 200 ký tự.");
                response.sendRedirect(request.getContextPath() + "/manager/room/add");
                return;
            }

            int capacity;
            try {
                capacity = Integer.parseInt(capacityStr);
                if (capacity <= 0) {
                    throw new NumberFormatException("Capacity must be positive");
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("errorMessage", "Sức chứa phải là số nguyên dương.");
                response.sendRedirect(request.getContextPath() + "/manager/room/add");
                return;
            }

            // Create new room
            Room room = new Room(name.trim(), description != null ? description.trim() : "", capacity);

            // Save to database
            Room savedRoom = roomDAO.save(room);

            if (savedRoom != null) {
                LOGGER.info("Successfully created room: " + savedRoom.getName() + " (ID: " + savedRoom.getRoomId() + ")");
                request.getSession().setAttribute("successMessage", "Thêm phòng mới thành công!");
                response.sendRedirect(request.getContextPath() + "/manager/rooms-management");
            } else {
                LOGGER.warning("Failed to create room: " + name);
                request.getSession().setAttribute("errorMessage", "Không thể thêm phòng mới. Vui lòng thử lại.");
                response.sendRedirect(request.getContextPath() + "/manager/room/add");
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in add room", e);
            request.getSession().setAttribute("errorMessage", "Lỗi khi thêm phòng mới. Vui lòng thử lại.");
            response.sendRedirect(request.getContextPath() + "/manager/room/add");
        }
    }

    /**
     * Handles room update from form submission
     */
    private void handleUpdateRoom(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get form parameters
            String roomIdStr = request.getParameter("roomId");
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String capacityStr = request.getParameter("capacity");

            // Validate room ID
            int roomId;
            try {
                roomId = Integer.parseInt(roomIdStr);
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("errorMessage", "ID phòng không hợp lệ.");
                response.sendRedirect(request.getContextPath() + "/manager/rooms-management");
                return;
            }

            // Validate input
            if (name == null || name.trim().isEmpty()) {
                request.getSession().setAttribute("errorMessage", "Tên phòng không được để trống.");
                response.sendRedirect(request.getContextPath() + "/manager/room/edit/" + roomId);
                return;
            }

            if (name.trim().length() < 2) {
                request.getSession().setAttribute("errorMessage", "Tên phòng phải có ít nhất 2 ký tự.");
                response.sendRedirect(request.getContextPath() + "/manager/room/edit/" + roomId);
                return;
            }

            if (name.trim().length() > 50) {
                request.getSession().setAttribute("errorMessage", "Tên phòng không được vượt quá 50 ký tự.");
                response.sendRedirect(request.getContextPath() + "/manager/room/edit/" + roomId);
                return;
            }

            // Check for duplicate room name (excluding current room)
            List<Room> existingRooms = roomDAO.findAll();
            for (Room existingRoom : existingRooms) {
                if (existingRoom.getRoomId() != roomId && existingRoom.getName().equalsIgnoreCase(name.trim())) {
                    request.getSession().setAttribute("errorMessage", "Tên phòng đã tồn tại. Vui lòng chọn tên khác.");
                    response.sendRedirect(request.getContextPath() + "/manager/room/edit/" + roomId);
                    return;
                }
            }

            // Validate description length
            if (description != null && description.trim().length() > 200) {
                request.getSession().setAttribute("errorMessage", "Mô tả không được vượt quá 200 ký tự.");
                response.sendRedirect(request.getContextPath() + "/manager/room/edit/" + roomId);
                return;
            }

            int capacity;
            try {
                capacity = Integer.parseInt(capacityStr);
                if (capacity <= 0) {
                    throw new NumberFormatException("Capacity must be positive");
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("errorMessage", "Sức chứa phải là số nguyên dương.");
                response.sendRedirect(request.getContextPath() + "/manager/room/edit/" + roomId);
                return;
            }

            // Get existing room
            Optional<Room> roomOpt = roomDAO.findById(roomId);
            if (!roomOpt.isPresent()) {
                request.getSession().setAttribute("errorMessage", "Không tìm thấy phòng.");
                response.sendRedirect(request.getContextPath() + "/manager/rooms-management");
                return;
            }

            Room room = roomOpt.get();

            // Update room properties
            room.setName(name.trim());
            room.setDescription(description != null ? description.trim() : "");
            room.setCapacity(capacity);

            // Update in database
            Room updatedRoom = roomDAO.update(room);

            if (updatedRoom != null) {
                LOGGER.info("Successfully updated room: " + updatedRoom.getName() + " (ID: " + updatedRoom.getRoomId() + ")");
                request.getSession().setAttribute("successMessage", "Cập nhật thông tin phòng thành công!");
                response.sendRedirect(request.getContextPath() + "/manager/rooms-management");
            } else {
                LOGGER.warning("Failed to update room ID: " + roomId);
                request.getSession().setAttribute("errorMessage", "Không thể cập nhật thông tin phòng. Vui lòng thử lại.");
                response.sendRedirect(request.getContextPath() + "/manager/room/edit/" + roomId);
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in update room", e);
            request.getSession().setAttribute("errorMessage", "Lỗi khi cập nhật thông tin phòng. Vui lòng thử lại.");
            response.sendRedirect(request.getContextPath() + "/manager/rooms-management");
        }
    }

    // ==================== BED MANAGEMENT METHODS ====================

    /**
     * Handles bed addition form display
     */
    private void handleAddBedForm(HttpServletRequest request, HttpServletResponse response, String roomIdStr)
            throws ServletException, IOException {

        try {
            int roomId = Integer.parseInt(roomIdStr);

            // Get room information
            Optional<Room> roomOpt = roomDAO.findById(roomId);
            if (!roomOpt.isPresent()) {
                request.getSession().setAttribute("errorMessage", "Không tìm thấy phòng.");
                response.sendRedirect(request.getContextPath() + "/manager/rooms-management");
                return;
            }

            Room room = roomOpt.get();
            request.setAttribute("room", room);

            // Forward to add bed form
            request.getRequestDispatcher("/WEB-INF/view/manager/bed-add.jsp")
                   .forward(request, response);

        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid room ID format: " + roomIdStr, e);
            request.getSession().setAttribute("errorMessage", "ID phòng không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/manager/rooms-management");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in add bed form", e);
            request.getSession().setAttribute("errorMessage", "Lỗi khi tải thông tin phòng.");
            response.sendRedirect(request.getContextPath() + "/manager/rooms-management");
        }
    }

    /**
     * Handles bed edit form display
     */
    private void handleEditBedForm(HttpServletRequest request, HttpServletResponse response, String bedIdStr)
            throws ServletException, IOException {

        try {
            int bedId = Integer.parseInt(bedIdStr);

            // Get bed information
            Optional<Bed> bedOpt = bedDAO.findById(bedId);
            if (!bedOpt.isPresent()) {
                request.getSession().setAttribute("errorMessage", "Không tìm thấy giường.");
                response.sendRedirect(request.getContextPath() + "/manager/rooms-management");
                return;
            }

            Bed bed = bedOpt.get();
            request.setAttribute("bed", bed);

            // Get room information
            Optional<Room> roomOpt = roomDAO.findById(bed.getRoomId());
            if (roomOpt.isPresent()) {
                request.setAttribute("room", roomOpt.get());
            }

            // Forward to edit bed form
            request.getRequestDispatcher("/WEB-INF/view/manager/bed-edit.jsp")
                   .forward(request, response);

        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid bed ID format: " + bedIdStr, e);
            request.getSession().setAttribute("errorMessage", "ID giường không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/manager/rooms-management");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in edit bed form", e);
            request.getSession().setAttribute("errorMessage", "Lỗi khi tải thông tin giường.");
            response.sendRedirect(request.getContextPath() + "/manager/rooms-management");
        }
    }

    /**
     * Handles bed update from form submission
     */
    private void handleUpdateBed(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get form parameters
            String bedIdStr = request.getParameter("bedId");
            String roomIdStr = request.getParameter("roomId");
            String name = request.getParameter("name");
            String description = request.getParameter("description");

            // Validate input
            if (bedIdStr == null || bedIdStr.trim().isEmpty()) {
                request.getSession().setAttribute("errorMessage", "ID giường không hợp lệ.");
                response.sendRedirect(request.getContextPath() + "/manager/rooms-management");
                return;
            }

            if (name == null || name.trim().isEmpty()) {
                request.getSession().setAttribute("errorMessage", "Tên giường không được để trống.");
                response.sendRedirect(request.getContextPath() + "/manager/bed/edit/" + bedIdStr);
                return;
            }

            if (name.trim().length() < 2) {
                request.getSession().setAttribute("errorMessage", "Tên giường phải có ít nhất 2 ký tự.");
                response.sendRedirect(request.getContextPath() + "/manager/bed/edit/" + bedIdStr);
                return;
            }

            if (name.trim().length() > 50) {
                request.getSession().setAttribute("errorMessage", "Tên giường không được vượt quá 50 ký tự.");
                response.sendRedirect(request.getContextPath() + "/manager/bed/edit/" + bedIdStr);
                return;
            }

            int bedId = Integer.parseInt(bedIdStr);
            int roomId = Integer.parseInt(roomIdStr);

            // Get existing bed
            Optional<Bed> bedOpt = bedDAO.findById(bedId);
            if (!bedOpt.isPresent()) {
                request.getSession().setAttribute("errorMessage", "Không tìm thấy giường.");
                response.sendRedirect(request.getContextPath() + "/manager/rooms-management");
                return;
            }

            Bed bed = bedOpt.get();
            bed.setName(name.trim());
            bed.setDescription(description != null ? description.trim() : "");

            // Update bed
            bedDAO.update(bed);

            LOGGER.info("Bed updated successfully with ID: " + bedId);
            request.getSession().setAttribute("successMessage", "Cập nhật thông tin giường thành công!");
            response.sendRedirect(request.getContextPath() + "/manager/room-details/" + roomId);

        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid ID format in update bed", e);
            request.getSession().setAttribute("errorMessage", "ID không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/manager/rooms-management");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in update bed", e);
            request.getSession().setAttribute("errorMessage", "Lỗi khi cập nhật thông tin giường. Vui lòng thử lại.");
            response.sendRedirect(request.getContextPath() + "/manager/rooms-management");
        }
    }

    /**
     * Handles bed creation from form submission
     */
    private void handleAddBed(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get form parameters
            String roomIdStr = request.getParameter("roomId");
            String name = request.getParameter("name");
            String description = request.getParameter("description");

            // Validate input
            if (roomIdStr == null || roomIdStr.trim().isEmpty()) {
                request.getSession().setAttribute("errorMessage", "ID phòng không hợp lệ.");
                response.sendRedirect(request.getContextPath() + "/manager/rooms-management");
                return;
            }

            if (name == null || name.trim().isEmpty()) {
                request.getSession().setAttribute("errorMessage", "Tên giường không được để trống.");
                response.sendRedirect(request.getContextPath() + "/manager/bed/add/" + roomIdStr);
                return;
            }

            if (name.trim().length() < 2) {
                request.getSession().setAttribute("errorMessage", "Tên giường phải có ít nhất 2 ký tự.");
                response.sendRedirect(request.getContextPath() + "/manager/bed/add/" + roomIdStr);
                return;
            }

            if (name.trim().length() > 50) {
                request.getSession().setAttribute("errorMessage", "Tên giường không được vượt quá 50 ký tự.");
                response.sendRedirect(request.getContextPath() + "/manager/bed/add/" + roomIdStr);
                return;
            }

            int roomId = Integer.parseInt(roomIdStr);

            // Verify room exists
            Optional<Room> roomOpt = roomDAO.findById(roomId);
            if (!roomOpt.isPresent()) {
                request.getSession().setAttribute("errorMessage", "Không tìm thấy phòng.");
                response.sendRedirect(request.getContextPath() + "/manager/rooms-management");
                return;
            }

            // Create new bed
            Bed bed = new Bed(roomId, name.trim(), description != null ? description.trim() : "");

            // Save bed
            bedDAO.save(bed);

            LOGGER.info("Bed created successfully for room ID: " + roomId);
            request.getSession().setAttribute("successMessage", "Thêm giường mới thành công!");
            response.sendRedirect(request.getContextPath() + "/manager/room-details/" + roomId);

        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid room ID format in add bed", e);
            request.getSession().setAttribute("errorMessage", "ID phòng không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/manager/rooms-management");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in add bed", e);
            request.getSession().setAttribute("errorMessage", "Lỗi khi thêm giường mới. Vui lòng thử lại.");
            response.sendRedirect(request.getContextPath() + "/manager/rooms-management");
        }
    }

    /**
     * Handles bed deletion
     */
    private void handleDeleteBed(HttpServletRequest request, HttpServletResponse response, String bedIdStr)
            throws ServletException, IOException {

        try {
            int bedId = Integer.parseInt(bedIdStr);

            // Get bed information to get room ID for redirect
            Optional<Bed> bedOpt = bedDAO.findById(bedId);
            if (!bedOpt.isPresent()) {
                request.getSession().setAttribute("errorMessage", "Không tìm thấy giường.");
                response.sendRedirect(request.getContextPath() + "/manager/rooms-management");
                return;
            }

            Bed bed = bedOpt.get();
            int roomId = bed.getRoomId();

            // Delete bed
            bedDAO.deleteById(bedId);

            LOGGER.info("Bed deleted successfully with ID: " + bedId);
            request.getSession().setAttribute("successMessage", "Xóa giường thành công!");
            response.sendRedirect(request.getContextPath() + "/manager/room-details/" + roomId);

        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid bed ID format: " + bedIdStr, e);
            request.getSession().setAttribute("errorMessage", "ID giường không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/manager/rooms-management");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in delete bed", e);
            request.getSession().setAttribute("errorMessage", "Lỗi khi xóa giường. Vui lòng thử lại.");
            response.sendRedirect(request.getContextPath() + "/manager/rooms-management");
        }
    }

    /**
     * Handles bed status toggle (active/inactive)
     */
    private void handleToggleBedStatus(HttpServletRequest request, HttpServletResponse response, String bedIdStr)
            throws ServletException, IOException {

        try {
            int bedId = Integer.parseInt(bedIdStr);

            // Get bed information
            Optional<Bed> bedOpt = bedDAO.findById(bedId);
            if (!bedOpt.isPresent()) {
                request.getSession().setAttribute("errorMessage", "Không tìm thấy giường.");
                response.sendRedirect(request.getContextPath() + "/manager/rooms-management");
                return;
            }

            Bed bed = bedOpt.get();
            int roomId = bed.getRoomId();

            // Toggle status
            bed.setIsActive(!bed.getIsActive());

            // Update bed
            bedDAO.update(bed);

            String statusText = bed.getIsActive() ? "kích hoạt" : "vô hiệu hóa";
            LOGGER.info("Bed status toggled successfully for ID: " + bedId + " to " + bed.getIsActive());
            request.getSession().setAttribute("successMessage", "Đã " + statusText + " giường thành công!");
            response.sendRedirect(request.getContextPath() + "/manager/room-details/" + roomId);

        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid bed ID format: " + bedIdStr, e);
            request.getSession().setAttribute("errorMessage", "ID giường không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/manager/rooms-management");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in toggle bed status", e);
            request.getSession().setAttribute("errorMessage", "Lỗi khi thay đổi trạng thái giường. Vui lòng thử lại.");
            response.sendRedirect(request.getContextPath() + "/manager/rooms-management");
        }
    }
}
