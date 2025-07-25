package controller;

import dao.StaffStatisticsDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet({
    "/manager/staff-statistics/bookings",
    "/manager/staff-statistics/revenue",
    "/manager/staff-statistics/reviews",
    "/manager/staff-statistics/customers",
    "/manager/staff-statistics/top-services",
    "/manager/staff-statistics/working-hours",
    "/manager/staff-statistics/cancelled",
    "/manager/staff-statistics/inventory",
    "/manager/staff-statistics/compare"
})
public class StaffStatisticsController extends HttpServlet {
    private final StaffStatisticsDAO staffStatisticsDAO = new StaffStatisticsDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();
        String jspPath = null;
        switch (servletPath) {
            case "/manager/staff-statistics/bookings": {
                // Lấy therapistId từ request param, nếu không có thì mặc định là 1
                int therapistId = 1;
                String tid = request.getParameter("therapistId");
                if (tid != null) {
                    try {
                        therapistId = Integer.parseInt(tid);
                    } catch (NumberFormatException ignored) {}
                }
                int totalBookings = staffStatisticsDAO.getTotalBookings(therapistId);
                request.setAttribute("totalBookings", totalBookings);
                request.setAttribute("therapistId", therapistId);
                // Lấy danh sách tất cả therapist và các chỉ số booking
                request.setAttribute("therapistsStatsList", staffStatisticsDAO.getAllTherapistBookingStats());
                request.setAttribute("pageTitle", "Thống kê số booking đã thực hiện");
                // Thêm các thống kê nhỏ
                request.setAttribute("pendingBookings", staffStatisticsDAO.getPendingBookings());
                request.setAttribute("cancelledBookingsThisMonth", staffStatisticsDAO.getCancelledBookingsThisMonth());
                request.setAttribute("noShowBookings", staffStatisticsDAO.getNoShowBookings());
                request.setAttribute("totalRevenue", staffStatisticsDAO.getTotalRevenue());
                request.setAttribute("peakBookingDay", staffStatisticsDAO.getPeakBookingDay());
                request.setAttribute("topStaffId", staffStatisticsDAO.getTopStaffId());
                request.setAttribute("bottomStaffId", staffStatisticsDAO.getBottomStaffId());
                request.setAttribute("topReturningCustomerId", staffStatisticsDAO.getTopReturningCustomerId());
                request.setAttribute("onlineBookingRate", staffStatisticsDAO.getOnlineBookingRate());
                request.setAttribute("serviceTypeBookingRate", staffStatisticsDAO.getServiceTypeBookingRate());
                request.setAttribute("morningBookings", staffStatisticsDAO.getMorningBookings());
                request.setAttribute("afternoonBookings", staffStatisticsDAO.getAfternoonBookings());
                request.setAttribute("eveningBookings", staffStatisticsDAO.getEveningBookings());
                jspPath = "/WEB-INF/view/therapist/reports/bookings.jsp";
                break;
            }
            case "/manager/staff-statistics/revenue":
                jspPath = "/WEB-INF/view/therapist/reports/revenue.jsp";
                break;
            case "/manager/staff-statistics/reviews":
                jspPath = "/WEB-INF/view/therapist/reports/reviews.jsp";
                break;
            case "/manager/staff-statistics/customers":
                jspPath = "/WEB-INF/view/therapist/reports/customers.jsp";
                break;
            case "/manager/staff-statistics/top-services":
                jspPath = "/WEB-INF/view/therapist/reports/top-services.jsp";
                break;
            case "/manager/staff-statistics/working-hours":
                jspPath = "/WEB-INF/view/therapist/reports/working-hours.jsp";
                break;
            case "/manager/staff-statistics/cancelled":
                jspPath = "/WEB-INF/view/therapist/reports/cancelled.jsp";
                break;
            case "/manager/staff-statistics/inventory":
                jspPath = "/WEB-INF/view/therapist/reports/inventory.jsp";
                break;
            case "/manager/staff-statistics/compare":
                jspPath = "/WEB-INF/view/therapist/reports/compare.jsp";
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
        }
        request.getRequestDispatcher(jspPath).forward(request, response);
    }
} 