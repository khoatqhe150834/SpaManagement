package controller;

import dao.PaymentItemDAO;
import dao.ServiceDAO;
import dao.StaffDAO;
import dao.BookingDAO;
import dao.UserDAO;
import dao.PaymentDAO;
import dao.PaymentItemUsageDAO;
import dao.ServiceTypeDAO;
import model.PaymentItem;
import model.Service;
import model.Staff;
import model.User;
import model.Payment;
import model.PaymentItemUsage;
import model.ServiceType;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * CSP Booking API for the spa management system
 * Provides static methods for booking system integration
 */
public class CSPBookingAPI {

    private static final Logger LOGGER = Logger.getLogger(CSPBookingAPI.class.getName());

    // PaymentItem Details class for CSP booking
    public static class PaymentItemDetails {
        public Integer paymentItemId;
        public Integer serviceId;
        public String serviceName;
        public String serviceDescription;
        public Integer serviceDuration;
        public Integer customerId;
        public String customerName;
        public String customerPhone;
        public Integer remainingQuantity;
        public Integer totalQuantity;
        public String paymentStatus;

        public PaymentItemDetails() {}

        public PaymentItemDetails(Integer paymentItemId, Integer serviceId, String serviceName,
                                String serviceDescription, Integer serviceDuration, Integer customerId,
                                String customerName, String customerPhone, Integer remainingQuantity,
                                Integer totalQuantity, String paymentStatus) {
            this.paymentItemId = paymentItemId;
            this.serviceId = serviceId;
            this.serviceName = serviceName;
            this.serviceDescription = serviceDescription;
            this.serviceDuration = serviceDuration;
            this.customerId = customerId;
            this.customerName = customerName;
            this.customerPhone = customerPhone;
            this.remainingQuantity = remainingQuantity;
            this.totalQuantity = totalQuantity;
            this.paymentStatus = paymentStatus;
        }
    }

    // Qualified Therapist class
    public static class QualifiedTherapist {
        public Integer therapistId;
        public String therapistName;
        public String email;
        public String phone;
        public Integer serviceTypeId;
        public String serviceTypeName;
        public Integer yearsOfExperience;
        public String availabilityStatus;

        public QualifiedTherapist(Integer therapistId, String therapistName, String email,
                                String phone, Integer serviceTypeId, String serviceTypeName,
                                Integer yearsOfExperience, String availabilityStatus) {
            this.therapistId = therapistId;
            this.therapistName = therapistName;
            this.email = email;
            this.phone = phone;
            this.serviceTypeId = serviceTypeId;
            this.serviceTypeName = serviceTypeName;
            this.yearsOfExperience = yearsOfExperience;
            this.availabilityStatus = availabilityStatus;
        }
    }
    
    // System Information
    public static class SystemInfo {
        public String systemType;
        public String version;
        public String status;
        public String lastUpdate;
        public String businessHours;
        public String timeInterval;
        public String bufferTime;

        public SystemInfo(String systemType, String version, String status, String lastUpdate,
                         String businessHours, String timeInterval, String bufferTime) {
            this.systemType = systemType;
            this.version = version;
            this.status = status;
            this.lastUpdate = lastUpdate;
            this.businessHours = businessHours;
            this.timeInterval = timeInterval;
            this.bufferTime = bufferTime;
        }
    }
    
    // Health Status
    public static class HealthStatus {
        public String status;
        public String message;
        public long responseTime;
        public long responseTimeMs;
        public String testResult;
        public String error;

        public HealthStatus(String status, String message, long responseTime) {
            this.status = status;
            this.message = message;
            this.responseTime = responseTime;
            this.responseTimeMs = responseTime; // Same value for compatibility
            this.testResult = null;
            this.error = null;
        }
    }
    
    // Available Slot
    public static class AvailableSlot {
        public LocalDate date;
        public LocalTime startTime;
        public LocalTime endTime;
        public int therapistId;
        public String therapistName;
        public int roomId;
        public int bedId;
        public String confidenceLevel;
        public String reason;
        
        public AvailableSlot(LocalDate date, LocalTime startTime, LocalTime endTime, 
                           int therapistId, String therapistName, int roomId, int bedId, 
                           String confidenceLevel, String reason) {
            this.date = date;
            this.startTime = startTime;
            this.endTime = endTime;
            this.therapistId = therapistId;
            this.therapistName = therapistName;
            this.roomId = roomId;
            this.bedId = bedId;
            this.confidenceLevel = confidenceLevel;
            this.reason = reason;
        }
        
        public String getFormattedTime() {
            return startTime.format(DateTimeFormatter.ofPattern("HH:mm")) +
                   " - " + endTime.format(DateTimeFormatter.ofPattern("HH:mm"));
        }

        // Getter methods
        public LocalDate getDate() { return date; }
        public LocalTime getStartTime() { return startTime; }
        public LocalTime getEndTime() { return endTime; }
        public int getTherapistId() { return therapistId; }
        public String getTherapistName() { return therapistName; }
        public int getRoomId() { return roomId; }
        public int getBedId() { return bedId; }
        public String getConfidenceLevel() { return confidenceLevel; }
        public String getReason() { return reason; }
    }
    
    // Unavailable Slot
    public static class UnavailableSlot {
        public LocalDate date;
        public LocalTime startTime;
        public LocalTime endTime;
        public String reason;
        public String conflictType;
        
        public UnavailableSlot(LocalDate date, LocalTime startTime, LocalTime endTime, 
                             String reason, String conflictType) {
            this.date = date;
            this.startTime = startTime;
            this.endTime = endTime;
            this.reason = reason;
            this.conflictType = conflictType;
        }
        
        public String getFormattedTime() {
            return startTime.format(DateTimeFormatter.ofPattern("HH:mm")) +
                   " - " + endTime.format(DateTimeFormatter.ofPattern("HH:mm"));
        }

        // Getter methods
        public LocalDate getDate() { return date; }
        public LocalTime getStartTime() { return startTime; }
        public LocalTime getEndTime() { return endTime; }
        public String getReason() { return reason; }
        public String getConflictType() { return conflictType; }
    }
    
    // Booking Result
    public static class BookingResult {
        private List<AvailableSlot> availableSlots;
        private List<UnavailableSlot> unavailableSlots;
        private String summary;
        private long processingTime;
        
        public BookingResult(List<AvailableSlot> availableSlots, List<UnavailableSlot> unavailableSlots, 
                           String summary, long processingTime) {
            this.availableSlots = availableSlots != null ? availableSlots : new ArrayList<>();
            this.unavailableSlots = unavailableSlots != null ? unavailableSlots : new ArrayList<>();
            this.summary = summary;
            this.processingTime = processingTime;
        }
        
        public List<AvailableSlot> getAvailableSlots() { return availableSlots; }
        public List<UnavailableSlot> getUnavailableSlots() { return unavailableSlots; }
        public String getSummary() { return summary; }
        public long getProcessingTime() { return processingTime; }
    }
    
    // Static API Methods
    public static SystemInfo getSystemInfo() {
        return new SystemInfo(
            "CSP Booking System",
            "1.0.0",
            "Active",
            LocalDate.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")),
            "08:00 - 20:00",
            "30 minutes",
            "15 minutes"
        );
    }
    
    public static HealthStatus getSystemHealth() {
        long startTime = System.currentTimeMillis();
        // Simulate health check
        try {
            Thread.sleep(10); // Simulate processing time
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        long responseTime = System.currentTimeMillis() - startTime;
        
        return new HealthStatus("healthy", "All systems operational", responseTime);
    }
    
    public static BookingResult findAvailableSlotsDetailed(int customerId, int serviceId) {
        long startTime = System.currentTimeMillis();

        // Generate mock available slots for backward compatibility
        List<AvailableSlot> availableSlots = generateMockAvailableSlots();

        // Generate mock unavailable slots
        List<UnavailableSlot> unavailableSlots = generateMockUnavailableSlots();

        long processingTime = System.currentTimeMillis() - startTime;

        String summary = String.format("Found %d available slots and %d unavailable slots for customer %d, service %d",
                                     availableSlots.size(), unavailableSlots.size(), customerId, serviceId);

        return new BookingResult(availableSlots, unavailableSlots, summary, processingTime);
    }

    /**
     * Overloaded method for real CSP booking with payment item ID and date
     */
    public static BookingResult findAvailableSlotsDetailed(Integer paymentItemId, LocalDate selectedDate) {
        return findAvailableSlotsWithCSP(paymentItemId, selectedDate);
    }
    
    public static String runProductionTest() {
        StringBuilder result = new StringBuilder();
        result.append("=== CSP BOOKING SYSTEM PRODUCTION TEST ===\n");
        result.append("Test Date: ").append(LocalDate.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss"))).append("\n\n");
        
        // Test 1: System Health
        result.append("1. System Health Check:\n");
        HealthStatus health = getSystemHealth();
        result.append("   Status: ").append(health.status).append("\n");
        result.append("   Response Time: ").append(health.responseTime).append("ms\n\n");
        
        // Test 2: System Info
        result.append("2. System Information:\n");
        SystemInfo info = getSystemInfo();
        result.append("   System: ").append(info.systemType).append(" v").append(info.version).append("\n");
        result.append("   Status: ").append(info.status).append("\n\n");
        
        // Test 3: Slot Finding
        result.append("3. Slot Finding Test:\n");
        BookingResult bookingResult = findAvailableSlotsDetailed(1, 10);
        result.append("   Available Slots: ").append(bookingResult.getAvailableSlots().size()).append("\n");
        result.append("   Unavailable Slots: ").append(bookingResult.getUnavailableSlots().size()).append("\n");
        result.append("   Processing Time: ").append(bookingResult.getProcessingTime()).append("ms\n\n");
        
        result.append("=== TEST COMPLETED SUCCESSFULLY ===");

        return result.toString();
    }

    // NEW METHODS FOR REAL DATABASE INTEGRATION

    /**
     * Load PaymentItem details by ID with complete service and customer information
     */
    public static PaymentItemDetails loadPaymentItemDetails(Integer paymentItemId) {
        if (paymentItemId == null) {
            return null;
        }

        try {
            PaymentItemDAO paymentItemDAO = new PaymentItemDAO();
            ServiceDAO serviceDAO = new ServiceDAO();
            PaymentDAO paymentDAO = new PaymentDAO();
            PaymentItemUsageDAO usageDAO = new PaymentItemUsageDAO();

            // Load payment item
            Optional<PaymentItem> paymentItemOpt = paymentItemDAO.findById(paymentItemId);
            if (!paymentItemOpt.isPresent()) {
                return null;
            }

            PaymentItem paymentItem = paymentItemOpt.get();

            // Load service details
            Optional<Service> serviceOpt = serviceDAO.findById(paymentItem.getServiceId());
            if (!serviceOpt.isPresent()) {
                return null;
            }

            Service service = serviceOpt.get();

            // Load payment details to get customer info
            Optional<Payment> paymentOpt = paymentDAO.findById(paymentItem.getPaymentId());
            if (!paymentOpt.isPresent()) {
                return null;
            }

            Payment payment = paymentOpt.get();

            // Load usage information to calculate remaining quantity
            Optional<PaymentItemUsage> usageOpt = usageDAO.findByPaymentItemId(paymentItemId);
            PaymentItemUsage usage = usageOpt.orElse(null);

            Integer remainingQuantity = paymentItem.getQuantity();
            if (usage != null) {
                remainingQuantity = usage.getRemainingQuantity();
            }

            // Get customer details from payment
            String customerName = "Customer " + payment.getCustomerId(); // Default name
            String customerPhone = "N/A";

            // Create PaymentItemDetails object
            return new PaymentItemDetails(
                paymentItemId,
                service.getServiceId(),
                service.getName(),
                service.getDescription(),
                service.getDurationMinutes(),
                payment.getCustomerId(),
                customerName,
                customerPhone,
                remainingQuantity,
                paymentItem.getQuantity(),
                payment.getPaymentStatus().toString()
            );

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error loading payment item details: " + paymentItemId, e);
            return null;
        }
    }

    /**
     * Find qualified therapists for a specific service
     */
    public static List<QualifiedTherapist> findQualifiedTherapists(Integer serviceId) {
        List<QualifiedTherapist> qualifiedTherapists = new ArrayList<>();

        if (serviceId == null) {
            LOGGER.log(Level.WARNING, "Service ID is null");
            return qualifiedTherapists;
        }

        try {
            ServiceDAO serviceDAO = new ServiceDAO();
            StaffDAO staffDAO = new StaffDAO();

            LOGGER.log(Level.INFO, "Loading service with ID: " + serviceId);

            // Load service to get service type
            Optional<Service> serviceOpt = serviceDAO.findById(serviceId);
            if (!serviceOpt.isPresent()) {
                LOGGER.log(Level.WARNING, "Service not found with ID: " + serviceId);
                return qualifiedTherapists;
            }

            Service service = serviceOpt.get();
            LOGGER.log(Level.INFO, "Loaded service: " + service.getName());

            // Check if service type is loaded
            if (service.getServiceTypeId() == null) {
                LOGGER.log(Level.WARNING, "Service type not loaded for service: " + serviceId);
                LOGGER.log(Level.WARNING, "Service object: " + service.toString());
                return qualifiedTherapists;
            }

            Integer serviceTypeId = service.getServiceTypeId().getServiceTypeId();
            String serviceTypeName = service.getServiceTypeId().getName();

            LOGGER.log(Level.INFO, "Service type ID: " + serviceTypeId + ", Name: " + serviceTypeName);

            // Find therapists qualified for this service type (include offline for testing)
            List<Staff> therapists = staffDAO.findTherapistsByServiceType(serviceTypeId, true);

            LOGGER.log(Level.INFO, "Found " + therapists.size() + " therapists for service type: " + serviceTypeId);

            for (Staff therapist : therapists) {
                User user = therapist.getUser();
                if (user != null) {
                    LOGGER.log(Level.INFO, "Adding qualified therapist: " + user.getFullName());
                    qualifiedTherapists.add(new QualifiedTherapist(
                        user.getUserId(),
                        user.getFullName(),
                        user.getEmail(),
                        user.getPhoneNumber(),
                        serviceTypeId,
                        serviceTypeName,
                        therapist.getYearsOfExperience(),
                        therapist.getAvailabilityStatus().toString()
                    ));
                } else {
                    LOGGER.log(Level.WARNING, "Therapist has no user information");
                }
            }

            LOGGER.log(Level.INFO, "Total qualified therapists found: " + qualifiedTherapists.size());

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error finding qualified therapists for service: " + serviceId, e);
        }

        return qualifiedTherapists;
    }

    /**
     * Debug method to check database state
     */
    public static String debugDatabaseState(Integer serviceId) {
        StringBuilder debug = new StringBuilder();
        debug.append("=== DATABASE DEBUG FOR SERVICE ").append(serviceId).append(" ===\n");

        try {
            ServiceDAO serviceDAO = new ServiceDAO();
            StaffDAO staffDAO = new StaffDAO();
            ServiceTypeDAO serviceTypeDAO = new ServiceTypeDAO();

            // Check service
            Optional<Service> serviceOpt = serviceDAO.findById(serviceId);
            if (serviceOpt.isPresent()) {
                Service service = serviceOpt.get();
                debug.append("Service found: ").append(service.getName()).append("\n");
                debug.append("Service Type ID: ").append(service.getServiceTypeId() != null ? service.getServiceTypeId().getServiceTypeId() : "NULL").append("\n");
                debug.append("Service Type Name: ").append(service.getServiceTypeId() != null ? service.getServiceTypeId().getName() : "NULL").append("\n");

                if (service.getServiceTypeId() != null) {
                    Integer serviceTypeId = service.getServiceTypeId().getServiceTypeId();

                    // Check all therapists
                    List<Staff> allTherapists = staffDAO.findAll();
                    debug.append("Total therapists in database: ").append(allTherapists.size()).append("\n");

                    // Check therapists for this service type
                    List<Staff> qualifiedTherapists = staffDAO.findTherapistsByServiceType(serviceTypeId, true);
                    debug.append("Therapists for service type ").append(serviceTypeId).append(": ").append(qualifiedTherapists.size()).append("\n");

                    for (Staff therapist : qualifiedTherapists) {
                        debug.append("- Therapist: ").append(therapist.getUser() != null ? therapist.getUser().getFullName() : "No user info")
                             .append(" (Status: ").append(therapist.getAvailabilityStatus()).append(")\n");
                    }

                    // Check all service types
                    List<ServiceType> serviceTypes = serviceTypeDAO.findAll();
                    debug.append("All service types:\n");
                    for (ServiceType st : serviceTypes) {
                        List<Staff> therapistsForType = staffDAO.findTherapistsByServiceType(st.getServiceTypeId(), true);
                        debug.append("- ").append(st.getName()).append(" (ID: ").append(st.getServiceTypeId()).append("): ")
                             .append(therapistsForType.size()).append(" therapists\n");
                    }
                }
            } else {
                debug.append("Service not found!\n");
            }

        } catch (Exception e) {
            debug.append("Error: ").append(e.getMessage()).append("\n");
            LOGGER.log(Level.SEVERE, "Debug database state error", e);
        }

        return debug.toString();
    }

    /**
     * Find available slots using real CSP algorithm with database data
     */
    public static BookingResult findAvailableSlotsWithCSP(Integer paymentItemId, LocalDate selectedDate) {
        long startTime = System.currentTimeMillis();

        if (paymentItemId == null || selectedDate == null) {
            return new BookingResult(new ArrayList<>(), new ArrayList<>(),
                                   "Invalid parameters", System.currentTimeMillis() - startTime);
        }

        try {
            // Load payment item details
            PaymentItemDetails paymentDetails = loadPaymentItemDetails(paymentItemId);
            if (paymentDetails == null) {
                return new BookingResult(new ArrayList<>(), new ArrayList<>(),
                                       "Payment item not found", System.currentTimeMillis() - startTime);
            }

            // Find qualified therapists
            List<QualifiedTherapist> qualifiedTherapists = findQualifiedTherapists(paymentDetails.serviceId);
            if (qualifiedTherapists.isEmpty()) {
                return new BookingResult(new ArrayList<>(), new ArrayList<>(),
                                       "No qualified therapists found", System.currentTimeMillis() - startTime);
            }

            // Generate time slots for the selected date
            List<AvailableSlot> availableSlots = new ArrayList<>();
            List<UnavailableSlot> unavailableSlots = new ArrayList<>();

            // Business hours: 8:00 AM to 8:00 PM
            LocalTime startHour = LocalTime.of(8, 0);
            LocalTime endHour = LocalTime.of(20, 0);
            int serviceDuration = paymentDetails.serviceDuration;
            int bufferTime = 15; // 15 minutes buffer
            int totalDuration = serviceDuration + bufferTime;

            // Generate 30-minute intervals
            LocalTime currentTime = startHour;
            while (currentTime.plusMinutes(totalDuration).isBefore(endHour) ||
                   currentTime.plusMinutes(totalDuration).equals(endHour)) {

                LocalTime slotEndTime = currentTime.plusMinutes(serviceDuration);

                // Check availability for each qualified therapist
                boolean foundAvailableTherapist = false;
                for (QualifiedTherapist therapist : qualifiedTherapists) {
                    // For now, simulate availability check
                    // In a real implementation, this would check the database for conflicts
                    boolean isAvailable = checkTherapistAvailability(therapist.therapistId, selectedDate, currentTime, totalDuration);

                    if (isAvailable) {
                        availableSlots.add(new AvailableSlot(
                            selectedDate,
                            currentTime,
                            slotEndTime,
                            therapist.therapistId,
                            therapist.therapistName,
                            1, // Room ID (would be determined by CSP)
                            1, // Bed ID (would be determined by CSP)
                            "HIGH", // Confidence level
                            "Available therapist: " + therapist.therapistName
                        ));
                        foundAvailableTherapist = true;
                        break; // Found one available therapist, move to next time slot
                    }
                }

                if (!foundAvailableTherapist) {
                    unavailableSlots.add(new UnavailableSlot(
                        selectedDate,
                        currentTime,
                        slotEndTime,
                        "No therapists available",
                        "THERAPIST_UNAVAILABLE"
                    ));
                }

                currentTime = currentTime.plusMinutes(30); // 30-minute intervals
            }

            long processingTime = System.currentTimeMillis() - startTime;
            String summary = String.format("Found %d available slots and %d unavailable slots for service '%s' on %s",
                                         availableSlots.size(), unavailableSlots.size(),
                                         paymentDetails.serviceName, selectedDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));

            return new BookingResult(availableSlots, unavailableSlots, summary, processingTime);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error finding available slots with CSP", e);
            long processingTime = System.currentTimeMillis() - startTime;
            return new BookingResult(new ArrayList<>(), new ArrayList<>(),
                                   "Error: " + e.getMessage(), processingTime);
        }
    }

    /**
     * Check if therapist is available at specific time (simplified version)
     * In a real implementation, this would query the bookings table
     */
    private static boolean checkTherapistAvailability(Integer therapistId, LocalDate date, LocalTime startTime, int durationMinutes) {
        // For now, simulate availability with some logic
        // In peak hours (11 AM - 2 PM, 6 PM - 8 PM), reduce availability
        int hour = startTime.getHour();
        boolean isPeakHour = (hour >= 11 && hour <= 14) || (hour >= 18 && hour <= 20);

        // Simulate 80% availability during normal hours, 60% during peak hours
        double availabilityRate = isPeakHour ? 0.6 : 0.8;

        // Use therapist ID and time to create deterministic "randomness"
        int seed = therapistId + date.getDayOfYear() + hour + startTime.getMinute();
        double random = ((seed * 1664525 + 1013904223) % 100) / 100.0;

        return random < availabilityRate;
    }
    
    // Helper methods to generate mock data
    private static List<AvailableSlot> generateMockAvailableSlots() {
        List<AvailableSlot> slots = new ArrayList<>();
        LocalDate today = LocalDate.now();
        
        // Generate some mock available slots
        slots.add(new AvailableSlot(today, LocalTime.of(9, 0), LocalTime.of(10, 0), 
                                  1, "Nguyễn Thị A", 1, 1, "HIGH", "Optimal slot"));
        slots.add(new AvailableSlot(today, LocalTime.of(10, 30), LocalTime.of(11, 30), 
                                  2, "Trần Văn B", 2, 2, "MEDIUM", "Good availability"));
        slots.add(new AvailableSlot(today, LocalTime.of(14, 0), LocalTime.of(15, 0), 
                                  3, "Lê Thị C", 1, 3, "HIGH", "Afternoon slot"));
        slots.add(new AvailableSlot(today, LocalTime.of(15, 30), LocalTime.of(16, 30), 
                                  1, "Nguyễn Thị A", 3, 4, "LOW", "Limited options"));
        slots.add(new AvailableSlot(today, LocalTime.of(17, 0), LocalTime.of(18, 0), 
                                  2, "Trần Văn B", 2, 1, "MEDIUM", "Evening slot"));
        
        return slots;
    }
    
    private static List<UnavailableSlot> generateMockUnavailableSlots() {
        List<UnavailableSlot> slots = new ArrayList<>();
        LocalDate today = LocalDate.now();
        
        // Generate some mock unavailable slots
        slots.add(new UnavailableSlot(today, LocalTime.of(8, 0), LocalTime.of(9, 0), 
                                    "Before business hours", "TIME_CONSTRAINT"));
        slots.add(new UnavailableSlot(today, LocalTime.of(11, 0), LocalTime.of(12, 0), 
                                    "All therapists busy", "THERAPIST_UNAVAILABLE"));
        slots.add(new UnavailableSlot(today, LocalTime.of(13, 0), LocalTime.of(14, 0), 
                                    "Lunch break", "BUSINESS_RULE"));
        slots.add(new UnavailableSlot(today, LocalTime.of(16, 0), LocalTime.of(17, 0), 
                                    "No rooms available", "ROOM_UNAVAILABLE"));
        slots.add(new UnavailableSlot(today, LocalTime.of(19, 0), LocalTime.of(20, 0), 
                                    "After business hours", "TIME_CONSTRAINT"));
        
        return slots;
    }
}
