package model;

import java.sql.Timestamp;
import java.util.List;
import lombok.ToString;

/**
 * Room model class representing physical rooms in the spa
 * Corresponds to the rooms table in the database
 * 
 * @author SpaManagement
 */
@ToString
public class Room {
    private Integer roomId;
    private String name;
    private String description;
    private Integer capacity;
    private Boolean isActive;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Related entities (for joins)
    private List<Bed> beds;
    
    // Constructors
    public Room() {
        this.isActive = true;
        this.capacity = 1;
        this.createdAt = new Timestamp(System.currentTimeMillis());
        this.updatedAt = new Timestamp(System.currentTimeMillis());
    }
    
    public Room(String name, String description, Integer capacity) {
        this();
        this.name = name;
        this.description = description;
        this.capacity = capacity;
    }
    
    public Room(Integer roomId, String name, String description, Integer capacity, Boolean isActive, 
                Timestamp createdAt, Timestamp updatedAt) {
        this.roomId = roomId;
        this.name = name;
        this.description = description;
        this.capacity = capacity;
        this.isActive = isActive;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }
    
    // Getters and Setters
    public Integer getRoomId() {
        return roomId;
    }
    
    public void setRoomId(Integer roomId) {
        this.roomId = roomId;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public Integer getCapacity() {
        return capacity;
    }
    
    public void setCapacity(Integer capacity) {
        this.capacity = capacity;
    }
    
    public Boolean getIsActive() {
        return isActive;
    }
    
    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public Timestamp getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    public List<Bed> getBeds() {
        return beds;
    }
    
    public void setBeds(List<Bed> beds) {
        this.beds = beds;
    }
    
    // Utility methods
    public String getStatus() {
        return isActive ? "Hoạt động" : "Bảo trì";
    }
    
    public String getStatusClass() {
        return isActive ? "status-active" : "status-inactive";
    }
    
    public int getBedCount() {
        return beds != null ? beds.size() : 0;
    }
    
    /**
     * Updates the updatedAt timestamp to current time
     */
    public void updateTimestamp() {
        this.updatedAt = new Timestamp(System.currentTimeMillis());
    }
    
    /**
     * Checks if the room is available for booking
     * @return true if room is active and has capacity
     */
    public boolean isAvailable() {
        return isActive && capacity > 0;
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        Room room = (Room) obj;
        return roomId != null && roomId.equals(room.roomId);
    }
    
    @Override
    public int hashCode() {
        return roomId != null ? roomId.hashCode() : 0;
    }
}
