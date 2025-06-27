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
import java.util.Arrays;
import java.util.stream.Collectors;

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

        if ("check-duplicate".equals(service)) {
            String userIdStr = request.getParameter("userId");
            boolean exists = false;
            String message = "";
            if (userIdStr != null && !userIdStr.isEmpty()) {
                int userId = Integer.parseInt(userIdStr);
                StaffDAO staffDAO = new StaffDAO();
                User user = new UserDAO().findById(userId).orElse(null);
                if (user != null) {
                    if (staffDAO.existsByUserId(userId)) {
                        exists = true;
                        message = "Nhân viên này đã tồn tại. Vui lòng chọn nhân viên khác.";
                    } else if (staffDAO.existsByFullName(user.getFullName())) {
                        exists = true;
                        message = "Tên nhân viên này đã tồn tại. Vui lòng chọn nhân viên khác.";
                    }
                }
            }
            response.setContentType("application/json");
            response.getWriter().write("{\"exists\": " + exists + ", \"message\": \"" + message + "\"}");
            return;
        }

        StaffDAO staffDAO = new StaffDAO();
        int limit = 5; // Default value
        if (request.getParameter("limit") != null) {
            try {
                limit = Integer.parseInt(request.getParameter("limit"));
            } catch (NumberFormatException ignored) {}
        }

        switch (service) {
            case "list-all": {
                int page = 1;
                if (request.getParameter("page") != null) {
                    try {
                        page = Integer.parseInt(request.getParameter("page"));
                    } catch (NumberFormatException ignored) {}
                }
                int offset = (page - 1) * limit;

                List<Staff> staffList = staffDAO.findPaginated(offset, limit);
                int totalRecords = staffDAO.countAll();
                int totalPages = (int) Math.ceil((double) totalRecords / limit);

                request.setAttribute("limit", limit);
                request.setAttribute("staffList", staffList);
                request.setAttribute("currentPage", page);
                request.setAttribute("totalPages", totalPages);
                request.setAttribute("totalEntries", totalRecords);

                List<ServiceType> serviceTypes = new ServiceTypeDAO().findAll();
                request.setAttribute("serviceTypes", serviceTypes);

                List<String> statusList = Arrays.stream(Staff.AvailabilityStatus.values())
                                .map(Enum::name)
                                .collect(Collectors.toList());
                request.setAttribute("statusList", statusList);

                request.getRequestDispatcher(STAFF_MANAGER_VIEW).forward(request, response);
                break;
            }

            case "pre-insert": {
                // Load service types for the dropdown
                List<ServiceType> serviceTypes = new ServiceTypeDAO().findAll();
                request.setAttribute("serviceTypes", serviceTypes);
                List<User> userList = new UserDAO().findAll();
                request.setAttribute("userList", userList);
                request.getRequestDispatcher(STAFF_INSERT_VIEW).forward(request, response);
                break;
            }

            case "pre-update": {
                int id = Integer.parseInt(request.getParameter("id"));
                Staff staff = staffDAO.findById(id).orElse(null);
                List<ServiceType> serviceTypes = new ServiceTypeDAO().findAll();
                request.setAttribute("staff", staff);
                request.setAttribute("serviceTypes", serviceTypes);
                request.getRequestDispatcher(STAFF_UPDATE_VIEW).forward(request, response);
                break;
            }

            case "viewById": {
                int id = Integer.parseInt(request.getParameter("id"));
                Staff staff = staffDAO.findById(id).orElse(null);
                List<ServiceType> serviceTypes = new ServiceTypeDAO().findAll();
                request.setAttribute("staff", staff);
                request.setAttribute("serviceTypes", serviceTypes);
                request.getRequestDispatcher("WEB-INF/view/admin_pages/Staff/ViewStaff.jsp").forward(request, response);
                break;
            }

            case "search": {
                String keyword = request.getParameter("keyword");
                String status = request.getParameter("status");
                String serviceTypeIdParam = request.getParameter("serviceTypeId");
                Integer serviceTypeId = null;
                if (serviceTypeIdParam != null && !serviceTypeIdParam.isEmpty()) {
                    serviceTypeId = Integer.parseInt(serviceTypeIdParam);
                }

                int page = 1;
                if (request.getParameter("page") != null) {
                    try {
                        page = Integer.parseInt(request.getParameter("page"));
                    } catch (NumberFormatException ignored) {}
                }
                int offset = (page - 1) * limit;

                List<Staff> staffList = staffDAO.searchByKeywordAndStatus(keyword, status, serviceTypeId, offset, limit);
                int totalRecords = staffDAO.countByKeywordAndStatus(keyword, status, serviceTypeId);
                int totalPages = (int) Math.ceil((double) totalRecords / limit);

                request.setAttribute("keyword", keyword);
                request.setAttribute("status", status);
                request.setAttribute("serviceTypeId", serviceTypeId);
                request.setAttribute("staffList", staffList);
                request.setAttribute("limit", limit);
                request.setAttribute("currentPage", page);
                request.setAttribute("totalPages", totalPages);
                request.setAttribute("totalEntries", totalRecords);

                List<ServiceType> serviceTypes = new ServiceTypeDAO().findAll();
                request.setAttribute("serviceTypes", serviceTypes);

                List<String> statusList = Arrays.stream(Staff.AvailabilityStatus.values())
                                .map(Enum::name)
                                .collect(Collectors.toList());
                request.setAttribute("statusList", statusList);

                request.getRequestDispatcher(STAFF_MANAGER_VIEW).forward(request, response);
                break;
            }

            case "deactiveById": {
                int id = Integer.parseInt(request.getParameter("id"));
                int n = staffDAO.deactiveById(id);

                if (n == 1) {
                    request.setAttribute("toastType", "success");
                    request.setAttribute("toastMessage", "Deactivate Staff (Id = " + id + ") done!");
                } else {
                    request.setAttribute("toastType", "error");
                    request.setAttribute("toastMessage", "Failed to deactivate Staff (Id = " + id + ") because it is associated with an order.");
                }

                // Reload pagination
                int page = 1;
                int offset = (page - 1) * limit;

                List<Staff> staffList = staffDAO.findPaginated(offset, limit);
                int totalRecords = staffDAO.countAll();
                int totalPages = (int) Math.ceil((double) totalRecords / limit);

                request.setAttribute("limit", limit);
                request.setAttribute("staffList", staffList);
                request.setAttribute("currentPage", page);
                request.setAttribute("totalPages", totalPages);
                request.setAttribute("totalEntries", totalRecords);

                request.getRequestDispatcher(STAFF_MANAGER_VIEW).forward(request, response);
                break;
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String service = request.getParameter("service");

        if (service.equals("insert") || service.equals("update")) {
            Staff staff = createStaffFromRequest(request);
            if (staff == null) {
                request.setAttribute("toastType", "error");
                request.setAttribute("toastMessage", "Dữ liệu không hợp lệ!");
                request.getRequestDispatcher(STAFF_MANAGER_VIEW).forward(request, response);
                return;
            }

            StaffDAO staffDAO = new StaffDAO();
            
            if (service.equals("insert")) {
                if (staff.getYearsOfExperience() < 0) {
                    request.setAttribute("toastType", "error");
                    request.setAttribute("toastMessage", "Years of experience must be non-negative!");
                    request.getRequestDispatcher(STAFF_INSERT_VIEW).forward(request, response);
                    return;
                }
                staffDAO.save(staff);
                request.setAttribute("toastType", "success");
                request.setAttribute("toastMessage", "Thêm nhân viên thành công!");
            } else {
                System.out.println("Update staff userId: " + staff.getUser().getUserId());
                staff.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
                Staff updatedStaff = staffDAO.update(staff);
                if (updatedStaff == null) {
                    request.setAttribute("toastType", "error");
                    request.setAttribute("toastMessage", "Cập nhật thông tin nhân viên thất bại!");
                    request.getRequestDispatcher(STAFF_MANAGER_VIEW).forward(request, response);
                    return;
                }
                request.setAttribute("toastType", "success");
                request.setAttribute("toastMessage", "Cập nhật thông tin nhân viên thành công!");
            }
            
            // Load lại dữ liệu mới
            int limit = 5;
            int page = 1;
            int offset = (page - 1) * limit;

            List<Staff> staffList = staffDAO.findPaginated(offset, limit);
            int totalRecords = staffDAO.countAll();
            int totalPages = (int) Math.ceil((double) totalRecords / limit);

            request.setAttribute("limit", limit);
            request.setAttribute("staffList", staffList);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalEntries", totalRecords);

            request.getRequestDispatcher(STAFF_MANAGER_VIEW).forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action in POST");
        }

        System.out.println("Received userId: " + request.getParameter("userId"));
        System.out.println("Received bio: " + request.getParameter("bio"));
        System.out.println("Received serviceTypeId: " + request.getParameter("serviceTypeId"));
        System.out.println("Received availabilityStatus: " + request.getParameter("availabilityStatus"));
        System.out.println("Received yearsOfExperience: " + request.getParameter("yearsOfExperience"));
    }

    private Staff createStaffFromRequest(HttpServletRequest request) {
        try {
            String userIdStr = request.getParameter("userId");
            int userId = 0;
            if (userIdStr != null && !userIdStr.isEmpty()) {
                userId = Integer.parseInt(userIdStr);
            }

            String fullName = request.getParameter("fullName");
            String serviceTypeIdStr = request.getParameter("serviceTypeId");
            int serviceTypeId = 0;
            if (serviceTypeIdStr != null && !serviceTypeIdStr.isEmpty()) {
                serviceTypeId = Integer.parseInt(serviceTypeIdStr);
            }

            String availabilityStatus = request.getParameter("availabilityStatus");
            String yearsOfExperienceStr = request.getParameter("yearsOfExperience");
            int yearsOfExperience = 0;
            if (yearsOfExperienceStr != null && !yearsOfExperienceStr.isEmpty()) {
                yearsOfExperience = Integer.parseInt(yearsOfExperienceStr);
            }

            String bio = request.getParameter("bio");
            // Xử lý bio: loại bỏ khoảng trắng thừa và validate độ dài
            if (bio != null) {
                bio = bio.trim().replaceAll("\\s{2,}", " "); // Thay thế nhiều khoảng trắng bằng 1 khoảng trắng
                
                // Validate độ dài
                if (bio.length() < 20) {
                    request.setAttribute("toastType", "error");
                    request.setAttribute("toastMessage", "Bio must be at least 20 characters long!");
                    return null;
                }
                if (bio.length() > 500) {
                    bio = bio.substring(0, 500);
                }
            }

            User user = new User();
            user.setUserId(userId);
            user.setFullName(fullName);

            ServiceType serviceType = new ServiceTypeDAO().findById(serviceTypeId).orElse(null);

            Staff staff = new Staff();
            staff.setUser(user);
            staff.setServiceType(serviceType);
            staff.setBio(bio);
            staff.setAvailabilityStatus(Staff.AvailabilityStatus.valueOf(availabilityStatus));
            staff.setYearsOfExperience(yearsOfExperience);

            return staff;
        } catch (NumberFormatException e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public String getServletInfo() {
        return "Staff Management Controller";
    }
}