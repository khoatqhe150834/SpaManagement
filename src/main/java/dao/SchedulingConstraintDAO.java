/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author quang
 */
// src/main/java/dao/SchedulingConstraintDAO.java

import booking.*;
import db.DBContext;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;


public class SchedulingConstraintDAO {
    private static final Logger LOGGER = Logger.getLogger(SchedulingConstraintDAO.class.getName());
    
    /**
     * Load all existing bookings for a specific date that could conflict with new bookings
     */
    public List<BookingConstraint> loadExistingBookings(LocalDate targetDate) throws SQLException {
        List<BookingConstraint> bookings = new ArrayList<>();
        
        String query = """
            SELECT b.therapist_user_id, b.room_id, b.bed_id,
                   b.appointment_date, b.appointment_time, b.duration_minutes,
                   b.booking_status
            FROM bookings b 
            WHERE b.appointment_date = ? 
            AND b.booking_status IN ('SCHEDULED', 'CONFIRMED', 'IN_PROGRESS')
            ORDER BY b.appointment_time
            """;
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setDate(1, Date.valueOf(targetDate));
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    LocalDate appointmentDate = rs.getDate("appointment_date").toLocalDate();
                    LocalTime appointmentTime = rs.getTime("appointment_time").toLocalTime();
                    LocalDateTime startDateTime = LocalDateTime.of(appointmentDate, appointmentTime);
                    LocalDateTime endDateTime = startDateTime.plusMinutes(rs.getInt("duration_minutes"));
                    
                    BookingConstraint constraint = new BookingConstraint(
                        rs.getInt("therapist_user_id"),
                        rs.getInt("room_id"),
                        rs.getObject("bed_id", Integer.class),
                        startDateTime,
                        endDateTime,
                        rs.getString("booking_status")
                    );
                    
                    bookings.add(constraint);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error loading existing bookings for date: " + targetDate, e);
            throw e;
        }
        
        LOGGER.info("Loaded " + bookings.size() + " existing bookings for date: " + targetDate);
        return bookings;
    }
    
    /**
     * Load all active therapists grouped by their service type
     */
    public Map<Integer, List<TherapistInfo>> loadTherapistsByServiceType() throws SQLException {
        Map<Integer, List<TherapistInfo>> therapistsByServiceType = new HashMap<>();
        
        String query = """
            SELECT t.user_id, t.service_type_id, u.full_name, t.availability_status
            FROM therapists t
            JOIN users u ON t.user_id = u.user_id
            WHERE u.is_active = 1 AND t.availability_status = 'AVAILABLE'
            ORDER BY t.service_type_id, u.full_name
            """;
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                TherapistInfo therapist = new TherapistInfo(
                    rs.getInt("user_id"),
                    rs.getString("full_name"),
                    rs.getInt("service_type_id"),
                    rs.getString("availability_status")
                );
                
                int serviceTypeId = therapist.getServiceTypeId();
                therapistsByServiceType.computeIfAbsent(serviceTypeId, k -> new ArrayList<>()).add(therapist);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error loading therapists by service type", e);
            throw e;
        }
        
        LOGGER.info("Loaded therapists for " + therapistsByServiceType.size() + " service types");
        return therapistsByServiceType;
    }
    
    /**
     * Load all active rooms and their beds
     */
    public List<RoomBedInfo> loadRoomsAndBeds() throws SQLException {
        List<RoomBedInfo> roomBeds = new ArrayList<>();
        
        String query = """
            SELECT r.room_id, r.name as room_name, r.capacity,
                   b.bed_id, b.name as bed_name
            FROM rooms r
            LEFT JOIN beds b ON r.room_id = b.room_id AND b.is_active = 1
            WHERE r.is_active = 1
            ORDER BY r.room_id, b.bed_id
            """;
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                RoomBedInfo roomBed = new RoomBedInfo(
                    rs.getInt("room_id"),
                    rs.getString("room_name"),
                    rs.getInt("capacity"),
                    rs.getObject("bed_id", Integer.class),
                    rs.getString("bed_name")
                );
                
                roomBeds.add(roomBed);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error loading rooms and beds", e);
            throw e;
        }
        
        LOGGER.info("Loaded " + roomBeds.size() + " room-bed combinations");
        return roomBeds;
    }
    
    /**
     * Get service information by service ID
     */
    public ServiceInfo getServiceInfo(int serviceId) throws SQLException {
        String query = """
            SELECT s.service_id, s.name, s.duration_minutes, 
                   COALESCE(s.buffer_time_after_minutes, si.default_appointment_buffer_minutes, 15) as buffer_time,
                   s.service_type_id, s.is_active
            FROM services s
            CROSS JOIN spa_information si
            WHERE s.service_id = ? AND s.is_active = 1
            """;
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, serviceId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    // Make sure we're calling the constructor with 6 parameters in the right order:
                    // serviceId, name, durationMinutes, bufferTimeAfterMinutes, serviceTypeId, isActive
                    return new ServiceInfo(
                        rs.getInt("service_id"),        // serviceId (int)
                        rs.getString("name"),           // name (String)
                        rs.getInt("duration_minutes"),  // durationMinutes (int)
                        rs.getInt("buffer_time"),       // bufferTimeAfterMinutes (int)
                        rs.getInt("service_type_id"),   // serviceTypeId (int)
                        rs.getBoolean("is_active")      // isActive (boolean)
                    );
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error loading service info for ID: " + serviceId, e);
            throw e;
        }
        
        return null; // Service not found
    }
    
    /**
     * Get business hours for a specific day of week
     */
    
    
    /**
     * Get qualified therapists for a specific service
     */
    public List<TherapistInfo> getQualifiedTherapists(int serviceId) throws SQLException {
        String query = """
            SELECT t.user_id, u.full_name, t.service_type_id, t.availability_status
            FROM services s
            JOIN therapists t ON s.service_type_id = t.service_type_id
            JOIN users u ON t.user_id = u.user_id
            WHERE s.service_id = ? AND s.is_active = 1 
            AND u.is_active = 1 AND t.availability_status = 'AVAILABLE'
            ORDER BY u.full_name
            """;
        
        List<TherapistInfo> qualifiedTherapists = new ArrayList<>();
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, serviceId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    TherapistInfo therapist = new TherapistInfo(
                        rs.getInt("user_id"),
                        rs.getString("full_name"),
                        rs.getInt("service_type_id"),
                        rs.getString("availability_status")
                    );
                    qualifiedTherapists.add(therapist);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error loading qualified therapists for service ID: " + serviceId, e);
            throw e;
        }
        
        LOGGER.info("Found " + qualifiedTherapists.size() + " qualified therapists for service ID: " + serviceId);
        return qualifiedTherapists;
    }
}