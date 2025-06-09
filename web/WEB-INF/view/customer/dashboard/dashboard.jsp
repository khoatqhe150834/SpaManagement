<%-- 
    Document   : dashboard.jsp
    Created on : Customer Dashboard Overview
    Author     : G1_SpaManagement Team
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Customer Dashboard - BeautyZone Spa</title>
    <style>
        /* Dashboard Styles */
        .dashboard-container {
            padding: 1.5rem;
            max-width: 1400px;
            margin: 0 auto;
        }
        
        .dashboard-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 2rem;
            flex-wrap: wrap;
            gap: 1rem;
        }
        
        .welcome-section h2 {
            font-size: 2rem;
            font-weight: bold;
            color: #2d3748;
            margin: 0 0 0.25rem 0;
        }
        
        .welcome-section p {
            color: #4a5568;
            margin: 0;
        }
        
        .next-appointment {
            text-align: right;
        }
        
        .next-appointment p:first-child {
            font-size: 0.875rem;
            color: #4a5568;
            margin: 0;
        }
        
        .next-appointment p:last-child {
            font-size: 1.125rem;
            font-weight: 600;
            color: #2d3748;
            margin: 0;
        }
        
        /* Grid Layouts */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .quick-actions-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .two-column-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        
        /* Stat Cards */
        .stat-card {
            background: linear-gradient(135deg, #f7fafc 0%, #e2e8f0 100%);
            padding: 1.5rem;
            border-radius: 0.75rem;
            border: 1px solid #e2e8f0;
            transition: box-shadow 0.2s ease;
        }
        
        .stat-card:hover {
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }
        
        .stat-card.sage {
            background: linear-gradient(135deg, #f0fdfa 0%, #ccfbf1 100%);
            border-color: #5eead4;
        }
        
        .stat-card.coral {
            background: linear-gradient(135deg, #fff5f5 0%, #fed7d7 100%);
            border-color: #fc8181;
        }
        
        .stat-card.stone {
            background: linear-gradient(135deg, #fafaf9 0%, #e7e5e4 100%);
            border-color: #a8a29e;
        }
        
        .stat-card.emerald {
            background: linear-gradient(135deg, #ecfdf5 0%, #d1fae5 100%);
            border-color: #6ee7b7;
        }
        
        .stat-content {
            display: flex;
            align-items: center;
        }
        
        .stat-icon {
            padding: 0.75rem;
            border-radius: 0.5rem;
            margin-right: 1rem;
            color: white;
            font-size: 1.5rem;
        }
        
        .stat-icon.sage { background-color: #0d9488; }
        .stat-icon.coral { background-color: #e53e3e; }
        .stat-icon.stone { background-color: #57534e; }
        .stat-icon.emerald { background-color: #059669; }
        
        .stat-info p:first-child {
            font-size: 0.875rem;
            font-weight: 500;
            margin: 0;
            color: #374151;
        }
        
        .stat-info p:nth-child(2) {
            font-size: 2rem;
            font-weight: bold;
            margin: 0;
            color: #1f2937;
        }
        
        .stat-info p:last-child {
            font-size: 0.75rem;
            margin: 0;
            color: #6b7280;
        }
        
        /* Promotion Banner */
        .promotion-banner {
            background: linear-gradient(135deg, #e53e3e 0%, #c53030 100%);
            color: white;
            padding: 2rem;
            border-radius: 0.75rem;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
            margin-bottom: 2rem;
        }
        
        .promotion-content {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 1rem;
        }
        
        .promotion-text h3 {
            font-size: 1.25rem;
            font-weight: bold;
            margin: 0 0 0.5rem 0;
        }
        
        .promotion-text p {
            color: rgba(255, 255, 255, 0.9);
            margin: 0 0 1rem 0;
        }
        
        .promotion-actions {
            display: flex;
            align-items: center;
            gap: 1rem;
            flex-wrap: wrap;
        }
        
        .promotion-badge {
            background: rgba(255, 255, 255, 0.2);
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.875rem;
            font-weight: 500;
        }
        
        .promotion-button {
            background: white;
            color: #e53e3e;
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            font-weight: 500;
            text-decoration: none;
            transition: background-color 0.2s ease;
        }
        
        .promotion-button:hover {
            background: #f7fafc;
        }
        
        .promotion-discount {
            text-align: right;
        }
        
        .promotion-discount p:first-child {
            font-size: 3rem;
            font-weight: bold;
            margin: 0;
        }
        
        .promotion-discount p:last-child {
            color: rgba(255, 255, 255, 0.9);
            margin: 0;
        }
        
        /* Cards */
        .card {
            background: white;
            padding: 1.5rem;
            border-radius: 0.75rem;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
            border: 1px solid #e5e7eb;
        }
        
        .card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 1rem;
        }
        
        .card-header h3 {
            font-size: 1.125rem;
            font-weight: 600;
            color: #1f2937;
            margin: 0;
        }
        
        .card-icon {
            width: 1.25rem;
            height: 1.25rem;
            color: #6b7280;
        }
        
        /* List Items */
        .list-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0.75rem;
            background: #f9fafb;
            border-radius: 0.5rem;
            margin-bottom: 0.75rem;
            transition: background-color 0.2s ease;
        }
        
        .list-item:hover {
            background: #f3f4f6;
        }
        
        .list-item:last-child {
            margin-bottom: 0;
        }
        
        /* Buttons */
        .btn {
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            font-weight: 500;
            text-decoration: none;
            text-align: center;
            display: inline-block;
            transition: all 0.2s ease;
            border: none;
            cursor: pointer;
        }
        
        .btn-primary {
            background: #0d9488;
            color: white;
        }
        
        .btn-primary:hover {
            background: #0f766e;
        }
        
        .btn-coral {
            background: #e53e3e;
            color: white;
        }
        
        .btn-coral:hover {
            background: #c53030;
        }
        
        .btn-emerald {
            background: #059669;
            color: white;
        }
        
        .btn-emerald:hover {
            background: #047857;
        }
        
        .btn-full {
            width: 100%;
            margin-top: 1rem;
        }
        
        .btn-text {
            background: none;
            color: #0d9488;
            padding: 0.5rem 0;
        }
        
        .btn-text:hover {
            color: #0f766e;
        }
        
        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 2rem 0;
        }
        
        .empty-state-icon {
            font-size: 3rem;
            color: #d1d5db;
            margin-bottom: 1rem;
        }
        
        .empty-state p {
            color: #6b7280;
            margin-bottom: 1rem;
        }
        
        /* Notification Dot */
        .notification-dot {
            width: 0.5rem;
            height: 0.5rem;
            border-radius: 50%;
            margin-top: 0.5rem;
            flex-shrink: 0;
        }
        
        .dot-coral { background: #e53e3e; }
        .dot-emerald { background: #059669; }
        .dot-sage { background: #0d9488; }
        
        /* Responsive */
        @media (max-width: 768px) {
            .dashboard-header {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .next-appointment {
                text-align: left;
            }
            
            .promotion-content {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .promotion-discount {
                text-align: left;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- Header Section -->
        <div class="dashboard-header">
            <div class="welcome-section">
                <h2>Welcome back, ${sessionScope.customer.fullName != null ? sessionScope.customer.fullName : 'Valued Customer'}!</h2>
                <p>Here's your spa journey overview</p>
            </div>
            <div class="next-appointment">
                <p>Next Appointment</p>
                <p>Tomorrow at 2:00 PM</p>
            </div>
        </div>

        <!-- Stats Cards -->
        <div class="stats-grid">
            <div class="stat-card sage">
                <div class="stat-content">
                    <div class="stat-icon sage">📅</div>
                    <div class="stat-info">
                        <p>Upcoming</p>
                        <p>2</p>
                        <p>appointments</p>
                    </div>
                </div>
            </div>

            <div class="stat-card coral">
                <div class="stat-content">
                    <div class="stat-icon coral">🎁</div>
                    <div class="stat-info">
                        <p>Reward Points</p>
                        <p>${sessionScope.customer.loyaltyPoints != null ? sessionScope.customer.loyaltyPoints : 1240}</p>
                        <p>available to redeem</p>
                    </div>
                </div>
            </div>

            <div class="stat-card stone">
                <div class="stat-content">
                    <div class="stat-icon stone">⏰</div>
                    <div class="stat-info">
                        <p>Hours Relaxed</p>
                        <p>24</p>
                        <p>this year</p>
                    </div>
                </div>
            </div>

            <div class="stat-card emerald">
                <div class="stat-content">
                    <div class="stat-icon emerald">📈</div>
                    <div class="stat-info">
                        <p>Membership</p>
                        <p style="font-size: 1.5rem;">Gold</p>
                        <p>tier status</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Current Promotion -->
        <div class="promotion-banner">
            <div class="promotion-content">
                <div class="promotion-text">
                    <h3>🌸 Spring Special Offer</h3>
                    <p>Book any 90-minute massage and get a complimentary facial treatment</p>
                    <div class="promotion-actions">
                        <span class="promotion-badge">Valid until March 31st</span>
                        <a href="${pageContext.request.contextPath}/customer/appointments/booking" class="promotion-button">Book Now</a>
                    </div>
                </div>
                <div class="promotion-discount">
                    <p>25%</p>
                    <p>OFF</p>
                </div>
            </div>
        </div>

        <!-- Quick Actions Grid -->
        <div class="quick-actions-grid">
            <!-- Upcoming Appointments -->
            <div class="card">
                <div class="card-header">
                    <h3>Upcoming Appointments</h3>
                    <span class="card-icon">📅</span>
                </div>
                <div class="appointments-list">
                    <div class="list-item">
                        <div>
                            <p style="font-weight: 500; margin: 0; color: #1f2937;">Deep Tissue Massage</p>
                            <p style="font-size: 0.875rem; margin: 0; color: #6b7280;">with Emma Thompson</p>
                        </div>
                        <div style="text-align: right;">
                            <p style="font-size: 0.875rem; font-weight: 500; margin: 0; color: #1f2937;">Tomorrow</p>
                            <p style="font-size: 0.875rem; margin: 0; color: #6b7280;">2:00 PM</p>
                        </div>
                    </div>
                    <div class="list-item">
                        <div>
                            <p style="font-weight: 500; margin: 0; color: #1f2937;">Aromatherapy Session</p>
                            <p style="font-size: 0.875rem; margin: 0; color: #6b7280;">with Sarah Wilson</p>
                        </div>
                        <div style="text-align: right;">
                            <p style="font-size: 0.875rem; font-weight: 500; margin: 0; color: #1f2937;">March 28</p>
                            <p style="font-size: 0.875rem; margin: 0; color: #6b7280;">10:00 AM</p>
                        </div>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/customer/appointments/booking" class="btn btn-primary btn-full">Book New Appointment</a>
            </div>

            <!-- Available Rewards -->
            <div class="card">
                <div class="card-header">
                    <h3>Available Rewards</h3>
                    <span class="card-icon">🎁</span>
                </div>
                <div class="rewards-list">
                    <div class="list-item">
                        <div>
                            <p style="font-weight: 500; margin: 0; color: #1f2937;">Free 30-min Massage</p>
                            <p style="font-size: 0.875rem; margin: 0; color: #6b7280;">800 points</p>
                        </div>
                        <button class="btn btn-coral">Redeem</button>
                    </div>
                    <div class="list-item">
                        <div>
                            <p style="font-weight: 500; margin: 0; color: #1f2937;">Facial Treatment</p>
                            <p style="font-size: 0.875rem; margin: 0; color: #6b7280;">1200 points</p>
                        </div>
                        <button class="btn btn-coral">Redeem</button>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/customer/rewards/rewards-list" class="btn btn-coral btn-full">View All Rewards</a>
            </div>

            <!-- Quick Book Favorites -->
            <div class="card">
                <div class="card-header">
                    <h3>Quick Book Favorites</h3>
                    <span class="card-icon">⭐</span>
                </div>
                <div class="favorites-list">
                    <div class="list-item">
                        <div>
                            <p style="font-weight: 500; margin: 0; color: #1f2937;">Deep Tissue Massage</p>
                            <p style="font-size: 0.875rem; margin: 0; color: #6b7280;">with Emma Thompson</p>
                        </div>
                        <button class="btn btn-emerald">Book</button>
                    </div>
                    <div class="list-item">
                        <div>
                            <p style="font-weight: 500; margin: 0; color: #1f2937;">Aromatherapy Session</p>
                            <p style="font-size: 0.875rem; margin: 0; color: #6b7280;">with Emma Thompson</p>
                        </div>
                        <button class="btn btn-emerald">Book</button>
                    </div>
                </div>
                <a href="#" class="btn btn-emerald btn-full">Manage Favorites</a>
            </div>
        </div>

        <!-- Recent Activity & Recommendations -->
        <div class="two-column-grid">
            <!-- Recent Treatments -->
            <div class="card">
                <div class="card-header">
                    <h3>Recent Treatments</h3>
                    <span class="card-icon">📄</span>
                </div>
                <div class="treatments-list">
                    <div class="list-item">
                        <div style="display: flex; align-items: center; gap: 1rem;">
                            <div style="width: 0.5rem; height: 0.5rem; background: #059669; border-radius: 50%;"></div>
                            <div>
                                <p style="font-weight: 500; margin: 0; color: #1f2937;">Swedish Massage</p>
                                <p style="font-size: 0.875rem; margin: 0; color: #6b7280;">with Emma Thompson</p>
                            </div>
                        </div>
                        <div style="text-align: right;">
                            <p style="font-size: 0.875rem; font-weight: 500; margin: 0; color: #1f2937;">March 15</p>
                            <p style="font-size: 0.875rem; margin: 0; color: #6b7280;">$120</p>
                        </div>
                    </div>
                    <div class="list-item">
                        <div style="display: flex; align-items: center; gap: 1rem;">
                            <div style="width: 0.5rem; height: 0.5rem; background: #059669; border-radius: 50%;"></div>
                            <div>
                                <p style="font-weight: 500; margin: 0; color: #1f2937;">Facial Treatment</p>
                                <p style="font-size: 0.875rem; margin: 0; color: #6b7280;">with Sarah Wilson</p>
                            </div>
                        </div>
                        <div style="text-align: right;">
                            <p style="font-size: 0.875rem; font-weight: 500; margin: 0; color: #1f2937;">March 10</p>
                            <p style="font-size: 0.875rem; margin: 0; color: #6b7280;">$85</p>
                        </div>
                    </div>
                    <div class="list-item">
                        <div style="display: flex; align-items: center; gap: 1rem;">
                            <div style="width: 0.5rem; height: 0.5rem; background: #059669; border-radius: 50%;"></div>
                            <div>
                                <p style="font-weight: 500; margin: 0; color: #1f2937;">Aromatherapy</p>
                                <p style="font-size: 0.875rem; margin: 0; color: #6b7280;">with Emma Thompson</p>
                            </div>
                        </div>
                        <div style="text-align: right;">
                            <p style="font-size: 0.875rem; font-weight: 500; margin: 0; color: #1f2937;">March 5</p>
                            <p style="font-size: 0.875rem; margin: 0; color: #6b7280;">$95</p>
                        </div>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/customer/treatments/history" class="btn btn-text btn-full">View Full History</a>
            </div>

            <!-- Product Recommendations -->
            <div class="card">
                <div class="card-header">
                    <h3>Recommended for You</h3>
                    <span class="card-icon">🛍️</span>
                </div>
                <div class="products-list">
                    <div class="list-item" style="border: 1px solid #e5e7eb;">
                        <div>
                            <p style="font-weight: 500; margin: 0; color: #1f2937;">Lavender Body Oil</p>
                            <p style="font-size: 0.875rem; margin: 0; color: #6b7280;">Based on your aromatherapy sessions</p>
                        </div>
                        <div style="text-align: right;">
                            <p style="font-weight: bold; margin: 0; color: #1f2937;">$45</p>
                            <button style="background: none; border: none; color: #0d9488; font-size: 0.875rem; cursor: pointer;">Add to Cart</button>
                        </div>
                    </div>
                    <div class="list-item" style="border: 1px solid #e5e7eb;">
                        <div>
                            <p style="font-weight: 500; margin: 0; color: #1f2937;">Hydrating Face Mask</p>
                            <p style="font-size: 0.875rem; margin: 0; color: #6b7280;">Perfect for your skin type</p>
                        </div>
                        <div style="text-align: right;">
                            <p style="font-weight: bold; margin: 0; color: #1f2937;">$32</p>
                            <button style="background: none; border: none; color: #0d9488; font-size: 0.875rem; cursor: pointer;">Add to Cart</button>
                        </div>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/customer/recommendations/services" class="btn btn-primary btn-full">View All Recommendations</a>
            </div>
        </div>

        <!-- Notifications -->
        <div class="card">
            <div class="card-header">
                <h3>Recent Notifications</h3>
                <span class="card-icon">🔔</span>
            </div>
            <div class="notifications-list">
                <div style="display: flex; align-items: flex-start; gap: 0.75rem; padding: 0.75rem; background: #f9fafb; border-radius: 0.5rem; margin-bottom: 0.75rem;">
                    <div class="notification-dot dot-coral"></div>
                    <div style="flex: 1;">
                        <p style="font-size: 0.875rem; margin: 0 0 0.25rem 0; color: #1f2937;">Appointment reminder: Swedish Massage tomorrow at 2:00 PM</p>
                        <p style="font-size: 0.75rem; margin: 0; color: #6b7280;">2 hours ago</p>
                    </div>
                </div>
                <div style="display: flex; align-items: flex-start; gap: 0.75rem; padding: 0.75rem; background: #f9fafb; border-radius: 0.5rem; margin-bottom: 0.75rem;">
                    <div class="notification-dot dot-emerald"></div>
                    <div style="flex: 1;">
                        <p style="font-size: 0.875rem; margin: 0 0 0.25rem 0; color: #1f2937;">New spring promotion available - 25% off facial treatments</p>
                        <p style="font-size: 0.75rem; margin: 0; color: #6b7280;">1 day ago</p>
                    </div>
                </div>
                <div style="display: flex; align-items: flex-start; gap: 0.75rem; padding: 0.75rem; background: #f9fafb; border-radius: 0.5rem;">
                    <div class="notification-dot dot-sage"></div>
                    <div style="flex: 1;">
                        <p style="font-size: 0.875rem; margin: 0 0 0.25rem 0; color: #1f2937;">You earned 120 reward points from your last visit</p>
                        <p style="font-size: 0.75rem; margin: 0; color: #6b7280;">3 days ago</p>
                    </div>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/customer/dashboard/notifications" class="btn btn-text btn-full">View All Notifications</a>
        </div>
    </div>
</body>
</html> 