package model;

import dao.ServiceDAO;
import dao.StaffDAO;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Scheduling Simulation using CSPSolver with randomly selected services
 * This simulation demonstrates the CSP solver's ability to find available slots
 * for multiple services while considering therapist qualifications and time
 * constraints
 */
public class CSPSchedulingSimulation {

  private static final DateTimeFormatter DATE_FORMAT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
  private static final Random random = new Random();

  public static void main(String[] args) {
    System.out.println("=== CSP Scheduling Simulation ===");
    System.out.println("Randomly selecting 6 services and finding available slots...\n");

    try {
      // 1. Get random services from database
      System.out.println("1. Fetching random services from database...");
      List<Service> randomServices = getRandomServices(6);

      if (randomServices.isEmpty()) {
        System.out.println("❌ No services found in database. Please add services first.");
        return;
      }

      System.out.println("✅ Selected " + randomServices.size() + " random services:");
      displayServices(randomServices);

      // 2. Create CSP domain and solver
      System.out.println("\n2. Initializing CSP solver...");
      CSPDomain domain = new CSPDomain();
      CSPSolver solver = new CSPSolver(domain, new ArrayList<>());

      System.out.println("✅ CSP solver initialized with:");
      System.out.println("   - Available time slots: " + domain.getAvailableTimes().size());
      System.out.println("   - Business hours: 8:00 AM - 8:00 PM");
      System.out.println("   - Next 30 days coverage");

      // 3. Find available slots for each service
      System.out.println("\n3. Finding available slots for each service...");
      simulateSchedulingForServices(solver, randomServices);

      // 4. Simulate booking conflicts
      System.out.println("\n4. Simulating booking scenarios...");
      simulateBookingScenarios(solver, randomServices);

      System.out.println("\n=== Simulation Complete ===");

    } catch (Exception e) {
      System.err.println("❌ Simulation failed: " + e.getMessage());
      e.printStackTrace();
    }
  }

  /**
   * Get random services from the database
   */
  private static List<Service> getRandomServices(int count) {
    try {
      ServiceDAO serviceDAO = new ServiceDAO();
      List<Service> allServices = serviceDAO.findAll();

      if (allServices.isEmpty()) {
        return createMockServices(count);
      }

      // Shuffle and take first 'count' services
      Collections.shuffle(allServices);
      return allServices.stream()
          .limit(count)
          .collect(Collectors.toList());

    } catch (Exception e) {
      System.err.println("⚠️ Database error, using mock services: " + e.getMessage());
      return createMockServices(count);
    }
  }

  /**
   * Create mock services for testing when database is unavailable
   */
  private static List<Service> createMockServices(int count) {
    List<Service> mockServices = new ArrayList<>();
    String[] serviceNames = {
        "Swedish Massage", "Hot Stone Massage", "Deep Tissue Massage",
        "Facial Treatment", "Manicure", "Pedicure", "Body Scrub", "Aromatherapy"
    };
    int[] durations = { 60, 90, 75, 60, 45, 60, 90, 120 };

    for (int i = 0; i < Math.min(count, serviceNames.length); i++) {
      Service service = createMockService(i + 1, serviceNames[i], durations[i]);
      mockServices.add(service);
    }

    return mockServices;
  }

  /**
   * Create a mock service for testing
   */
  private static Service createMockService(int id, String name, int duration) {
    Service service = new Service();
    service.setServiceId(id);
    service.setName(name);
    service.setDurationMinutes(duration);
    service.setPrice(BigDecimal.valueOf(50.0 + (duration * 0.8))); // Mock pricing
    service.setDescription("Mock " + name + " service for testing");

    // Create mock service type
    ServiceType serviceType = new ServiceType();
    serviceType.setServiceTypeId(id);
    serviceType.setName(name + " Type");
    service.setServiceTypeId(serviceType);

    return service;
  }

  /**
   * Display selected services information
   */
  private static void displayServices(List<Service> services) {
    for (int i = 0; i < services.size(); i++) {
      Service service = services.get(i);
      System.out.printf("   %d. %s (%d min) - $%.2f%n",
          i + 1,
          service.getName(),
          service.getDurationMinutes(),
          service.getPrice());
    }
  }

  /**
   * Simulate scheduling for each service
   */
  private static void simulateSchedulingForServices(CSPSolver solver, List<Service> services) {
    for (int i = 0; i < services.size(); i++) {
      Service service = services.get(i);
      System.out.println("\n--- Service " + (i + 1) + ": " + service.getName() + " ---");

      try {
        // Find all valid slots
        List<Assignment> validSlots = solver.getAllValidSlots(service);

        if (validSlots.isEmpty()) {
          System.out.println("❌ No available slots found for " + service.getName());
          analyzeWhyNoSlots(solver, service);
        } else {
          System.out.println("✅ Found " + validSlots.size() + " available slots");

          // Show first few slots
          int slotsToShow = Math.min(5, validSlots.size());
          System.out.println("📅 Next " + slotsToShow + " available slots:");

          for (int j = 0; j < slotsToShow; j++) {
            Assignment slot = validSlots.get(j);
            System.out.printf("   %d. %s with %s%n",
                j + 1,
                formatDateTime(slot.getStartTime()),
                getTherapistName(slot.getTherapist()));
          }

          // Show slots grouped by therapist
          showSlotsByTherapist(solver, service);
        }

      } catch (Exception e) {
        System.err.println("❌ Error finding slots for " + service.getName() + ": " + e.getMessage());
      }
    }
  }

  /**
   * Show available slots grouped by therapist
   */
  private static void showSlotsByTherapist(CSPSolver solver, Service service) {
    try {
      Map<Staff, List<LocalDateTime>> slotsByTherapist = solver.getAllValidSlotsGroupedByTherapist(service);

      if (!slotsByTherapist.isEmpty()) {
        System.out.println("👥 Slots by therapist:");
        slotsByTherapist.forEach((therapist, times) -> {
          String therapistName = getTherapistName(therapist);
          System.out.printf("   • %s: %d slots available%n", therapistName, times.size());

          // Show first 3 times for this therapist
          int timesToShow = Math.min(3, times.size());
          for (int i = 0; i < timesToShow; i++) {
            System.out.printf("     - %s%n", formatDateTime(times.get(i)));
          }
          if (times.size() > 3) {
            System.out.printf("     ... and %d more%n", times.size() - 3);
          }
        });
      }
    } catch (Exception e) {
      System.err.println("⚠️ Could not group slots by therapist: " + e.getMessage());
    }
  }

  /**
   * Analyze why no slots were found
   */
  private static void analyzeWhyNoSlots(CSPSolver solver, Service service) {
    System.out.println("🔍 Analyzing why no slots were found:");

    // Check if there are qualified therapists
    CSPDomain domain = new CSPDomain(); // Create new domain for analysis
    CSPVariable variable = new CSPVariable(service, null, null, true);

    try {
      List<Staff> qualifiedTherapists = domain.getCompatibleTherapistsForService(variable);
      if (qualifiedTherapists.isEmpty()) {
        System.out.println("   ❌ No therapists qualified for this service type");
      } else {
        System.out.println("   ✅ Found " + qualifiedTherapists.size() + " qualified therapists");
      }

      // Check available time slots
      List<LocalDateTime> compatibleTimes = domain.getCompatibleTimesForService(variable);
      if (compatibleTimes.isEmpty()) {
        System.out.println("   ❌ No time slots can accommodate service duration (" +
            service.getDurationMinutes() + " minutes)");
      } else {
        System.out.println("   ✅ Found " + compatibleTimes.size() + " compatible time slots");
      }

    } catch (Exception e) {
      System.err.println("   ❌ Error during analysis: " + e.getMessage());
    }
  }

  /**
   * Simulate various booking scenarios
   */
  private static void simulateBookingScenarios(CSPSolver solver, List<Service> services) {
    System.out.println("🎯 Scenario 1: Peak hours booking (10 AM - 2 PM)");
    simulatePeakHoursBooking(solver, services);

    System.out.println("\n🎯 Scenario 2: Next-day booking availability");
    simulateNextDayBooking(solver, services);

    System.out.println("\n🎯 Scenario 3: Weekend availability");
    simulateWeekendBooking(solver, services);

    System.out.println("\n🎯 Scenario 4: Multi-service package booking");
    simulateMultiServiceBooking(solver, services);
  }

  /**
   * Simulate peak hours booking
   */
  private static void simulatePeakHoursBooking(CSPSolver solver, List<Service> services) {
    Service service = services.get(random.nextInt(services.size()));

    try {
      List<Assignment> allSlots = solver.getAllValidSlots(service);
      List<Assignment> peakHourSlots = allSlots.stream()
          .filter(slot -> {
            int hour = slot.getStartTime().getHour();
            return hour >= 10 && hour <= 14; // 10 AM - 2 PM
          })
          .collect(Collectors.toList());

      System.out.printf("   📊 Peak hours availability for %s: %d/%d slots%n",
          service.getName(), peakHourSlots.size(), allSlots.size());

      if (!peakHourSlots.isEmpty()) {
        Assignment nextPeakSlot = peakHourSlots.get(0);
        System.out.printf("   ⏰ Next peak hour slot: %s%n",
            formatDateTime(nextPeakSlot.getStartTime()));
      }

    } catch (Exception e) {
      System.err.println("   ❌ Error analyzing peak hours: " + e.getMessage());
    }
  }

  /**
   * Simulate next-day booking (starting from tomorrow as per booking system
   * design)
   */
  private static void simulateNextDayBooking(CSPSolver solver, List<Service> services) {
    Service service = services.get(random.nextInt(services.size()));

    try {
      List<Assignment> allSlots = solver.getAllValidSlots(service);
      LocalDateTime tomorrow = LocalDateTime.now().plusDays(1).withHour(8).withMinute(0).withSecond(0);
      LocalDateTime endOfDay = tomorrow.withHour(20);

      List<Assignment> tomorrowSlots = allSlots.stream()
          .filter(slot -> slot.getStartTime().toLocalDate().equals(tomorrow.toLocalDate()))
          .collect(Collectors.toList());

      System.out.printf("   📅 Next-day availability for %s: %d slots available tomorrow%n",
          service.getName(), tomorrowSlots.size());

      if (!tomorrowSlots.isEmpty()) {
        Assignment nextTomorrowSlot = tomorrowSlots.get(0);
        System.out.printf("   ⚡ Earliest tomorrow: %s%n",
            formatDateTime(nextTomorrowSlot.getStartTime()));
      } else {
        System.out.println("   ❌ No next-day availability");
      }

    } catch (Exception e) {
      System.err.println("   ❌ Error analyzing next-day booking: " + e.getMessage());
    }
  }

  /**
   * Simulate weekend booking
   */
  private static void simulateWeekendBooking(CSPSolver solver, List<Service> services) {
    Service service = services.get(random.nextInt(services.size()));

    try {
      List<Assignment> allSlots = solver.getAllValidSlots(service);
      List<Assignment> weekendSlots = allSlots.stream()
          .filter(slot -> {
            int dayOfWeek = slot.getStartTime().getDayOfWeek().getValue();
            return dayOfWeek == 6 || dayOfWeek == 7; // Saturday or Sunday
          })
          .collect(Collectors.toList());

      System.out.printf("   🎉 Weekend availability for %s: %d slots%n",
          service.getName(), weekendSlots.size());

      if (!weekendSlots.isEmpty()) {
        Assignment nextWeekendSlot = weekendSlots.get(0);
        System.out.printf("   📅 Next weekend slot: %s%n",
            formatDateTime(nextWeekendSlot.getStartTime()));
      }

    } catch (Exception e) {
      System.err.println("   ❌ Error analyzing weekend availability: " + e.getMessage());
    }
  }

  /**
   * Simulate multi-service package booking
   */
  private static void simulateMultiServiceBooking(CSPSolver solver, List<Service> services) {
    // Select 2-3 services for a package
    int packageSize = 2 + random.nextInt(2); // 2 or 3 services
    List<Service> packageServices = services.stream()
        .limit(packageSize)
        .collect(Collectors.toList());

    System.out.printf("   📦 Analyzing package booking for %d services:%n", packageSize);
    packageServices.forEach(
        service -> System.out.printf("      • %s (%d min)%n", service.getName(), service.getDurationMinutes()));

    // Calculate total duration
    int totalDuration = packageServices.stream()
        .mapToInt(Service::getDurationMinutes)
        .sum();

    System.out.printf("   ⏱️ Total package duration: %d minutes (%.1f hours)%n",
        totalDuration, totalDuration / 60.0);

    // Find availability for each service
    int availableForAll = Integer.MAX_VALUE;
    for (Service service : packageServices) {
      try {
        List<Assignment> slots = solver.getAllValidSlots(service);
        availableForAll = Math.min(availableForAll, slots.size());
        System.out.printf("      %s: %d slots available%n", service.getName(), slots.size());
      } catch (Exception e) {
        System.err.println("      ❌ Error for " + service.getName() + ": " + e.getMessage());
      }
    }

    if (availableForAll > 0) {
      System.out.printf("   ✅ Package booking feasible with %d potential scheduling combinations%n",
          availableForAll);
    } else {
      System.out.println("   ❌ Package booking challenging - some services have limited availability");
    }
  }

  /**
   * Format date time for display
   */
  private static String formatDateTime(LocalDateTime dateTime) {
    return dateTime.format(DATE_FORMAT);
  }

  /**
   * Get therapist name safely
   */
  private static String getTherapistName(Staff therapist) {
    if (therapist == null)
      return "Unknown Therapist";
    if (therapist.getUser() != null && therapist.getUser().getFullName() != null) {
      return therapist.getUser().getFullName();
    }
    return "Therapist ID: " + (therapist.getUser() != null ? therapist.getUser().getUserId() : "Unknown");
  }
}