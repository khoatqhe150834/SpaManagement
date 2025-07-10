<%--
    Document   : sidebar.jsp
    Modernized with admin-sidebar design while preserving business logic
    Author     : G1_SpaManagement Team
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="model.User, model.Customer, model.RoleConstants, java.util.List, model.MenuService, model.MenuService.MenuItem" %>

<%
    // --- User and Role Detection Logic (Preserved) ---
    String userRole = "GUEST"; // Default role
    Object userObject = null;
    
    // Fallback to session attributes if request attributes are not set
    if (session.getAttribute("user") != null) {
        userObject = session.getAttribute("user");
    } else if (session.getAttribute("customer") != null) {
        userObject = session.getAttribute("customer");
    }

    String fullName = "Guest User";
    String email = "guest@example.com";
    String avatarUrl = null; // Initialize as null to handle empty case better

    if (userObject instanceof User) {
        User user = (User) userObject;
        userRole = RoleConstants.getUserTypeFromRole(user.getRoleId());
        fullName = user.getFullName();
        email = user.getEmail();
        String userAvatar = user.getAvatarUrl();
        if (userAvatar != null && !userAvatar.trim().isEmpty()) {
            // Handle both absolute URLs and relative paths
            if (userAvatar.startsWith("http://") || userAvatar.startsWith("https://")) {
                avatarUrl = userAvatar;
            } else {
                avatarUrl = request.getContextPath() + (userAvatar.startsWith("/") ? "" : "/") + userAvatar;
            }
        }
    } else if (userObject instanceof Customer) {
        Customer customer = (Customer) userObject;
        userRole = "CUSTOMER";
        fullName = customer.getFullName();
        email = customer.getEmail();
        String customerAvatar = customer.getAvatarUrl();
        if (customerAvatar != null && !customerAvatar.trim().isEmpty()) {
            // Handle both absolute URLs and relative paths
            if (customerAvatar.startsWith("http://") || customerAvatar.startsWith("https://")) {
                avatarUrl = customerAvatar;
            } else {
                avatarUrl = request.getContextPath() + (customerAvatar.startsWith("/") ? "" : "/") + customerAvatar;
            }
        }
    }

    // Set default avatar if none is provided
    if (avatarUrl == null || avatarUrl.trim().isEmpty()) {
        avatarUrl = request.getContextPath() + "/assets/home/images/default-avatar.png";
    }

    pageContext.setAttribute("userRole", userRole);
    pageContext.setAttribute("contextPath", request.getContextPath());
    pageContext.setAttribute("fullName", fullName);
    pageContext.setAttribute("email", email);
    pageContext.setAttribute("avatarUrl", avatarUrl);
%>

<!-- Modern Admin Sidebar with Preserved Business Logic -->
<div class="fixed left-0 top-0 w-64 h-full bg-spa-cream p-4 z-50 sidebar-menu transition-transform border-r border-primary/20">
    <a href="${pageContext.request.contextPath}/dashboard" class="flex items-center pb-4 border-b border-primary/30">
        <h2 class="font-bold text-2xl text-spa-dark">Spa <span class="bg-primary text-white px-2 rounded-md">Hương Sen</span></h2>
    </a>
    
    <div class="mt-4">
        <!-- Dynamic Role-Based Navigation (Preserved Business Logic) -->
            <c:choose>
            <%-- ============================ CUSTOMER NAVIGATION ============================ --%>
                <c:when test="${userRole == 'CUSTOMER'}">
                <span class="text-primary/70 font-bold text-xs uppercase tracking-wider">KHÁCH HÀNG</span>
                <ul class="mt-2">
                    <li class="mb-1 group">
                        <a href="${pageContext.request.contextPath}/dashboard" class="flex font-medium items-center py-2 px-4 text-spa-dark hover:bg-primary hover:text-white rounded-lg group-[.active]:bg-primary group-[.active]:text-white transition-all duration-200">
                            <i data-lucide="layout-dashboard" class="mr-3 h-4 w-4"></i>
                            <span class="text-sm">Dashboard</span>
                        </a>
                    </li>
                    <li class="mb-1 group">
                        <a href="${pageContext.request.contextPath}/customer/view" class="flex font-medium items-center py-2 px-4 text-spa-dark hover:bg-primary hover:text-white rounded-lg transition-all duration-200">
                            <i data-lucide="calendar" class="mr-3 h-4 w-4"></i>
                            <span class="text-sm">Lịch hẹn của tôi</span>
                            <span class="md:block px-2 py-0.5 ml-auto text-xs font-medium tracking-wide text-white bg-yellow-500 rounded-full">3</span>
                        </a>
                    </li>
                    <li class="mb-1 group">
                        <a href="${pageContext.request.contextPath}/booking" class="flex font-medium items-center py-2 px-4 text-spa-dark hover:bg-primary hover:text-white rounded-lg transition-all duration-200">
                            <i data-lucide="calendar-plus" class="mr-3 h-4 w-4"></i>
                            <span class="text-sm">Đặt dịch vụ</span>
                        </a>
                    </li>
                    <li class="mb-1 group">
                        <a href="${pageContext.request.contextPath}/customer/history" class="flex font-medium items-center py-2 px-4 text-spa-dark hover:bg-primary hover:text-white rounded-lg transition-all duration-200">
                            <i data-lucide="history" class="mr-3 h-4 w-4"></i>
                            <span class="text-sm">Lịch sử điều trị</span>
                        </a>
                    </li>
                    <li class="mb-1 group">
                        <a href="${pageContext.request.contextPath}/customer/loyalty" class="flex font-medium items-center py-2 px-4 text-spa-dark hover:bg-primary hover:text-white rounded-lg transition-all duration-200">
                            <i data-lucide="gift" class="mr-3 h-4 w-4"></i>
                            <span class="text-sm">Điểm tích lũy</span>
                            <span class="md:block px-2 py-0.5 ml-auto text-xs font-medium tracking-wide text-white bg-yellow-500 rounded-full">2,450</span>
                        </a>
                    </li>
                    <li class="mb-1 group">
                        <a href="${pageContext.request.contextPath}/customer/payments" class="flex font-medium items-center py-2 px-4 text-spa-dark hover:bg-primary hover:text-white rounded-lg transition-all duration-200">
                            <i data-lucide="credit-card" class="mr-3 h-4 w-4"></i>
                            <span class="text-sm">Lịch sử thanh toán</span>
                        </a>
                    </li>
                    <li class="mb-1 group">
                        <a href="${pageContext.request.contextPath}/promotions" class="flex font-medium items-center py-2 px-4 text-spa-dark hover:bg-primary hover:text-white rounded-lg transition-all duration-200">
                            <i data-lucide="star" class="mr-3 h-4 w-4"></i>
                            <span class="text-sm">Ưu đãi đặc biệt</span>
                            <span class="bg-red-500 text-white text-xs font-semibold px-2 py-0.5 rounded-full animate-pulse">Mới</span>
                        </a>
                    </li>
                </ul>
                
                <span class="text-primary/70 font-bold text-xs uppercase tracking-wider mt-4 block">CÁ NHÂN</span>
                <ul class="mt-2">
                    <li class="mb-1 group">
                        <a href="${pageContext.request.contextPath}/profile" class="flex font-medium items-center py-2 px-4 text-spa-dark hover:bg-primary hover:text-white rounded-lg transition-all duration-200">
                            <i data-lucide="user-cog" class="mr-3 h-4 w-4"></i>
                            <span class="text-sm">Hồ sơ cá nhân</span>
                        </a>
                    </li>
                    <li class="mb-1 group">
                        <a href="${pageContext.request.contextPath}/password/change" class="flex font-medium items-center py-2 px-4 text-spa-dark hover:bg-primary hover:text-white rounded-lg transition-all duration-200">
                            <i data-lucide="key" class="mr-3 h-4 w-4"></i>
                            <span class="text-sm">Đổi mật khẩu</span>
                        </a>
                    </li>
                </ul>
                </c:when>

            <%-- ============================ ADMIN/MANAGER NAVIGATION ============================ --%>
            <c:when test="${userRole == 'ADMIN' || userRole == 'MANAGER'}">
                <span class="text-primary/70 font-bold text-xs uppercase tracking-wider">QUẢN LÝ</span>
                <ul class="mt-2">
                    <li class="mb-1 group">
                        <a href="${pageContext.request.contextPath}/dashboard" class="flex font-medium items-center py-2 px-4 text-spa-dark hover:bg-primary hover:text-white rounded-lg group-[.active]:bg-primary group-[.active]:text-white transition-all duration-200">
                            <i data-lucide="layout-dashboard" class="mr-3 h-4 w-4"></i>
                            <span class="text-sm">Dashboard</span>
                        </a>
                    </li>
                    <li class="mb-1 group">
                        <a href="${pageContext.request.contextPath}/user/list" class="flex font-medium items-center py-2 px-4 text-spa-dark hover:bg-primary hover:text-white rounded-lg sidebar-dropdown-toggle transition-all duration-200">
                            <i data-lucide="users" class="mr-3 h-4 w-4"></i>                
                            <span class="text-sm">Quản lý người dùng</span>
                            <i class="ri-arrow-right-s-line ml-auto group-[.selected]:rotate-90 transition-transform duration-200"></i>
                        </a>
                        <ul class="pl-7 mt-2 hidden group-[.selected]:block">
                            <li class="mb-4">
                                <a href="${pageContext.request.contextPath}/user/list" class="text-spa-dark text-sm flex items-center hover:text-primary before:contents-[''] before:w-1 before:h-1 before:rounded-full before:bg-primary/40 before:mr-3 transition-colors duration-200">Tất cả người dùng</a>
                            </li> 
                            <li class="mb-4">
                                <a href="#" class="text-spa-dark text-sm flex items-center hover:text-primary before:contents-[''] before:w-1 before:h-1 before:rounded-full before:bg-primary/40 before:mr-3 transition-colors duration-200">Vai trò</a>
                            </li> 
                        </ul>
                    </li>
                    <li class="mb-1 group">
                        <a href="#" class="flex font-medium items-center py-2 px-4 text-spa-dark hover:bg-primary hover:text-white rounded-lg transition-all duration-200">
                            <i data-lucide="activity" class="mr-3 h-4 w-4"></i>                
                            <span class="text-sm">Hoạt động</span>
                        </a>
                    </li>
                </ul>
                
                <span class="text-primary/70 font-bold text-xs uppercase tracking-wider mt-4 block">DỊCH VỤ</span>
                <ul class="mt-2">
                    <li class="mb-1 group">
                        <a href="${pageContext.request.contextPath}/manager/service" class="flex font-medium items-center py-2 px-4 text-spa-dark hover:bg-primary hover:text-white rounded-lg sidebar-dropdown-toggle transition-all duration-200">
                            <i data-lucide="sparkles" class="mr-3 h-4 w-4"></i>                 
                            <span class="text-sm">Dịch vụ Spa</span>
                            <i class="ri-arrow-right-s-line ml-auto group-[.selected]:rotate-90 transition-transform duration-200"></i>
                        </a>
                        <ul class="pl-7 mt-2 hidden group-[.selected]:block">
                            <li class="mb-4">
                                <a href="${pageContext.request.contextPath}/manager/service" class="text-spa-dark text-sm flex items-center hover:text-primary before:contents-[''] before:w-1 before:h-1 before:rounded-full before:bg-primary/40 before:mr-3 transition-colors duration-200">Tất cả dịch vụ</a>
                            </li> 
                            <li class="mb-4">
                                <a href="${pageContext.request.contextPath}/manager/servicetype" class="text-spa-dark text-sm flex items-center hover:text-primary before:contents-[''] before:w-1 before:h-1 before:rounded-full before:bg-primary/40 before:mr-3 transition-colors duration-200">Loại dịch vụ</a>
                            </li> 
                        </ul>
                    </li>
                    <li class="mb-1 group">
                        <a href="${pageContext.request.contextPath}/appointment" class="flex font-medium items-center py-2 px-4 text-spa-dark hover:bg-primary hover:text-white rounded-lg transition-all duration-200">
                            <i data-lucide="calendar" class="mr-3 h-4 w-4"></i>                
                            <span class="text-sm">Lịch hẹn</span>
                        </a>
                    </li>
                    <c:if test="${userRole == 'ADMIN' || userRole == 'MANAGER'}">
                        <li class="mb-1 group">
                            <a href="${pageContext.request.contextPath}/promotion/list" class="flex font-medium items-center py-2 px-4 text-spa-dark hover:bg-primary hover:text-white rounded-lg transition-all duration-200">
                                <i data-lucide="gift" class="mr-3 h-4 w-4"></i>                
                                <span class="text-sm">Khuyến mãi</span>
                            </a>
                        </li>
                    </c:if>
                </ul>
                </c:when>
                
            <%-- ============================ THERAPIST NAVIGATION ============================ --%>
            <c:when test="${userRole == 'THERAPIST'}">
                <span class="text-primary/70 font-bold text-xs uppercase tracking-wider">NHÂN VIÊN</span>
                <ul class="mt-2">
                    <li class="mb-1 group">
                        <a href="${pageContext.request.contextPath}/dashboard" class="flex font-medium items-center py-2 px-4 text-spa-dark hover:bg-primary hover:text-white rounded-lg group-[.active]:bg-primary group-[.active]:text-white transition-all duration-200">
                            <i data-lucide="layout-dashboard" class="mr-3 h-4 w-4"></i>
                            <span class="text-sm">Dashboard</span>
                        </a>
                    </li>
                    <li class="mb-1 group">
                        <a href="${pageContext.request.contextPath}/therapist/schedule" class="flex font-medium items-center py-2 px-4 text-spa-dark hover:bg-primary hover:text-white rounded-lg transition-all duration-200">
                            <i data-lucide="clock" class="mr-3 h-4 w-4"></i>
                            <span class="text-sm">Lịch làm việc hôm nay</span>
                            <span class="md:block px-2 py-0.5 ml-auto text-xs font-medium tracking-wide text-white bg-yellow-500 rounded-full">8</span>
                        </a>
                    </li>
                    <li class="mb-1 group">
                        <a href="${pageContext.request.contextPath}/appointment" class="flex font-medium items-center py-2 px-4 text-spa-dark hover:bg-primary hover:text-white rounded-lg transition-all duration-200">
                            <i data-lucide="calendar" class="mr-3 h-4 w-4"></i>
                            <span class="text-sm">Quản lý lịch hẹn</span>
                        </a>
                    </li>
                    <li class="mb-1 group">
                        <a href="${pageContext.request.contextPath}/therapist/clients" class="flex font-medium items-center py-2 px-4 text-spa-dark hover:bg-primary hover:text-white rounded-lg transition-all duration-200">
                            <i data-lucide="file-text" class="mr-3 h-4 w-4"></i>
                            <span class="text-sm">Hồ sơ khách hàng</span>
                        </a>
                    </li>
                    <li class="mb-1 group">
                        <a href="${pageContext.request.contextPath}/therapist/notes" class="flex font-medium items-center py-2 px-4 text-spa-dark hover:bg-primary hover:text-white rounded-lg transition-all duration-200">
                            <i data-lucide="book-open" class="mr-3 h-4 w-4"></i>
                            <span class="text-sm">Ghi chú điều trị</span>
                        </a>
                    </li>
                </ul>
            </c:when>

            <%-- ============================ DEFAULT/GUEST NAVIGATION ============================ --%>
            <c:otherwise>
                <span class="text-primary/70 font-bold text-xs uppercase tracking-wider">TỔNG QUAN</span>
                <ul class="mt-2">
                    <li class="mb-1 group">
                        <a href="${pageContext.request.contextPath}/login" class="flex font-medium items-center py-2 px-4 text-spa-dark hover:bg-primary hover:text-white rounded-lg transition-all duration-200">
                            <i data-lucide="log-in" class="mr-3 h-4 w-4"></i>
                            <span class="text-sm">Đăng nhập</span>
                        </a>
                    </li>
                    <li class="mb-1 group">
                        <a href="${pageContext.request.contextPath}/register" class="flex font-medium items-center py-2 px-4 text-spa-dark hover:bg-primary hover:text-white rounded-lg transition-all duration-200">
                            <i data-lucide="user-plus" class="mr-3 h-4 w-4"></i>
                            <span class="text-sm">Đăng ký</span>
                        </a>
                    </li>
                </ul>
            </c:otherwise>
        </c:choose>

        <!-- Common Personal Section for Logged-in Users -->
        <c:if test="${userRole != 'GUEST'}">
            <span class="text-primary/70 font-bold text-xs uppercase tracking-wider mt-4 block">CÁ NHÂN</span>
            <ul class="mt-2">
                <li class="mb-1 group">
                    <a href="${pageContext.request.contextPath}/profile" class="flex font-medium items-center py-2 px-4 text-spa-dark hover:bg-primary hover:text-white rounded-lg transition-all duration-200">
                        <i data-lucide="settings" class="mr-3 h-4 w-4"></i>                
                        <span class="text-sm">Cài đặt</span>
                    </a>
                </li>
                <li class="mb-1 group">
                    <button onclick="confirmLogout()" class="w-full flex font-medium items-center py-2 px-4 text-spa-dark hover:bg-red-500 hover:text-white rounded-lg transition-all duration-200">
                        <i data-lucide="log-out" class="mr-3 h-4 w-4"></i>                
                        <span class="text-sm">Đăng xuất</span>
                    </button>
                </li>
            </ul>

            <!-- User Profile Section -->
            <div class="mt-6 pt-4 border-t border-primary/30">
                <div class="flex items-center space-x-3 p-2">
                    <img src="${avatarUrl}" alt="User Avatar" class="w-10 h-10 rounded-full object-cover border-2 border-primary/20">
                    <div class="flex-1 min-w-0">
                        <p class="text-sm font-semibold text-spa-dark truncate">${fullName}</p>
                        <p class="text-xs text-primary/70 capitalize">${userRole.toLowerCase()}</p>
                    </div>
                </div>
            </div>
        </c:if>
                </div>
            </div>

<!-- Mobile overlay -->
<div class="fixed top-0 left-0 w-full h-full bg-black/50 z-40 md:hidden sidebar-overlay"></div>

<script>
    // Preserved and Enhanced Sidebar Functionality
    document.addEventListener('DOMContentLoaded', function() {
        // Dropdown functionality
        document.querySelectorAll('.sidebar-dropdown-toggle').forEach(function (item) {
            item.addEventListener('click', function (e) {
                e.preventDefault()
                const parent = item.closest('.group')
                if (parent.classList.contains('selected')) {
                    parent.classList.remove('selected')
                } else {
                    document.querySelectorAll('.sidebar-dropdown-toggle').forEach(function (i) {
                        i.closest('.group').classList.remove('selected')
                    })
                    parent.classList.add('selected')
                }
            })
        })
        
        // Initialize Lucide icons for sidebar
        if (typeof lucide !== 'undefined') {
                    lucide.createIcons();
                }

        // Active link detection
        const currentPath = window.location.pathname;
        document.querySelectorAll('.sidebar-menu a').forEach(function(link) {
            if (link.getAttribute('href') && currentPath.includes(link.getAttribute('href'))) {
                link.closest('.group').classList.add('active');
            }
        });
    });

    // Logout confirmation function
    function confirmLogout() {
                    if (confirm('Bạn có chắc chắn muốn đăng xuất?')) {
            window.location.href = '${pageContext.request.contextPath}/logout';
        }
    }

    // Make toggle function globally available for navbar
    window.toggleSidebar = function() {
        const sidebarMenu = document.querySelector('.sidebar-menu');
        const sidebarOverlay = document.querySelector('.sidebar-overlay');
        
        if (sidebarMenu.classList.contains('-translate-x-full')) {
            sidebarMenu.classList.remove('-translate-x-full');
            sidebarOverlay.classList.remove('hidden');
                } else {
            sidebarMenu.classList.add('-translate-x-full');
            sidebarOverlay.classList.add('hidden');
        }
    };
</script> 