<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!--sidenav -->
<div class="fixed left-0 top-0 w-64 h-full bg-spa-cream p-4 z-50 sidebar-menu transition-transform border-r border-primary/20">
    <a href="#" class="flex items-center pb-4 border-b border-primary/30">
        <h2 class="font-bold text-2xl text-spa-dark">Spa <span class="bg-primary text-white px-2 rounded-md">Hương Sen</span></h2>
    </a>
    <ul class="mt-4">
        <span class="text-primary/70 font-bold text-xs uppercase tracking-wider">QUẢN LÝ</span>
        <li class="mb-1 group">
            <a href="" class="flex font-medium items-center py-2 px-4 text-spa-dark hover:bg-primary hover:text-white rounded-lg group-[.active]:bg-primary group-[.active]:text-white group-[.selected]:bg-primary-dark group-[.selected]:text-white transition-all duration-200">
                <i class="ri-home-2-line mr-3 text-lg"></i>
                <span class="text-sm">Dashboard</span>
            </a>
        </li>
        <li class="mb-1 group">
            <a href="" class="flex font-medium items-center py-2 px-4 text-spa-dark hover:bg-primary hover:text-white rounded-lg group-[.active]:bg-primary group-[.active]:text-white group-[.selected]:bg-primary-dark group-[.selected]:text-white sidebar-dropdown-toggle transition-all duration-200">
                <i class='bx bx-user mr-3 text-lg'></i>                
                <span class="text-sm">Người dùng</span>
                <i class="ri-arrow-right-s-line ml-auto group-[.selected]:rotate-90 transition-transform duration-200"></i>
            </a>
            <ul class="pl-7 mt-2 hidden group-[.selected]:block">
                <li class="mb-4">
                    <a href="" class="text-spa-dark text-sm flex items-center hover:text-primary before:contents-[''] before:w-1 before:h-1 before:rounded-full before:bg-primary/40 before:mr-3 transition-colors duration-200">Tất cả</a>
                </li> 
                <li class="mb-4">
                    <a href="" class="text-spa-dark text-sm flex items-center hover:text-primary before:contents-[''] before:w-1 before:h-1 before:rounded-full before:bg-primary/40 before:mr-3 transition-colors duration-200">Vai trò</a>
                </li> 
            </ul>
        </li>
        <li class="mb-1 group">
            <a href="" class="flex font-medium items-center py-2 px-4 text-spa-dark hover:bg-primary hover:text-white rounded-lg group-[.active]:bg-primary group-[.active]:text-white group-[.selected]:bg-primary-dark group-[.selected]:text-white transition-all duration-200">
                <i data-lucide="activity" class="mr-3 h-4 w-4"></i>                
                <span class="text-sm">Hoạt động</span>
            </a>
        </li>
        <span class="text-primary/70 font-bold text-xs uppercase tracking-wider mt-4 block">DỊCH VỤ</span>
        <li class="mb-1 group">
            <a href="" class="flex font-medium items-center py-2 px-4 text-spa-dark hover:bg-primary hover:text-white rounded-lg group-[.active]:bg-primary group-[.active]:text-white group-[.selected]:bg-primary-dark group-[.selected]:text-white sidebar-dropdown-toggle transition-all duration-200">
                <i data-lucide="sparkles" class="mr-3 h-4 w-4"></i>                 
                <span class="text-sm">Dịch vụ Spa</span>
                <i class="ri-arrow-right-s-line ml-auto group-[.selected]:rotate-90 transition-transform duration-200"></i>
            </a>
            <ul class="pl-7 mt-2 hidden group-[.selected]:block">
                <li class="mb-4">
                    <a href="" class="text-spa-dark text-sm flex items-center hover:text-primary before:contents-[''] before:w-1 before:h-1 before:rounded-full before:bg-primary/40 before:mr-3 transition-colors duration-200">Tất cả</a>
                </li> 
                <li class="mb-4">
                    <a href="" class="text-spa-dark text-sm flex items-center hover:text-primary before:contents-[''] before:w-1 before:h-1 before:rounded-full before:bg-primary/40 before:mr-3 transition-colors duration-200">Danh mục</a>
                </li> 
            </ul>
        </li>
        <li class="mb-1 group">
            <a href="" class="flex font-medium items-center py-2 px-4 text-spa-dark hover:bg-primary hover:text-white rounded-lg group-[.active]:bg-primary group-[.active]:text-white group-[.selected]:bg-primary-dark group-[.selected]:text-white transition-all duration-200">
                <i data-lucide="calendar" class="mr-3 h-4 w-4"></i>                
                <span class="text-sm">Lịch hẹn</span>
            </a>
        </li>
        <span class="text-primary/70 font-bold text-xs uppercase tracking-wider mt-4 block">CÁ NHÂN</span>
        <li class="mb-1 group">
            <a href="" class="flex font-medium items-center py-2 px-4 text-spa-dark hover:bg-primary hover:text-white rounded-lg group-[.active]:bg-primary group-[.active]:text-white group-[.selected]:bg-primary-dark group-[.selected]:text-white transition-all duration-200">
                <i data-lucide="bell" class="mr-3 h-4 w-4"></i>                
                <span class="text-sm">Thông báo</span>
                <span class="md:block px-2 py-0.5 ml-auto text-xs font-medium tracking-wide text-white bg-red-500 rounded-full">5</span>
            </a>
        </li>
        <li class="mb-1 group">
            <a href="" class="flex font-medium items-center py-2 px-4 text-spa-dark hover:bg-primary hover:text-white rounded-lg group-[.active]:bg-primary group-[.active]:text-white group-[.selected]:bg-primary-dark group-[.selected]:text-white transition-all duration-200">
                <i data-lucide="mail" class="mr-3 h-4 w-4"></i>                
                <span class="text-sm">Tin nhắn</span>
                <span class="md:block px-2 py-0.5 ml-auto text-xs font-medium tracking-wide text-white bg-green-500 rounded-full">2</span>
            </a>
        </li>
    </ul>
</div>
<div class="fixed top-0 left-0 w-full h-full bg-black/50 z-40 md:hidden sidebar-overlay"></div>
<!-- end sidenav -->

<script>
    // Sidebar dropdown functionality for admin sidebar
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
    });
</script> 