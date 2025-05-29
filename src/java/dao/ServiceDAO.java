package dao;

import db.DBContext;
import model.Service;
import java.sql.*;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.ServiceType;

public class ServiceDAO {

    public ArrayList<Service> getAll() {
        ArrayList<Service> services = new ArrayList<>();
        String sql = "SELECT * FROM Services";
        Connection connection = null;
        PreparedStatement stm = null;
        ResultSet rs = null;

        try {
            connection = DBContext.getConnection();
            stm = connection.prepareStatement(sql);
            rs = stm.executeQuery();

            while (rs.next()) {
                int serviceId = rs.getInt("serviceId");
                ServiceType serviceTypeId = 
            }
        } catch (SQLException ex) {
            Logger.getLogger(ServiceDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            // Đóng tài nguyên
            try {
                if (rs != null) rs.close();
                if (stm != null) stm.close();
                // KHÔNG đóng connection ở đây nếu dùng connection pool hoặc cần giữ mở
                // DBContext.closeConnection(); // gọi nếu muốn đóng
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return services;
    }
}
