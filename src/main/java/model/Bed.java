package model;

import java.sql.Timestamp;
import lombok.ToString;

/**
 * Bed model class representing beds within rooms in the spa
 * Corresponds to the beds table in the database
 * 
 * @author SpaManagement
 */
@ToString
public class Bed {
    private Integer bedId;
    private Integer roomId;
    private String name;
    private String description;
    private Boolean isActive;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Related entities (for joins)
    private Room room;
    
    // Constructors
    public Bed() {
        this.isActive = true;
        this.createdAt = new Timestamp(System.currentTimeMillis());
        this.updatedAt = new Timestamp(System.currentTimeMillis());
    }
    
    public Bed(Integer roomId, String name, String description) {
        this();
        this.roomId = roomId;
        this.name = name;
        this.description = description;
    }
    
    public Bed(Integer bedId, Integer roomId, String name, String description, Boolean isActive, 
               Timestamp createdAt, Timestamp updatedAt) {
        this.bedId = bedId;
        this.roomId = roomId;
        this.name = name;
        this.description = description;
        this.isActive = isActive;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }
    
    // Getters and Setters
    public Integer getBedId() {
        return bedId;
    }
    
    public void setBedId(Integer bedId) {
        this.bedId = bedId;
    }
    
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
    
    public Room getRoom() {
        return room;
    }
    
    public void setRoom(Room room) {
        this.room = room;
        if (room != null) {
            this.roomId = room.getRoomId();
        }
    }
    
    // Utility methods
    public String getStatus() {
        return isActive ? "Hoạt động" : "Bảo trì";
    }
    
    public String getStatusClass() {
        return isActive ? "status-active" : "status-inactive";
    }
    
    public String getRoomName() {
        return room != null ? room.getName() : "Unknown Room";
    }
    
    /**
     * Updates the updatedAt timestamp to current time
     */
    public void updateTimestamp() {
        this.updatedAt = new Timestamp(System.currentTimeMillis());
    }
    
    /**
     * Checks if the bed is available for booking
     * @return true if bed is active
     */
    public boolean isAvailable() {
        return isActive;
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        Bed bed = (Bed) obj;
        return bedId != null && bedId.equals(bed.bedId);
    }
    
    @Override
    public int hashCode() {
        return bedId != null ? bedId.hashCode() : 0;
    }
}
