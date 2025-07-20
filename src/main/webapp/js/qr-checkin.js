/**
 * QR Check-in JavaScript
 * Handles QR code scanning and customer check-in functionality
 * 
 * @author SpaManagement
 */

class QRCheckInSystem {
    constructor() {
        this.contextPath = this.getContextPath();
        this.isScanning = false;
        this.stream = null;
        this.init();
    }
    
    init() {
        console.log('[QR-CHECKIN] Initializing QR Check-in System...');
        this.setupEventListeners();
        this.loadRecentCheckIns();
        console.log('[QR-CHECKIN] System initialized');
    }
    
    getContextPath() {
        // Get context path from current URL
        const path = window.location.pathname;
        const contextPath = path.substring(0, path.indexOf('/', 1));
        return contextPath || '';
    }
    
    setupEventListeners() {
        // Enter key on QR input
        const qrInput = document.getElementById('qrCodeInput');
        if (qrInput) {
            qrInput.addEventListener('keypress', (e) => {
                if (e.key === 'Enter') {
                    this.processQRCheckIn();
                }
            });
            
            // Auto-validate on input change
            qrInput.addEventListener('input', (e) => {
                if (e.target.value.length > 5) {
                    this.validateQRCode();
                }
            });
        }
        
        // Auto-refresh recent check-ins every 30 seconds
        setInterval(() => {
            this.loadRecentCheckIns();
        }, 30000);
    }
    
    async startQRScanner() {
        try {
            // Check if browser supports camera
            if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
                this.showAlert('Trình duyệt không hỗ trợ camera', 'warning');
                return;
            }
            
            // Request camera permission
            this.stream = await navigator.mediaDevices.getUserMedia({ 
                video: { facingMode: 'environment' } // Use back camera if available
            });
            
            // Create video element for camera feed
            const scannerContainer = document.getElementById('qrScannerContainer');
            scannerContainer.innerHTML = `
                <video id="qrVideo" autoplay playsinline style="width: 100%; max-width: 400px; border-radius: 10px;"></video>
                <div class="mt-3">
                    <button class="btn btn-danger" onclick="qrCheckInSystem.stopQRScanner()">
                        <i class="fas fa-stop me-2"></i>Dừng quét
                    </button>
                </div>
                <p class="mt-2 text-muted">Hướng camera về phía mã QR</p>
            `;
            
            const video = document.getElementById('qrVideo');
            video.srcObject = this.stream;
            
            this.isScanning = true;
            this.showAlert('Camera đã được kích hoạt. Hướng camera về phía mã QR.', 'info');
            
            // Note: In a real implementation, you would integrate with a QR code library
            // like jsQR or QuaggaJS to actually decode QR codes from the video stream
            
        } catch (error) {
            console.error('[QR-CHECKIN] Error starting camera:', error);
            this.showAlert('Không thể truy cập camera. Vui lòng kiểm tra quyền truy cập.', 'danger');
        }
    }
    
    stopQRScanner() {
        if (this.stream) {
            this.stream.getTracks().forEach(track => track.stop());
            this.stream = null;
        }
        
        this.isScanning = false;
        
        // Reset scanner container
        const scannerContainer = document.getElementById('qrScannerContainer');
        scannerContainer.innerHTML = `
            <div class="qr-scanner-icon">
                <i class="fas fa-qrcode"></i>
            </div>
            <h4>Quét mã QR của khách hàng</h4>
            <p class="text-muted">Hướng camera về phía mã QR trên điện thoại khách hàng</p>
            <button class="btn btn-spa" onclick="qrCheckInSystem.startQRScanner()">
                <i class="fas fa-camera me-2"></i>Bắt đầu quét
            </button>
        `;
        
        this.showAlert('Đã dừng quét QR code', 'info');
    }
    
    async validateQRCode() {
        const qrInput = document.getElementById('qrCodeInput');
        const qrData = qrInput.value.trim();
        
        if (!qrData) {
            this.showAlert('Vui lòng nhập mã QR', 'warning');
            return;
        }
        
        try {
            this.showLoading(true);
            
            const formData = new FormData();
            formData.append('action', 'validate_qr');
            formData.append('qrData', qrData);
            
            const response = await fetch(`${this.contextPath}/checkin/qr`, {
                method: 'POST',
                body: formData
            });
            
            const data = await response.json();
            
            if (data.success && data.data.valid) {
                this.showBookingDetails(data.data.bookingDetails);
                this.showAlert('Mã QR hợp lệ! Thông tin booking đã được tải.', 'success');
            } else {
                this.showAlert(data.message || 'Mã QR không hợp lệ', 'danger');
                this.hideBookingDetails();
            }
            
        } catch (error) {
            console.error('[QR-CHECKIN] Error validating QR:', error);
            this.showAlert('Lỗi khi kiểm tra mã QR', 'danger');
        } finally {
            this.showLoading(false);
        }
    }
    
    async processQRCheckIn() {
        const qrInput = document.getElementById('qrCodeInput');
        const qrData = qrInput.value.trim();
        
        if (!qrData) {
            this.showAlert('Vui lòng nhập mã QR', 'warning');
            return;
        }
        
        if (!confirm('Xác nhận check-in cho khách hàng này?')) {
            return;
        }
        
        try {
            this.showLoading(true);
            
            const formData = new FormData();
            formData.append('action', 'checkin_qr');
            formData.append('qrData', qrData);
            
            const response = await fetch(`${this.contextPath}/checkin/qr`, {
                method: 'POST',
                body: formData
            });
            
            const data = await response.json();
            
            if (data.success) {
                this.showSuccessCheckIn(data.data.bookingDetails);
                this.showAlert('Check-in thành công!', 'success');
                
                // Clear input and refresh recent check-ins
                qrInput.value = '';
                this.loadRecentCheckIns();
                
                // Auto-hide success message after 5 seconds
                setTimeout(() => {
                    this.hideBookingDetails();
                }, 5000);
                
            } else {
                this.showAlert(data.message || 'Check-in thất bại', 'danger');
            }
            
        } catch (error) {
            console.error('[QR-CHECKIN] Error processing check-in:', error);
            this.showAlert('Lỗi khi xử lý check-in', 'danger');
        } finally {
            this.showLoading(false);
        }
    }
    
    async processManualCheckIn() {
        const bookingId = document.getElementById('manualBookingId').value.trim();
        const customerName = document.getElementById('manualCustomerName').value.trim();
        
        if (!bookingId || !customerName) {
            this.showAlert('Vui lòng nhập đầy đủ thông tin', 'warning');
            return;
        }
        
        try {
            this.showLoading(true);
            
            const formData = new FormData();
            formData.append('action', 'manual_checkin');
            formData.append('bookingId', bookingId);
            
            const response = await fetch(`${this.contextPath}/checkin/qr`, {
                method: 'POST',
                body: formData
            });
            
            const data = await response.json();
            
            if (data.success) {
                // Verify customer name matches
                const bookingDetails = data.data.bookingDetails;
                if (bookingDetails.customerName.toLowerCase().includes(customerName.toLowerCase()) ||
                    customerName.toLowerCase().includes(bookingDetails.customerName.toLowerCase())) {
                    
                    this.showSuccessCheckIn(bookingDetails);
                    this.showAlert('Check-in thủ công thành công!', 'success');
                    
                    // Close modal and refresh
                    const modal = bootstrap.Modal.getInstance(document.getElementById('manualCheckInModal'));
                    modal.hide();
                    this.loadRecentCheckIns();
                    
                } else {
                    this.showAlert('Tên khách hàng không khớp. Vui lòng kiểm tra lại.', 'warning');
                }
            } else {
                this.showAlert(data.message || 'Check-in thất bại', 'danger');
            }
            
        } catch (error) {
            console.error('[QR-CHECKIN] Error processing manual check-in:', error);
            this.showAlert('Lỗi khi xử lý check-in thủ công', 'danger');
        } finally {
            this.showLoading(false);
        }
    }
    
    showBookingDetails(bookingDetails) {
        const container = document.getElementById('bookingDetailsContainer');
        
        const html = `
            <div class="booking-details-card">
                <div class="row align-items-center">
                    <div class="col-auto">
                        <div class="customer-avatar">
                            ${bookingDetails.customerName.charAt(0).toUpperCase()}
                        </div>
                    </div>
                    <div class="col">
                        <h5 class="mb-1">${bookingDetails.customerName}</h5>
                        <p class="text-muted mb-2">${bookingDetails.customerPhone}</p>
                        <div class="row">
                            <div class="col-md-6">
                                <strong>Dịch vụ:</strong> ${bookingDetails.serviceName}<br>
                                <strong>Kỹ thuật viên:</strong> ${bookingDetails.therapistName}
                            </div>
                            <div class="col-md-6">
                                <strong>Ngày:</strong> ${this.formatDate(bookingDetails.appointmentDate)}<br>
                                <strong>Giờ:</strong> ${this.formatTime(bookingDetails.appointmentTime)}
                            </div>
                        </div>
                    </div>
                    <div class="col-auto">
                        <span class="status-badge status-${bookingDetails.bookingStatus.toLowerCase()}">
                            ${this.getStatusText(bookingDetails.bookingStatus)}
                        </span>
                    </div>
                </div>
            </div>
        `;
        
        container.innerHTML = html;
        container.style.display = 'block';
    }
    
    showSuccessCheckIn(bookingDetails) {
        this.showBookingDetails(bookingDetails);
        
        // Add success animation
        const container = document.getElementById('bookingDetailsContainer');
        container.classList.add('success-animation');
        
        setTimeout(() => {
            container.classList.remove('success-animation');
        }, 600);
    }
    
    hideBookingDetails() {
        const container = document.getElementById('bookingDetailsContainer');
        container.style.display = 'none';
    }
    
    async loadRecentCheckIns() {
        // This would load recent check-ins from the server
        // For now, we'll show a placeholder
        const container = document.getElementById('recentCheckinsContainer');
        
        // Simulate loading recent check-ins
        const mockCheckIns = [
            {
                customerName: 'Nguyễn Thị Lan',
                serviceName: 'Massage thư giãn',
                checkInTime: new Date(Date.now() - 15 * 60 * 1000), // 15 minutes ago
                status: 'IN_PROGRESS'
            },
            {
                customerName: 'Trần Văn Nam',
                serviceName: 'Chăm sóc da mặt',
                checkInTime: new Date(Date.now() - 45 * 60 * 1000), // 45 minutes ago
                status: 'IN_PROGRESS'
            }
        ];
        
        if (mockCheckIns.length > 0) {
            let html = '';
            mockCheckIns.forEach(checkIn => {
                html += `
                    <div class="checkin-item">
                        <div class="customer-avatar" style="width: 40px; height: 40px; font-size: 1rem;">
                            ${checkIn.customerName.charAt(0)}
                        </div>
                        <div class="flex-grow-1">
                            <div class="fw-bold">${checkIn.customerName}</div>
                            <div class="text-muted small">${checkIn.serviceName}</div>
                            <div class="checkin-time">${this.formatTimeElapsed(checkIn.checkInTime)}</div>
                        </div>
                        <div>
                            <span class="status-badge status-${checkIn.status.toLowerCase()}">
                                ${this.getStatusText(checkIn.status)}
                            </span>
                        </div>
                    </div>
                `;
            });
            container.innerHTML = html;
        }
    }
    
    showLoading(show) {
        const spinner = document.getElementById('loadingSpinner');
        if (spinner) {
            spinner.style.display = show ? 'block' : 'none';
        }
    }
    
    showAlert(message, type) {
        const container = document.getElementById('alertContainer');
        const alertId = 'alert-' + Date.now();
        
        const html = `
            <div id="${alertId}" class="alert alert-${type} alert-dismissible fade show alert-custom" role="alert">
                ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        `;
        
        container.innerHTML = html;
        
        // Auto-dismiss after 5 seconds
        setTimeout(() => {
            const alert = document.getElementById(alertId);
            if (alert) {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            }
        }, 5000);
    }
    
    formatDate(dateString) {
        const date = new Date(dateString);
        return date.toLocaleDateString('vi-VN');
    }
    
    formatTime(timeString) {
        const time = new Date('1970-01-01T' + timeString);
        return time.toLocaleTimeString('vi-VN', { hour: '2-digit', minute: '2-digit' });
    }
    
    formatTimeElapsed(date) {
        const now = new Date();
        const diff = now - date;
        const minutes = Math.floor(diff / (1000 * 60));
        
        if (minutes < 1) {
            return 'Vừa xong';
        } else if (minutes < 60) {
            return `${minutes} phút trước`;
        } else {
            const hours = Math.floor(minutes / 60);
            return `${hours} giờ trước`;
        }
    }
    
    getStatusText(status) {
        switch (status) {
            case 'SCHEDULED': return 'Đã lên lịch';
            case 'CONFIRMED': return 'Đã xác nhận';
            case 'IN_PROGRESS': return 'Đang thực hiện';
            case 'COMPLETED': return 'Hoàn thành';
            case 'CANCELLED': return 'Đã hủy';
            case 'NO_SHOW': return 'Không đến';
            default: return status;
        }
    }
    
    // Public methods for button handlers
    refreshPage() {
        window.location.reload();
    }
    
    viewTodayBookings() {
        window.open(`${this.contextPath}/bookings?date=today`, '_blank');
    }
    
    manualCheckInModal() {
        const modal = new bootstrap.Modal(document.getElementById('manualCheckInModal'));
        modal.show();
    }
}

// Global functions for JSP onclick handlers
function startQRScanner() {
    window.qrCheckInSystem.startQRScanner();
}

function validateQRCode() {
    window.qrCheckInSystem.validateQRCode();
}

function processQRCheckIn() {
    window.qrCheckInSystem.processQRCheckIn();
}

function processManualCheckIn() {
    window.qrCheckInSystem.processManualCheckIn();
}

function refreshPage() {
    window.qrCheckInSystem.refreshPage();
}

function viewTodayBookings() {
    window.qrCheckInSystem.viewTodayBookings();
}

function manualCheckInModal() {
    window.qrCheckInSystem.manualCheckInModal();
}

// Initialize the QR check-in system when page loads
document.addEventListener('DOMContentLoaded', () => {
    window.qrCheckInSystem = new QRCheckInSystem();
});
