package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import dao.PaymentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * StatisticsController handles detailed payment statistics and reports
 * for the spa management system
 */
@WebServlet({
        "/manager/payment-statistics/revenue",
        "/manager/payment-statistics/methods",
        "/manager/payment-statistics/timeline",
        "/manager/payment-statistics/customers",
        "/manager/payment-statistics/services"
})
public class StatisticsController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(StatisticsController.class.getName());
    private final PaymentDAO paymentDAO;

    public StatisticsController() {
        this.paymentDAO = new PaymentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String servletPath = request.getServletPath();

        try {
            switch (servletPath) {
                case "/manager/payment-statistics/revenue":
                    handleRevenueStatistics(request, response);
                    break;
                case "/manager/payment-statistics/methods":
                    handlePaymentMethodsStatistics(request, response);
                    break;
                case "/manager/payment-statistics/timeline":
                    handleTimelineStatistics(request, response);
                    break;
                case "/manager/payment-statistics/customers":
                    handleCustomerStatistics(request, response);
                    break;
                case "/manager/payment-statistics/services":
                    handleServiceStatistics(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in statistics controller", e);
            request.setAttribute("errorMessage", "Lỗi hệ thống. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/WEB-INF/view/error.jsp").forward(request, response);
        }
    }

    /**
     * Handle revenue overview statistics
     */
    private void handleRevenueStatistics(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        

        // Get revenue data
        Map<String, Object> revenueData = paymentDAO.getRevenueStatistics();

        // Calculate revenue trends
        Map<String, Double> monthlyRevenue = paymentDAO.getMonthlyRevenue();
        Map<String, Double> dailyRevenue = paymentDAO.getDailyRevenue();

        // Get top performing services by revenue
        List<Map<String, Object>> topServices = paymentDAO.getTopServicesByRevenue(10);

        // Revenue by payment status
        Map<String, Double> revenueByStatus = paymentDAO.getRevenueByStatus();

        // Set attributes for JSP
        request.setAttribute("revenueData", revenueData);
        request.setAttribute("monthlyRevenue", monthlyRevenue);
        request.setAttribute("dailyRevenue", dailyRevenue);
        request.setAttribute("topServices", topServices);
        request.setAttribute("revenueByStatus", revenueByStatus);

        request.getRequestDispatcher("/WEB-INF/view/manager/statistics/revenue-statistics.jsp").forward(request,
                response);
    }

    /**
     * Handle payment methods analysis
     */
    private void handlePaymentMethodsStatistics(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        

        // Get payment method statistics
        Map<String, Integer> paymentMethodCounts = paymentDAO.getPaymentMethodCounts();
        Map<String, Double> paymentMethodRevenue = paymentDAO.getPaymentMethodRevenue();

        // Payment method trends over time
        Map<String, Map<String, Integer>> methodTrends = paymentDAO.getPaymentMethodTrends();

        // Average transaction amount by method
        Map<String, Double> avgAmountByMethod = paymentDAO.getAverageAmountByMethod();

        // Set attributes for JSP
        request.setAttribute("paymentMethodCounts", paymentMethodCounts);
        request.setAttribute("paymentMethodRevenue", paymentMethodRevenue);
        request.setAttribute("methodTrends", methodTrends);
        request.setAttribute("avgAmountByMethod", avgAmountByMethod);

        request.getRequestDispatcher("/WEB-INF/view/manager/statistics/methods-statistics.jsp").forward(request,
                response);
    }

    /**
     * Handle timeline-based statistics
     */
    private void handleTimelineStatistics(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        // Get timeline data
        Map<String, Integer> dailyTransactions = paymentDAO.getDailyTransactionCounts();
        Map<String, Integer> monthlyTransactions = paymentDAO.getMonthlyTransactionCounts();
        Map<String, Integer> hourlyTransactions = paymentDAO.getHourlyTransactionCounts();

        // Peak hours and days
        Map<String, Object> peakAnalysis = paymentDAO.getPeakTimeAnalysis();

        // Growth trends
        Map<String, Double> growthTrends = paymentDAO.getGrowthTrends();

        // Set attributes for JSP
        request.setAttribute("dailyTransactions", dailyTransactions);
        request.setAttribute("monthlyTransactions", monthlyTransactions);
        request.setAttribute("hourlyTransactions", hourlyTransactions);
        request.setAttribute("peakAnalysis", peakAnalysis);
        request.setAttribute("growthTrends", growthTrends);

        request.getRequestDispatcher("/WEB-INF/view/manager/statistics/timeline-statistics.jsp").forward(request,
                response);
    }

    /**
     * Handle customer statistics and reports
     */
    private void handleCustomerStatistics(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        // Get customer statistics
        List<Map<String, Object>> topCustomers = paymentDAO.getTopCustomersByRevenue(20);
        Map<String, Integer> customerSegments = paymentDAO.getCustomerSegments();

        // Customer behavior analysis
        Map<String, Object> customerBehavior = paymentDAO.getCustomerBehaviorAnalysis();

        // New vs returning customers
        Map<String, Integer> customerTypes = paymentDAO.getNewVsReturningCustomers();

        // Customer lifetime value
        List<Map<String, Object>> customerLTV = paymentDAO.getCustomerLifetimeValue();

        // Set attributes for JSP
        request.setAttribute("topCustomers", topCustomers);
        request.setAttribute("customerSegments", customerSegments);
        request.setAttribute("customerBehavior", customerBehavior);
        request.setAttribute("customerTypes", customerTypes);
        request.setAttribute("customerLTV", customerLTV);

        request.getRequestDispatcher("/WEB-INF/view/manager/statistics/customers-statistics.jsp").forward(request,
                response);
    }

    /**
     * Handle service revenue statistics
     */
    private void handleServiceStatistics(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {

        // Get service performance data
        List<Map<String, Object>> servicePerformance = paymentDAO.getServicePerformanceData();

        // Service popularity trends
        Map<String, Map<String, Integer>> serviceTrends = paymentDAO.getServicePopularityTrends();

        // Service revenue breakdown
        Map<String, Double> serviceRevenue = paymentDAO.getServiceRevenueBreakdown();

        // Service utilization rates
        Map<String, Double> utilizationRates = paymentDAO.getServiceUtilizationRates();

        // Seasonal service analysis
        Map<String, Map<String, Integer>> seasonalAnalysis = paymentDAO.getSeasonalServiceAnalysis();

        // Set attributes for JSP
        request.setAttribute("servicePerformance", servicePerformance);
        request.setAttribute("serviceTrends", serviceTrends);
        request.setAttribute("serviceRevenue", serviceRevenue);
        request.setAttribute("utilizationRates", utilizationRates);
        request.setAttribute("seasonalAnalysis", seasonalAnalysis);

        request.getRequestDispatcher("/WEB-INF/view/manager/statistics/services-statistics.jsp").forward(request,
                response);
    }
}
