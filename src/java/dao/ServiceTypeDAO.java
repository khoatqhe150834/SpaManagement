package dao;

import db.DBContext;
import model.ServiceType;
import java.sql.*;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ServiceTypeDAO {

    public ArrayList<ServiceType> getAll() {
        ArrayList<ServiceType> serviceTypes = new ArrayList<>();
        String sql = "SELECT * FROM Service_Types"; // <-- Tên bảng đúng trong DB

        Connection connection = null;
        PreparedStatement stm = null;
        ResultSet rs = null;

        try {
            connection = DBContext.getConnection();
            stm = connection.prepareStatement(sql);
            rs = stm.executeQuery();

            while (rs.next()) {
                ServiceType serviceType = new ServiceType();

                serviceType.setServiceTypeId(rs.getInt("service_type_id"));
                serviceType.setName(rs.getString("name"));
                serviceType.setDescription(rs.getString("description"));
                serviceType.setImageUrl(rs.getString("image_url"));
                serviceType.setActive(rs.getBoolean("is_active"));
                serviceType.setCreatedAt(rs.getTimestamp("created_at"));
                serviceType.setUpdatedAt(rs.getTimestamp("updated_at"));

                serviceTypes.add(serviceType);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ServiceTypeDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (rs != null) rs.close();
                if (stm != null) stm.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return serviceTypes;
    }
    
    public static void main(String[] args) {
        ServiceTypeDAO serviceTypeDAO = new ServiceTypeDAO();
        
        ArrayList<ServiceType> list = serviceTypeDAO.getAll();
        for (ServiceType c : list) {
            System.out.println(c);
        }
    }
}
