
package controller;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

// Data Models
class Therapist {
    private int id;
    private String name;
    private Set<Integer> qualifiedServiceTypes;
    
    public Therapist(int id, String name, Set<Integer> qualifiedServiceTypes) {
        this.id = id;
        this.name = name;
        this.qualifiedServiceTypes = qualifiedServiceTypes;
    }
    
    public int getId() { return id; }
    public String getName() { return name; }
    public Set<Integer> getQualifiedServiceTypes() { return qualifiedServiceTypes; }
    public boolean canPerformService(int serviceTypeId) {
        return qualifiedServiceTypes.contains(serviceTypeId);
    }
}

class Service {
    private int id;
    private int serviceTypeId;
    private String name;
    private int durationMinutes;
    
    public Service(int id, int serviceTypeId, String name, int durationMinutes) {
        this.id = id;
        this.serviceTypeId = serviceTypeId;
        this.name = name;
        this.durationMinutes = durationMinutes;
    }
    
    public int getId() { return id; }
    public int getServiceTypeId() { return serviceTypeId; }
    public String getName() { return name; }
    public int getDurationMinutes() { return durationMinutes; }
    public int getTotalDurationMinutes() { return durationMinutes + 15; } // Include 15min buffer
}

class Room {
    private int id;
    private String name;
    
    public Room(int id, String name) {
        this.id = id;
        this.name = name;
    }
    
    public int getId() { return id; }
    public String getName() { return name; }
}

class Bed {
    private int id;
    private String name;
    
    public Bed(int id, String name) {
        this.id = id;
        this.name = name;
    }
    
    public int getId() { return id; }
    public String getName() { return name; }
}

class Booking {
    private int id;
    private int therapistId;
    private int roomId;
    private int bedId;
    private LocalDate date;
    private LocalTime startTime;
    private LocalTime endTime;
    
    public Booking(int id, int therapistId, int roomId, int bedId, LocalDate date, 
                   LocalTime startTime, LocalTime endTime) {
        this.id = id;
        this.therapistId = therapistId;
        this.roomId = roomId;
        this.bedId = bedId;
        this.date = date;
        this.startTime = startTime;
        this.endTime = endTime;
    }
    
    public int getId() { return id; }
    public int getTherapistId() { return therapistId; }
    public int getRoomId() { return roomId; }
    public int getBedId() { return bedId; }
    public LocalDate getDate() { return date; }
    public LocalTime getStartTime() { return startTime; }
    public LocalTime getEndTime() { return endTime; }
}

class TimeRange {
    private LocalTime startTime;
    private LocalTime endTime;
    
    public TimeRange(LocalTime startTime, LocalTime endTime) {
        this.startTime = startTime;
        this.endTime = endTime;
    }
    
    public LocalTime getStartTime() { return startTime; }
    public LocalTime getEndTime() { return endTime; }
    
    public boolean overlaps(LocalTime otherStart, LocalTime otherEnd) {
        return startTime.isBefore(otherEnd) && endTime.isAfter(otherStart);
    }
}

class AvailableSlot {
    private LocalDate date;
    private LocalTime startTime;
    private LocalTime endTime;
    private int therapistId;
    private int roomId;
    private int bedId;
    
    public AvailableSlot(LocalDate date, LocalTime startTime, LocalTime endTime,
                        int therapistId, int roomId, int bedId) {
        this.date = date;
        this.startTime = startTime;
        this.endTime = endTime;
        this.therapistId = therapistId;
        this.roomId = roomId;
        this.bedId = bedId;
    }
    
    public LocalDate getDate() { return date; }
    public LocalTime getStartTime() { return startTime; }
    public LocalTime getEndTime() { return endTime; }
    public int getTherapistId() { return therapistId; }
    public int getRoomId() { return roomId; }
    public int getBedId() { return bedId; }
    
    @Override
    public String toString() {
        return String.format("Date: %s, Time: %s-%s, Therapist: %d, Room: %d, Bed: %d",
                date.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")),
                startTime.format(DateTimeFormatter.ofPattern("HH:mm")),
                endTime.format(DateTimeFormatter.ofPattern("HH:mm")),
                therapistId, roomId, bedId);
    }
}

class UnavailableSlot {
    private LocalDate date;
    private LocalTime startTime;
    private LocalTime endTime;
    private String reason;
    private String details;
    
    public UnavailableSlot(LocalDate date, LocalTime startTime, LocalTime endTime, 
                          String reason, String details) {
        this.date = date;
        this.startTime = startTime;
        this.endTime = endTime;
        this.reason = reason;
        this.details = details;
    }
    
    public LocalDate getDate() { return date; }
    public LocalTime getStartTime() { return startTime; }
    public LocalTime getEndTime() { return endTime; }
    public String getReason() { return reason; }
    public String getDetails() { return details; }
    
    @Override
    public String toString() {
        return String.format("Date: %s, Time: %s-%s, Reason: %s%s",
                date.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")),
                startTime.format(DateTimeFormatter.ofPattern("HH:mm")),
                endTime.format(DateTimeFormatter.ofPattern("HH:mm")),
                reason,
                details.isEmpty() ? "" : " (" + details + ")");
    }
}

class BookingResult {
    private List<AvailableSlot> availableSlots;
    private List<UnavailableSlot> unavailableSlots;
    
    public BookingResult() {
        this.availableSlots = new ArrayList<>();
        this.unavailableSlots = new ArrayList<>();
    }
    
    public List<AvailableSlot> getAvailableSlots() { return availableSlots; }
    public List<UnavailableSlot> getUnavailableSlots() { return unavailableSlots; }
    public void addAvailableSlot(AvailableSlot slot) { availableSlots.add(slot); }
    public void addUnavailableSlot(UnavailableSlot slot) { unavailableSlots.add(slot); }
}

// Main Booking System
class BookingSystem {
    private List<Therapist> therapists;
    private List<Service> services;
    private List<Room> rooms;
    private List<Bed> beds;
    private List<Booking> existingBookings;
    
    // Business hours
    private static final LocalTime BUSINESS_START = LocalTime.of(8, 0);
    private static final LocalTime BUSINESS_END = LocalTime.of(20, 0);
    private static final int TIME_INTERVAL_MINUTES = 15;
    
    public BookingSystem() {
        initializeMockData();
    }
    
    private void initializeMockData() {
        // Initialize therapists with qualifications
        therapists = Arrays.asList(
            new Therapist(1, "Alice", Set.of(1, 2)), // Massage & Facial
            new Therapist(2, "Bob", Set.of(1, 3)),   // Massage & Manicure
            new Therapist(3, "Carol", Set.of(2, 3)), // Facial & Manicure
            new Therapist(4, "David", Set.of(1)),    // Massage only
            new Therapist(5, "Eva", Set.of(2))       // Facial only
        );
        
        // Initialize services
        services = Arrays.asList(
            new Service(1, 1, "Swedish Massage", 60),
            new Service(2, 1, "Deep Tissue Massage", 90),
            new Service(3, 2, "Classic Facial", 60),
            new Service(4, 2, "Anti-Aging Facial", 75),
            new Service(5, 3, "Basic Manicure", 30),
            new Service(6, 3, "Gel Manicure", 45)
        );
        
        // Initialize rooms (all identical)
        rooms = Arrays.asList(
            new Room(1, "Room A"),
            new Room(2, "Room B"),
            new Room(3, "Room C")
        );
        
        // Initialize beds (all identical)
        beds = Arrays.asList(
            new Bed(1, "Bed 1"),
            new Bed(2, "Bed 2"),
            new Bed(3, "Bed 3"),
            new Bed(4, "Bed 4")
        );
        
        // Initialize existing bookings
        LocalDate today = LocalDate.now();
        existingBookings = Arrays.asList(
            // Today's bookings - creating more conflicts
            new Booking(1, 1, 1, 1, today, LocalTime.of(9, 0), LocalTime.of(10, 15)),
            new Booking(2, 2, 2, 2, today, LocalTime.of(10, 0), LocalTime.of(11, 45)),
            new Booking(3, 3, 3, 3, today, LocalTime.of(14, 0), LocalTime.of(15, 15)),
            new Booking(4, 4, 1, 1, today, LocalTime.of(11, 0), LocalTime.of(12, 15)), // Room conflict
            new Booking(5, 5, 2, 2, today, LocalTime.of(12, 0), LocalTime.of(13, 15)), // Bed conflict
            new Booking(6, 1, 3, 4, today, LocalTime.of(15, 30), LocalTime.of(16, 45)), // Alice busy again
            new Booking(7, 2, 1, 3, today, LocalTime.of(16, 0), LocalTime.of(17, 30)), // Bob busy again
            
            // Tomorrow's bookings
            new Booking(8, 1, 1, 1, today.plusDays(1), LocalTime.of(8, 0), LocalTime.of(9, 15)),
            new Booking(9, 4, 2, 2, today.plusDays(1), LocalTime.of(11, 0), LocalTime.of(12, 15)),
            new Booking(10, 2, 3, 3, today.plusDays(1), LocalTime.of(13, 0), LocalTime.of(14, 30)),
            new Booking(11, 3, 1, 4, today.plusDays(1), LocalTime.of(15, 0), LocalTime.of(16, 0)),
            new Booking(12, 5, 2, 1, today.plusDays(1), LocalTime.of(16, 30), LocalTime.of(17, 45)),
            
            // Day after tomorrow - make it very busy to test resource conflicts
            new Booking(13, 1, 1, 1, today.plusDays(2), LocalTime.of(9, 0), LocalTime.of(10, 15)),
            new Booking(14, 2, 2, 2, today.plusDays(2), LocalTime.of(9, 15), LocalTime.of(10, 30)),
            new Booking(15, 4, 3, 3, today.plusDays(2), LocalTime.of(9, 30), LocalTime.of(10, 45)),
            new Booking(16, 3, 1, 4, today.plusDays(2), LocalTime.of(10, 0), LocalTime.of(11, 15)),
            new Booking(17, 5, 2, 1, today.plusDays(2), LocalTime.of(10, 15), LocalTime.of(11, 30)),
            
            // Next week bookings
            new Booking(18, 2, 1, 1, today.plusDays(7), LocalTime.of(13, 0), LocalTime.of(14, 45)),
            new Booking(19, 3, 2, 2, today.plusDays(7), LocalTime.of(15, 0), LocalTime.of(16, 0))
        );
    }
    
    public BookingResult findAvailableSlots(int serviceId, int maxResults, boolean trackUnavailable) {
        Service service = services.stream()
            .filter(s -> s.getId() == serviceId)
            .findFirst()
            .orElseThrow(() -> new IllegalArgumentException("Service not found"));
        
        System.out.println("\n=== Finding slots for: " + service.getName() + 
                          " (Duration: " + service.getDurationMinutes() + " min + 15 min buffer) ===");
        
        // 1. Get qualified therapists
        List<Therapist> qualifiedTherapists = therapists.stream()
            .filter(t -> t.canPerformService(service.getServiceTypeId()))
            .collect(Collectors.toList());
        
        System.out.println("Qualified therapists: " + 
            qualifiedTherapists.stream().map(Therapist::getName).collect(Collectors.joining(", ")));
        
        if (qualifiedTherapists.isEmpty()) {
            System.out.println("ERROR: No therapists qualified for this service!");
            return new BookingResult();
        }
        
        // 2. Pre-load and organize existing bookings
        LocalDate today = LocalDate.now();
        LocalDate endDate = today.plusDays(3); // Limit to 3 days for demo to see more unavailable slots
        
        Map<LocalDate, Map<Integer, List<TimeRange>>> therapistBookings = organizeTherapistBookings();
        Map<LocalDate, List<TimeRange>> roomBookings = organizeResourceBookings("room");
        Map<LocalDate, List<TimeRange>> bedBookings = organizeResourceBookings("bed");
        
        // 3. Generate time slots and check availability
        BookingResult result = new BookingResult();
        
        for (LocalDate date = today; !date.isAfter(endDate) && result.getAvailableSlots().size() < maxResults; date = date.plusDays(1)) {
            List<LocalTime> timeSlots = generateTimeSlots();
            
            for (LocalTime startTime : timeSlots) {
                if (result.getAvailableSlots().size() >= maxResults) break;
                
                LocalTime endTime = startTime.plusMinutes(service.getTotalDurationMinutes());
                
                // Check if service goes beyond business hours
                if (endTime.isAfter(BUSINESS_END)) {
                    if (trackUnavailable) {
                        result.addUnavailableSlot(new UnavailableSlot(date, startTime, endTime,
                            "BEYOND_BUSINESS_HOURS", 
                            "Service would end at " + endTime.format(DateTimeFormatter.ofPattern("HH:mm")) + 
                            ", after business close at " + BUSINESS_END.format(DateTimeFormatter.ofPattern("HH:mm"))));
                    }
                    continue;
                }
                
                // FAIL FAST: Check therapist availability first
                TherapistAvailabilityResult therapistResult = findAvailableTherapistWithDetails(
                    qualifiedTherapists, therapistBookings.get(date), startTime, endTime);
                
                if (therapistResult.therapistId == null) {
                    if (trackUnavailable) {
                        result.addUnavailableSlot(new UnavailableSlot(date, startTime, endTime,
                            "NO_THERAPIST_AVAILABLE", therapistResult.reason));
                    }
                    continue;
                }
                
                // Check room availability
                ResourceAvailabilityResult roomResult = findAvailableResourceWithDetails(
                    rooms, roomBookings.get(date), startTime, endTime, "room");
                
                if (roomResult.resourceId == null) {
                    if (trackUnavailable) {
                        result.addUnavailableSlot(new UnavailableSlot(date, startTime, endTime,
                            "NO_ROOM_AVAILABLE", roomResult.reason));
                    }
                    continue;
                }
                
                // Check bed availability
                ResourceAvailabilityResult bedResult = findAvailableResourceWithDetails(
                    beds, bedBookings.get(date), startTime, endTime, "bed");
                
                if (bedResult.resourceId == null) {
                    if (trackUnavailable) {
                        result.addUnavailableSlot(new UnavailableSlot(date, startTime, endTime,
                            "NO_BED_AVAILABLE", bedResult.reason));
                    }
                    continue;
                }
                
                // Found available slot!
                result.addAvailableSlot(new AvailableSlot(date, startTime, endTime,
                    therapistResult.therapistId, roomResult.resourceId, bedResult.resourceId));
            }
        }
        
        return result;
    }
    
    // Legacy method for backward compatibility
    public List<AvailableSlot> findAvailableSlots(int serviceId, int maxResults) {
        return findAvailableSlots(serviceId, maxResults, false).getAvailableSlots();
    }
    
    private Map<LocalDate, Map<Integer, List<TimeRange>>> organizeTherapistBookings() {
        Map<LocalDate, Map<Integer, List<TimeRange>>> organized = new HashMap<>();
        
        for (Booking booking : existingBookings) {
            organized.computeIfAbsent(booking.getDate(), k -> new HashMap<>())
                     .computeIfAbsent(booking.getTherapistId(), k -> new ArrayList<>())
                     .add(new TimeRange(booking.getStartTime(), booking.getEndTime()));
        }
        
        return organized;
    }
    
    private Map<LocalDate, List<TimeRange>> organizeResourceBookings(String resourceType) {
        Map<LocalDate, List<TimeRange>> organized = new HashMap<>();
        
        for (Booking booking : existingBookings) {
            organized.computeIfAbsent(booking.getDate(), k -> new ArrayList<>())
                     .add(new TimeRange(booking.getStartTime(), booking.getEndTime()));
        }
        
        return organized;
    }
    
    private List<LocalTime> generateTimeSlots() {
        List<LocalTime> slots = new ArrayList<>();
        LocalTime current = BUSINESS_START;
        
        while (current.isBefore(BUSINESS_END)) {
            slots.add(current);
            current = current.plusMinutes(TIME_INTERVAL_MINUTES);
        }
        
        return slots;
    }
    
    // Helper classes for detailed availability checking
    private static class TherapistAvailabilityResult {
        Integer therapistId;
        String reason;
        
        TherapistAvailabilityResult(Integer therapistId, String reason) {
            this.therapistId = therapistId;
            this.reason = reason;
        }
    }
    
    private static class ResourceAvailabilityResult {
        Integer resourceId;
        String reason;
        
        ResourceAvailabilityResult(Integer resourceId, String reason) {
            this.resourceId = resourceId;
            this.reason = reason;
        }
    }
    
    private TherapistAvailabilityResult findAvailableTherapistWithDetails(List<Therapist> qualifiedTherapists,
                                                                        Map<Integer, List<TimeRange>> therapistBookings,
                                                                        LocalTime startTime, LocalTime endTime) {
        if (therapistBookings == null) therapistBookings = new HashMap<>();
        
        List<String> busyTherapists = new ArrayList<>();
        
        for (Therapist therapist : qualifiedTherapists) {
            List<TimeRange> bookings = therapistBookings.getOrDefault(therapist.getId(), new ArrayList<>());
            
            boolean isAvailable = bookings.stream()
                .noneMatch(range -> range.overlaps(startTime, endTime));
            
            if (isAvailable) {
                return new TherapistAvailabilityResult(therapist.getId(), "");
            } else {
                // Find conflicting booking details
                TimeRange conflictingRange = bookings.stream()
                    .filter(range -> range.overlaps(startTime, endTime))
                    .findFirst()
                    .orElse(null);
                
                if (conflictingRange != null) {
                    busyTherapists.add(therapist.getName() + " (busy " + 
                        conflictingRange.getStartTime().format(DateTimeFormatter.ofPattern("HH:mm")) + "-" +
                        conflictingRange.getEndTime().format(DateTimeFormatter.ofPattern("HH:mm")) + ")");
                }
            }
        }
        
        String reason = "All qualified therapists busy: " + String.join(", ", busyTherapists);
        return new TherapistAvailabilityResult(null, reason);
    }
    
    private <T> ResourceAvailabilityResult findAvailableResourceWithDetails(List<T> resources,
                                                                          List<TimeRange> resourceBookings,
                                                                          LocalTime startTime, LocalTime endTime,
                                                                          String resourceType) {
        if (resourceBookings == null) resourceBookings = new ArrayList<>();
        
        // Count overlapping bookings
        long overlappingBookings = resourceBookings.stream()
            .mapToLong(range -> range.overlaps(startTime, endTime) ? 1 : 0)
            .sum();
        
        // If we have more resources than overlapping bookings, we have availability
        if (overlappingBookings < resources.size()) {
            // For simplicity, return the first resource ID
            if (resources.get(0) instanceof Room) {
                return new ResourceAvailabilityResult(((Room) resources.get(0)).getId(), "");
            } else if (resources.get(0) instanceof Bed) {
                return new ResourceAvailabilityResult(((Bed) resources.get(0)).getId(), "");
            }
        }
        
        String reason = String.format("All %s%s occupied (%d total, %d busy)", 
            resourceType, resources.size() > 1 ? "s" : "", resources.size(), overlappingBookings);
        return new ResourceAvailabilityResult(null, reason);
    }
    
    private Integer findAvailableTherapist(List<Therapist> qualifiedTherapists,
                                         Map<Integer, List<TimeRange>> therapistBookings,
                                         LocalTime startTime, LocalTime endTime) {
        if (therapistBookings == null) therapistBookings = new HashMap<>();
        
        for (Therapist therapist : qualifiedTherapists) {
            List<TimeRange> bookings = therapistBookings.getOrDefault(therapist.getId(), new ArrayList<>());
            
            boolean isAvailable = bookings.stream()
                .noneMatch(range -> range.overlaps(startTime, endTime));
            
            if (isAvailable) {
                return therapist.getId();
            }
        }
        return null;
    }
    
    private <T> Integer findAvailableResource(List<T> resources,
                                            List<TimeRange> resourceBookings,
                                            LocalTime startTime, LocalTime endTime) {
        if (resourceBookings == null) resourceBookings = new ArrayList<>();
        
        // Count overlapping bookings
        long overlappingBookings = resourceBookings.stream()
            .mapToLong(range -> range.overlaps(startTime, endTime) ? 1 : 0)
            .sum();
        
        // If we have more resources than overlapping bookings, we have availability
        if (overlappingBookings < resources.size()) {
            // For simplicity, return the first resource ID
            // In practice, you might want more sophisticated assignment logic
            if (resources.get(0) instanceof Room) {
                return ((Room) resources.get(0)).getId();
            } else if (resources.get(0) instanceof Bed) {
                return ((Bed) resources.get(0)).getId();
            }
        }
        return null;
    }
    
    public void printSystemStatus() {
        System.out.println("=== BEAUTY SERVICE BOOKING SYSTEM STATUS ===");
        System.out.println("Therapists: " + therapists.size());
        therapists.forEach(t -> System.out.println("  " + t.getName() + " - Services: " + t.getQualifiedServiceTypes()));
        
        System.out.println("\nServices: " + services.size());
        services.forEach(s -> System.out.println("  " + s.getName() + " (" + s.getDurationMinutes() + " min)"));
        
        System.out.println("\nRooms: " + rooms.size());
        System.out.println("Beds: " + beds.size());
        System.out.println("Existing Bookings: " + existingBookings.size());
        
        // Show today's bookings for context
        LocalDate today = LocalDate.now();
        List<Booking> todaysBookings = existingBookings.stream()
            .filter(b -> b.getDate().equals(today))
            .collect(Collectors.toList());
        
        System.out.println("\nToday's existing bookings (" + today + "):");
        if (todaysBookings.isEmpty()) {
            System.out.println("  No bookings today");
        } else {
            todaysBookings.forEach(b -> {
                String therapistName = therapists.stream()
                    .filter(t -> t.getId() == b.getTherapistId())
                    .map(Therapist::getName)
                    .findFirst().orElse("Unknown");
                System.out.println("  " + b.getStartTime().format(DateTimeFormatter.ofPattern("HH:mm")) + 
                                 "-" + b.getEndTime().format(DateTimeFormatter.ofPattern("HH:mm")) + 
                                 " - " + therapistName + " (Room " + b.getRoomId() + ", Bed " + b.getBedId() + ")");
            });
        }
        
        System.out.println("\nBusiness Hours: " + BUSINESS_START + " - " + BUSINESS_END);
        System.out.println("Time Intervals: " + TIME_INTERVAL_MINUTES + " minutes");
        System.out.println("Buffer Time: 15 minutes");
    }
}

