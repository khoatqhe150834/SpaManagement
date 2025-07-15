package dao;

import model.Certificate;
import java.sql.*;
import java.util.*;

public class CertificateDAO extends BaseDAO {

    public List<Certificate> getCertificatesByStaffId(int staffUserId) {
        List<Certificate> list = new ArrayList<>();
        String sql = "SELECT * FROM certificates WHERE staff_user_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, staffUserId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Certificate c = new Certificate();
                c.setCertificateId(rs.getInt("certificate_id"));
                c.setStaffUserId(rs.getInt("staff_user_id"));
                c.setCertificateName(rs.getString("certificate_name"));
                c.setCertificateNumber(rs.getString("certificate_number"));
                c.setIssuedDate(rs.getDate("issued_date"));
                c.setExpiryDate(rs.getDate("expiry_date"));
                c.setFileUrl(rs.getString("file_url"));
                c.setNote(rs.getString("note"));
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Certificate getCertificateById(int certificateId) {
        String sql = "SELECT * FROM certificates WHERE certificate_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, certificateId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Certificate c = new Certificate();
                c.setCertificateId(rs.getInt("certificate_id"));
                c.setStaffUserId(rs.getInt("staff_user_id"));
                c.setCertificateName(rs.getString("certificate_name"));
                c.setCertificateNumber(rs.getString("certificate_number"));
                c.setIssuedDate(rs.getDate("issued_date"));
                c.setExpiryDate(rs.getDate("expiry_date"));
                c.setFileUrl(rs.getString("file_url"));
                c.setNote(rs.getString("note"));
                return c;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addCertificate(Certificate c) {
        String sql = "INSERT INTO certificates (staff_user_id, certificate_name, certificate_number, issued_date, expiry_date, file_url, note) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, c.getStaffUserId());
            ps.setString(2, c.getCertificateName());
            ps.setString(3, c.getCertificateNumber());
            ps.setDate(4, new java.sql.Date(c.getIssuedDate().getTime()));
            if (c.getExpiryDate() != null) {
                ps.setDate(5, new java.sql.Date(c.getExpiryDate().getTime()));
            } else {
                ps.setNull(5, Types.DATE);
            }
            ps.setString(6, c.getFileUrl());
            ps.setString(7, c.getNote());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateCertificate(Certificate c) {
        String sql = "UPDATE certificates SET certificate_name=?, certificate_number=?, issued_date=?, expiry_date=?, file_url=?, note=? WHERE certificate_id=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getCertificateName());
            ps.setString(2, c.getCertificateNumber());
            ps.setDate(3, new java.sql.Date(c.getIssuedDate().getTime()));
            if (c.getExpiryDate() != null) {
                ps.setDate(4, new java.sql.Date(c.getExpiryDate().getTime()));
            } else {
                ps.setNull(4, Types.DATE);
            }
            ps.setString(5, c.getFileUrl());
            ps.setString(6, c.getNote());
            ps.setInt(7, c.getCertificateId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteCertificate(int certificateId) {
        String sql = "DELETE FROM certificates WHERE certificate_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, certificateId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
} 