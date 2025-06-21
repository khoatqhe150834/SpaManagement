package model;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

public class BookingSession {
  private String sessionId;
  private Integer customerId;
  private String sessionData; // JSON string
  private CurrentStep currentStep;
  private LocalDateTime expiresAt;
  private LocalDateTime createdAt;
  private LocalDateTime updatedAt;

  // Transient fields for working with session data
  private BookingSessionData data;
  private static final ObjectMapper objectMapper = new ObjectMapper()
      .registerModule(new JavaTimeModule());

  public enum CurrentStep {
    SERVICES, TIME, THERAPISTS, REGISTRATION, PAYMENT
  }

  // Constructors
  public BookingSession() {
    this.data = new BookingSessionData();
    this.currentStep = CurrentStep.SERVICES;
    this.expiresAt = LocalDateTime.now().plusDays(30);
  }

  public BookingSession(String sessionId) {
    this();
    this.sessionId = sessionId;
  }

  // Business Logic Methods
  public void addSelectedService(ServiceSelection service) {
    if (data.getSelectedServices() == null) {
      data.setSelectedServices(new ArrayList<>());
    }
    data.getSelectedServices().add(service);
    updateTotals();
  }

  public void removeSelectedService(int serviceId) {
    if (data.getSelectedServices() != null) {
      data.getSelectedServices().removeIf(s -> s.getServiceId() == serviceId);
      updateTotals();
    }
  }

  public void assignTherapistToService(int serviceId, int therapistUserId, String therapistName) {
    if (data.getSelectedServices() != null) {
      for (ServiceSelection service : data.getSelectedServices()) {
        if (service.getServiceId() == serviceId) {
          service.setTherapistUserId(therapistUserId);
          service.setTherapistName(therapistName);
          break;
        }
      }
    }
  }

  public void scheduleService(int serviceId, LocalDateTime scheduledTime) {
    if (data.getSelectedServices() != null) {
      for (ServiceSelection service : data.getSelectedServices()) {
        if (service.getServiceId() == serviceId) {
          service.setScheduledTime(scheduledTime);
          break;
        }
      }
    }
  }

  public boolean isExpired() {
    return LocalDateTime.now().isAfter(expiresAt);
  }

  public boolean hasServices() {
    return data.getSelectedServices() != null && !data.getSelectedServices().isEmpty();
  }

  public boolean hasTherapistAssignments() {
    if (!hasServices())
      return false;
    return data.getSelectedServices().stream()
        .allMatch(s -> s.getTherapistUserId() != null);
  }

  public boolean hasTimeSlots() {
    if (!hasServices())
      return false;
    return data.getSelectedServices().stream()
        .allMatch(s -> s.getScheduledTime() != null);
  }

  public boolean isReadyForPayment() {
    return hasServices() && hasTimeSlots() && hasTherapistAssignments() && customerId != null;
  }

  private void updateTotals() {
    if (data.getSelectedServices() == null || data.getSelectedServices().isEmpty()) {
      data.setTotalAmount(BigDecimal.ZERO);
      data.setTotalDuration(0);
      return;
    }

    BigDecimal total = data.getSelectedServices().stream()
        .map(ServiceSelection::getEstimatedPrice)
        .reduce(BigDecimal.ZERO, BigDecimal::add);
    data.setTotalAmount(total);

    int duration = data.getSelectedServices().stream()
        .mapToInt(ServiceSelection::getEstimatedDuration)
        .sum();
    data.setTotalDuration(duration);
  }

  // JSON Serialization Methods
  public void serializeData() {
    try {
      this.sessionData = objectMapper.writeValueAsString(this.data);
    } catch (JsonProcessingException e) {
      throw new RuntimeException("Failed to serialize session data", e);
    }
  }

  public void deserializeData() {
    if (this.sessionData != null && !this.sessionData.trim().isEmpty()) {
      try {
        this.data = objectMapper.readValue(this.sessionData, BookingSessionData.class);
      } catch (JsonProcessingException e) {
        this.data = new BookingSessionData(); // Fallback to empty data
      }
    } else {
      this.data = new BookingSessionData();
    }
  }

  // Getters and Setters
  public String getSessionId() {
    return sessionId;
  }

  public void setSessionId(String sessionId) {
    this.sessionId = sessionId;
  }

  public Integer getCustomerId() {
    return customerId;
  }

  public void setCustomerId(Integer customerId) {
    this.customerId = customerId;
  }

  public String getSessionData() {
    return sessionData;
  }

  public void setSessionData(String sessionData) {
    this.sessionData = sessionData;
    deserializeData();
  }

  public CurrentStep getCurrentStep() {
    return currentStep;
  }

  public void setCurrentStep(CurrentStep currentStep) {
    this.currentStep = currentStep;
  }

  public LocalDateTime getExpiresAt() {
    return expiresAt;
  }

  public void setExpiresAt(LocalDateTime expiresAt) {
    this.expiresAt = expiresAt;
  }

  public LocalDateTime getCreatedAt() {
    return createdAt;
  }

  public void setCreatedAt(LocalDateTime createdAt) {
    this.createdAt = createdAt;
  }

  public LocalDateTime getUpdatedAt() {
    return updatedAt;
  }

  public void setUpdatedAt(LocalDateTime updatedAt) {
    this.updatedAt = updatedAt;
  }

  public BookingSessionData getData() {
    if (data == null) {
      deserializeData();
    }
    return data;
  }

  public void setData(BookingSessionData data) {
    this.data = data;
    serializeData();
  }

  // Inner Classes for JSON Data Structure
  @JsonIgnoreProperties(ignoreUnknown = true)
  public static class BookingSessionData {
    @JsonProperty("selectedServices")
    private List<ServiceSelection> selectedServices = new ArrayList<>();

    @JsonProperty("totalAmount")
    private BigDecimal totalAmount = BigDecimal.ZERO;

    @JsonProperty("totalDuration")
    private Integer totalDuration = 0;

    @JsonProperty("selectedDate")
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate selectedDate;

    @JsonProperty("paymentMethod")
    private String paymentMethod = "ONLINE_BANKING";

    @JsonProperty("specialNotes")
    private String specialNotes;

    // Getters and Setters
    public List<ServiceSelection> getSelectedServices() {
      return selectedServices;
    }

    public void setSelectedServices(List<ServiceSelection> selectedServices) {
      this.selectedServices = selectedServices;
    }

    public BigDecimal getTotalAmount() {
      return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
      this.totalAmount = totalAmount;
    }

    public Integer getTotalDuration() {
      return totalDuration;
    }

    public void setTotalDuration(Integer totalDuration) {
      this.totalDuration = totalDuration;
    }

    public LocalDate getSelectedDate() {
      return selectedDate;
    }

    public void setSelectedDate(LocalDate selectedDate) {
      this.selectedDate = selectedDate;
    }

    public String getPaymentMethod() {
      return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
      this.paymentMethod = paymentMethod;
    }

    public String getSpecialNotes() {
      return specialNotes;
    }

    public void setSpecialNotes(String specialNotes) {
      this.specialNotes = specialNotes;
    }
  }

  @JsonIgnoreProperties(ignoreUnknown = true)
  public static class ServiceSelection {
    @JsonProperty("serviceId")
    private Integer serviceId;

    @JsonProperty("serviceName")
    private String serviceName;

    @JsonProperty("therapistUserId")
    private Integer therapistUserId;

    @JsonProperty("therapistName")
    private String therapistName;

    @JsonProperty("estimatedPrice")
    private BigDecimal estimatedPrice;

    @JsonProperty("estimatedDuration")
    private Integer estimatedDuration;

    @JsonProperty("scheduledTime")
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
    private LocalDateTime scheduledTime;

    @JsonProperty("serviceOrder")
    private Integer serviceOrder = 1;

    // Constructors
    public ServiceSelection() {
    }

    public ServiceSelection(Integer serviceId, String serviceName, BigDecimal estimatedPrice,
        Integer estimatedDuration) {
      this.serviceId = serviceId;
      this.serviceName = serviceName;
      this.estimatedPrice = estimatedPrice;
      this.estimatedDuration = estimatedDuration;
    }

    // Getters and Setters
    public Integer getServiceId() {
      return serviceId;
    }

    public void setServiceId(Integer serviceId) {
      this.serviceId = serviceId;
    }

    public String getServiceName() {
      return serviceName;
    }

    public void setServiceName(String serviceName) {
      this.serviceName = serviceName;
    }

    public Integer getTherapistUserId() {
      return therapistUserId;
    }

    public void setTherapistUserId(Integer therapistUserId) {
      this.therapistUserId = therapistUserId;
    }

    public String getTherapistName() {
      return therapistName;
    }

    public void setTherapistName(String therapistName) {
      this.therapistName = therapistName;
    }

    public BigDecimal getEstimatedPrice() {
      return estimatedPrice;
    }

    public void setEstimatedPrice(BigDecimal estimatedPrice) {
      this.estimatedPrice = estimatedPrice;
    }

    public Integer getEstimatedDuration() {
      return estimatedDuration;
    }

    public void setEstimatedDuration(Integer estimatedDuration) {
      this.estimatedDuration = estimatedDuration;
    }

    public LocalDateTime getScheduledTime() {
      return scheduledTime;
    }

    public void setScheduledTime(LocalDateTime scheduledTime) {
      this.scheduledTime = scheduledTime;
    }

    public Integer getServiceOrder() {
      return serviceOrder;
    }

    public void setServiceOrder(Integer serviceOrder) {
      this.serviceOrder = serviceOrder;
    }
  }
}