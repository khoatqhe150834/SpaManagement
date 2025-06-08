<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="db.DBContext" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%!
    // Helper method to execute SQL and return results
    public List<Map<String, Object>> executeQuery(String sql, Object... params) {
        List<Map<String, Object>> results = new ArrayList<>();
        try {
            Connection conn = DBContext.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            
            for (int i = 0; i < params.length; i++) {
                ps.setObject(i + 1, params[i]);
            }
            
            ResultSet rs = ps.executeQuery();
            ResultSetMetaData meta = rs.getMetaData();
            int columnCount = meta.getColumnCount();
            
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                for (int i = 1; i <= columnCount; i++) {
                    row.put(meta.getColumnLabel(i), rs.getObject(i));
                }
                results.add(row);
            }
            
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return results;
    }
    
    // Helper method to execute update/insert/delete
    public boolean executeUpdate(String sql, Object... params) {
        try {
            Connection conn = DBContext.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            
            for (int i = 0; i < params.length; i++) {
                ps.setObject(i + 1, params[i]);
            }
            
            int result = ps.executeUpdate();
            ps.close();
            conn.close();
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
%>

<%
    String action = request.getParameter("action");
    String message = "";
    String error = "";
    
    // Handle CRUD operations
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        if ("add".equals(action)) {
            try {
                String title = request.getParameter("title");
                String code = request.getParameter("promotionCode");
                String type = request.getParameter("discountType");
                String value = request.getParameter("discountValue");
                String status = request.getParameter("status");
                String description = request.getParameter("description");
                
                String sql = "INSERT INTO promotions (title, promotion_code, discount_type, discount_value, status, description, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";
                boolean success = executeUpdate(sql, title, code, type, new BigDecimal(value), status, description);
                
                if (success) {
                    message = "Promotion added successfully!";
                } else {
                    error = "Failed to add promotion.";
                }
            } catch (Exception e) {
                error = "Error adding promotion: " + e.getMessage();
            }
        } else if ("edit".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                String title = request.getParameter("title");
                String code = request.getParameter("promotionCode");
                String type = request.getParameter("discountType");
                String value = request.getParameter("discountValue");
                String status = request.getParameter("status");
                String description = request.getParameter("description");
                
                String sql = "UPDATE promotions SET title=?, promotion_code=?, discount_type=?, discount_value=?, status=?, description=?, updated_at=GETDATE() WHERE promotion_id=?";
                boolean success = executeUpdate(sql, title, code, type, new BigDecimal(value), status, description, id);
                
                if (success) {
                    message = "Promotion updated successfully!";
                } else {
                    error = "Failed to update promotion.";
                }
            } catch (Exception e) {
                error = "Error updating promotion: " + e.getMessage();
            }
        }
    } else if ("GET".equalsIgnoreCase(request.getMethod())) {
        if ("delete".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                String sql = "DELETE FROM promotions WHERE promotion_id = ?";
                boolean success = executeUpdate(sql, id);
                
                if (success) {
                    message = "Promotion deleted successfully!";
                } else {
                    error = "Failed to delete promotion.";
                }
            } catch (Exception e) {
                error = "Error deleting promotion: " + e.getMessage();
            }
        }
    }
    
    // Load promotions based on search and sort
    String keyword = request.getParameter("keyword");
    String sortBy = request.getParameter("sortBy");
    String sortOrder = request.getParameter("sortOrder");
    
    String sql = "SELECT * FROM promotions";
    List<Object> params = new ArrayList<>();
    
    if (keyword != null && !keyword.trim().isEmpty()) {
        sql += " WHERE title LIKE ? OR promotion_code LIKE ? OR promotion_id = ?";
        String searchPattern = "%" + keyword + "%";
        params.add(searchPattern);
        params.add(searchPattern);
        try {
            params.add(Integer.parseInt(keyword));
        } catch (NumberFormatException e) {
            params.add(-1); // Will not match any ID
        }
    }
    
    if (sortBy != null && !sortBy.isEmpty()) {
        sql += " ORDER BY " + sortBy;
        if ("desc".equalsIgnoreCase(sortOrder)) {
            sql += " DESC";
        } else {
            sql += " ASC";
        }
    } else {
        sql += " ORDER BY created_at DESC";
    }
    
    List<Map<String, Object>> promotions = executeQuery(sql, params.toArray());
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>🎁 Promotion CRUD Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .action-btn {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            border: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
            cursor: pointer;
            margin: 0 2px;
            transition: all 0.3s ease;
        }
        .action-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        .btn-edit {
            background: #fef3c7;
            color: #d97706;
        }
        .btn-delete {
            background: #fee2e2;
            color: #dc2626;
        }
        .discount-badge {
            font-size: 11px;
            padding: 3px 6px;
            border-radius: 4px;
            font-weight: 500;
        }
        .status-badge {
            font-size: 10px;
            padding: 3px 6px;
            border-radius: 8px;
            font-weight: 500;
        }
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
        }
        .modal-content {
            background-color: #fefefe;
            margin: 5% auto;
            padding: 20px;
            border: none;
            border-radius: 8px;
            width: 80%;
            max-width: 600px;
        }
        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }
        .close:hover {
            color: black;
        }
    </style>
</head>
<body>
    <div class="container-fluid p-4">
        <h2>🎁 Promotion CRUD Management</h2>
        
        <!-- Messages -->
        <% if (!message.isEmpty()) { %>
            <div class="alert alert-success alert-dismissible fade show">
                <%= message %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>
        
        <% if (!error.isEmpty()) { %>
            <div class="alert alert-danger alert-dismissible fade show">
                <%= error %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>
        
        <!-- Search and Controls -->
        <div class="row mb-4">
            <div class="col-md-8">
                <form method="get" class="d-flex gap-2">
                    <input type="text" name="keyword" class="form-control" placeholder="🔍 Search by title, code or ID..." value="<%= keyword != null ? keyword : "" %>">
                    <button type="submit" class="btn btn-primary">Search</button>
                    <% if (keyword != null && !keyword.trim().isEmpty()) { %>
                        <a href="promotion-crud.jsp" class="btn btn-secondary">Clear</a>
                    <% } %>
                </form>
            </div>
            <div class="col-md-4 text-end">
                <button onclick="openAddModal()" class="btn btn-success">➕ Add New Promotion</button>
            </div>
        </div>
        
        <!-- Sort Controls -->
        <div class="row mb-3">
            <div class="col-12">
                <form method="get" class="d-flex gap-2 align-items-center">
                    <% if (keyword != null && !keyword.trim().isEmpty()) { %>
                        <input type="hidden" name="keyword" value="<%= keyword %>">
                    <% } %>
                    <label>Sort by:</label>
                    <select name="sortBy" class="form-select form-select-sm" style="width: auto;">
                        <option value="created_at" <%= "created_at".equals(sortBy) ? "selected" : "" %>>📅 Created Date</option>
                        <option value="title" <%= "title".equals(sortBy) ? "selected" : "" %>>📝 Title</option>
                        <option value="promotion_code" <%= "promotion_code".equals(sortBy) ? "selected" : "" %>>🏷️ Code</option>
                        <option value="discount_value" <%= "discount_value".equals(sortBy) ? "selected" : "" %>>💰 Discount</option>
                        <option value="status" <%= "status".equals(sortBy) ? "selected" : "" %>>📊 Status</option>
                    </select>
                    <select name="sortOrder" class="form-select form-select-sm" style="width: auto;">
                        <option value="asc" <%= "asc".equals(sortOrder) ? "selected" : "" %>>↗️ Ascending</option>
                        <option value="desc" <%= "desc".equals(sortOrder) ? "selected" : "" %>>↘️ Descending</option>
                    </select>
                    <button type="submit" class="btn btn-sm btn-outline-primary">Sort</button>
                </form>
            </div>
        </div>
        
        <!-- Promotions Table -->
        <div class="table-responsive">
            <table class="table table-striped table-hover">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>🎁 Title</th>
                        <th>🎫 Code</th>
                        <th>💰 Discount</th>
                        <th>📊 Status</th>
                        <th>📝 Description</th>
                        <th>📅 Created</th>
                        <th class="text-center">⚙️ Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (promotions.isEmpty()) { %>
                        <tr>
                            <td colspan="8" class="text-center py-5">
                                <div style="font-size: 48px;">🎁</div>
                                <p class="text-muted">No promotions found.</p>
                                <button onclick="openAddModal()" class="btn btn-primary">Add First Promotion</button>
                            </td>
                        </tr>
                    <% } else {
                        for (Map<String, Object> promo : promotions) { %>
                        <tr>
                            <td><span class="fw-bold text-primary">#<%= promo.get("promotion_id") %></span></td>
                            <td><strong><%= promo.get("title") %></strong></td>
                            <td><code><%= promo.get("promotion_code") %></code></td>
                            <td>
                                <% 
                                String discountType = (String) promo.get("discount_type");
                                BigDecimal discountValue = (BigDecimal) promo.get("discount_value");
                                if ("percentage".equals(discountType)) { %>
                                    <span class="discount-badge bg-success text-white"><%= discountValue %>% OFF</span>
                                <% } else { %>
                                    <span class="discount-badge bg-primary text-white">$<%= discountValue %> OFF</span>
                                <% } %>
                            </td>
                            <td>
                                <% String status = (String) promo.get("status");
                                if ("active".equals(status)) { %>
                                    <span class="status-badge bg-success text-white">✅ Active</span>
                                <% } else { %>
                                    <span class="status-badge bg-secondary text-white">❌ Inactive</span>
                                <% } %>
                            </td>
                            <td>
                                <% String desc = (String) promo.get("description");
                                if (desc != null && desc.length() > 50) { %>
                                    <%= desc.substring(0, 50) %>...
                                <% } else { %>
                                    <%= desc != null ? desc : "" %>
                                <% } %>
                            </td>
                            <td>
                                <small><%= new java.text.SimpleDateFormat("MMM dd, yyyy").format((java.util.Date) promo.get("created_at")) %></small>
                            </td>
                            <td class="text-center">
                                <button onclick="editPromotion(<%= promo.get("promotion_id") %>, '<%= promo.get("title") %>', '<%= promo.get("promotion_code") %>', '<%= promo.get("discount_type") %>', '<%= promo.get("discount_value") %>', '<%= promo.get("status") %>', '<%= promo.get("description") != null ? promo.get("description").toString().replace("'", "\\'") : "" %>')" 
                                       class="action-btn btn-edit" title="Edit">✏️</button>
                                <button onclick="confirmDelete(<%= promo.get("promotion_id") %>, '<%= promo.get("title") %>')" 
                                       class="action-btn btn-delete" title="Delete">🗑️</button>
                            </td>
                        </tr>
                    <% }
                    } %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Add/Edit Modal -->
    <div id="promotionModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal()">&times;</span>
            <h4 id="modalTitle">➕ Add New Promotion</h4>
            <form id="promotionForm" method="post">
                <input type="hidden" name="action" id="formAction" value="add">
                <input type="hidden" name="id" id="promotionId">
                
                <div class="row">
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label class="form-label">🏷️ Title *</label>
                            <input type="text" class="form-control" name="title" id="title" required>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label class="form-label">🎫 Promotion Code *</label>
                            <input type="text" class="form-control" name="promotionCode" id="promotionCode" required>
                        </div>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-md-4">
                        <div class="mb-3">
                            <label class="form-label">💰 Discount Type *</label>
                            <select class="form-select" name="discountType" id="discountType" required>
                                <option value="">Select Type</option>
                                <option value="percentage">Percentage (%)</option>
                                <option value="fixed">Fixed Amount ($)</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="mb-3">
                            <label class="form-label">💵 Discount Value *</label>
                            <input type="number" class="form-control" name="discountValue" id="discountValue" step="0.01" required>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="mb-3">
                            <label class="form-label">📊 Status *</label>
                            <select class="form-select" name="status" id="status" required>
                                <option value="">Select Status</option>
                                <option value="active">✅ Active</option>
                                <option value="inactive">❌ Inactive</option>
                            </select>
                        </div>
                    </div>
                </div>
                
                <div class="mb-3">
                    <label class="form-label">📝 Description</label>
                    <textarea class="form-control" name="description" id="description" rows="3"></textarea>
                </div>
                
                <div class="text-end">
                    <button type="button" class="btn btn-secondary" onclick="closeModal()">Cancel</button>
                    <button type="submit" class="btn btn-primary" id="submitBtn">Save Promotion</button>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    
    <script>
        function openAddModal() {
            document.getElementById('modalTitle').textContent = '➕ Add New Promotion';
            document.getElementById('formAction').value = 'add';
            document.getElementById('promotionForm').reset();
            document.getElementById('promotionId').value = '';
            document.getElementById('submitBtn').textContent = 'Add Promotion';
            document.getElementById('promotionModal').style.display = 'block';
        }
        
        function editPromotion(id, title, code, type, value, status, description) {
            document.getElementById('modalTitle').textContent = '✏️ Edit Promotion #' + id;
            document.getElementById('formAction').value = 'edit';
            document.getElementById('promotionId').value = id;
            document.getElementById('title').value = title;
            document.getElementById('promotionCode').value = code;
            document.getElementById('discountType').value = type;
            document.getElementById('discountValue').value = value;
            document.getElementById('status').value = status;
            document.getElementById('description').value = description;
            document.getElementById('submitBtn').textContent = 'Update Promotion';
            document.getElementById('promotionModal').style.display = 'block';
        }
        
        function closeModal() {
            document.getElementById('promotionModal').style.display = 'none';
        }
        
        function confirmDelete(id, title) {
            Swal.fire({
                title: '🗑️ Confirm Delete',
                html: 'Are you sure you want to delete:<br><strong>"' + title + '"</strong>',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#dc3545',
                cancelButtonColor: '#6c757d',
                confirmButtonText: '✅ Yes, delete it!',
                cancelButtonText: '❌ Cancel'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = 'promotion-crud.jsp?action=delete&id=' + id;
                }
            });
        }
        
        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('promotionModal');
            if (event.target == modal) {
                closeModal();
            }
        }
        
        // Auto-dismiss alerts
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                if (alert.classList.contains('show')) {
                    const bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                }
            });
        }, 5000);
    </script>
</body>
</html> 