/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package booking;

/**
 *
 * @author quang
 */
public class ServiceInfo {
    private int serviceId;
    private String name;
    private int durationMinutes;
    private int bufferTimeAfterMinutes; // Add buffer time
    private int serviceTypeId;
    private boolean isActive;
    
    public ServiceInfo(int serviceId, String name, int durationMinutes, 
                      int bufferTimeAfterMinutes, int serviceTypeId, boolean isActive) {
        this.serviceId = serviceId;
        this.name = name;
        this.durationMinutes = durationMinutes;
        this.bufferTimeAfterMinutes = bufferTimeAfterMinutes;
        this.serviceTypeId = serviceTypeId;
        this.isActive = isActive;
    }

   
    
    // Getters and setters
    public int getServiceId() { return serviceId; }
    public void setServiceId(int serviceId) { this.serviceId = serviceId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public int getDurationMinutes() { return durationMinutes; }
    public void setDurationMinutes(int durationMinutes) { this.durationMinutes = durationMinutes; }
    public int getBufferTimeAfterMinutes() { return bufferTimeAfterMinutes; }
    public void setBufferTimeAfterMinutes(int bufferTimeAfterMinutes) { this.bufferTimeAfterMinutes = bufferTimeAfterMinutes; }
    public int getServiceTypeId() { return serviceTypeId; }
    public void setServiceTypeId(int serviceTypeId) { this.serviceTypeId = serviceTypeId; }
    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
    
    /**
     * Get total time including service duration and buffer
     */
    public int getTotalTimeMinutes() {
        return durationMinutes + bufferTimeAfterMinutes;
    }
    
    @Override
    public String toString() {
        return "ServiceInfo{serviceId=" + serviceId + ", name='" + name + 
               "', durationMinutes=" + durationMinutes + ", bufferTimeAfterMinutes=" + bufferTimeAfterMinutes +
               ", serviceTypeId=" + serviceTypeId + ", isActive=" + isActive + 
               ", totalTime=" + getTotalTimeMinutes() + "}";
    }
}