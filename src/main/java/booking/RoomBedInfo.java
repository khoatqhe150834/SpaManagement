/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package booking;

/**
 *
 * @author quang
 */
// src/main/java/model/RoomBedInfo.java

public class RoomBedInfo {
    private int roomId;
    private String roomName;
    private int capacity;
    private Integer bedId; // Can be null
    private String bedName;
    
    public RoomBedInfo(int roomId, String roomName, int capacity, Integer bedId, String bedName) {
        this.roomId = roomId;
        this.roomName = roomName;
        this.capacity = capacity;
        this.bedId = bedId;
        this.bedName = bedName;
    }
    
    // Getters and setters
    public int getRoomId() { return roomId; }
    public void setRoomId(int roomId) { this.roomId = roomId; }
    public String getRoomName() { return roomName; }
    public void setRoomName(String roomName) { this.roomName = roomName; }
    public int getCapacity() { return capacity; }
    public void setCapacity(int capacity) { this.capacity = capacity; }
    public Integer getBedId() { return bedId; }
    public void setBedId(Integer bedId) { this.bedId = bedId; }
    public String getBedName() { return bedName; }
    public void setBedName(String bedName) { this.bedName = bedName; }
    
    @Override
    public String toString() {
        return "RoomBedInfo{roomId=" + roomId + ", roomName='" + roomName + 
               "', capacity=" + capacity + ", bedId=" + bedId + ", bedName='" + bedName + "'}";
    }
}
