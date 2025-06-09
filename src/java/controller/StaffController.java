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

    private final String STAFF_MANAGER_VIEW = "WEB-INF/view/admin_pages/StaffManager.jsp";
    private final String STAFF_UPDATE_VIEW = "WEB-INF/view/admin_pages/UpdateStaff.jsp";
    private final String STAFF_INSERT_VIEW = "WEB-INF/view/admin_pages/AddStaff.jsp";

    @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    String service = request.getParameter("service");
    String searchQuery = request.getParameter("search"); // Lấy giá trị search từ query string

    if (service == null) {
        service = "list-all";
    }

    // Tìm kiếm nhân viên theo name hoặc serviceType
    if ("list-all".equals(service)) {
        List<Staff> staffList;
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            staffList = new StaffDAO().searchByNameOrServiceType(searchQuery);
        } else {
            staffList = new StaffDAO().findAll();
        }
        request.setAttribute("staffList", staffList);
        request.getRequestDispatcher(STAFF_MANAGER_VIEW).forward(request, response);
    } else if ("pre-insert".equals(service)) {
            // Truyền dữ liệu ServiceType và User vào AddStaff.jsp
            List<ServiceType> serviceTypes = new ServiceTypeDAO().findAll();
            List<User> users = new UserDAO().findAll();  // Lấy danh sách người dùng
            request.setAttribute("serviceTypes", serviceTypes);
            request.setAttribute("users", users);  // Truyền danh sách user vào JSP
            request.getRequestDispatcher(STAFF_INSERT_VIEW).forward(request, response);
        } else if ("pre-update".equals(service)) {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID is missing or empty.");
                return;
            }

            try {
                int userId = Integer.parseInt(idParam);
                Optional<Staff> staff = new StaffDAO().findById(userId);
                if (staff.isPresent()) {
                    // Lấy thông tin service types để hiển thị trên giao diện
                    List<ServiceType> serviceTypes = new ServiceTypeDAO().findAll();
                    request.setAttribute("staff", staff.get());
                    request.setAttribute("serviceTypes", serviceTypes);
                    request.getRequestDispatcher(STAFF_UPDATE_VIEW).forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Staff not found");
                }
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid ID format.");
            }
        } else if ("delete".equals(service)) {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID is missing or empty.");
                return;
            }

            try {
                int userId = Integer.parseInt(idParam);
                new StaffDAO().deleteById(userId);
                response.sendRedirect("staff");
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid ID format.");
            }
        }
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