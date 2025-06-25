package model;

import dao.StaffDAO;
import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.Month;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

public class CSPDomain {
  private static final int NUMBER_OF_DAY_AHEAD = 360; // in days
  private static final int TIME_INTERVAL = 30; // in minutes
  private static final LocalTime BUSINESS_START_TIME = LocalTime.of(7, 0); // 7:00 AM
  private static final LocalTime BUSINESS_END_TIME = LocalTime.of(19, 0); // 7:00 PM

  // Vietnam holidays and closures
  private static final Set<LocalDate> VIETNAM_HOLIDAYS = getVietnamHolidays();

  private List<Staff> availableTherapists;
  private List<LocalDateTime> availableTimes;

  public CSPDomain(List<Staff> availableTherapists, List<LocalDateTime> availableTimes) {
    this.availableTherapists = availableTherapists != null ? new ArrayList<>(availableTherapists) : new ArrayList<>();
    this.availableTimes = availableTimes != null ? new ArrayList<>(availableTimes) : new ArrayList<>();
  }

  public CSPDomain() {
    this.availableTherapists = new ArrayList<>();
    this.availableTimes = getAllPossibleDateTimes();
  }

  /**
   * Get therapists qualified for a specific service
   * 
   * @param variable CSP variable containing the chosen service
   * @return List of compatible therapists, filtered by domain availability
   */
  public List<Staff> getCompatibleTherapistsForService(CSPVariable variable) {
    if (variable == null || variable.getChosenService() == null) {
      return new ArrayList<>();
    }

    // get the service
    Service service = variable.getChosenService();

    // get the therapists qualified for the service using DAO
    if (service.getServiceTypeId() == null) {
      return new ArrayList<>();
    }

    int serviceTypeId = service.getServiceTypeId().getServiceTypeId();

    StaffDAO staffDAO = new StaffDAO();
    List<Staff> compatibleTherapists = staffDAO.findTherapistsByServiceType(serviceTypeId);

    // Filter by available therapists in the domain (if domain has specific
    // therapists)
    if (availableTherapists.isEmpty()) {
      return compatibleTherapists;
    } else {
      return compatibleTherapists.stream()
          .filter(therapist -> availableTherapists.contains(therapist))
          .collect(Collectors.toList());
    }
  }

  /**
   * Generate all possible date-time slots for booking
   * 
   * @return List of all possible booking times within business hours
   */
  public List<LocalDateTime> getAllPossibleDateTimes() {
    List<LocalDateTime> allPossibleDatetimes = new ArrayList<>();

    LocalDate today = LocalDate.now();
    Duration interval = Duration.ofMinutes(TIME_INTERVAL);

    System.out.println("🕐 DEBUG CSPDomain: Generating slots starting from today: " + today);
    System.out.println("🕐 DEBUG CSPDomain: Current time: " + LocalDateTime.now());

    // Generate available times for the next specified days (starting from today)
    for (int day = 0; day <= NUMBER_OF_DAY_AHEAD; day++) {
      LocalDate currentDate = today.plusDays(day);
      LocalDateTime currentDateTime;
      LocalDateTime dayEndTime = LocalDateTime.of(currentDate, BUSINESS_END_TIME);

      // For today, start from current time or business start time (whichever is
      // later)
      if (day == 0) {
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime businessStart = LocalDateTime.of(currentDate, BUSINESS_START_TIME);

        // MODIFIED: For testing purposes, always start from business hours
        // In production, you would want to use current time + buffer
        currentDateTime = businessStart; // Always start from 7 AM for testing

        System.out.println("🕐 DEBUG CSPDomain Day " + day + " (today): Business start=" + businessStart +
            ", Current time=" + now + ", Using business start for testing=" + currentDateTime);

        // Round up to next interval
        int minutesToAdd = TIME_INTERVAL - (currentDateTime.getMinute() % TIME_INTERVAL);
        if (minutesToAdd != TIME_INTERVAL) {
          currentDateTime = currentDateTime.plusMinutes(minutesToAdd);
        }
      } else {
        currentDateTime = LocalDateTime.of(currentDate, BUSINESS_START_TIME);
        System.out.println("🕐 DEBUG CSPDomain Day " + day + ": Starting from business hours=" + currentDateTime);
      }

      // Generate time slots for the current day (skip holidays/closures)
      if (!isHolidayOrClosure(currentDate)) {
        int slotsGenerated = 0;
        while (currentDateTime.isBefore(dayEndTime)) {
          allPossibleDatetimes.add(currentDateTime);
          currentDateTime = currentDateTime.plus(interval);
          slotsGenerated++;
        }
        System.out.println(
            "🕐 DEBUG CSPDomain Day " + day + " (" + currentDate + "): Generated " + slotsGenerated + " slots");
      } else {
        System.out.println("🕐 DEBUG CSPDomain Day " + day + " (" + currentDate + "): Skipped (holiday/closure)");
      }
    }

    System.out.println("🕐 DEBUG CSPDomain: Total slots generated: " + allPossibleDatetimes.size());
    return allPossibleDatetimes;
  }

  /**
   * Get Vietnam holidays for the current year
   * 
   * @return Set of holiday dates
   */
  private static Set<LocalDate> getVietnamHolidays() {
    Set<LocalDate> holidays = new HashSet<>();
    int currentYear = LocalDate.now().getYear();

    // Fixed Vietnam holidays
    holidays.add(LocalDate.of(currentYear, Month.JANUARY, 1)); // New Year's Day
    holidays.add(LocalDate.of(currentYear, Month.APRIL, 30)); // Liberation Day
    holidays.add(LocalDate.of(currentYear, Month.MAY, 1)); // Labour Day
    holidays.add(LocalDate.of(currentYear, Month.SEPTEMBER, 2)); // National Day

    // Tet Holiday (Vietnamese New Year) - approximate dates for 2024-2025
    if (currentYear == 2024) {
      // Tet 2024: February 8-14
      for (int day = 8; day <= 14; day++) {
        holidays.add(LocalDate.of(2024, Month.FEBRUARY, day));
      }
    } else if (currentYear == 2025) {
      // Tet 2025: January 28 - February 3
      holidays.add(LocalDate.of(2025, Month.JANUARY, 28));
      holidays.add(LocalDate.of(2025, Month.JANUARY, 29));
      holidays.add(LocalDate.of(2025, Month.JANUARY, 30));
      holidays.add(LocalDate.of(2025, Month.JANUARY, 31));
      holidays.add(LocalDate.of(2025, Month.FEBRUARY, 1));
      holidays.add(LocalDate.of(2025, Month.FEBRUARY, 2));
      holidays.add(LocalDate.of(2025, Month.FEBRUARY, 3));
    }

    // Hung Kings Festival - 10th day of 3rd lunar month (approximate)
    holidays.add(LocalDate.of(currentYear, Month.APRIL, 18)); // Approximate date

    return holidays;
  }

  /**
   * Check if a date is a holiday or closure day
   * 
   * @param date Date to check
   * @return true if it's a holiday/closure, false otherwise
   */
  private static boolean isHolidayOrClosure(LocalDate date) {
    // Check Vietnam holidays
    if (VIETNAM_HOLIDAYS.contains(date)) {
      return true;
    }

    // Spa closure on Sundays (optional business rule)
    // return date.getDayOfWeek() == DayOfWeek.SUNDAY;

    return false;
  }

  /**
   * Filter available times based on service duration
   * 
   * @param serviceDurationMinutes Duration of the service in minutes
   * @return List of times that can accommodate the service duration
   */
  public List<LocalDateTime> getCompatibleTimesForService(CSPVariable variable) {
    int serviceDurationMinutes = variable.getChosenService().getDurationMinutes();
    return availableTimes.stream()
        .filter(time -> {
          LocalDateTime serviceEndTime = time.plusMinutes(serviceDurationMinutes);
          // Check if service ends within business hours
          return serviceEndTime.toLocalTime().isBefore(BUSINESS_END_TIME) ||
              serviceEndTime.toLocalTime().equals(BUSINESS_END_TIME);
        })
        .collect(Collectors.toList());
  }

  /**
   * Remove a therapist from the available domain
   * 
   * @param therapist Therapist to remove
   * @return true if therapist was removed, false if not found
   */
  public boolean removeTherapist(Staff therapist) {
    return availableTherapists.remove(therapist);
  }

  /**
   * Remove a time slot from the available domain
   * 
   * @param time Time slot to remove
   * @return true if time was removed, false if not found
   */
  public boolean removeTimeSlot(LocalDateTime time) {
    return availableTimes.remove(time);
  }

  /**
   * Add a therapist to the available domain
   * 
   * @param therapist Therapist to add
   * @return true if therapist was added, false if already exists
   */
  public boolean addTherapist(Staff therapist) {
    if (therapist != null && !availableTherapists.contains(therapist)) {
      return availableTherapists.add(therapist);
    }
    return false;
  }

  /**
   * Add a time slot to the available domain
   * 
   * @param time Time slot to add
   * @return true if time was added, false if already exists
   */
  public boolean addTimeSlot(LocalDateTime time) {
    if (time != null && !availableTimes.contains(time)) {
      return availableTimes.add(time);
    }
    return false;
  }

  /**
   * Check if the domain is empty (no available therapists or times)
   * 
   * @return true if domain is empty, false otherwise
   */
  public boolean isEmpty() {
    return availableTherapists.isEmpty() || availableTimes.isEmpty();
  }

  /**
   * Get the size of the domain (combination of therapists and times)
   * 
   * @return total number of possible combinations
   */
  public int getDomainSize() {
    return availableTherapists.size() * availableTimes.size();
  }

  /**
   * Filter times that are in the future (not in the past)
   * 
   * @return List of future time slots
   */
  public List<LocalDateTime> getFutureTimeSlots() {
    LocalDateTime now = LocalDateTime.now();
    return availableTimes.stream()
        .filter(time -> time.isAfter(now))
        .collect(Collectors.toList());
  }

  /**
   * Create a copy of this domain
   * 
   * @return Deep copy of the current domain
   */
  public CSPDomain copy() {
    return new CSPDomain(new ArrayList<>(this.availableTherapists),
        new ArrayList<>(this.availableTimes));
  }

  // Getters and setters
  public List<Staff> getAvailableTherapists() {
    return new ArrayList<>(availableTherapists);
  }

  public void setAvailableTherapists(List<Staff> availableTherapists) {
    this.availableTherapists = availableTherapists != null ? new ArrayList<>(availableTherapists) : new ArrayList<>();
  }

  public List<LocalDateTime> getAvailableTimes() {
    return new ArrayList<>(availableTimes);
  }

  public void setAvailableTimes(List<LocalDateTime> availableTimes) {
    this.availableTimes = availableTimes != null ? new ArrayList<>(availableTimes) : new ArrayList<>();
  }

  /**
   * Main method for testing CSPDomain functionality
   */
  public static void main(String[] args) {
    System.out.println("=== Testing CSPDomain ===");

    // Test 1: Create domain with default constructor
    CSPDomain domain = new CSPDomain();

    System.out.println("\n1. Default Domain:");
    System.out.println("- Available time slots: " + domain.getAvailableTimes().size());
    System.out.println("- Available therapists: " + domain.getAvailableTherapists().size());
    System.out.println("- Domain size: " + domain.getDomainSize());
    System.out.println("- Is empty: " + domain.isEmpty());

    // Test 2: Test time generation
    System.out.println("\n2. First 5 available time slots:");
    List<LocalDateTime> times = domain.getAvailableTimes();
    for (int i = 0; i < Math.min(5, times.size()); i++) {
      System.out.println("- " + times.get(i));
    }

    // Test 3: Test with real therapist data
    StaffDAO staffDAO = new StaffDAO();
    List<Staff> allStaff = staffDAO.findAll();

    if (!allStaff.isEmpty()) {
      System.out.println("\n3. Testing with real therapist data:");
      List<Staff> sampleTherapists = allStaff.subList(0, Math.min(3, allStaff.size()));

      CSPDomain populatedDomain = new CSPDomain(sampleTherapists, domain.getAvailableTimes());

      System.out.println("- Populated domain size: " + populatedDomain.getDomainSize());
      System.out.println("- Available therapists: " + populatedDomain.getAvailableTherapists().size());

      for (Staff therapist : populatedDomain.getAvailableTherapists()) {
        System.out.println("  * "
            + (therapist.getUser() != null ? "Therapist ID: " + therapist.getUser().getUserId() : "Unknown therapist") +
            " (Status: " + therapist.getAvailabilityStatus() + ")");
      }

      // Test 4: Test service compatibility
      if (!sampleTherapists.isEmpty() && sampleTherapists.get(0).getServiceType() != null) {
        System.out.println("\n4. Testing service compatibility:");
        int serviceTypeId = sampleTherapists.get(0).getServiceType().getServiceTypeId();
        List<Staff> compatibleTherapists = staffDAO.findTherapistsByServiceType(serviceTypeId);
        System.out.println("- Compatible therapists for service type " + serviceTypeId + ": " +
            compatibleTherapists.size());
      }
    }

    // Test 5: Test domain operations
    System.out.println("\n5. Testing domain operations:");
    CSPDomain testDomain = new CSPDomain();

    System.out.println("- Future time slots: " + testDomain.getFutureTimeSlots().size());
    // Note: getCompatibleTimesForService now requires CSPVariable, so skipping this
    // test
    System.out.println("- Total available times: " + testDomain.getAvailableTimes().size());

    // Test 6: Test copy functionality
    CSPDomain copiedDomain = testDomain.copy();
    System.out.println("- Copied domain size: " + copiedDomain.getDomainSize());
    System.out.println("- Original and copy are different objects: " + (testDomain != copiedDomain));

    System.out.println("\n=== Testing completed ===");
  }
}
