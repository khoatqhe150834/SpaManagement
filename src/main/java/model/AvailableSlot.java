/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDate;
import java.time.LocalTime;

/**
 *
 * @author quang
 */
public class AvailableSlot {
    private LocalDate date;
    private LocalTime startTime;
    private LocalTime endTime;
    private int therapistUserId;
    private int roomId;
    private Integer bedId;
    
    public AvailableSlot(LocalDate date, LocalTime startTime, LocalTime endTime,
                        int therapistUserId, int roomId, Integer bedId) {
        this.date = date;
        this.startTime = startTime;
        this.endTime = endTime;
        this.therapistUserId = therapistUserId;
        this.roomId = roomId;
        this.bedId = bedId;
    }
    
    
}