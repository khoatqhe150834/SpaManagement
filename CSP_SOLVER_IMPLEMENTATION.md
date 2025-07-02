# Constraint Satisfaction Problem (CSP) Solver for Therapist Assignment

## Overview

This document describes the implementation of a CSP solver to optimize therapist assignments in our spa booking system. The solver ensures efficient allocation of therapists to appointments while respecting various constraints like skills, availability, and workload balance.

## Problem Definition

### Variables

- Appointments that need therapist assignment
- Available time slots
- Therapist schedules

### Constraints

1. Hard Constraints:

   - Therapist must be qualified for service
   - No schedule conflicts
   - Respect working hours
   - Required breaks between appointments

2. Soft Constraints:
   - Workload balance
   - Customer preferences
   - Minimize gaps between appointments
   - Therapist specialization match

## Implementation

### 1. Domain Model

```java
public class Assignment {
    private int appointmentId;
    private int therapistId;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private double score;  // For optimization

    // Getters and setters
}

public class Constraint {
    private ConstraintType type;
    private int weight;
    private BiFunction<Assignment, Assignment, Boolean> validator;

    public boolean validate(Assignment a1, Assignment a2) {
        return validator.apply(a1, a2);
    }
}

public enum ConstraintType {
    QUALIFICATION,
    TIME_CONFLICT,
    WORKING_HOURS,
    BREAK_TIME,
    WORKLOAD_BALANCE,
    CUSTOMER_PREFERENCE,
    SPECIALIZATION_MATCH
}
```

### 2. Constraint Definitions

```java
public class ConstraintRepository {

    private List<Constraint> constraints = new ArrayList<>();

    public void initializeConstraints() {
        // Hard Constraints
        addQualificationConstraint();
        addTimeConflictConstraint();
        addWorkingHoursConstraint();
        addBreakTimeConstraint();

        // Soft Constraints
        addWorkloadBalanceConstraint();
        addCustomerPreferenceConstraint();
        addSpecializationMatchConstraint();
    }

    private void addQualificationConstraint() {
        constraints.add(new Constraint(
            ConstraintType.QUALIFICATION,
            Integer.MAX_VALUE,  // Hard constraint
            (a1, a2) -> {
                Therapist therapist = therapistDAO.findById(a1.getTherapistId());
                Service service = appointmentDAO.findServiceById(a1.getAppointmentId());
                return therapist.getQualifications().contains(service.getType());
            }
        ));
    }

    private void addTimeConflictConstraint() {
        constraints.add(new Constraint(
            ConstraintType.TIME_CONFLICT,
            Integer.MAX_VALUE,  // Hard constraint
            (a1, a2) -> {
                if (a1.getTherapistId() != a2.getTherapistId()) {
                    return true;  // Different therapists, no conflict
                }
                return !a1.getTimeSlot().overlaps(a2.getTimeSlot());
            }
        ));
    }

    // Add more constraints...
}
```

### 3. CSP Solver Implementation

```java
@Service
public class TherapistAssignmentSolver {

    private final ConstraintRepository constraintRepo;
    private final TherapistDAO therapistDAO;
    private final AppointmentDAO appointmentDAO;

    /**
     * Solves the therapist assignment problem using backtracking
     */
    public List<Assignment> solve(List<Appointment> appointments) {
        List<Assignment> assignments = new ArrayList<>();
        List<Therapist> therapists = therapistDAO.findAvailableTherapists();

        // Sort appointments by complexity (more complex first)
        appointments.sort((a1, a2) ->
            Integer.compare(calculateComplexity(a2), calculateComplexity(a1)));

        for (Appointment appt : appointments) {
            Optional<Assignment> assignment = findBestAssignment(appt, therapists, assignments);
            if (assignment.isPresent()) {
                assignments.add(assignment.get());
            } else {
                throw new NoSolutionException("Cannot find valid assignment for appointment: " + appt.getId());
            }
        }

        return assignments;
    }

    /**
     * Finds the best assignment for an appointment using forward checking
     */
    private Optional<Assignment> findBestAssignment(
            Appointment appt,
            List<Therapist> therapists,
            List<Assignment> existingAssignments) {

        PriorityQueue<Assignment> candidates = new PriorityQueue<>(
            (a1, a2) -> Double.compare(a2.getScore(), a1.getScore()));

        for (Therapist therapist : therapists) {
            List<TimeSlot> availableSlots = findAvailableSlots(
                therapist, appt.getStartTime(), appt.getEndTime());

            for (TimeSlot slot : availableSlots) {
                Assignment candidate = new Assignment(appt, therapist, slot);
                if (isValidAssignment(candidate, existingAssignments)) {
                    double score = calculateScore(candidate, existingAssignments);
                    candidate.setScore(score);
                    candidates.add(candidate);
                }
            }
        }

        return Optional.ofNullable(candidates.poll());
    }

    /**
     * Validates an assignment against all constraints
     */
    private boolean isValidAssignment(
            Assignment candidate,
            List<Assignment> existingAssignments) {

        for (Constraint constraint : constraintRepo.getHardConstraints()) {
            for (Assignment existing : existingAssignments) {
                if (!constraint.validate(candidate, existing)) {
                    return false;
                }
            }
        }
        return true;
    }

    /**
     * Calculates score for an assignment based on soft constraints
     */
    private double calculateScore(
            Assignment candidate,
            List<Assignment> existingAssignments) {

        double score = 0.0;
        for (Constraint constraint : constraintRepo.getSoftConstraints()) {
            double constraintScore = 0.0;
            for (Assignment existing : existingAssignments) {
                if (constraint.validate(candidate, existing)) {
                    constraintScore += constraint.getWeight();
                }
            }
            score += constraintScore;
        }
        return score;
    }

    /**
     * Calculates complexity of an appointment for sorting
     */
    private int calculateComplexity(Appointment appt) {
        int complexity = 0;
        complexity += appt.getServices().size() * 2;  // More services = more complex
        complexity += appt.getDuration().toHours() * 1;  // Longer = more complex
        if (appt.hasCustomerPreference()) complexity += 3;
        return complexity;
    }
}
```

### 4. Integration with Booking System

```java
@Service
public class BookingService {

    private final TherapistAssignmentSolver solver;

    @Transactional
    public List<Appointment> assignTherapists(List<Appointment> appointments) {
        try {
            List<Assignment> assignments = solver.solve(appointments);

            // Apply assignments
            for (Assignment assignment : assignments) {
                Appointment appt = appointmentDAO.findById(assignment.getAppointmentId());
                appt.setTherapist(assignment.getTherapist());
                appt.setTimeSlot(assignment.getTimeSlot());
                appointmentDAO.save(appt);
            }

            return appointments;

        } catch (NoSolutionException e) {
            // Handle case where no valid assignment is possible
            throw new BookingException("Unable to assign therapists: " + e.getMessage());
        }
    }
}
```

## Performance Optimization

### 1. Forward Checking

- Prune invalid assignments early
- Maintain domain consistency
- Reduce backtracking

```java
private List<Therapist> filterCandidateTherapists(
        Appointment appt,
        List<Assignment> existingAssignments) {

    return therapistDAO.findAll().stream()
        .filter(therapist -> hasRequiredQualifications(therapist, appt))
        .filter(therapist -> hasAvailableTime(therapist, appt))
        .filter(therapist -> !exceedsMaxDailyHours(therapist, appt))
        .collect(Collectors.toList());
}
```

### 2. Least Constraining Value

- Choose assignments that leave more options open
- Sort candidates by impact on future assignments

```java
private void sortCandidatesByConstraintImpact(
        List<Assignment> candidates,
        List<Appointment> unassignedAppointments) {

    candidates.sort((a1, a2) -> {
        int impact1 = calculateConstraintImpact(a1, unassignedAppointments);
        int impact2 = calculateConstraintImpact(a2, unassignedAppointments);
        return Integer.compare(impact1, impact2);
    });
}
```

### 3. Caching

- Cache constraint validation results
- Store frequently accessed data
- Update cache on changes

```java
@Service
public class ConstraintValidationCache {
    private LoadingCache<CacheKey, Boolean> validationCache;

    public ConstraintValidationCache() {
        validationCache = Caffeine.newBuilder()
            .maximumSize(10_000)
            .expireAfterWrite(5, TimeUnit.MINUTES)
            .build(key -> validateConstraint(key));
    }

    public boolean isValid(Assignment a1, Assignment a2, Constraint constraint) {
        CacheKey key = new CacheKey(a1, a2, constraint);
        return validationCache.get(key);
    }
}
```

## Testing

### 1. Unit Tests

```java
@Test
public void testConstraintValidation() {
    Assignment a1 = createTestAssignment(1, 1, "09:00", "10:00");
    Assignment a2 = createTestAssignment(2, 1, "10:30", "11:30");

    assertTrue(solver.isValidAssignment(a1, Collections.emptyList()));
    assertTrue(solver.isValidAssignment(a2, Arrays.asList(a1)));

    // Test overlapping assignments
    Assignment a3 = createTestAssignment(3, 1, "09:30", "10:30");
    assertFalse(solver.isValidAssignment(a3, Arrays.asList(a1)));
}
```

### 2. Integration Tests

```java
@Test
public void testComplexBookingScenario() {
    List<Appointment> appointments = createComplexBookingScenario();
    List<Assignment> assignments = solver.solve(appointments);

    assertNotNull(assignments);
    assertEquals(appointments.size(), assignments.size());
    assertTrue(validateAllConstraints(assignments));
    assertTrue(isWorkloadBalanced(assignments));
}
```

### 3. Performance Tests

```java
@Test
public void testSolverPerformance() {
    int numAppointments = 100;
    List<Appointment> appointments = generateRandomAppointments(numAppointments);

    long startTime = System.currentTimeMillis();
    List<Assignment> assignments = solver.solve(appointments);
    long endTime = System.currentTimeMillis();

    assertTrue((endTime - startTime) < 5000);  // Should solve within 5 seconds
    assertEquals(numAppointments, assignments.size());
}
```

## Monitoring & Maintenance

1. Performance Metrics:

   - Solution time
   - Number of backtracks
   - Cache hit rate
   - Constraint validation time

2. Quality Metrics:

   - Workload balance score
   - Customer satisfaction
   - Resource utilization
   - Booking success rate

3. Alerts:
   - Solver failures
   - Performance degradation
   - High conflict rates
   - Resource bottlenecks

## Future Improvements

1. Machine Learning:

   - Learn from historical assignments
   - Predict optimal assignments
   - Adjust constraint weights
   - Identify patterns

2. Real-time Updates:

   - Dynamic constraint adjustment
   - Continuous optimization
   - Handle last-minute changes

3. Scalability:
   - Parallel solving
   - Distributed processing
   - Incremental solving
