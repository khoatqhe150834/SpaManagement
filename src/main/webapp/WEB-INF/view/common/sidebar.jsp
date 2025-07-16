<%--
    Document   : sidebar.jsp
    Enhanced role-based sidebar with MenuService integration
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

    // Set default avatar if none is provided for any user type (admin, manager, customer, etc.)
    if (avatarUrl == null || avatarUrl.trim().isEmpty()) {
        // Default blank profile picture from Pixabay for all users without avatars
        avatarUrl = "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png";
    }

    // Generate role-based menu items using MenuService
    List<MenuItem> menuItems = MenuService.getMenuItemsByRole(userRole, request.getContextPath());

    pageContext.setAttribute("userRole", userRole);
    pageContext.setAttribute("contextPath", request.getContextPath());
    pageContext.setAttribute("fullName", fullName);
    pageContext.setAttribute("email", email);
    pageContext.setAttribute("avatarUrl", avatarUrl);
    pageContext.setAttribute("menuItems", menuItems);
%>

<!-- Enhanced Role-Based Sidebar with MenuService Integration -->
<div class="fixed left-0 top-0 w-64 h-full bg-spa-cream p-4 z-50 sidebar-menu transition-transform border-r border-primary/20">
    <a href="${pageContext.request.contextPath}/dashboard" class="flex items-center pb-4 border-b border-primary/30">
        <h2 class="font-bold text-2xl text-spa-dark">Spa <span class="bg-primary text-white px-2 rounded-md">Hương Sen</span></h2>
    </a>
    
    <div class="mt-4">
            <c:choose>
            <%-- ============================ DYNAMIC ROLE-BASED NAVIGATION ============================ --%>
            <c:when test="${userRole != 'GUEST'}">
                <div class="space-y-1">
                    <c:set var="currentSection" value="" />
                    <c:forEach var="menuItem" items="${menuItems}">
                        <%
                            MenuItem item = (MenuItem) pageContext.getAttribute("menuItem");
                            // Check if this is a section header
                            if (item.getSection() != null && !item.getSection().isEmpty() && item.getUrl() == null) {
                                pageContext.setAttribute("isSection", true);
                                pageContext.setAttribute("sectionTitle", item.getSection());
                            } else {
                                pageContext.setAttribute("isSection", false);
                            }
                        %>
                        
                        <c:choose>
                            <%-- Section Header --%>
                            <c:when test="${isSection}">
                                <c:if test="${not empty currentSection}">
                                    <!-- Add spacing between sections -->
                                    <div class="mt-4"></div>
                                </c:if>
                                <span class="text-primary/70 font-bold text-xs uppercase tracking-wider block mt-4">${sectionTitle}</span>
                                <c:set var="currentSection" value="${sectionTitle}" />
                </c:when>

                            <%-- Regular Menu Item --%>
                            <c:otherwise>
                                <div class="mb-1 group">
                                    <%
                                        MenuItem menuItem = (MenuItem) pageContext.getAttribute("menuItem");
                                        boolean hasSubItems = menuItem.getSubItems() != null && !menuItem.getSubItems().isEmpty();
                                        pageContext.setAttribute("hasSubItems", hasSubItems);
                                        pageContext.setAttribute("subItems", menuItem.getSubItems());
                                    %>
                                    
                                    <c:choose>
                                        <%-- Menu item with dropdown --%>
                                        <c:when test="${hasSubItems}">
                                            <a href="#" class="flex font-medium items-center py-2 px-4 text-spa-dark hover:bg-primary hover:text-white rounded-lg sidebar-dropdown-toggle transition-all duration-200">
                                                <i data-lucide="${menuItem.icon}" class="mr-3 h-4 w-4"></i>
                                                <span class="text-sm">${menuItem.label}</span>
                                                <c:if test="${menuItem.hasNotification}">
                                                    <span class="md:block px-2 py-0.5 ml-auto text-xs font-medium tracking-wide text-white 
                                                        <c:choose>
                                                            <c:when test='${menuItem.notificationColor == "red"}'>bg-red-500</c:when>
                                                            <c:when test='${menuItem.notificationColor == "yellow"}'>bg-yellow-500</c:when>
                                                            <c:when test='${menuItem.notificationColor == "green"}'>bg-green-500</c:when>
                                                            <c:when test='${menuItem.notificationColor == "blue"}'>bg-blue-500</c:when>
                                                            <c:otherwise>bg-primary</c:otherwise>
                                                        </c:choose>
                                                        rounded-full">${menuItem.notificationText}</span>
                                                </c:if>
                            <i class="ri-arrow-right-s-line ml-auto group-[.selected]:rotate-90 transition-transform duration-200"></i>
                        </a>
                                            <div class="pl-7 mt-2 hidden group-[.selected]:block list-none">
                                                <c:forEach var="subItem" items="${subItems}">
                                                    <div class="mb-4">
                                                        <a href="${subItem.url}" class="text-spa-dark text-sm flex items-center hover:text-primary before:contents-[''] before:w-1 before:h-1 before:rounded-full before:bg-primary/40 before:mr-3 transition-colors duration-200">
                                                            ${subItem.label}
                                                        </a>
                                                    </div>
                                                </c:forEach>
                                            </div>
                </c:when>
                
                                        <%-- Regular menu item --%>
                                        <c:otherwise>
                                            <a href="${menuItem.url}" class="flex font-medium items-center py-2 px-4 text-spa-dark hover:bg-primary hover:text-white rounded-lg transition-all duration-200">
                                                <i data-lucide="${menuItem.icon}" class="mr-3 h-4 w-4"></i>
                                                <span class="text-sm">${menuItem.label}</span>
                                                <c:if test="${menuItem.hasNotification}">
                                                    <span class="md:block px-2 py-0.5 ml-auto text-xs font-medium tracking-wide text-white 
                                                        <c:choose>
                                                            <c:when test='${menuItem.notificationColor == "red"}'>bg-red-500 animate-pulse</c:when>
                                                            <c:when test='${menuItem.notificationColor == "yellow"}'>bg-yellow-500</c:when>
                                                            <c:when test='${menuItem.notificationColor == "green"}'>bg-green-500</c:when>
                                                            <c:when test='${menuItem.notificationColor == "blue"}'>bg-blue-500</c:when>
                                                            <c:otherwise>bg-primary</c:otherwise>
                                                        </c:choose>
                                                        rounded-full">${menuItem.notificationText}</span>
                                                </c:if>
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </div>
            </c:when>

            <%-- ============================ GUEST/UNAUTHENTICATED NAVIGATION ============================ --%>
            <c:otherwise>
                <span class="text-primary/70 font-bold text-xs uppercase tracking-wider">TỔNG QUAN</span>
                <div class="mt-2">
                    <div class="mb-1 group">
                        <a href="${pageContext.request.contextPath}/login" class="flex font-medium items-center py-2 px-4 text-spa-dark hover:bg-primary hover:text-white rounded-lg transition-all duration-200">
                            <i data-lucide="log-in" class="mr-3 h-4 w-4"></i>
                            <span class="text-sm">Đăng nhập</span>
                        </a>
                    </div>
                    <div class="mb-1 group">
                        <a href="${pageContext.request.contextPath}/register" class="flex font-medium items-center py-2 px-4 text-spa-dark hover:bg-primary hover:text-white rounded-lg transition-all duration-200">
                            <i data-lucide="user-plus" class="mr-3 h-4 w-4"></i>
                            <span class="text-sm">Đăng ký</span>
                        </a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>

        <!-- Account Management Section for All Roles -->
        <c:if test="${userRole != 'GUEST'}">
            <span class="text-primary/70 font-bold text-xs uppercase tracking-wider mt-6 block">TÀI KHOẢN</span>
            <div class="mt-2">
                <div class="mb-1 group">
                    <a href="${pageContext.request.contextPath}/account/profile" class="flex font-medium items-center py-2 px-4 text-spa-dark hover:bg-primary hover:text-white rounded-lg transition-all duration-200">
                        <i data-lucide="user-circle" class="mr-3 h-4 w-4"></i>                
                        <span class="text-sm">Thông tin cá nhân</span>
                    </a>
                </div>
                <div class="mb-1 group">
                    <a href="${pageContext.request.contextPath}/password/change" class="flex font-medium items-center py-2 px-4 text-spa-dark hover:bg-primary hover:text-white rounded-lg transition-all duration-200">
                        <i data-lucide="key" class="mr-3 h-4 w-4"></i>                
                        <span class="text-sm">Đổi mật khẩu</span>
                    </a>
                </div>
                <div class="mb-1 group">
                    <a href="${pageContext.request.contextPath}/account/security" class="flex font-medium items-center py-2 px-4 text-spa-dark hover:bg-primary hover:text-white rounded-lg transition-all duration-200">
                        <i data-lucide="shield-check" class="mr-3 h-4 w-4"></i>                
                        <span class="text-sm">Bảo mật</span>
                    </a>
                </div>
            </div>

            <!-- Common Personal Section for Logged-in Users -->
            <span class="text-primary/70 font-bold text-xs uppercase tracking-wider mt-6 block">CÁ NHÂN</span>
            <div class="mt-2">
                <div class="mb-1 group">
                    <a href="${pageContext.request.contextPath}/profile" class="flex font-medium items-center py-2 px-4 text-spa-dark hover:bg-primary hover:text-white rounded-lg transition-all duration-200">
                        <i data-lucide="settings" class="mr-3 h-4 w-4"></i>                
                        <span class="text-sm">Cài đặt</span>
                    </a>
                </div>
                <div class="mb-1 group">
                    <button onclick="confirmLogout()" class="w-full flex font-medium items-center py-2 px-4 text-spa-dark hover:bg-red-500 hover:text-white rounded-lg transition-all duration-200">
                        <i data-lucide="log-out" class="mr-3 h-4 w-4"></i>                
                        <span class="text-sm">Đăng xuất</span>
                    </button>
                </div>
            </div>

            <!-- Enhanced User Profile Section -->
            <div class="mt-6 pt-4 border-t border-primary/30">
                <div class="flex items-center space-x-3 p-2">
                    <img src="${avatarUrl}" alt="User Avatar" class="w-10 h-10 rounded-full object-cover border-2 border-primary/20">
                    <div class="flex-1 min-w-0">
                        <p class="text-sm font-semibold text-spa-dark truncate">${fullName}</p>
                        <p class="text-xs text-primary/70 capitalize">
                            <c:choose>
                                <c:when test="${userRole == 'ADMIN'}">Quản trị viên</c:when>
                                <c:when test="${userRole == 'MANAGER'}">Quản lý</c:when>
                                <c:when test="${userRole == 'THERAPIST'}">Nhân viên</c:when>
                                <c:when test="${userRole == 'RECEPTIONIST'}">Lễ tân</c:when>
                                <c:when test="${userRole == 'MARKETING'}">Marketing</c:when>
                                <c:when test="${userRole == 'INVENTORY_MANAGER'}">Quản lý kho</c:when>
                                <c:when test="${userRole == 'CUSTOMER'}">Khách hàng</c:when>
                                <c:otherwise>${userRole.toLowerCase()}</c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </div>
            </div>
        </c:if>
                </div>
            </div>

<!-- Mobile overlay -->
<div class="fixed top-0 left-0 w-full h-full bg-black/50 z-40 md:hidden sidebar-overlay"></div>

<script>
    // Enhanced Sidebar Functionality with MenuService Integration
    document.addEventListener('DOMContentLoaded', function() {
        // Dropdown functionality for menu items with sub-items
        document.querySelectorAll('.sidebar-dropdown-toggle').forEach(function (item) {
            item.addEventListener('click', function (e) {
                e.preventDefault()
                const parent = item.closest('.group')
                if (parent.classList.contains('selected')) {
                    parent.classList.remove('selected')
                } else {
                    // Close other open dropdowns
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

        // Enhanced active link detection based on current URL
        const currentPath = window.location.pathname;
        const currentParams = window.location.search;
        
        // Clear previous active states
        function clearActiveStates() {
        document.querySelectorAll('.sidebar-menu a').forEach(function(link) {
                link.classList.remove('bg-primary', 'text-white');
                link.classList.add('text-spa-dark');
                link.closest('.group')?.classList.remove('active');
            });
        }

        // Set active state for matching links
        document.querySelectorAll('.sidebar-menu a[href]').forEach(function(link) {
            const linkPath = link.getAttribute('href');
            const linkUrl = new URL(linkPath, window.location.origin);
            
            // Exact match or path contains check
            if (currentPath === linkUrl.pathname || 
                (linkUrl.pathname !== '/' && currentPath.includes(linkUrl.pathname))) {
                clearActiveStates();
                link.classList.remove('text-spa-dark');
                link.classList.add('bg-primary', 'text-white');
                link.closest('.group')?.classList.add('active');
                
                // If this is a sub-item, also open its parent dropdown
                const parentDropdown = link.closest('ul.hidden')?.previousElementSibling;
                if (parentDropdown && parentDropdown.classList.contains('sidebar-dropdown-toggle')) {
                    parentDropdown.closest('.group').classList.add('selected');
                }
            }
        });

        // Handle click events for better active state management
        document.querySelectorAll('.sidebar-menu a[href]').forEach(function(link) {
            link.addEventListener('click', function() {
                // Don't clear active states for dropdown toggles
                if (!this.classList.contains('sidebar-dropdown-toggle')) {
                    clearActiveStates();
                    this.classList.remove('text-spa-dark');
                    this.classList.add('bg-primary', 'text-white');
                    this.closest('.group')?.classList.add('active');
            }
            });
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

    // Enhanced role-based feature access helper
    window.hasRoleAccess = function(feature) {
        const userRole = '${userRole}';
        // This can be extended to call backend MenuService.hasAccess method
        return true; // Placeholder - implement as needed
    };

    console.log('Enhanced Role-Based Sidebar Loaded Successfully for role: ${userRole}');
</script> 