package controller;

import dao.InventoryIssueDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.InventoryIssue;
import model.InventoryIssueDetail;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "AdminManagerInventoryController", urlPatterns = {"/manager-admin/inventory/*"})
public class ManagerInventoryController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        try {
            switch (path) {
                case "/issue":
                    handleIssueApprove(req, resp);
                    break;
                case "/issue/views":
                    handleIssueViews(req, resp);
                    break;
                default:
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }

    }



    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getPathInfo();
        try {
            switch (path) {
                case "/issue/delete":
                    handleIssueDelete(request, response);
                    break;
                case "/issue/approve":
                    handleIssueApproveAccAndreject(request, response);
                    break;
//                case "/alerts/update":
//                    handleAlertsUpdate(request, response);
//                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void handleIssueApproveAccAndreject(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        String id = request.getParameter("id");
        String action = request.getParameter("action");
        InventoryIssueDAO issueDAO = new InventoryIssueDAO();
        issueDAO.findIssueById(Integer.parseInt(id)).ifPresent(
                inventoryIssue -> {
                    inventoryIssue.setStatus(action);
                    try {
                        issueDAO.updateIssue(inventoryIssue);
                    } catch (SQLException e) {
                        throw new RuntimeException(e);
                    }
                }
        );
        response.sendRedirect(request.getContextPath() + "/manager-admin/inventory/issue");
    }

    private void handleIssueApprove(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession(false);
        InventoryIssueDAO issueDAO = new InventoryIssueDAO();
        UserDAO userDAO = new UserDAO();
        String search = request.getParameter("search");
        int page = 1;
        int pageSize = 10;
        try {
            page = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
        } catch (Exception ignored) {
        }
        try {
            pageSize = request.getParameter("pageSize") != null ? Integer.parseInt(request.getParameter("pageSize")) : 10;
        } catch (Exception ignored) {
        }
        List<InventoryIssue> issues = issueDAO.findIssues(search, page, pageSize);
        issues.forEach(issue -> {
            userDAO.findById(issue.getRequestedBy()).ifPresent(
                    issue::setRequestedByUser
            );
            userDAO.findById(issue.getApprovedBy()).ifPresent(
                    issue::setApprovedByUser
            );
            issue.setOwner(true);
        });
        int total = issueDAO.countIssues(search);
        request.setAttribute("issues", issues);
        request.setAttribute("total", total);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("search", search);
        request.getRequestDispatcher("/WEB-INF/view/manager/inventory/issue_list.jsp").forward(request, response);
    }

    private void handleIssueViews(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        String id = request.getParameter("id");
        InventoryIssueDAO issueDAO = new InventoryIssueDAO();
        UserDAO userDAO = new UserDAO();
        issueDAO.findIssueById(Integer.parseInt(id)).ifPresent(
                issue -> {
                    userDAO.findById(issue.getRequestedBy()).ifPresent(
                            issue::setRequestedByUser
                    );
                    userDAO.findById(issue.getApprovedBy()).ifPresent(
                            issue::setApprovedByUser
                    );
                    request.setAttribute("issue", issue);
                }
        );
        List<InventoryIssueDetail> issueDetails = issueDAO.getIssueDetailsByIssueId(Integer.parseInt(id));
        request.setAttribute("issueDetails", issueDetails);
        request.getRequestDispatcher("/WEB-INF/view/manager/inventory/issue_views.jsp").forward(request, response);
    }

    private void handleIssueDelete(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        String id = request.getParameter("id");
        InventoryIssueDAO issueDAO = new InventoryIssueDAO();
        issueDAO.deleteIssue(Integer.parseInt(id));
        response.sendRedirect(request.getContextPath() + "/manager-admin/inventory/issue");
    }
}
