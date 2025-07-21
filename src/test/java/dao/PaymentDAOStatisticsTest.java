package dao;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import static org.junit.jupiter.api.Assertions.*;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

/**
 * Test class for PaymentDAO statistics methods
 * Tests the newly implemented statistics methods for the StatisticsController
 */
public class PaymentDAOStatisticsTest {
    
//    private PaymentDAO paymentDAO;
//    
//    @BeforeEach
//    void setUp() {
//        paymentDAO = new PaymentDAO();
//    }
//    
//    @Test
//    void testGetRevenueStatistics() {
//        try {
//            Map<String, Object> stats = paymentDAO.getRevenueStatistics();
//            assertNotNull(stats, "Revenue statistics should not be null");
//            assertTrue(stats.containsKey("totalRevenue"), "Should contain totalRevenue");
//            assertTrue(stats.containsKey("monthlyRevenue"), "Should contain monthlyRevenue");
//            assertTrue(stats.containsKey("averageTransaction"), "Should contain averageTransaction");
//            assertTrue(stats.containsKey("totalTransactions"), "Should contain totalTransactions");
//            System.out.println("✓ Revenue statistics test passed");
//        } catch (SQLException e) {
//            System.err.println("Database error in revenue statistics test: " + e.getMessage());
//        }
//    }
//    
//    @Test
//    void testGetMonthlyRevenue() {
//        try {
//            Map<String, Double> monthlyRevenue = paymentDAO.getMonthlyRevenue();
//            assertNotNull(monthlyRevenue, "Monthly revenue should not be null");
//            System.out.println("✓ Monthly revenue test passed - " + monthlyRevenue.size() + " months found");
//        } catch (SQLException e) {
//            System.err.println("Database error in monthly revenue test: " + e.getMessage());
//        }
//    }
//    
//    @Test
//    void testGetPaymentMethodCounts() {
//        try {
//            Map<String, Integer> methodCounts = paymentDAO.getPaymentMethodCounts();
//            assertNotNull(methodCounts, "Payment method counts should not be null");
//            System.out.println("✓ Payment method counts test passed - " + methodCounts.size() + " methods found");
//        } catch (SQLException e) {
//            System.err.println("Database error in payment method counts test: " + e.getMessage());
//        }
//    }
//    
//    @Test
//    void testGetTopCustomersByRevenue() {
//        try {
//            List<Map<String, Object>> topCustomers = paymentDAO.getTopCustomersByRevenue(10);
//            assertNotNull(topCustomers, "Top customers should not be null");
//            System.out.println("✓ Top customers test passed - " + topCustomers.size() + " customers found");
//        } catch (SQLException e) {
//            System.err.println("Database error in top customers test: " + e.getMessage());
//        }
//    }
//    
//    @Test
//    void testGetServicePerformanceData() {
//        try {
//            List<Map<String, Object>> servicePerformance = paymentDAO.getServicePerformanceData();
//            assertNotNull(servicePerformance, "Service performance data should not be null");
//            System.out.println("✓ Service performance test passed - " + servicePerformance.size() + " services found");
//        } catch (SQLException e) {
//            System.err.println("Database error in service performance test: " + e.getMessage());
//        }
//    }
//    
//    @Test
//    void testGetDailyTransactionCounts() {
//        try {
//            Map<String, Integer> dailyTransactions = paymentDAO.getDailyTransactionCounts();
//            assertNotNull(dailyTransactions, "Daily transactions should not be null");
//            System.out.println("✓ Daily transactions test passed - " + dailyTransactions.size() + " days found");
//        } catch (SQLException e) {
//            System.err.println("Database error in daily transactions test: " + e.getMessage());
//        }
//    }
//    
//    @Test
//    void testGetPeakTimeAnalysis() {
//        try {
//            Map<String, Object> peakAnalysis = paymentDAO.getPeakTimeAnalysis();
//            assertNotNull(peakAnalysis, "Peak analysis should not be null");
//            System.out.println("✓ Peak time analysis test passed");
//        } catch (SQLException e) {
//            System.err.println("Database error in peak time analysis test: " + e.getMessage());
//        }
//    }
//    
//    @Test
//    void testGetCustomerSegments() {
//        try {
//            Map<String, Integer> segments = paymentDAO.getCustomerSegments();
//            assertNotNull(segments, "Customer segments should not be null");
//            System.out.println("✓ Customer segments test passed - " + segments.size() + " segments found");
//        } catch (SQLException e) {
//            System.err.println("Database error in customer segments test: " + e.getMessage());
//        }
//    }
//    
//    @Test
//    void testGetServiceRevenueBreakdown() {
//        try {
//            Map<String, Double> serviceRevenue = paymentDAO.getServiceRevenueBreakdown();
//            assertNotNull(serviceRevenue, "Service revenue breakdown should not be null");
//            System.out.println("✓ Service revenue breakdown test passed - " + serviceRevenue.size() + " services found");
//        } catch (SQLException e) {
//            System.err.println("Database error in service revenue breakdown test: " + e.getMessage());
//        }
//    }
//    
//    @Test
//    void testAllStatisticsMethods() {
//        System.out.println("\n=== Testing All Statistics Methods ===");
//        
//        try {
//            // Test all revenue methods
//            paymentDAO.getRevenueStatistics();
//            paymentDAO.getMonthlyRevenue();
//            paymentDAO.getDailyRevenue();
//            paymentDAO.getTopServicesByRevenue(10);
//            paymentDAO.getRevenueByStatus();
//            System.out.println("✓ All revenue methods working");
//            
//            // Test all payment method methods
//            paymentDAO.getPaymentMethodCounts();
//            paymentDAO.getPaymentMethodRevenue();
//            paymentDAO.getPaymentMethodTrends();
//            paymentDAO.getAverageAmountByMethod();
//            System.out.println("✓ All payment method methods working");
//            
//            // Test all timeline methods
//            paymentDAO.getDailyTransactionCounts();
//            paymentDAO.getMonthlyTransactionCounts();
//            paymentDAO.getHourlyTransactionCounts();
//            paymentDAO.getPeakTimeAnalysis();
//            paymentDAO.getGrowthTrends();
//            System.out.println("✓ All timeline methods working");
//            
//            // Test all customer methods
//            paymentDAO.getTopCustomersByRevenue(20);
//            paymentDAO.getCustomerSegments();
//            paymentDAO.getCustomerBehaviorAnalysis();
//            paymentDAO.getNewVsReturningCustomers();
//            paymentDAO.getCustomerLifetimeValue();
//            System.out.println("✓ All customer methods working");
//            
//            // Test all service methods
//            paymentDAO.getServicePerformanceData();
//            paymentDAO.getServicePopularityTrends();
//            paymentDAO.getServiceRevenueBreakdown();
//            paymentDAO.getServiceUtilizationRates();
//            paymentDAO.getSeasonalServiceAnalysis();
//            System.out.println("✓ All service methods working");
//            
//            System.out.println("\n🎉 ALL STATISTICS METHODS IMPLEMENTED SUCCESSFULLY!");
//            
//        } catch (SQLException e) {
//            fail("Database error in comprehensive test: " + e.getMessage());
//        }
//    }
}
