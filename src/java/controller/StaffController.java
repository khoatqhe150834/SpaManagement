package controller;

import dao.StaffDAO;
import dao.ServiceTypeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Staff;
import model.ServiceType;
import model.User;
import model.Staff.AvailabilityStatus;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;
import java.util.Optional;

@WebServlet(name = "StaffController", urlPatterns = {"/staff"})
public class StaffController extends HttpServlet {

    private final String STAFF_MANAGER_VIEW = "WEB-INF/view/admin_pages/StaffManager.jsp";
    private final String STAFF_UPDATE_VIEW = "WEB-INF/view/admin_pages/update_staff.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String service = request.getParameter("service");

        if (service == null || service.equals("list-all")) {
            List<Staff> staffList = new StaffDAO().findAll();
            request.setAttribute("staffList", staffList);
            request.getRequestDispatcher(STAFF_MANAGER_VIEW).forward(request, response);
        } else if ("pre-update".equals(service)) {
            int userId = Integer.parseInt(request.getParameter("id"));
            Optional<Staff> staff = new StaffDAO().findById(userId);
            if (staff.isPresent()) {
                request.setAttribute("staff", staff.get());
                List<ServiceType> serviceTypes = new ServiceTypeDAO().findAll();
                request.setAttribute("serviceTypes", serviceTypes);
                request.getRequestDispatcher(STAFF_UPDATE_VIEW).forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Staff not found");
            }
        } else if ("delete".equals(service)) {
            int userId = Integer.parseInt(request.getParameter("id"));
            new StaffDAO().deleteById(userId);
            response.sendRedirect("staff");
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action in GET");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String service = request.getParameter("service");

        if ("insert".equals(service)) {
            Staff staff = buildStaffFromRequest(request);
            new StaffDAO().save(staff);
            response.sendRedirect("staff");
        } else if ("update".equals(service)) {
            Staff staff = buildStaffFromRequest(request);
            new StaffDAO().update(staff);
            response.sendRedirect("staff");
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action in POST");
        }
    }

    private Staff buildStaffFromRequest(HttpServletRequest request) {
        int userId = Integer.parseInt(request.getParameter("user_id"));
        String bio = request.getParameter("bio");
        String availabilityStr = request.getParameter("availability_status");
        int experience = Integer.parseInt(request.getParameter("years_of_experience"));
        int serviceTypeId = Integer.parseInt(request.getParameter("service_type_id"));

        User user = new User();
        user.setUserId(userId);

        ServiceType st = new ServiceType();
        st.setServiceTypeId(serviceTypeId);

        AvailabilityStatus availabilityStatus = null;
        if (availabilityStr != null && !availabilityStr.isEmpty()) {
            availabilityStatus = AvailabilityStatus.valueOf(availabilityStr);
        }

        Timestamp now = new Timestamp(System.currentTimeMillis());

        Staff staff = new Staff();
        staff.setUser(user);
        staff.setServiceType(st);
        staff.setBio(bio);
        staff.setAvailabilityStatus(availabilityStatus);
        staff.setYearsOfExperience(experience);
        staff.setUpdatedAt(now);
        staff.setCreatedAt(now); // optional for insert

        return staff;
    }

    @Override
    public String getServletInfo() {
        return "Controller for managing Staff (therapists) CRUD operations";
    }
}
