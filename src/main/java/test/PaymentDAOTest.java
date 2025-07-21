package test;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import dao.PaymentDAO;
import model.Payment;

/**
 * Simple test class to debug PaymentDAO issues
 */
public class PaymentDAOTest {
    
    private static final Logger LOGGER = Logger.getLogger(PaymentDAOTest.class.getName());
    
    public static void main(String[] args) {
        // Initialize DataSource first
        try {
            db.DataSource.initialize();
            System.out.println("DataSource initialized successfully");
        } catch (Exception e) {
            System.err.println("Failed to initialize DataSource: " + e.getMessage());
            e.printStackTrace();
            return;
        }

        // Test basic database connectivity
        try (Connection conn = db.DataSource.getConnection()) {
            System.out.println("Database connection successful!");

            // Test if payments table exists and has data
            String countSql = "SELECT COUNT(*) as count FROM payments";
            try (PreparedStatement stmt = conn.prepareStatement(countSql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int count = rs.getInt("count");
                    System.out.println("Total payments in database: " + count);
                }
            }

            // Test if customers table exists and has data
            String customerCountSql = "SELECT COUNT(*) as count FROM customers";
            try (PreparedStatement stmt = conn.prepareStatement(customerCountSql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int count = rs.getInt("count");
                    System.out.println("Total customers in database: " + count);
                }
            }

        } catch (SQLException e) {
            System.err.println("Database connection failed: " + e.getMessage());
            e.printStackTrace();
            return;
        }

        PaymentDAO paymentDAO = new PaymentDAO();

        try {
            // Test 1: Get all payments using findAll
            System.out.println("=== Test 1: findAll ===");
            List<Payment> allPayments = paymentDAO.findAll(1, 10);
            System.out.println("Found " + allPayments.size() + " payments using findAll");
            
            for (Payment payment : allPayments) {
                System.out.println("Payment ID: " + payment.getPaymentId() + 
                                 ", Customer ID: " + payment.getCustomerId() +
                                 ", Amount: " + payment.getTotalAmount() +
                                 ", Status: " + payment.getPaymentStatus());
                if (payment.getCustomer() != null) {
                    System.out.println("  Customer: " + payment.getCustomer().getFullName());
                } else {
                    System.out.println("  Customer: NULL");
                }
            }
            
            // Test 2: Get all payments using findAllPaymentsSimple
            System.out.println("\n=== Test 2: findAllPaymentsSimple ===");
            List<Payment> simplePayments = paymentDAO.findAllPaymentsSimple();
            System.out.println("Found " + simplePayments.size() + " payments using findAllPaymentsSimple");
            
            for (Payment payment : simplePayments) {
                System.out.println("Payment ID: " + payment.getPaymentId() + 
                                 ", Customer ID: " + payment.getCustomerId() +
                                 ", Amount: " + payment.getTotalAmount() +
                                 ", Status: " + payment.getPaymentStatus());
                if (payment.getCustomer() != null) {
                    System.out.println("  Customer: " + payment.getCustomer().getFullName() + 
                                     ", Email: " + payment.getCustomer().getEmail() +
                                     ", Phone: " + payment.getCustomer().getPhoneNumber());
                } else {
                    System.out.println("  Customer: NULL");
                }
            }
            
            // Test 3: Get all payments using findAllWithFilters
            System.out.println("\n=== Test 3: findAllWithFilters ===");
            List<Payment> filteredPayments = paymentDAO.findAllWithFilters(
                1, 10, null, null, null, null, null, null);
            System.out.println("Found " + filteredPayments.size() + " payments using findAllWithFilters");
            
            for (Payment payment : filteredPayments) {
                System.out.println("Payment ID: " + payment.getPaymentId() + 
                                 ", Customer ID: " + payment.getCustomerId() +
                                 ", Amount: " + payment.getTotalAmount() +
                                 ", Status: " + payment.getPaymentStatus());
                if (payment.getCustomer() != null) {
                    System.out.println("  Customer: " + payment.getCustomer().getFullName() + 
                                     ", Email: " + payment.getCustomer().getEmail() +
                                     ", Phone: " + payment.getCustomer().getPhoneNumber());
                } else {
                    System.out.println("  Customer: NULL");
                }
            }
            
            // Test 4: Count all payments
            System.out.println("\n=== Test 4: countAllWithFilters ===");
            int totalCount = paymentDAO.countAllWithFilters(null, null, null, null, null, null);
            System.out.println("Total payment count: " + totalCount);
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Database error during testing", ex);
            ex.printStackTrace();
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Unexpected error during testing", ex);
            ex.printStackTrace();
        }
    }
}
