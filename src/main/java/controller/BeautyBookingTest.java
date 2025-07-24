
package controller;

// Main Test Class

import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class BeautyBookingTest {
    public static void main(String[] args) {
        BookingSystem system = new BookingSystem();
        system.printSystemStatus();
        
        // Test finding available slots for different services
        System.out.println("\n" + "=".repeat(80));
        
        // Test 1: Swedish Massage (60 min + 15 buffer = 75 min total)
        testServiceBooking(system, 1, "Swedish Massage", 10);
        
        // Test 2: Anti-Aging Facial (75 min + 15 buffer = 90 min total)
        testServiceBooking(system, 4, "Anti-Aging Facial", 5);
        
        // Test 3: Basic Manicure (30 min + 15 buffer = 45 min total)
        testServiceBooking(system, 5, "Basic Manicure", 8);
    }
    
    private static void testServiceBooking(BookingSystem system, int serviceId, 
                                         String serviceName, int maxResults) {
        System.out.println("\n" + "=".repeat(50));
        System.out.println("TESTING: " + serviceName + " (Service ID: " + serviceId + ")");
        System.out.println("=".repeat(50));
        
        long startTime = System.currentTimeMillis();
        BookingResult result = system.findAvailableSlots(serviceId, maxResults, true);
        long endTime = System.currentTimeMillis();
        
        List<AvailableSlot> availableSlots = result.getAvailableSlots();
        List<UnavailableSlot> unavailableSlots = result.getUnavailableSlots();
        
        System.out.println("\nFound " + availableSlots.size() + " available slots and " + 
                          unavailableSlots.size() + " unavailable slots in " + (endTime - startTime) + "ms:");
        
        // Show available slots
        System.out.println("\n--- AVAILABLE SLOTS ---");
        if (availableSlots.isEmpty()) {
            System.out.println("No available slots found!");
        } else {
            for (int i = 0; i < Math.min(availableSlots.size(), 5); i++) {
                System.out.println("  " + (i+1) + ". " + availableSlots.get(i));
            }
            if (availableSlots.size() > 5) {
                System.out.println("  ... and " + (availableSlots.size() - 5) + " more available slots");
            }
        }
        
        // Show unavailable slots
        System.out.println("\n--- UNAVAILABLE SLOTS (First 10) ---");
        if (unavailableSlots.isEmpty()) {
            System.out.println("All checked slots were available!");
        } else {
            // Group by reason for better readability
            Map<String, List<UnavailableSlot>> groupedByReason = unavailableSlots.stream()
                .collect(Collectors.groupingBy(UnavailableSlot::getReason));
            
            for (Map.Entry<String, List<UnavailableSlot>> entry : groupedByReason.entrySet()) {
                String reason = entry.getKey();
                List<UnavailableSlot> slots = entry.getValue();
                
                System.out.println("\n  Reason: " + reason + " (" + slots.size() + " slots)");
                for (int i = 0; i < Math.min(slots.size(), 3); i++) {
                    UnavailableSlot slot = slots.get(i);
                    System.out.println("    - " + slot.getDate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd")) + 
                                     " " + slot.getStartTime().format(DateTimeFormatter.ofPattern("HH:mm")) + 
                                     "-" + slot.getEndTime().format(DateTimeFormatter.ofPattern("HH:mm")) +
                                     (slot.getDetails().isEmpty() ? "" : " (" + slot.getDetails() + ")"));
                }
                if (slots.size() > 3) {
                    System.out.println("    ... and " + (slots.size() - 3) + " more slots");
                }
            }
        }
        
        // Summary statistics
        System.out.println("\n--- SUMMARY ---");
        System.out.println("Total slots checked: " + (availableSlots.size() + unavailableSlots.size()));
        System.out.println("Available: " + availableSlots.size() + 
                          " (" + String.format("%.1f", (double)availableSlots.size() / 
                          (availableSlots.size() + unavailableSlots.size()) * 100) + "%)");
        System.out.println("Unavailable: " + unavailableSlots.size() + 
                          " (" + String.format("%.1f", (double)unavailableSlots.size() / 
                          (availableSlots.size() + unavailableSlots.size()) * 100) + "%)");
    }
}