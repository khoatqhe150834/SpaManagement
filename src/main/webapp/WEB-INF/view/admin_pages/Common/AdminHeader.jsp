<%-- AdminHeader.jsp: Modern Navbar dùng chung cho admin pages --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- Modern Navbar (giống dashboard) -->
<div class="h-16 px-6 bg-spa-cream flex items-center shadow-sm border-b border-primary/10 sticky top-0 left-0 z-30">
    <button type="button" class="text-lg text-spa-dark font-semibold sidebar-toggle hover:text-primary transition-colors duration-200 hidden">
        <i class="ri-menu-line"></i>
    </button>
    <ul class="ml-auto flex items-center">
        <li class="mr-1 dropdown">
            <button type="button" class="dropdown-toggle text-primary/60 hover:text-primary mr-4 w-8 h-8 rounded-lg flex items-center justify-center hover:bg-primary/10 transition-all duration-200">
                <i data-lucide="search" class="h-5 w-5"></i>
            </button>
            <div class="dropdown-menu shadow-lg shadow-black/10 z-30 hidden max-w-xs w-full bg-white rounded-lg border border-primary/20">
                <form action="" class="p-4 border-b border-primary/10">
                    <div class="relative w-full">
                        <input type="text" class="py-2 pr-4 pl-10 bg-spa-cream w-full outline-none border border-primary/20 rounded-lg text-sm focus:border-primary focus:ring-2 focus:ring-primary/20" placeholder="Tìm kiếm...">
                        <i data-lucide="search" class="absolute top-1/2 left-3 -translate-y-1/2 text-primary/60 h-4 w-4"></i>
                    </div>
                </form>
            </div>
        </li>
        <!-- User Profile Dropdown -->
        <li class="dropdown ml-3">
            <button type="button" class="dropdown-toggle flex items-center hover:bg-primary/10 rounded-lg p-2 transition-all duration-200">
                <div class="flex-shrink-0 w-10 h-10 relative">
                    <div class="p-1 bg-white rounded-full focus:outline-none focus:ring-2 focus:ring-primary/20">
                        <img class="w-8 h-8 rounded-full object-cover" src="https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&w=100" alt="Admin Avatar"/>
                        <div class="top-0 left-7 absolute w-3 h-3 bg-green-400 border-2 border-white rounded-full animate-ping"></div>
                        <div class="top-0 left-7 absolute w-3 h-3 bg-green-500 border-2 border-white rounded-full"></div>
                    </div>
                </div>
                <div class="p-2 md:block text-left">
                    <h2 class="text-sm font-semibold text-spa-dark">${sessionScope.user.fullName != null ? sessionScope.user.fullName : sessionScope.customer.fullName}</h2>
                    <p class="text-xs text-primary/70">
                        <c:choose>
                            <c:when test="${sessionScope.userType == 'ADMIN'}">Quản trị viên</c:when>
                            <c:when test="${sessionScope.userType == 'MANAGER'}">Quản lý</c:when>
                            <c:when test="${sessionScope.userType == 'THERAPIST'}">Nhân viên</c:when>
                            <c:when test="${sessionScope.userType == 'CUSTOMER'}">Khách hàng</c:when>
                            <c:otherwise>Người dùng</c:otherwise>
                        </c:choose>
                    </p>
                </div>
            </button>
            <ul class="dropdown-menu shadow-lg shadow-black/10 z-30 hidden py-2 rounded-lg bg-white border border-primary/20 w-full max-w-[160px]">
                <li>
                    <a href="${pageContext.request.contextPath}/profile" class="flex items-center text-sm py-2 px-4 text-spa-dark hover:text-primary hover:bg-spa-cream transition-all duration-200">
                        <i data-lucide="user" class="h-4 w-4 mr-2"></i>
                        Hồ sơ
                    </a>
                </li>
                <li>
                    <a href="#" class="flex items-center text-sm py-2 px-4 text-spa-dark hover:text-primary hover:bg-spa-cream transition-all duration-200">
                        <i data-lucide="settings" class="h-4 w-4 mr-2"></i>
                        Cài đặt
                    </a>
                </li>
                <li class="border-t border-primary/10 mt-1 pt-1">
                    <a href="${pageContext.request.contextPath}/logout" class="flex items-center text-sm py-2 px-4 text-red-600 hover:bg-red-50 cursor-pointer transition-all duration-200">
                        <i data-lucide="log-out" class="h-4 w-4 mr-2"></i>
                        Đăng xuất
                    </a>
                </li>
            </ul>
        </li>
    </ul>
</div> 