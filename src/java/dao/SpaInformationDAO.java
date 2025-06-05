package dao;

import db.DBContext;
import model.SpaInformation;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SpaInformationDAO {

    // Create a new spa information record
    public boolean create(SpaInformation spa) throws SQLException {
        String sql = "INSERT INTO spa_information (name, address_line1, address_line2, city, postal_code, country, phone_number_main, phone_number_secondary, email_main, email_secondary, website_url, logo_url, tax_identification_number, cancellation_policy, booking_terms, about_us_short, about_us_long, vat_percentage, default_appointment_buffer_minutes) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, spa.getName());
            stmt.setString(2, spa.getAddressLine1());
            stmt.setString(3, spa.getAddressLine2());
            stmt.setString(4, spa.getCity());
            stmt.setString(5, spa.getPostalCode());
            stmt.setString(6, spa.getCountry());
            stmt.setString(7, spa.getPhoneNumberMain());
            stmt.setString(8, spa.getPhoneNumberSecondary());
            stmt.setString(9, spa.getEmailMain());
            stmt.setString(10, spa.getEmailSecondary());
            stmt.setString(11, spa.getWebsiteUrl());
            stmt.setString(12, spa.getLogoUrl());
            stmt.setString(13, spa.getTaxIdentificationNumber());
            stmt.setString(14, spa.getCancellationPolicy());
            stmt.setString(15, spa.getBookingTerms());
            stmt.setString(16, spa.getAboutUsShort());
            stmt.setString(17, spa.getAboutUsLong());
            stmt.setBigDecimal(18, spa.getVatPercentage());
            stmt.setInt(19, spa.getDefaultAppointmentBufferMinutes());
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        spa.setSpaId(rs.getInt(1));
                        return true;
                    }
                }
            }
            return false;
        }
    }

    // Read a spa information record by ID
    public SpaInformation read(int spaId) throws SQLException {
        String sql = "SELECT * FROM spa_information WHERE spa_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, spaId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToSpaInformation(rs);
                }
            }
        }
        return null;
    }

    // Update an existing spa information record
    public boolean update(SpaInformation spa) throws SQLException {
        String sql = "UPDATE spa_information SET name = ?, address_line1 = ?, address_line2 = ?, city = ?, postal_code = ?, country = ?, phone_number_main = ?, phone_number_secondary = ?, email_main = ?, email_secondary = ?, website_url = ?, logo_url = ?, tax_identification_number = ?, cancellation_policy = ?, booking_terms = ?, about_us_short = ?, about_us_long = ?, vat_percentage = ?, default_appointment_buffer_minutes = ? WHERE spa_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, spa.getName());
            stmt.setString(2, spa.getAddressLine1());
            stmt.setString(3, spa.getAddressLine2());
            stmt.setString(4, spa.getCity());
            stmt.setString(5, spa.getPostalCode());
            stmt.setString(6, spa.getCountry());
            stmt.setString(7, spa.getPhoneNumberMain());
            stmt.setString(8, spa.getPhoneNumberSecondary());
            stmt.setString(9, spa.getEmailMain());
            stmt.setString(10, spa.getEmailSecondary());
            stmt.setString(11, spa.getWebsiteUrl());
            stmt.setString(12, spa.getLogoUrl());
            stmt.setString(13, spa.getTaxIdentificationNumber());
            stmt.setString(14, spa.getCancellationPolicy());
            stmt.setString(15, spa.getBookingTerms());
            stmt.setString(16, spa.getAboutUsShort());
            stmt.setString(17, spa.getAboutUsLong());
            stmt.setBigDecimal(18, spa.getVatPercentage());
            stmt.setInt(19, spa.getDefaultAppointmentBufferMinutes());
            stmt.setInt(20, spa.getSpaId());
            return stmt.executeUpdate() > 0;
        }
    }

    // Delete a spa information record by ID
    public boolean delete(int spaId) throws SQLException {
        String sql = "DELETE FROM spa_information WHERE spa_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, spaId);
            return stmt.executeUpdate() > 0;
        }
    }

    // List all spa information records
    public List<SpaInformation> listAll() throws SQLException {
        List<SpaInformation> spas = new ArrayList<>();
        String sql = "SELECT * FROM spa_information";
        try (Connection conn = DBContext.getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                spas.add(mapResultSetToSpaInformation(rs));
            }
        }
        return spas;
    }

    // Helper method to map ResultSet to SpaInformation object
    private SpaInformation mapResultSetToSpaInformation(ResultSet rs) throws SQLException {
        SpaInformation spa = new SpaInformation();
        spa.setSpaId(rs.getInt("spa_id"));
        spa.setName(rs.getString("name"));
        spa.setAddressLine1(rs.getString("address_line1"));
        spa.setAddressLine2(rs.getString("address_line2"));
        spa.setCity(rs.getString("city"));
        spa.setPostalCode(rs.getString("postal_code"));
        spa.setCountry(rs.getString("country"));
        spa.setPhoneNumberMain(rs.getString("phone_number_main"));
        spa.setPhoneNumberSecondary(rs.getString("phone_number_secondary"));
        spa.setEmailMain(rs.getString("email_main"));
        spa.setEmailSecondary(rs.getString("email_secondary"));
        spa.setWebsiteUrl(rs.getString("website_url"));
        spa.setLogoUrl(rs.getString("logo_url"));
        spa.setTaxIdentificationNumber(rs.getString("tax_identification_number"));
        spa.setCancellationPolicy(rs.getString("cancellation_policy"));
        spa.setBookingTerms(rs.getString("booking_terms"));
        spa.setAboutUsShort(rs.getString("about_us_short"));
        spa.setAboutUsLong(rs.getString("about_us_long"));
        spa.setVatPercentage(rs.getBigDecimal("vat_percentage"));
        spa.setDefaultAppointmentBufferMinutes(rs.getInt("default_appointment_buffer_minutes"));
        spa.setCreatedAt(rs.getTimestamp("created_at"));
        spa.setUpdatedAt(rs.getTimestamp("updated_at"));
        return spa;
    }
}
