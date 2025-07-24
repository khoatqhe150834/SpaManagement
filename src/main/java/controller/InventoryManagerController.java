package controller;

import dao.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.*;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@WebServlet(name = "InventoryManagerController", urlPatterns = {"/inventory-manager/*"})
public class InventoryManagerController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getPathInfo();
        if (path == null) path = "/item";
        try {
            switch (path) {
                case "/item":
                    handleItemList(request, response);
                    break;
                case "/item/create":
                    handleItemCreateForm(request, response);
                    break;
                case "/item/edit":
                    handleItemEditForm(request, response);
                    break;
                case "/category":
                    handleCategoryList(request, response);
                    break;
                case "/category/create":
                    handleCategoryCreateForm(request, response);
                    break;
                case "/category/edit":
                    handleCategoryEditForm(request, response);
                    break;
                case "/supplier":
                    handleSupplierList(request, response);
                    break;
                case "/supplier/create":
                    handleSupplierCreateForm(request, response);
                    break;
                case "/supplier/edit":
                    handleSupplierEditForm(request, response);
                    break;
                case "/receipt":
                    handleReceiptList(request, response);
                    break;
                case "/receipt/create":
                    handleReceiptCreateForm(request, response);
                    break;
                case "/receipt/view":
                    handleReceiptView(request, response);
                    break;
                case "/issue":
                    handleIssueList(request, response);
                    break;
                case "/issue/views":
                    handleIssueViews(request, response);
                    break;
                case "/issue/create":
                    handleIssueCreateForm(request, response);
                    break;
//                case "/report":
//                    handleReport(request, response);
//                    break;
//                case "/alerts":
//                    handleAlerts(request, response);
//                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getPathInfo();
        if (path == null) path = "/item";
        try {
            switch (path) {
                case "/item/create":
                    handleItemCreate(request, response);
                    break;
                case "/item/edit":
                    handleItemEdit(request, response);
                    break;
                case "/item/delete":
                    handleItemDelete(request, response);
                    break;
                case "/category/create":
                    handleCategoryCreate(request, response);
                    break;
                case "/category/edit":
                    handleCategoryEdit(request, response);
                    break;
                case "/category/delete":
                    handleCategoryDelete(request, response);
                    break;
                case "/supplier/create":
                    handleSupplierCreate(request, response);
                    break;
                case "/supplier/edit":
                    handleSupplierEdit(request, response);
                    break;
                case "/supplier/delete":
                    handleSupplierDelete(request, response);
                    break;
                case "/receipt/create":
                    handleReceiptCreate(request, response);
                    break;
//                case "/receipt/delete":
//                    handleReceiptDelete(request, response);
//                    break;
                case "/issue/create":
                    handleIssueCreate(request, response);
                    break;
                case "/issue/delete":
                    handleIssueDelete(request, response);
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


    // ===== ITEM =====
    private void handleItemList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        InventoryItemDAO itemDAO = new InventoryItemDAO();
        InventoryMasterDataDAO masterDAO = new InventoryMasterDataDAO();
        String search = request.getParameter("search");
        Integer categoryId = null;
        Integer supplierId = null;
        try {
            categoryId = request.getParameter("categoryId") != null ? Integer.parseInt(request.getParameter("categoryId")) : null;
        } catch (Exception ignored) {
        }
        try {
            supplierId = request.getParameter("supplierId") != null ? Integer.parseInt(request.getParameter("supplierId")) : null;
        } catch (Exception ignored) {
        }
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
        Boolean isActive = null;
        String isActiveParam = request.getParameter("isActive");
        if (isActiveParam != null && !isActiveParam.isEmpty()) {
            if ("true".equals(isActiveParam)) isActive = true;
            else if ("false".equals(isActiveParam)) isActive = false;
        }
        List<InventoryItem> items = itemDAO.findItems(search, categoryId, supplierId, isActive, page, pageSize);
        int total = itemDAO.countItems(search, categoryId, supplierId, isActive);
        List<InventoryCategory> categories = masterDAO.findCategories(null, true, 1, 100);
        List<Supplier> suppliers = masterDAO.findSuppliers(null, true, 1, 100);
        request.setAttribute("items", items);
        request.setAttribute("categories", categories);
        request.setAttribute("suppliers", suppliers);
        request.setAttribute("total", total);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", pageSize);
        // Bổ sung biến start và end cho phân trang
        int start = total == 0 ? 0 : (page - 1) * pageSize + 1;
        int end = Math.min(page * pageSize, total);
        request.setAttribute("start", start);
        request.setAttribute("end", end);
        int totalPages = (int) Math.ceil((double) total / pageSize);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("isActive", isActiveParam);
        request.getRequestDispatcher("/WEB-INF/view/admin_pages/Inventory/item_list.jsp").forward(request, response);
    }

    private void handleItemCreateForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        InventoryMasterDataDAO masterDAO = new InventoryMasterDataDAO();
        List<InventoryCategory> categories = masterDAO.findCategories(null, true, 1, 100);
        List<Supplier> suppliers = masterDAO.findSuppliers(null, true, 1, 100);
        request.setAttribute("categories", categories);
        request.setAttribute("suppliers", suppliers);
        request.setAttribute("item", new InventoryItem());
        request.setAttribute("formAction", "create");
        request.getRequestDispatcher("/WEB-INF/view/admin_pages/Inventory/item_form.jsp").forward(request, response);
    }

    private void handleItemEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        int editId = Integer.parseInt(request.getParameter("id"));
        InventoryItemDAO itemDAO = new InventoryItemDAO();
        InventoryMasterDataDAO masterDAO = new InventoryMasterDataDAO();
        Optional<InventoryItem> editItem = itemDAO.findItemById(editId);
        if (editItem.isPresent()) {
            List<InventoryCategory> categories = masterDAO.findCategories(null, true, 1, 100);
            List<Supplier> suppliers = masterDAO.findSuppliers(null, true, 1, 100);
            request.setAttribute("categories", categories);
            request.setAttribute("suppliers", suppliers);
            request.setAttribute("item", editItem.get());
            request.setAttribute("formAction", "edit");
            request.getRequestDispatcher("/WEB-INF/view/admin_pages/Inventory/item_form.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/inventory-manager/item");
        }
    }

    private void handleItemCreate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        InventoryItemDAO itemDAO = new InventoryItemDAO();
        InventoryItem newItem = extractItemFromRequest(request);
        itemDAO.addItem(newItem);
        response.sendRedirect(request.getContextPath() + "/inventory-manager/item");
    }

    private void handleItemEdit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        InventoryItemDAO itemDAO = new InventoryItemDAO();
        InventoryItem updateItem = extractItemFromRequest(request);
        updateItem.setInventoryItemId(Integer.parseInt(request.getParameter("id")));
        updateItem.setActive("on".equals(request.getParameter("isActive")));
        itemDAO.updateItem(updateItem);
        response.sendRedirect(request.getContextPath() + "/inventory-manager/item");
    }

    private void handleItemDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        InventoryItemDAO itemDAO = new InventoryItemDAO();
        int deleteId = Integer.parseInt(request.getParameter("id"));
        itemDAO.deleteItem(deleteId);
        response.sendRedirect(request.getContextPath() + "/inventory-manager/item");
    }

    private InventoryItem extractItemFromRequest(HttpServletRequest request) {
        InventoryItem item = new InventoryItem();
        item.setName(request.getParameter("name"));
        try {
            item.setInventoryCategoryId(request.getParameter("inventoryCategoryId") != null ? Integer.parseInt(request.getParameter("inventoryCategoryId")) : null);
        } catch (Exception ignored) {
        }
        try {
            item.setSupplierId(request.getParameter("supplierId") != null ? Integer.parseInt(request.getParameter("supplierId")) : null);
        } catch (Exception ignored) {
        }
        item.setUnit(request.getParameter("unit"));
        try {
            item.setQuantity(Integer.parseInt(request.getParameter("quantity")));
        } catch (Exception ignored) {
            item.setQuantity(0);
        }
        try {
            item.setMinQuantity(Integer.parseInt(request.getParameter("minQuantity")));
        } catch (Exception ignored) {
            item.setMinQuantity(0);
        }
        item.setDescription(request.getParameter("description"));
        item.setActive(true);
        return item;
    }

    // ===== CATEGORY =====
    private void handleCategoryList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        InventoryMasterDataDAO masterDAO = new InventoryMasterDataDAO();
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
        // Lấy filter trạng thái
        Boolean isActive = null;
        String isActiveParam = request.getParameter("isActive");
        if (isActiveParam != null && !isActiveParam.isEmpty()) {
            if ("true".equals(isActiveParam)) isActive = true;
            else if ("false".equals(isActiveParam)) isActive = false;
        }
        List<InventoryCategory> categories = masterDAO.findCategories(search, isActive, page, pageSize);
        int total = masterDAO.countCategories(search, isActive);
        int start = total == 0 ? 0 : (page - 1) * pageSize + 1;
        int end = Math.min(page * pageSize, total);
        int totalPages = (int) Math.ceil((double) total / pageSize);
        request.setAttribute("categories", categories);
        request.setAttribute("total", total);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("start", start);
        request.setAttribute("end", end);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("isActive", isActiveParam);
        request.getRequestDispatcher("/WEB-INF/view/admin_pages/Inventory/category_list.jsp").forward(request, response);
    }

    private void handleCategoryCreateForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        request.setAttribute("category", new InventoryCategory());
        request.setAttribute("formAction", "create");
        request.getRequestDispatcher("/WEB-INF/view/admin_pages/Inventory/category_form.jsp").forward(request, response);
    }

    private void handleCategoryEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        int editId = Integer.parseInt(request.getParameter("id"));
        InventoryMasterDataDAO masterDAO = new InventoryMasterDataDAO();
        Optional<InventoryCategory> editCategory = masterDAO.findCategoryById(editId);
        if (editCategory.isPresent()) {
            request.setAttribute("category", editCategory.get());
            request.setAttribute("formAction", "edit");
            request.getRequestDispatcher("/WEB-INF/view/admin_pages/Inventory/category_form.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/inventory-manager/category");
        }
    }

    private void handleCategoryCreate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        InventoryMasterDataDAO masterDAO = new InventoryMasterDataDAO();
        InventoryCategory category = extractCategoryFromRequest(request);
        masterDAO.addCategory(category);
        response.sendRedirect(request.getContextPath() + "/inventory-manager/category");
    }

    private void handleCategoryEdit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        InventoryMasterDataDAO masterDAO = new InventoryMasterDataDAO();
        InventoryCategory category = extractCategoryFromRequest(request);
        category.setInventoryCategoryId(Integer.parseInt(request.getParameter("id")));
        category.setActive("on".equals(request.getParameter("isActive")));
        masterDAO.updateCategory(category);
        response.sendRedirect(request.getContextPath() + "/inventory-manager/category");
    }

    private void handleCategoryDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        InventoryMasterDataDAO masterDAO = new InventoryMasterDataDAO();
        int deleteId = Integer.parseInt(request.getParameter("id"));
        masterDAO.deleteCategory(deleteId);
        response.sendRedirect(request.getContextPath() + "/inventory-manager/category");
    }

    private InventoryCategory extractCategoryFromRequest(HttpServletRequest request) {
        InventoryCategory category = new InventoryCategory();
        category.setName(request.getParameter("name"));
        category.setDescription(request.getParameter("description"));
        category.setActive(true);
        return category;
    }

    // ===== SUPPLIER =====
    private void handleSupplierList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        InventoryMasterDataDAO masterDAO = new InventoryMasterDataDAO();
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
        // Lấy filter trạng thái
        Boolean isActive = null;
        String isActiveParam = request.getParameter("isActive");
        if (isActiveParam != null && !isActiveParam.isEmpty()) {
            if ("true".equals(isActiveParam)) isActive = true;
            else if ("false".equals(isActiveParam)) isActive = false;
        }
        List<Supplier> suppliers = masterDAO.findSuppliers(search, isActive, page, pageSize);
        int total = masterDAO.countSuppliers(search, isActive);
        int start = total == 0 ? 0 : (page - 1) * pageSize + 1;
        int end = Math.min(page * pageSize, total);
        int totalPages = (int) Math.ceil((double) total / pageSize);
        request.setAttribute("suppliers", suppliers);
        request.setAttribute("total", total);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("start", start);
        request.setAttribute("end", end);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("isActive", isActiveParam);
        request.getRequestDispatcher("/WEB-INF/view/admin_pages/Inventory/supplier_list.jsp").forward(request, response);
    }

    private void handleSupplierCreateForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        request.setAttribute("supplier", new Supplier());
        request.setAttribute("formAction", "create");
        request.getRequestDispatcher("/WEB-INF/view/admin_pages/Inventory/supplier_form.jsp").forward(request, response);
    }

    private void handleSupplierEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        int editId = Integer.parseInt(request.getParameter("id"));
        InventoryMasterDataDAO masterDAO = new InventoryMasterDataDAO();
        Optional<Supplier> editSupplier = masterDAO.findSupplierById(editId);
        if (editSupplier.isPresent()) {
            request.setAttribute("supplier", editSupplier.get());
            request.setAttribute("formAction", "edit");
            request.getRequestDispatcher("/WEB-INF/view/admin_pages/Inventory/supplier_form.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/inventory-manager/supplier");
        }
    }

    private void handleSupplierCreate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        InventoryMasterDataDAO masterDAO = new InventoryMasterDataDAO();
        Supplier supplier = extractSupplierFromRequest(request);
        masterDAO.addSupplier(supplier);
        response.sendRedirect(request.getContextPath() + "/inventory-manager/supplier");
    }

    private void handleSupplierEdit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        InventoryMasterDataDAO masterDAO = new InventoryMasterDataDAO();
        Supplier supplier = extractSupplierFromRequest(request);
        supplier.setSupplierId(Integer.parseInt(request.getParameter("id")));
        supplier.setActive("on".equals(request.getParameter("isActive")));
        masterDAO.updateSupplier(supplier);
        response.sendRedirect(request.getContextPath() + "/inventory-manager/supplier");
    }

    private void handleSupplierDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        InventoryMasterDataDAO masterDAO = new InventoryMasterDataDAO();
        int deleteId = Integer.parseInt(request.getParameter("id"));
        masterDAO.deleteSupplier(deleteId);
        response.sendRedirect(request.getContextPath() + "/inventory-manager/supplier");
    }

    private Supplier extractSupplierFromRequest(HttpServletRequest request) {
        Supplier supplier = new Supplier();
        supplier.setName(request.getParameter("name"));
        supplier.setContactInfo(request.getParameter("contactInfo"));
        supplier.setActive(true);
        return supplier;
    }

    // ===== RECEIPT =====
    private void handleReceiptList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        InventoryReceiptDAO receiptDAO = new InventoryReceiptDAO();
        InventoryMasterDataDAO masterDAO = new InventoryMasterDataDAO();
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
        List<InventoryReceipt> receipts = receiptDAO.findReceipts(search, null, null, null, null, page, pageSize);
        receipts.forEach(receipt -> {
            try {
                masterDAO.findSupplierById(receipt.getSupplierId()).ifPresent(
                        receipt::setSupplier
                );
                userDAO.findById(receipt.getCreatedBy()).ifPresent(
                        receipt::setUser
                );
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }

        });
        int total = receiptDAO.countReceipts(search, null, null, null, null);
        request.setAttribute("receipts", receipts);
        request.setAttribute("total", total);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("search", search);
        request.getRequestDispatcher("/WEB-INF/view/admin_pages/Inventory/receipt_list.jsp").forward(request, response);
    }


    private void handleReceiptView(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        String id = request.getParameter("id");
        InventoryMasterDataDAO masterDAO = new InventoryMasterDataDAO();
        InventoryReceiptDAO receiptDAO = new InventoryReceiptDAO();
        UserDAO userDAO = new UserDAO();
        receiptDAO.findReceiptById(Integer.parseInt(id)).ifPresent(receipt -> {
            request.setAttribute("receipt", receipt);
            try {
                masterDAO.findSupplierById(receipt.getSupplierId()).ifPresent(
                        receipt::setSupplier
                );
                userDAO.findById(receipt.getCreatedBy()).ifPresent(
                        receipt::setUser
                );
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }

        });

        List<InventoryReceiptDetail> receiptDetailsByReceiptId = receiptDAO.getReceiptDetailsByReceiptId(Integer.parseInt(id));
        request.setAttribute("receiptDetails", receiptDetailsByReceiptId);
        request.getRequestDispatcher("/WEB-INF/view/admin_pages/Inventory/receipt_views.jsp").forward(request, response);
    }

    private void handleReceiptCreateForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        InventoryItemDAO itemDAO = new InventoryItemDAO();
        InventoryMasterDataDAO masterDAO = new InventoryMasterDataDAO();
        List<InventoryItem> items = itemDAO.findItems(null, null, null, true, 1, 100);
        List<Supplier> suppliers = masterDAO.findSuppliers(null, true, 1, 100);
        request.setAttribute("items", items);
        request.setAttribute("suppliers", suppliers);
        request.setAttribute("formAction", "create");
        request.getRequestDispatcher("/WEB-INF/view/admin_pages/Inventory/receipt_form.jsp").forward(request, response);
    }

    private void handleReceiptCreate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession(false);
        InventoryReceiptDAO receiptDAO = new InventoryReceiptDAO();
        // Xử lý encoding
        request.setCharacterEncoding("UTF-8");

        User user = (User) session.getAttribute("user");


        // Parse ngày tháng
        String dateStr = request.getParameter("receiptDate");
        LocalDate receiptDate = LocalDate.parse(dateStr);

        // Lấy các tham số cơ bản
        String supplierIdStr = request.getParameter("supplierId");
        String note = request.getParameter("note");

        int supplierId = Integer.parseInt(supplierIdStr);

        // Tạo đối tượng Receipt
        InventoryReceipt receipt = new InventoryReceipt();
        receipt.setReceiptDate(Date.valueOf(receiptDate));
        receipt.setSupplierId(supplierId);
        receipt.setNote(note);
        receipt.setCreatedAt(new Timestamp(System.currentTimeMillis()));
        receipt.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
        receipt.setCreatedBy(user.getUserId());


        InventoryReceipt inventoryReceipt = receiptDAO.addReceipt(receipt);

        // Nếu là edit
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            receipt.setInventoryReceiptId(Integer.parseInt(idStr));
        }

        // Parse danh sách chi tiết vật tư
        List<InventoryReceiptDetail> detailList = new ArrayList<>();

        String[] itemIds = request.getParameterValues("details[0].inventoryItemId");
        int index = 0;
        while (true) {
            String prefix = "details[" + index + "]";
            String itemIdStr = request.getParameter(prefix + ".inventoryItemId");
            if (itemIdStr == null) break;

            String quantityStr = request.getParameter(prefix + ".quantity");
            String unitPriceStr = request.getParameter(prefix + ".unitPrice");
            String detailNote = request.getParameter(prefix + ".note");

            InventoryReceiptDetail detail = new InventoryReceiptDetail();
            detail.setInventoryItemId(Integer.parseInt(itemIdStr));
            detail.setQuantity(Integer.parseInt(quantityStr));
            detail.setUnitPrice(Double.parseDouble(unitPriceStr));
            detail.setNote(detailNote);
            detailList.add(detail);
            index++;
        }
        receiptDAO.addReceiptDetails(inventoryReceipt.getInventoryReceiptId(), detailList);

        response.sendRedirect(request.getContextPath() + "/inventory-manager/receipt");
    }
//

    //
//    // ===== ISSUE =====
    private void handleIssueList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
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
            issue.setOwner(issue.getRequestedBy() == user.getUserId());
        });
        int total = issueDAO.countIssues(search);
        request.setAttribute("issues", issues);
        request.setAttribute("total", total);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("search", search);
        request.getRequestDispatcher("/WEB-INF/view/admin_pages/Inventory/issue_list.jsp").forward(request, response);
    }

    private void handleIssueCreateForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        InventoryItemDAO itemDAO = new InventoryItemDAO();
        InventoryMasterDataDAO masterDAO = new InventoryMasterDataDAO();
        BookingDAO bookingDAO = new BookingDAO();
        List<model.Booking> booking = bookingDAO.findAll();
        List<InventoryItem> items = itemDAO.findItems(null, null, null, true, 1, 100);
        List<Supplier> suppliers = masterDAO.findSuppliers(null, true, 1, 100);
        request.setAttribute("items", items);
        request.setAttribute("suppliers", suppliers);
        request.setAttribute("bookingAppointments", booking);
        request.getRequestDispatcher("/WEB-INF/view/admin_pages/Inventory/issue_form.jsp").forward(request, response);
    }

    private void handleIssueCreate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession(false);
        request.setCharacterEncoding("UTF-8");
        InventoryIssueDAO issueDAO = new InventoryIssueDAO();

        // Parse thông tin phiếu xuất
        String issueDateStr = request.getParameter("issueDate");
        String bookingAppointmentIdStr = request.getParameter("bookingAppointmentId");
        String status = request.getParameter("status");
        String note = request.getParameter("note");

        java.sql.Date issueDate = java.sql.Date.valueOf(issueDateStr);
        Integer bookingAppointmentId = (bookingAppointmentIdStr == null || bookingAppointmentIdStr.isEmpty())
                ? null : Integer.parseInt(bookingAppointmentIdStr);

        // Giả sử lấy user id từ session (có thể sửa tuỳ hệ thống bạn)
        User user = (User) session.getAttribute("user");

        InventoryIssue issue = new InventoryIssue();
        issue.setIssueDate(issueDate);
        issue.setBookingAppointmentId(bookingAppointmentId);
        issue.setRequestedBy(user.getUserId());
        issue.setStatus(status);
        issue.setApprovedBy(1);
        issue.setNote(note);
        issue.setCreatedAt(new Timestamp(System.currentTimeMillis()));

        InventoryIssue inventoryIssue = issueDAO.addIssue(issue);

        // Parse danh sách chi tiết
        List<InventoryIssueDetail> details = new ArrayList<>();
        int index = 0;

        while (true) {
            String itemIdParam = request.getParameter("details[" + index + "].inventoryItemId");
            if (itemIdParam == null) break; // Kết thúc danh sách
            String quantityParam = request.getParameter("details[" + index + "].quantity");
            String detailNote = request.getParameter("details[" + index + "].note");
            InventoryIssueDetail detail = new InventoryIssueDetail();
            detail.setInventoryItemId(Integer.parseInt(itemIdParam));
            detail.setQuantity(Integer.parseInt(quantityParam));
            detail.setNote(detailNote);
            details.add(detail);
            index++;
        }
        // Lưu vào DB (giả định DAO đã hỗ trợ)
        issueDAO.addIssueDetails(inventoryIssue.getInventoryIssueId(), details);

        // Chuyển hướng sau khi lưu thành công
        response.sendRedirect(request.getContextPath() + "/inventory-manager/issue");
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
        request.getRequestDispatcher("/WEB-INF/view/admin_pages/Inventory/issue_views.jsp").forward(request, response);
    }

    private void handleIssueDelete(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        String id = request.getParameter("id");
        InventoryIssueDAO issueDAO = new InventoryIssueDAO();
        issueDAO.deleteIssue(Integer.parseInt(id));
        response.sendRedirect(request.getContextPath() + "/inventory-manager/issue");
    }
//
//    private InventoryIssue extractIssueFromRequest(HttpServletRequest request) {
//        InventoryIssue issue = new InventoryIssue();
//        try { issue.setSupplierId(request.getParameter("supplierId") != null ? Integer.parseInt(request.getParameter("supplierId")) : null); } catch (Exception ignored) {}
//        issue.setNote(request.getParameter("note"));
//        // Các trường khác như date, status... có thể bổ sung nếu cần
//        return issue;
//    }
//
//    // ===== REPORT =====
//    private void handleReport(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
//        InventoryItemDAO itemDAO = new InventoryItemDAO();
//        // Tổng hợp tồn kho, nhập, xuất, cảnh báo
//        List<InventoryItem> lowStockItems = itemDAO.findLowStockItems();
//        // TODO: Có thể bổ sung thêm các báo cáo khác nếu cần
//        request.setAttribute("lowStockItems", lowStockItems);
//        request.getRequestDispatcher("/WEB-INF/view/admin_pages/Inventory/report.jsp").forward(request, response);
//    }
//
//    // ===== ALERTS =====
//    private void handleAlerts(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
//        InventoryItemDAO itemDAO = new InventoryItemDAO();
//        List<InventoryItem> lowStockItems = itemDAO.findLowStockItems();
//        request.setAttribute("lowStockItems", lowStockItems);
//        request.getRequestDispatcher("/WEB-INF/view/admin_pages/Inventory/alerts.jsp").forward(request, response);
//    }
//    private void handleAlertsUpdate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
//        // Cập nhật ngưỡng cảnh báo vật tư sắp hết
//        InventoryItemDAO itemDAO = new InventoryItemDAO();
//        int itemId = Integer.parseInt(request.getParameter("id"));
//        int minQuantity = Integer.parseInt(request.getParameter("minQuantity"));
//        Optional<InventoryItem> itemOpt = itemDAO.findItemById(itemId);
//        if (itemOpt.isPresent()) {
//            InventoryItem item = itemOpt.get();
//            item.setMinQuantity(minQuantity);
//            itemDAO.updateItem(item);
//        }
//        response.sendRedirect(request.getContextPath() + "/inventory-manager/alerts");
//    }
} 