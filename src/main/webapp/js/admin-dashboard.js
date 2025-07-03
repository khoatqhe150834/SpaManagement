// js/admin-dashboard.js

class AdminDashboard {
    constructor() {
        this.adminData = {
            metrics: [
                { label: 'Tổng người dùng', value: '1,234', icon: 'users', change: 12, trend: 'up' },
                { label: 'Lịch hẹn hôm nay', value: '45', icon: 'calendar', change: -5, trend: 'down' },
                { label: 'Doanh thu tháng', value: '125M', icon: 'dollar-sign', change: 18, trend: 'up' },
                { label: 'Tỷ lệ hài lòng', value: '98.5%', icon: 'smile', change: 2, trend: 'up' }
            ],
            usersByRole: {
                labels: ['Khách hàng', 'Nhân viên', 'Quản lý', 'Marketing'],
                data: [1150, 45, 8, 5]
            },
            systemHealth: [
                { name: 'Server CPU', status: 'good', value: '45%' },
                { name: 'Memory Usage', status: 'warning', value: '78%' },
                { name: 'Database', status: 'good', value: 'Online' },
                { name: 'Backup Status', status: 'good', value: 'Updated 2h ago' }
            ],
            recentActivities: [
                { message: 'Khách hàng mới đăng ký: an@example.com', time: '5 phút trước', icon: 'user-plus' },
                { message: 'Thanh toán 500.000đ thành công', time: '10 phút trước', icon: 'credit-card' },
                { message: 'Hệ thống backup hoàn tất', time: '1 giờ trước', icon: 'database-backup' },
            ],
            pendingApprovals: [
                { type: 'Yêu cầu nghỉ phép', requester: 'Lê Thị C (Nhân viên)', date: '20/12/2024' },
                { type: 'Đăng ký tài khoản', requester: 'Trần Văn D (Khách)', date: '19/12/2024' }
            ]
        };

        this.init();
    }

    init() {
        this.populateMetrics();
        this.renderUsersByRoleChart();
        this.populateSystemHealth();
        this.populateRecentActivities();
        this.populatePendingApprovals();
        lucide.createIcons();
    }

    populateMetrics() {
        const grid = document.getElementById('metrics-grid');
        if (!grid) return;
        grid.innerHTML = this.adminData.metrics.map(metric => `
            <div class="bg-white p-5 rounded-lg shadow-sm flex items-center justify-between">
                <div class="flex items-center">
                    <div class="bg-secondary p-3 rounded-full mr-4">
                        <i data-lucide="${metric.icon}" class="h-6 w-6 text-primary"></i>
                    </div>
                    <div>
                        <div class="text-sm text-gray-500">${metric.label}</div>
                        <div class="text-2xl font-bold text-spa-dark">${metric.value}</div>
                    </div>
                </div>
                <div class="text-sm flex items-center ${metric.trend === 'up' ? 'text-green-500' : 'text-red-500'}">
                    <i data-lucide="trending-${metric.trend}" class="h-4 w-4 mr-1"></i>
                    ${metric.change}%
                </div>
            </div>
        `).join('');
    }

    renderUsersByRoleChart() {
        const ctx = document.getElementById('users-by-role-chart');
        if (!ctx) return;
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: this.adminData.usersByRole.labels,
                datasets: [{
                    label: 'Số lượng người dùng',
                    data: this.adminData.usersByRole.data,
                    backgroundColor: 'rgba(212, 175, 55, 0.6)',
                    borderColor: 'rgba(212, 175, 55, 1)',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    }

    populateSystemHealth() {
        const container = document.getElementById('system-health');
        if (!container) return;
        const healthStatusHtml = this.adminData.systemHealth.map(item => {
            const statusColorClasses = {
                good: 'text-green-600 bg-green-100',
                warning: 'text-yellow-600 bg-yellow-100',
                error: 'text-red-600 bg-red-100'
            };
            return `
                <div class="flex items-center justify-between">
                    <span class="text-sm text-gray-600">${item.name}</span>
                    <div class="flex items-center">
                        <span class="text-sm font-medium mr-2">${item.value}</span>
                        <span class="px-2 py-1 rounded-full text-xs font-medium ${statusColorClasses[item.status]}">
                            ${item.status.charAt(0).toUpperCase() + item.status.slice(1)}
                        </span>
                    </div>
                </div>
            `;
        }).join('');
        container.innerHTML += `<div class="space-y-4 mt-4">${healthStatusHtml}</div>`;
    }

    populateRecentActivities() {
        const container = document.getElementById('recent-activities');
        if (!container) return;
        container.innerHTML = this.adminData.recentActivities.map(activity => `
            <div class="flex items-start space-x-3">
                <div class="bg-gray-100 p-2 rounded-full">
                    <i data-lucide="${activity.icon}" class="h-4 w-4 text-gray-500"></i>
                </div>
                <div class="flex-1">
                    <p class="text-sm text-gray-800">${activity.message}</p>
                    <p class="text-xs text-gray-500">${activity.time}</p>
                </div>
            </div>
        `).join('');
    }

    populatePendingApprovals() {
        const container = document.getElementById('pending-approvals');
        if (!container) return;
        container.innerHTML = this.adminData.pendingApprovals.map(approval => `
            <div class="flex items-center justify-between p-3 bg-yellow-50 rounded-lg">
                <div>
                    <p class="text-sm font-medium text-gray-900">${approval.type}</p>
                    <p class="text-xs text-gray-600">Từ: ${approval.requester}</p>
                    <p class="text-xs text-gray-500">${approval.date}</p>
                </div>
                <div class="flex space-x-2">
                    <button class="px-3 py-1 bg-green-600 text-white text-xs rounded hover:bg-green-700 transition-colors">Duyệt</button>
                    <button class="px-3 py-1 bg-red-600 text-white text-xs rounded hover:bg-red-700 transition-colors">Từ chối</button>
                </div>
            </div>
        `).join('');
    }
}

// This script should be loaded after dashboard.js
// It assumes the dashboard layout has been loaded and the main Dashboard class is instantiated.
document.addEventListener('DOMContentLoaded', () => {
    if (window.location.pathname.includes('admin-dashboard.html')) {
        new AdminDashboard();
    }
}); 