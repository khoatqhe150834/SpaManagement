package controller;

import dao.StaffDAO;
import dao.ServiceTypeDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Staff;
import model.ServiceType;
import model.User;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;
import java.util.Optional;

@WebServlet(name = "StaffController", urlPatterns = {"/staff"})
public class StaffController extends HttpServlet {

    private final String STAFF_MANAGER_VIEW = "WEB-INF/view/admin_pages/Staff/StaffManager.jsp";
    private final String STAFF_UPDATE_VIEW = "WEB-INF/view/admin_pages/Staff/UpdateStaff.jsp";
    private final String STAFF_INSERT_VIEW = "WEB-INF/view/admin_pages/Staff/AddStaff.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String service = request.getParameter("service");
        if (service == null || service.isEmpty()) {
            service = "list-all";
        }

        StaffDAO staffDAO = new StaffDAO();

        // Lấy các tham số phân trang, tìm kiếm, lọc
        int limit = 5;
        if (request.getParameter("limit") != null) {
            try {
                limit = Integer.parseInt(request.getParameter("limit"));
            } catch (Exception ignored) {}
        }
        int page = 1;
        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (Exception ignored) {}
        }
        int offset = (page - 1) * limit;
        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");

        List<Staff> staffList;
        int totalEntries;
        int totalPages;

        // Xử lý search/filter/list-all
        if ("search".equals(service)) {
            staffList = staffDAO.searchByKeywordAndStatus(keyword, status, offset, limit);
            totalEntries = staffDAO.countByKeywordAndStatus(keyword, status);
        } else {
            staffList = staffDAO.searchByKeywordAndStatus(null, null, offset, limit);
            totalEntries = staffDAO.countByKeywordAndStatus(null, null);
        }
        totalPages = (int) Math.ceil((double) totalEntries / limit);

        // Truyền dữ liệu sang JSP
        request.setAttribute("staffList", staffList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalEntries", totalEntries);
        request.setAttribute("limit", limit);
        request.setAttribute("keyword", keyword);
        request.setAttribute("status", status);

        request.getRequestDispatcher(STAFF_MANAGER_VIEW).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String service = request.getParameter("service");

        // Thêm mới nhân viên
        if ("insert".equals(service)) {
            Staff staff = createStaffFromRequest(request); // gọi phương thức này
            new StaffDAO().save(staff);
            response.sendRedirect("staff");  // Chuyển hướng về danh sách nhân viên
        } // Cập nhật nhân viên
        else if ("update".equals(service)) {
            Staff staff = createStaffFromRequest(request); // gọi phương thức này
            staff.setUpdatedAt(new Timestamp(System.currentTimeMillis()));  // Cập nhật thời gian chỉnh sửa
            boolean updateSuccess = new StaffDAO().update(staff) != null;  // Kiểm tra cập nhật thành công

            if (updateSuccess) {
                response.sendRedirect("staff");  // Cập nhật thành công, chuyển hướng lại danh sách nhân viên
            } else {
                request.setAttribute("errorMessage", "Update failed, please try again.");
                request.getRequestDispatcher(STAFF_UPDATE_VIEW).forward(request, response);  // Nếu có lỗi, quay lại trang cập nhật
            }
        }
    }

    // Phương thức này sẽ được gọi trong doPost để tạo Staff từ request
    private Staff createStaffFromRequest(HttpServletRequest request) {
        try {
            // Kiểm tra và chuyển đổi userId
            String userIdStr = request.getParameter("userId");
            int userId = 0;
            if (userIdStr != null && !userIdStr.isEmpty()) {
                userId = Integer.parseInt(userIdStr);
            }

            // Kiểm tra và lấy fullName
            String fullName = request.getParameter("fullName");

            // Kiểm tra và chuyển đổi serviceTypeId
            String serviceTypeIdStr = request.getParameter("serviceTypeId");
            int serviceTypeId = 0;
            if (serviceTypeIdStr != null && !serviceTypeIdStr.isEmpty()) {
                serviceTypeId = Integer.parseInt(serviceTypeIdStr);
            }

            // Kiểm tra và lấy availabilityStatus
            String availabilityStatus = request.getParameter("availabilityStatus");

            // Kiểm tra và chuyển đổi yearsOfExperience
            String yearsOfExperienceStr = request.getParameter("yearsOfExperience");
            int yearsOfExperience = 0;
            if (yearsOfExperienceStr != null && !yearsOfExperienceStr.isEmpty()) {
                yearsOfExperience = Integer.parseInt(yearsOfExperienceStr);
            }

            // Kiểm tra và lấy bio
            String bio = request.getParameter("bio");

            // Tạo đối tượng User
            User user = new User();
            user.setUserId(userId);
            user.setFullName(fullName);

            // Tạo đối tượng ServiceType
            ServiceType serviceType = new ServiceTypeDAO().findById(serviceTypeId).orElse(null);

            // Tạo đối tượng Staff và gán các giá trị
            Staff staff = new Staff();
            staff.setUser(user);
            staff.setServiceType(serviceType);
            staff.setBio(bio);
            staff.setAvailabilityStatus(Staff.AvailabilityStatus.valueOf(availabilityStatus));
            staff.setYearsOfExperience(yearsOfExperience);

            return staff;

        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
        return null;
    }   

    @Override
    public String getServletInfo() {
        return "Staff Management Controller";
    }
}