package controller;

import java.io.IOException;
import java.util.List;

import dao.CustomerDAO;
import dao.CustomerPointDAO;
import dao.PointRedemptionDAO;
import dao.RewardPointRuleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Customer;
import model.RewardPointRule;
import model.User;
import service.RewardPointService;

@WebServlet(urlPatterns = {
    "/manager/loyalty-points",
    "/manager/loyalty-points/edit",
    "/manager/loyalty-points/history",
    "/manager/loyalty-points/sync",
    "/manager/loyalty-points/rules"
})
public class LoyaltyPointManagerController extends HttpServlet {
    private final CustomerDAO customerDAO = new CustomerDAO();
    private final CustomerPointDAO customerPointDAO = new CustomerPointDAO();
    private final RewardPointService rewardPointService = new RewardPointService();
    private final RewardPointRuleDAO ruleDAO = new RewardPointRuleDAO();
    private final PointRedemptionDAO redemptionDAO = new PointRedemptionDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        // Kiểm tra quyền manager (giả sử roleId = 2 là manager)
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || currentUser.getRoleId() == null || currentUser.getRoleId() != 2) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập chức năng này.");
            return;
        }
        String uri = req.getRequestURI();
        if (uri.endsWith("/manager/loyalty-points")) {
            // --- Lấy tham số tìm kiếm, lọc, sắp xếp, phân trang ---
            String search = req.getParameter("search");
            String tierFilter = req.getParameter("tierFilter");
            String sortBy = req.getParameter("sortBy");
            String sortOrder = req.getParameter("sortOrder");
            int page = 1;
            int pageSize = 10;
            try { page = Integer.parseInt(req.getParameter("page")); } catch (Exception ignore) {}
            try { pageSize = Integer.parseInt(req.getParameter("pageSize")); } catch (Exception ignore) {}
            if (page < 1) page = 1;
            if (pageSize < 1) pageSize = 10;
            // --- Lấy danh sách khách hàng đã lọc ---
            List<model.Customer> customers = customerDAO.getPaginatedCustomersWithFilter(page, pageSize, search, tierFilter, sortBy, sortOrder);
            int totalCustomers = customerDAO.countCustomersWithFilter(search, tierFilter);
            int totalPages = (int) Math.ceil((double) totalCustomers / pageSize);
            req.setAttribute("customers", customers);
            req.setAttribute("currentPage", page);
            req.setAttribute("pageSize", pageSize);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("search", search);
            req.setAttribute("tierFilter", tierFilter);
            req.setAttribute("sortBy", sortBy);
            req.setAttribute("sortOrder", sortOrder);
            req.getRequestDispatcher("/WEB-INF/view/manager/loyalty/loyalty-points.jsp").forward(req, resp);
        } else if (uri.endsWith("/manager/loyalty-points/history")) {
            // Lịch sử cộng/trừ điểm của 1 khách hàng
            String customerIdStr = req.getParameter("customerId");
            int customerId = customerIdStr != null ? Integer.parseInt(customerIdStr) : 0;
            req.setAttribute("history", customerPointDAO.getHistoryByCustomerId(customerId));
            req.getRequestDispatcher("/WEB-INF/view/manager/loyalty/loyalty-history.jsp").forward(req, resp);
        } else if (uri.endsWith("/manager/loyalty-points/sync")) {
            // Đồng bộ điểm và tier toàn hệ thống
            customerDAO.syncLoyaltyPointsByTotalSpent();
            customerDAO.syncAllCustomerTiers();
            resp.sendRedirect(req.getContextPath() + "/manager/loyalty-points?success=sync");
        } else if (uri.endsWith("/manager/loyalty-points/rules")) {
            // Xem/sửa quy tắc quy đổi điểm
            List<RewardPointRule> rules = ruleDAO.getAllRules();
            req.setAttribute("rules", rules);
            req.getRequestDispatcher("/WEB-INF/view/manager/loyalty/loyalty-rules.jsp").forward(req, resp);
        } else if (uri.endsWith("/manager/loyalty-points/edit")) {
            String customerIdStr = req.getParameter("customerId");
            int customerId = customerIdStr != null ? Integer.parseInt(customerIdStr) : 0;
            Customer customer = customerDAO.findById(customerId).orElse(null);
            req.setAttribute("customer", customer);
            req.getRequestDispatcher("/WEB-INF/view/manager/loyalty/loyalty-edit.jsp").forward(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || currentUser.getRoleId() == null || currentUser.getRoleId() != 2) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập chức năng này.");
            return;
        }
        String uri = req.getRequestURI();
        if (uri.endsWith("/manager/loyalty-points/edit")) {
            // Cộng/trừ điểm thủ công cho khách hàng
            String customerIdStr = req.getParameter("customerId");
            String pointsStr = req.getParameter("points");
            String note = req.getParameter("note");
            int customerId = Integer.parseInt(customerIdStr);
            int points = Integer.parseInt(pointsStr);
            boolean success;
            if (points > 0) {
                success = customerPointDAO.addPoints(customerId, points, note != null ? note : "Điều chỉnh thủ công bởi manager");
            } else if (points < 0) {
                success = customerPointDAO.subtractPoints(customerId, -points, note != null ? note : "Điều chỉnh thủ công bởi manager");
            } else {
                success = true;
            }
            // Sau khi cộng/trừ điểm, đồng bộ lại tier
            rewardPointService.updateCustomerTierInDb(customerId);
            if (points > 0 && success) {
                session.setAttribute("successMessage", "Cộng điểm thành công!");
            } else if (points < 0 && success) {
                session.setAttribute("successMessage", "Trừ điểm thành công!");
            } else if (!success) {
                session.setAttribute("errorMessage", "Không đủ điểm để trừ!");
            } else {
                session.setAttribute("successMessage", "Không thay đổi điểm.");
            }
            resp.sendRedirect(req.getContextPath() + "/manager/loyalty-points?success=edit");
        } else if (uri.endsWith("/manager/loyalty-points/rules")) {
            // Sửa quy tắc quy đổi điểm
            String ruleIdStr = req.getParameter("ruleId");
            String moneyPerPointStr = req.getParameter("moneyPerPoint");
            int ruleId = Integer.parseInt(ruleIdStr);
            int moneyPerPoint = Integer.parseInt(moneyPerPointStr);
            ruleDAO.updateRuleMoneyPerPoint(ruleId, moneyPerPoint);
            resp.sendRedirect(req.getContextPath() + "/manager/loyalty-points/rules?success=update");
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
} 