/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.ReportDAO;
import model.Report;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.annotation.WebServlet;

@WebServlet(name = "ReportController", urlPatterns = {"/admin/report"})
public class ReportController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ReportDAO dao = new ReportDAO();
        List<Report> revenueList = dao.getRevenueByDate();
        request.setAttribute("revenueList", revenueList);
        request.getRequestDispatcher("/WEB-INF/view/admin_pages/Report/RevenueReport.jsp").forward(request, response);
    }
}
