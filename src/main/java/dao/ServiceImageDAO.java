/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.ServiceImage;
import db.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author ADMIN
 */
public class ServiceImageDAO {
    public void save(ServiceImage img) {
        String sql = "INSERT INTO service_images (service_id, image_url) VALUES (?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, img.getServiceId());
            stmt.setString(2, img.getImageUrl());
            stmt.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

    public List<ServiceImage> findByServiceId(int serviceId) {
        List<ServiceImage> images = new ArrayList<>();
        String sql = "SELECT id, service_id, image_url FROM service_images WHERE service_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, serviceId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                images.add(new ServiceImage(
                    rs.getInt("id"),
                    rs.getInt("service_id"),
                    rs.getString("image_url")
                ));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return images;
    }

    public void deleteByServiceId(int serviceId) {
        String sql = "DELETE FROM service_images WHERE service_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, serviceId);
            stmt.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

    public void deleteById(int id) {
        String sql = "DELETE FROM service_images WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
}
