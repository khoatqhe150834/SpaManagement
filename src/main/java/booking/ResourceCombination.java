/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package booking;

/**
 *
 * @author quang
 */
// src/main/java/model/ResourceCombination.java

public class ResourceCombination {
    private int therapistId;
    private String therapistName;
    private int roomId;
    private String roomName;
    private Integer bedId;
    private String bedName;
    
    public ResourceCombination(int therapistId, String therapistName, 
                             int roomId, String roomName, 
                             Integer bedId, String bedName) {
        this.therapistId = therapistId;
        this.therapistName = therapistName;
        this.roomId = roomId;
        this.roomName = roomName;
        this.bedId = bedId;
        this.bedName = bedName;
    }
    
    // Getters and setters
    public int getTherapistId() { return therapistId; }
    public void setTherapistId(int therapistId) { this.therapistId = therapistId; }
    public String getTherapistName() { return therapistName; }
    public void setTherapistName(String therapistName) { this.therapistName = therapistName; }
    public int getRoomId() { return roomId; }
    public void setRoomId(int roomId) { this.roomId = roomId; }
    public String getRoomName() { return roomName; }
    public void setRoomName(String roomName) { this.roomName = roomName; }
    public Integer getBedId() { return bedId; }
    public void setBedId(Integer bedId) { this.bedId = bedId; }
    public String getBedName() { return bedName; }
    public void setBedName(String bedName) { this.bedName = bedName; }
    
    @Override
    public String toString() {
        return "ResourceCombination{" +
               "therapist=" + therapistName + "(" + therapistId + "), " +
               "room=" + roomName + "(" + roomId + "), " +
               "bed=" + (bedName != null ? bedName + "(" + bedId + ")" : "none") + "}";
    }
}