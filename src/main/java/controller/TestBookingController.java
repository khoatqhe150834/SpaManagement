package controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonElement;
import com.google.gson.JsonPrimitive;
import com.google.gson.JsonSerializationContext;
import com.google.gson.JsonSerializer;
import dao.BedDAO;
import dao.BookingDAO;
import dao.RoomDAO;
import dao.ServiceDAO;
import dao.StaffDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.lang.reflect.Type;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.logging.Logger;
import model.Bed;
import model.Room;
import model.Service;
import model.ServiceType;
import model.User;
import model.csp.BookingAssignment;
import model.csp.BookingCSPRequest;
import service.BookingCSPSolver;
import service.RealTimeAvailabilityService;
import service.TimeSlotGenerationTest;

/**
 * Test Booking Controller for debugging CSP solver functionality
 * Provides comprehensive testing tools for booking scenarios
 */
@WebServlet("/test/booking/*")
public class TestBookingController extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(TestBookingController.class.getName());
    
    private final Gson gson;
    private final ServiceDAO serviceDAO;
    private final UserDAO userDAO;
    private final BookingDAO bookingDAO;
    private final StaffDAO staffDAO;
    private final RoomDAO roomDAO;
    private final BedDAO bedDAO;
    private final BookingCSPSolver cspSolver;
    private final RealTimeAvailabilityService availabilityService;
    
    public TestBookingController() {
        this.gson = new GsonBuilder()
            .setDateFormat("yyyy-MM-dd HH:mm:ss")
            .registerTypeAdapter(LocalDateTime.class, new JsonSerializer<LocalDateTime>() {
                @Override
                public JsonElement serialize(LocalDateTime src, Type typeOfSrc, JsonSerializationContext context) {
                    return new JsonPrimitive(src.format(DateTimeFormatter.ISO_LOCAL_DATE_TIME));
                }
            })
            .registerTypeAdapter(LocalDate.class, new JsonSerializer<LocalDate>() {
                @Override
                public JsonElement serialize(LocalDate src, Type typeOfSrc, JsonSerializationContext context) {
                    return new JsonPrimitive(src.format(DateTimeFormatter.ISO_LOCAL_DATE));
                }
            })
            .create();
        this.serviceDAO = new ServiceDAO();
        this.userDAO = new UserDAO();
        this.bookingDAO = new BookingDAO();
        this.staffDAO = new StaffDAO();
        this.roomDAO = new RoomDAO();
        this.bedDAO = new BedDAO();
        this.cspSolver = new BookingCSPSolver();
        this.availabilityService = new RealTimeAvailabilityService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        handleRequest(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        handleRequest(request, response);
    }
    
    private void handleRequest(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Set CORS headers for testing
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type, Accept, X-Requested-With");
        
        String pathInfo = request.getPathInfo();
        String action = request.getParameter("action");
        
        LOGGER.info("Test Booking Controller - Path: " + pathInfo + ", Action: " + action);
        
        try {
            switch (action != null ? action : "default") {
                case "load_services":
                    handleLoadServices(request, response);
                    break;
                case "load_customers":
                    handleLoadCustomers(request, response);
                    break;
                case "load_qualified_therapists":
                    handleLoadQualifiedTherapists(request, response);
                    break;
                case "load_rooms":
                    handleLoadRooms(request, response);
                    break;
                case "load_beds":
                    handleLoadBeds(request, response);
                    break;
                case "test_csp_solver":
                    handleTestCSPSolver(request, response);
                    break;
                case "test_availability_service":
                    handleTestAvailabilityService(request, response);
                    break;
                case "test_time_generation":
                    handleTestTimeGeneration(request, response);
                    break;
                case "simulate_conflicts":
                    handleSimulateConflicts(request, response);
                    break;
                case "load_existing_bookings":
                    handleLoadExistingBookings(request, response);
                    break;
                case "performance_test":
                    handlePerformanceTest(request, response);
                    break;
                default:
                    handleDefault(request, response);
                    break;
            }
        } catch (Exception e) {
            LOGGER.severe("Error in test booking controller: " + e.getMessage());
            e.printStackTrace();
            handleError(response, e);
        }
    }
    
    /**
     * Load all active services from database
     */
    private void handleLoadServices(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, SQLException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        List<Service> services = serviceDAO.findAll();
        
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "Services loaded successfully");
        result.put("count", services.size());
        result.put("data", services);
        result.put("timestamp", System.currentTimeMillis());
        
        response.getWriter().write(gson.toJson(result));
    }
    
    /**
     * Load customers for testing
     */
    private void handleLoadCustomers(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, SQLException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        // Get customers (role_id = 4)
        List<User> customers = userDAO.findByRoleId(4, 1, 50);
        
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "Customers loaded successfully");
        result.put("count", customers.size());
        result.put("data", customers);
        result.put("timestamp", System.currentTimeMillis());
        
        response.getWriter().write(gson.toJson(result));
    }

    /**
     * Load qualified therapists for a specific service
     */
    private void handleLoadQualifiedTherapists(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String serviceIdStr = request.getParameter("serviceId");
            if (serviceIdStr == null || serviceIdStr.trim().isEmpty()) {
                Map<String, Object> result = new HashMap<>();
                result.put("success", false);
                result.put("message", "Service ID is required");
                result.put("timestamp", System.currentTimeMillis());

                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write(gson.toJson(result));
                return;
            }

            int serviceId = Integer.parseInt(serviceIdStr);

            // First, get the service to find its service type
            Service service = serviceDAO.findById(serviceId).orElse(null);
            if (service == null) {
                Map<String, Object> result = new HashMap<>();
                result.put("success", false);
                result.put("message", "Service not found with ID: " + serviceId);
                result.put("timestamp", System.currentTimeMillis());

                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write(gson.toJson(result));
                return;
            }

            // Get the service type from the service
            ServiceType serviceType = service.getServiceTypeId();
            if (serviceType == null) {
                Map<String, Object> result = new HashMap<>();
                result.put("success", false);
                result.put("message", "Service does not have a service type assigned");
                result.put("timestamp", System.currentTimeMillis());

                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write(gson.toJson(result));
                return;
            }

            int serviceTypeId = serviceType.getServiceTypeId();

            // Find qualified therapists by service type
            List<model.Staff> qualifiedTherapists = staffDAO.findTherapistsByServiceType(serviceTypeId, true);

            // Convert to JSON-friendly format with service type information
            List<Map<String, Object>> therapistData = new ArrayList<>();
            for (model.Staff therapist : qualifiedTherapists) {
                Map<String, Object> therapistMap = new HashMap<>();
                therapistMap.put("userId", therapist.getUser().getUserId());
                therapistMap.put("fullName", therapist.getUser().getFullName());
                therapistMap.put("email", therapist.getUser().getEmail());
                therapistMap.put("phone", therapist.getUser().getPhoneNumber());
                therapistMap.put("yearsOfExperience", therapist.getYearsOfExperience());
                therapistMap.put("availabilityStatus", therapist.getAvailabilityStatus().toString());
                therapistMap.put("bio", therapist.getBio());

                // Add service type information for debugging
                if (therapist.getServiceType() != null) {
                    therapistMap.put("serviceTypeId", therapist.getServiceType().getServiceTypeId());
                    therapistMap.put("serviceTypeName", therapist.getServiceType().getName());
                } else {
                    therapistMap.put("serviceTypeId", null);
                    therapistMap.put("serviceTypeName", "No service type");
                }

                therapistData.add(therapistMap);
            }

            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("message", "Qualified therapists loaded successfully");
            result.put("serviceId", serviceId);
            result.put("serviceName", service.getName());
            result.put("serviceTypeId", serviceTypeId);
            result.put("serviceTypeName", serviceType.getName());
            result.put("count", qualifiedTherapists.size());
            result.put("data", therapistData);
            result.put("timestamp", System.currentTimeMillis());

            response.getWriter().write(gson.toJson(result));

        } catch (NumberFormatException e) {
            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "Invalid service ID format");
            result.put("error", e.getMessage());
            result.put("timestamp", System.currentTimeMillis());

            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(gson.toJson(result));

        }
    }

    /**
     * Load all available rooms
     */
    private void handleLoadRooms(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            List<model.Room> rooms = roomDAO.findAll();

            // Convert to JSON-friendly format
            List<Map<String, Object>> roomData = new ArrayList<>();
            for (model.Room room : rooms) {
                Map<String, Object> roomMap = new HashMap<>();
                roomMap.put("roomId", room.getRoomId());
                roomMap.put("name", room.getName());
                roomMap.put("description", room.getDescription());
                roomMap.put("capacity", room.getCapacity());
                roomMap.put("isActive", room.getIsActive());
                roomMap.put("createdAt", room.getCreatedAt() != null ?
                    room.getCreatedAt().toLocalDateTime().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME) : null);
                roomMap.put("updatedAt", room.getUpdatedAt() != null ?
                    room.getUpdatedAt().toLocalDateTime().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME) : null);
                roomData.add(roomMap);
            }

            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("message", "Rooms loaded successfully");
            result.put("count", rooms.size());
            result.put("data", roomData);
            result.put("timestamp", System.currentTimeMillis());

            response.getWriter().write(gson.toJson(result));

        } catch (SQLException e) {
            LOGGER.severe("Database error loading rooms: " + e.getMessage());
            e.printStackTrace();

            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "Database error loading rooms: " + e.getMessage());
            result.put("error", e.getClass().getSimpleName());
            result.put("timestamp", System.currentTimeMillis());

            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(result));
        }
    }

    /**
     * Load beds for a specific room
     */
    private void handleLoadBeds(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String roomIdStr = request.getParameter("roomId");

            List<model.Bed> beds;
            if (roomIdStr != null && !roomIdStr.trim().isEmpty()) {
                // Load beds for specific room
                int roomId = Integer.parseInt(roomIdStr);
                beds = bedDAO.getBedsByRoomId(roomId);
            } else {
                // Load all beds if no room specified
                beds = bedDAO.findAll();
            }

            // Convert to JSON-friendly format
            List<Map<String, Object>> bedData = new ArrayList<>();
            for (model.Bed bed : beds) {
                Map<String, Object> bedMap = new HashMap<>();
                bedMap.put("bedId", bed.getBedId());
                bedMap.put("roomId", bed.getRoomId());
                bedMap.put("name", bed.getName());
                bedMap.put("description", bed.getDescription());
                bedMap.put("isActive", bed.getIsActive());
                bedMap.put("createdAt", bed.getCreatedAt() != null ?
                    bed.getCreatedAt().toLocalDateTime().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME) : null);
                bedMap.put("updatedAt", bed.getUpdatedAt() != null ?
                    bed.getUpdatedAt().toLocalDateTime().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME) : null);

                // Add room information if available
                if (bed.getRoom() != null) {
                    bedMap.put("roomName", bed.getRoom().getName());
                    bedMap.put("roomCapacity", bed.getRoom().getCapacity());
                } else {
                    bedMap.put("roomName", "Unknown Room");
                    bedMap.put("roomCapacity", 0);
                }

                bedData.add(bedMap);
            }

            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("message", roomIdStr != null ?
                "Beds loaded successfully for room ID " + roomIdStr :
                "All beds loaded successfully");
            result.put("roomId", roomIdStr != null ? Integer.parseInt(roomIdStr) : null);
            result.put("count", beds.size());
            result.put("data", bedData);
            result.put("timestamp", System.currentTimeMillis());

            response.getWriter().write(gson.toJson(result));

        } catch (NumberFormatException e) {
            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "Invalid room ID format");
            result.put("error", e.getMessage());
            result.put("timestamp", System.currentTimeMillis());

            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(gson.toJson(result));

        } catch (SQLException e) {
            LOGGER.severe("Database error loading beds: " + e.getMessage());
            e.printStackTrace();

            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "Database error loading beds: " + e.getMessage());
            result.put("error", e.getClass().getSimpleName());
            result.put("timestamp", System.currentTimeMillis());

            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(result));
        }
    }

    /**
     * Test CSP solver with specific parameters
     */
    private void handleTestCSPSolver(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, SQLException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        long startTime = System.currentTimeMillis();
        
        try {
            // Parse parameters
            int serviceId = Integer.parseInt(request.getParameter("serviceId"));
            int customerId = Integer.parseInt(request.getParameter("customerId"));
            String dateStr = request.getParameter("date");
            int maxResults = Integer.parseInt(request.getParameter("maxResults") != null ? 
                request.getParameter("maxResults") : "50");
            
            LocalDate testDate = LocalDate.parse(dateStr);
            
            // Create CSP request
            BookingCSPRequest cspRequest = new BookingCSPRequest();
            cspRequest.setServiceId(serviceId);
            cspRequest.setCustomerId(customerId);
            cspRequest.setPreferredDate(testDate);
            cspRequest.setSearchStartDate(testDate);
            cspRequest.setSearchEndDate(testDate);
            cspRequest.setMaxResults(maxResults);
            cspRequest.setIncludeWeekends(true);
            
            // Run CSP solver
            List<BookingAssignment> solutions = cspSolver.findAvailableSlots(cspRequest);

            long executionTime = System.currentTimeMillis() - startTime;

            // Convert solutions to JSON-friendly format
            List<Map<String, Object>> jsonFriendlySolutions = new ArrayList<>();
            for (BookingAssignment assignment : solutions) {
                Map<String, Object> solutionMap = new HashMap<>();
                solutionMap.put("therapistId", assignment.getTherapistId());
                solutionMap.put("roomId", assignment.getRoomId());
                solutionMap.put("bedId", assignment.getBedId());
                solutionMap.put("confidenceLevel", assignment.getConfidenceLevel() != null ?
                    assignment.getConfidenceLevel().toString() : null);
                solutionMap.put("notes", assignment.getNotes());

                // Convert TimeSlot to JSON-friendly format
                if (assignment.getTimeSlot() != null) {
                    Map<String, Object> timeSlotMap = new HashMap<>();
                    timeSlotMap.put("startTime", assignment.getTimeSlot().getStartTime().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME));
                    timeSlotMap.put("endTime", assignment.getTimeSlot().getEndTime().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME));
                    timeSlotMap.put("durationMinutes", assignment.getTimeSlot().getDurationMinutes());
                    solutionMap.put("timeSlot", timeSlotMap);
                }

                jsonFriendlySolutions.add(solutionMap);
            }

            // Analyze results
            Map<String, Object> analysis = analyzeCSPResults(solutions);

            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("message", "CSP solver test completed");
            result.put("executionTime", executionTime);
            result.put("solutionsFound", solutions.size());
            result.put("data", jsonFriendlySolutions);
            result.put("analysis", analysis);
            result.put("parameters", Map.of(
                "serviceId", serviceId,
                "customerId", customerId,
                "date", dateStr,
                "maxResults", maxResults
            ));
            result.put("timestamp", System.currentTimeMillis());
            
            response.getWriter().write(gson.toJson(result));
            
        } catch (Exception e) {
            long executionTime = System.currentTimeMillis() - startTime;
            
            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "CSP solver test failed: " + e.getMessage());
            result.put("error", e.getClass().getSimpleName());
            result.put("executionTime", executionTime);
            result.put("timestamp", System.currentTimeMillis());
            
            response.getWriter().write(gson.toJson(result));
        }
    }
    
    /**
     * Test real-time availability service
     */
    private void handleTestAvailabilityService(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, SQLException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        long startTime = System.currentTimeMillis();
        
        try {
            // Parse parameters
            int serviceId = Integer.parseInt(request.getParameter("serviceId"));
            int customerId = Integer.parseInt(request.getParameter("customerId"));
            String dateStr = request.getParameter("date");
            
            LocalDate testDate = LocalDate.parse(dateStr);
            
            // Run availability service
            List<RealTimeAvailabilityService.AvailabilitySlot> slots =
                availabilityService.getAvailabilityForDate(testDate, serviceId, customerId);

            long executionTime = System.currentTimeMillis() - startTime;

            // Convert slots to JSON-friendly format
            List<Map<String, Object>> jsonFriendlySlots = new ArrayList<>();
            for (RealTimeAvailabilityService.AvailabilitySlot slot : slots) {
                Map<String, Object> slotMap = new HashMap<>();
                slotMap.put("startTime", slot.getStartTime().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME));
                slotMap.put("endTime", slot.getEndTime().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME));
                slotMap.put("available", slot.isAvailable());
                // Add only the methods that exist in AvailabilitySlot
                jsonFriendlySlots.add(slotMap);
            }

            // Analyze results
            Map<String, Object> analysis = analyzeAvailabilityResults(slots);

            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("message", "Availability service test completed");
            result.put("executionTime", executionTime);
            result.put("slotsFound", slots.size());
            result.put("data", jsonFriendlySlots);
            result.put("analysis", analysis);
            result.put("parameters", Map.of(
                "serviceId", serviceId,
                "customerId", customerId,
                "date", dateStr
            ));
            result.put("timestamp", System.currentTimeMillis());
            
            response.getWriter().write(gson.toJson(result));
            
        } catch (Exception e) {
            long executionTime = System.currentTimeMillis() - startTime;
            
            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "Availability service test failed: " + e.getMessage());
            result.put("error", e.getClass().getSimpleName());
            result.put("executionTime", executionTime);
            result.put("timestamp", System.currentTimeMillis());
            
            response.getWriter().write(gson.toJson(result));
        }
    }

    /**
     * Handle default request
     */
    private void handleDefault(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "Test Booking Controller is running");
        result.put("availableActions", Arrays.asList(
            "load_services", "load_customers", "test_csp_solver",
            "test_availability_service", "test_time_generation",
            "simulate_conflicts", "load_existing_bookings", "performance_test"
        ));
        result.put("timestamp", System.currentTimeMillis());

        response.getWriter().write(gson.toJson(result));
    }

    /**
     * Handle errors
     */
    private void handleError(HttpServletResponse response, Exception e) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);

        Map<String, Object> result = new HashMap<>();
        result.put("success", false);
        result.put("message", "Internal server error: " + e.getMessage());
        result.put("error", e.getClass().getSimpleName());
        result.put("timestamp", System.currentTimeMillis());

        response.getWriter().write(gson.toJson(result));
    }

    /**
     * Analyze CSP solver results
     */
    private Map<String, Object> analyzeCSPResults(List<BookingAssignment> solutions) {
        Map<String, Object> analysis = new HashMap<>();

        if (solutions.isEmpty()) {
            analysis.put("status", "NO_SOLUTIONS");
            analysis.put("issue", "No booking slots found - possible constraint issue");
            return analysis;
        }

        // Count unique time slots
        Set<String> uniqueStartTimes = new HashSet<>();
        for (BookingAssignment assignment : solutions) {
            if (assignment.getTimeSlot() != null) {
                uniqueStartTimes.add(assignment.getTimeSlot().getStartTime().toString());
            }
        }

        analysis.put("totalSolutions", solutions.size());
        analysis.put("uniqueTimeSlots", uniqueStartTimes.size());

        if (uniqueStartTimes.size() == 1) {
            analysis.put("status", "SINGLE_SLOT_BUG");
            analysis.put("issue", "Only one unique time slot found - constraint propagation bug detected!");
        } else if (uniqueStartTimes.size() > 15) {
            analysis.put("status", "HEALTHY");
            analysis.put("issue", "Good distribution of time slots");
        } else {
            analysis.put("status", "LIMITED");
            analysis.put("issue", "Limited time slots available");
        }

        return analysis;
    }

    /**
     * Analyze availability service results
     */
    private Map<String, Object> analyzeAvailabilityResults(List<RealTimeAvailabilityService.AvailabilitySlot> slots) {
        Map<String, Object> analysis = new HashMap<>();

        if (slots.isEmpty()) {
            analysis.put("status", "NO_SLOTS");
            analysis.put("issue", "No time slots generated");
            return analysis;
        }

        int availableCount = 0;
        for (RealTimeAvailabilityService.AvailabilitySlot slot : slots) {
            if (slot.isAvailable()) {
                availableCount++;
            }
        }

        analysis.put("totalSlots", slots.size());
        analysis.put("availableSlots", availableCount);
        analysis.put("availabilityRate", slots.size() > 0 ? (double) availableCount / slots.size() : 0);

        if (slots.size() > 20) {
            analysis.put("status", "HEALTHY");
            analysis.put("issue", "Good number of time slots generated");
        } else if (slots.size() == 1) {
            analysis.put("status", "SINGLE_SLOT_BUG");
            analysis.put("issue", "Only one time slot generated - algorithm issue!");
        } else {
            analysis.put("status", "LIMITED");
            analysis.put("issue", "Limited time slots generated");
        }

        return analysis;
    }

    /**
     * Test time slot generation algorithm
     */
    private void handleTestTimeGeneration(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        long startTime = System.currentTimeMillis();

        try {
            String dateStr = request.getParameter("date");
            int serviceDuration = Integer.parseInt(request.getParameter("serviceDuration") != null ?
                request.getParameter("serviceDuration") : "75");

            // Run time slot generation test
            String testResult = TimeSlotGenerationTest.runDiagnosticTest();

            long executionTime = System.currentTimeMillis() - startTime;

            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("message", "Time generation test completed");
            result.put("executionTime", executionTime);
            result.put("testOutput", testResult);
            result.put("parameters", Map.of(
                "date", dateStr != null ? dateStr : "2025-07-25",
                "serviceDuration", serviceDuration
            ));
            result.put("timestamp", System.currentTimeMillis());

            response.getWriter().write(gson.toJson(result));

        } catch (Exception e) {
            long executionTime = System.currentTimeMillis() - startTime;

            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "Time generation test failed: " + e.getMessage());
            result.put("error", e.getClass().getSimpleName());
            result.put("executionTime", executionTime);
            result.put("timestamp", System.currentTimeMillis());

            response.getWriter().write(gson.toJson(result));
        }
    }

    /**
     * Simulate booking conflicts for testing
     */
    private void handleSimulateConflicts(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String dateStr = request.getParameter("date");
            if (dateStr == null) dateStr = "2025-07-25";

            // Create conflict scenarios
            List<Map<String, Object>> conflictScenarios = new ArrayList<>();

            // Scenario 1: Peak hours (10:00-14:00)
            conflictScenarios.add(createConflictScenario("Peak Hours",
                "Multiple bookings during busy period", dateStr, 10, 14));

            // Scenario 2: End of day (18:00-20:00)
            conflictScenarios.add(createConflictScenario("End of Day",
                "Limited slots before closing", dateStr, 18, 20));

            // Scenario 3: Back-to-back bookings
            conflictScenarios.add(createConflictScenario("Back-to-back",
                "Consecutive bookings with no gaps", dateStr, 9, 12));

            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("message", "Conflict simulation completed");
            result.put("conflictScenarios", conflictScenarios);
            result.put("date", dateStr);
            result.put("timestamp", System.currentTimeMillis());

            response.getWriter().write(gson.toJson(result));

        } catch (Exception e) {
            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "Conflict simulation failed: " + e.getMessage());
            result.put("error", e.getClass().getSimpleName());
            result.put("timestamp", System.currentTimeMillis());

            response.getWriter().write(gson.toJson(result));
        }
    }

    /**
     * Load existing bookings for a date
     */
    private void handleLoadExistingBookings(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String dateStr = request.getParameter("date");
            if (dateStr == null) dateStr = "2025-07-25";

            // For now, return mock data since we don't have the exact booking query method
            List<Map<String, Object>> mockBookings = new ArrayList<>();

            Map<String, Object> booking1 = new HashMap<>();
            booking1.put("bookingId", 1);
            booking1.put("customerName", "Test Customer 1");
            booking1.put("serviceName", "Massage Therapy");
            booking1.put("startTime", "10:00");
            booking1.put("endTime", "11:15");
            booking1.put("status", "confirmed");
            mockBookings.add(booking1);

            Map<String, Object> booking2 = new HashMap<>();
            booking2.put("bookingId", 2);
            booking2.put("customerName", "Test Customer 2");
            booking2.put("serviceName", "Facial Treatment");
            booking2.put("startTime", "14:30");
            booking2.put("endTime", "15:45");
            booking2.put("status", "confirmed");
            mockBookings.add(booking2);

            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("message", "Existing bookings loaded (mock data)");
            result.put("count", mockBookings.size());
            result.put("data", mockBookings);
            result.put("date", dateStr);
            result.put("timestamp", System.currentTimeMillis());

            response.getWriter().write(gson.toJson(result));

        } catch (Exception e) {
            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "Failed to load existing bookings: " + e.getMessage());
            result.put("error", e.getClass().getSimpleName());
            result.put("timestamp", System.currentTimeMillis());

            response.getWriter().write(gson.toJson(result));
        }
    }

    /**
     * Performance test with multiple scenarios
     */
    private void handlePerformanceTest(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            int iterations = Integer.parseInt(request.getParameter("iterations") != null ?
                request.getParameter("iterations") : "5");

            List<Map<String, Object>> performanceResults = new ArrayList<>();

            // Test different scenarios
            String[] testScenarios = {"Basic Test", "Service Loading", "Time Generation"};

            for (String scenario : testScenarios) {
                long totalTime = 0;
                int successCount = 0;

                for (int i = 0; i < iterations; i++) {
                    long startTime = System.currentTimeMillis();

                    try {
                        // Simulate different test operations
                        switch (scenario) {
                            case "Basic Test":
                                Thread.sleep(10); // Simulate basic operation
                                break;
                            case "Service Loading":
                                serviceDAO.findAll(); // Actual database call
                                break;
                            case "Time Generation":
                                TimeSlotGenerationTest.runDiagnosticTest(); // Actual time generation
                                break;
                        }

                        totalTime += (System.currentTimeMillis() - startTime);
                        successCount++;

                    } catch (Exception e) {
                        LOGGER.warning("Performance test iteration failed: " + e.getMessage());
                    }
                }

                Map<String, Object> scenarioResult = new HashMap<>();
                scenarioResult.put("scenario", scenario);
                scenarioResult.put("iterations", iterations);
                scenarioResult.put("successCount", successCount);
                scenarioResult.put("averageTime", successCount > 0 ? totalTime / successCount : 0);
                scenarioResult.put("totalTime", totalTime);

                performanceResults.add(scenarioResult);
            }

            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("message", "Performance test completed");
            result.put("results", performanceResults);
            result.put("timestamp", System.currentTimeMillis());

            response.getWriter().write(gson.toJson(result));

        } catch (Exception e) {
            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "Performance test failed: " + e.getMessage());
            result.put("error", e.getClass().getSimpleName());
            result.put("timestamp", System.currentTimeMillis());

            response.getWriter().write(gson.toJson(result));
        }
    }

    /**
     * Create conflict scenario for testing
     */
    private Map<String, Object> createConflictScenario(String name, String description,
            String date, int startHour, int endHour) {

        Map<String, Object> scenario = new HashMap<>();
        scenario.put("name", name);
        scenario.put("description", description);
        scenario.put("date", date);
        scenario.put("timeRange", startHour + ":00 - " + endHour + ":00");

        // Create mock conflicting bookings
        List<Map<String, Object>> conflicts = new ArrayList<>();
        for (int hour = startHour; hour < endHour; hour += 2) {
            Map<String, Object> conflict = new HashMap<>();
            conflict.put("time", String.format("%02d:00", hour));
            conflict.put("duration", 90);
            conflict.put("service", "Test Service");
            conflict.put("therapist", "Test Therapist " + hour);
            conflicts.add(conflict);
        }

        scenario.put("conflicts", conflicts);
        scenario.put("conflictCount", conflicts.size());

        return scenario;
    }

    @Override
    protected void doOptions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Handle CORS preflight requests
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type, Accept, X-Requested-With");
        response.setStatus(HttpServletResponse.SC_OK);
    }
}
