# Manager Dashboard Folder Structure

## 📋 Overview

This document outlines the complete folder structure for the **Manager Dashboard** system in the G1 Spa Management application. The structure is designed to provide comprehensive management capabilities for all spa operations.

## 📁 Complete Folder Hierarchy

```
web/WEB-INF/view/manager/
├── 📂 dashboard/              # Main Interface (Giao diện chính)
│   ├── appointments/          # Appointment Statistics & Charts
│   ├── notifications/         # Important Notifications
│   └── revenue/              # Revenue Overview (Daily/Weekly/Monthly)
│
├── 📂 customers/             # Customer Management (Quản lý khách hàng)
│   ├── categories/           # Customer Classification (VIP, Regular, New)
│   ├── history/             # Service Usage History
│   ├── list/                # Customer Information Lists
│   └── notes/               # Special Customer Notes
│
├── 📂 services/              # Service Management (Quản lý dịch vụ)
│   ├── analytics/           # Most Booked Services Tracking
│   ├── media/               # Image & Service Description Management
│   ├── packages/            # Add/Edit/Delete Service Packages
│   └── pricing/             # Price & Promotion Updates
│
├── 📂 staff/                 # Staff Management (Quản lý nhân viên)
│   ├── assignments/         # Work Assignments
│   ├── list/                # Staff List & Detailed Information
│   ├── performance/         # Performance Statistics
│   └── schedules/           # Staff Work Schedules
│
├── 📂 reports/               # Reports & Analytics (Báo cáo và thống kê)
│   ├── customers/           # New Customer Statistics
│   ├── revenue/             # Detailed Revenue Reports
│   ├── reviews/             # Customer Reviews & Feedback
│   └── trends/              # Service Trend Analysis
│
└── 📂 shared/                # Shared Components
    ├── sidebar/             # Navigation Sidebar Components
    ├── header/              # Header Components
    └── common/              # Common Reusable Components
```

## 📊 Section Details

### 1. **Dashboard (Giao diện chính)**

Main management interface providing quick overview and insights.

| Folder           | Purpose                           | Features                                                                                    |
| ---------------- | --------------------------------- | ------------------------------------------------------------------------------------------- |
| `appointments/`  | Appointment statistics and charts | • Booking trend charts<br>• Daily/weekly/monthly appointment views<br>• Peak hours analysis |
| `notifications/` | Important system notifications    | • Critical alerts<br>• System announcements<br>• Reminder notifications                     |
| `revenue/`       | Revenue overview and analytics    | • Daily revenue tracking<br>• Weekly/monthly comparisons<br>• Revenue by service type       |

### 2. **Customer Management (Quản lý khách hàng)**

Comprehensive customer relationship management system.

| Folder        | Purpose                      | Features                                                                                        |
| ------------- | ---------------------------- | ----------------------------------------------------------------------------------------------- |
| `list/`       | Customer database management | • Customer search and filtering<br>• Contact information management<br>• Customer profile views |
| `history/`    | Service usage tracking       | • Treatment history<br>• Spending patterns<br>• Frequency analysis                              |
| `categories/` | Customer segmentation        | • VIP customer management<br>• Regular customer tracking<br>• New customer onboarding           |
| `notes/`      | Special customer information | • Preferences and allergies<br>• Special requirements<br>• Communication notes                  |

### 3. **Service Management (Quản lý dịch vụ)**

Complete service portfolio management system.

| Folder       | Purpose                        | Features                                                                      |
| ------------ | ------------------------------ | ----------------------------------------------------------------------------- |
| `packages/`  | Service package administration | • Create/edit/delete packages<br>• Package combinations<br>• Service bundling |
| `pricing/`   | Price and promotion management | • Dynamic pricing<br>• Discount management<br>• Seasonal promotions           |
| `media/`     | Content management             | • Service images<br>• Description management<br>• Marketing materials         |
| `analytics/` | Service performance tracking   | • Popular services analysis<br>• Revenue by service<br>• Booking trends       |

### 4. **Staff Management (Quản lý nhân viên)**

Human resource management for spa operations.

| Folder         | Purpose                    | Features                                                                 |
| -------------- | -------------------------- | ------------------------------------------------------------------------ |
| `list/`        | Employee database          | • Staff profiles<br>• Contact information<br>• Role management           |
| `schedules/`   | Work schedule management   | • Shift planning<br>• Availability tracking<br>• Schedule conflicts      |
| `performance/` | Performance analytics      | • KPI tracking<br>• Customer satisfaction<br>• Revenue per staff         |
| `assignments/` | Task and client assignment | • Service assignments<br>• Client preferences<br>• Workload distribution |

### 5. **Reports & Analytics (Báo cáo và thống kê)**

Business intelligence and reporting system.

| Folder       | Purpose                      | Features                                                                     |
| ------------ | ---------------------------- | ---------------------------------------------------------------------------- |
| `revenue/`   | Financial reporting          | • Detailed revenue analysis<br>• Profit margins<br>• Cost analysis           |
| `customers/` | Customer analytics           | • New customer acquisition<br>• Retention rates<br>• Customer lifetime value |
| `trends/`    | Business trend analysis      | • Seasonal patterns<br>• Service popularity trends<br>• Market analysis      |
| `reviews/`   | Customer feedback management | • Review aggregation<br>• Sentiment analysis<br>• Response management        |

### 6. **Shared Components**

Reusable UI components for consistent design.

| Component  | Purpose                                  |
| ---------- | ---------------------------------------- |
| `sidebar/` | Navigation sidebar for manager dashboard |
| `header/`  | Common header components                 |
| `common/`  | Reusable UI elements and utilities       |

## 🔗 URL Structure

The manager dashboard will follow this URL pattern:

```
/manager-dashboard/[section]/[subsection]/[action]
```

### Examples:

- Main Dashboard: `/manager-dashboard`
- Customer List: `/manager-dashboard/customers/list`
- Revenue Reports: `/manager-dashboard/reports/revenue`
- Staff Schedules: `/manager-dashboard/staff/schedules`
- Service Analytics: `/manager-dashboard/services/analytics`

## 🛠 Implementation Guidelines

### Controller Structure

```java
@WebServlet(name = "ManagerDashboardController", urlPatterns = { "/manager-dashboard/*" })
public class ManagerDashboardController extends HttpServlet {
    // Handle all manager dashboard routes
}
```

### JSP File Naming Convention

- Main pages: `[section].jsp` (e.g., `customers.jsp`)
- Sub-pages: `[action].jsp` (e.g., `list.jsp`, `analytics.jsp`)
- Forms: `[action]-form.jsp` (e.g., `add-form.jsp`)

### Authentication Requirements

- Manager role authentication required
- Session-based access control
- Route-level permission checking

## 📋 Next Steps

1. **Create Controller**: `ManagerDashboardController.java`
2. **Create Main JSP Files**: One for each main section
3. **Create Shared Components**: Sidebar, header, breadcrumbs
4. **Implement Authentication**: Role-based access control
5. **Create Sub-page JSPs**: Based on specific requirements
6. **Add Styling**: Consistent with admin framework

## 📝 Notes

- All folders are created but currently empty
- JSP files need to be created based on specific requirements
- Shared components should be created first for consistency
- Follow existing admin framework styling conventions
- Ensure responsive design for all manager dashboard pages

---

**Created:** December 2024  
**Author:** G1_SpaManagement Team  
**Version:** 1.0
