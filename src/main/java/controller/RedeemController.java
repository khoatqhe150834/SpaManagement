package controller;

import java.io.IOException;
import java.util.List;

import dao.PointRedemptionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Customer;
import model.PointRedemption;
import service.RewardPointService;

@WebServlet(urlPatterns = {"/spa/customer/profile", "/spa/customer/history"})
public class RedeemController extends HttpServlet {
    private final RewardPointService rewardPointService = new RewardPointService();
    private final PointRedemptionDAO redemptionDAO = new PointRedemptionDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();
        HttpSession session = req.getSession();
        Customer customer = (Customer) session.getAttribute("customer");
        if (customer == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        if (uri.endsWith("/spa/customer/history")) {
            // Lấy lịch sử đổi điểm
            List<PointRedemption> history = redemptionDAO.getRedemptionsByCustomer(customer.getCustomerId());
            req.setAttribute("redemptionHistory", history);
            req.getRequestDispatcher("/WEB-INF/view/customer/rewards/redeem-history.jsp").forward(req, resp);
        } else {
            // Trang đổi điểm (form)
            req.getRequestDispatcher("/WEB-INF/view/customer/rewards/redeem.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Customer customer = (Customer) session.getAttribute("customer");
        if (customer == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        // Lấy thông tin từ form
        String rewardType = req.getParameter("rewardType"); // Ví dụ: "DISCOUNT_CODE"
        String rewardValue = req.getParameter("rewardValue"); // Ví dụ: mã giảm giá
        String pointsStr = req.getParameter("pointsToUse");
        int pointsToUse = 0;
        try {
            pointsToUse = Integer.parseInt(pointsStr);
        } catch (Exception ignore) {}
        String note = req.getParameter("note");
        boolean success = false;
        if (pointsToUse > 0 && rewardType != null && rewardValue != null) {
            success = rewardPointService.redeemPointsForReward(customer.getCustomerId(), pointsToUse, rewardType, rewardValue, note);
        }
        if (success) {
            req.setAttribute("message", "Đổi điểm thành công! Mã giảm giá của bạn: " + rewardValue);
        } else {
            req.setAttribute("error", "Đổi điểm thất bại. Vui lòng kiểm tra số điểm hoặc thông tin phần thưởng.");
        }
        req.getRequestDispatcher("/WEB-INF/view/customer/rewards/redeem.jsp").forward(req, resp);
    }
} 