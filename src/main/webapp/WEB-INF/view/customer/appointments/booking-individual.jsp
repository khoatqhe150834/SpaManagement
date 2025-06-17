<%-- 
    Document   : booking-individual.jsp
    Created on : Individual Appointment Booking
    Author     : G1_SpaManagement Team
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Đặt Lịch Hẹn Cá Nhân - BeautyZone Spa</title>
    
    <!-- Include Home Framework Styles -->
    <jsp:include page="/WEB-INF/view/common/home/stylesheet.jsp" />
    
    <style>
        /* Color Variables from Palette */
        :root {
            /* Primary Colors */
            --spa-primary: #c8945f;
            --spa-secondary: #b59259;
            --spa-accent: #596bb5;
            
            /* Dark Colors */
            --spa-dark-bg: #2b2d36;
            --spa-dark-text: #36342b;
            --spa-dark-border: #36322b;
            
            /* Light Variants */
            --spa-primary-light: rgba(200, 148, 95, 0.1);
            --spa-secondary-light: rgba(181, 146, 89, 0.1);
            --spa-accent-light: rgba(89, 107, 181, 0.1);
            
            /* Hover States */
            --spa-primary-hover: #b8854e;
            --spa-secondary-hover: #a08350;
            --spa-accent-hover: #4f5fa3;
        }
        
        /* Enhanced Home Framework Integration */
        .page-content {
            background: #f8fafc;
            min-height: 100vh;
        }
        
        /* Simplified Progress Indicator */
        .booking-progress {
            background: white;
            border-radius: 12px;
            padding: 20px 25px;
            margin: 20px 0;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            border: 1px solid #e5e7eb;
        }
        
        .progress-steps {
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: relative;
            width: 100%;
            max-width: 600px;
            margin: 0 auto;
        }
        
        .progress-steps::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 25px;
            right: 25px;
            height: 3px;
            background: #e2e8f0;
            border-radius: 2px;
            z-index: 1;
            transform: translateY(-50%);
        }
        
        .progress-line {
            position: absolute;
            top: 50%;
            left: 25px;
            height: 3px;
            background: linear-gradient(90deg, var(--spa-primary) 0%, var(--spa-secondary) 50%, var(--spa-secondary-hover) 100%);
            border-radius: 2px;
            z-index: 2;
            transform: translateY(-50%);
            width: 0;
            transition: all 0.8s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 2px 8px rgba(200, 148, 95, 0.3);
        }
        
        .progress-line::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            border-radius: inherit;
            animation: shimmer 2s infinite;
        }
        
        @keyframes shimmer {
            0% { transform: translateX(-100%); }
            100% { transform: translateX(100%); }
        }
        
        .step-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
            position: relative;
            z-index: 3;
            background: white;
            padding: 0 15px;
            min-width: 100px;
        }
        
        .step-circle {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 8px;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
        }
        
        .step-circle::before {
            content: '';
            position: absolute;
            inset: 0;
            border-radius: inherit;
            padding: 2px;
            background: linear-gradient(135deg, var(--spa-primary), var(--spa-secondary), var(--spa-secondary-hover));
            mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
            mask-composite: xor;
            -webkit-mask-composite: xor;
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        
        .step-item.completed .step-circle {
            background: linear-gradient(135deg, var(--spa-primary), var(--spa-secondary));
            color: white;
            box-shadow: 0 4px 15px rgba(200, 148, 95, 0.4);
            transform: scale(1.02);
        }
        
        .step-item.active .step-circle {
            background: linear-gradient(135deg, var(--spa-primary), var(--spa-secondary));
            color: white;
            box-shadow: 0 6px 20px rgba(200, 148, 95, 0.5);
            transform: scale(1.08);
            animation: pulse 2s infinite;
        }
        
        .step-item.active .step-circle::before {
            opacity: 1;
        }
        
        .step-item.inactive .step-circle {
            background: #f8fafc;
            color: #9ca3af;
            border: 3px solid #e5e7eb;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        
        .step-item.inactive .step-circle:hover {
            border-color: var(--spa-primary);
            color: var(--spa-primary);
            transform: scale(1.02);
        }
        
        @keyframes pulse {
            0%, 100% { 
                box-shadow: 0 6px 20px rgba(200, 148, 95, 0.5), 0 0 0 0 rgba(200, 148, 95, 0.4); 
            }
            50% { 
                box-shadow: 0 6px 20px rgba(200, 148, 95, 0.5), 0 0 0 8px rgba(200, 148, 95, 0); 
            }
        }
        
        .step-label {
            font-size: 13px;
            font-weight: 600;
            color: #6b7280;
            margin-top: 6px;
            line-height: 1.2;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .step-item.active .step-label,
        .step-item.completed .step-label {
            color: var(--spa-primary);
            font-weight: 700;
            transform: translateY(-2px);
        }
        
        .step-item.inactive .step-label:hover {
            color: var(--spa-primary);
        }
        
        /* Responsive Progress Steps */
        @media (max-width: 768px) {
            .booking-progress {
                padding: 15px 20px;
                margin: 15px 0;
            }
            
            .progress-steps::before {
                left: 20px;
                right: 20px;
                height: 2px;
            }
            
            .progress-line {
                left: 20px;
                height: 2px;
            }
            
            .step-item {
                padding: 0 8px;
                min-width: 80px;
            }
            
            .step-circle {
                width: 40px;
                height: 40px;
                font-size: 16px;
                margin-bottom: 6px;
            }
            
            .step-label {
                font-size: 11px;
                margin-top: 4px;
            }
        }
        
        @media (max-width: 480px) {
            .step-item {
                min-width: 60px;
                padding: 0 5px;
            }
            
            .step-circle {
                width: 35px;
                height: 35px;
                font-size: 14px;
            }
            
            .step-label {
                font-size: 10px;
                line-height: 1.1;
            }
            
            .progress-steps::before {
                left: 15px;
                right: 15px;
            }
            
            .progress-line {
                left: 15px;
            }
        }
        
        /* Simplified Page Header */
        .page-header {
            text-align: center;
            margin: 30px 0;
        }
        
        .page-main-title {
            font-size: 2.2rem;
            font-weight: 700;
            color: #1f2937;
            margin-bottom: 12px;
            background: linear-gradient(135deg, var(--spa-primary), var(--spa-secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .page-subtitle {
            font-size: 1rem;
            color: #6b7280;
            max-width: 500px;
            margin: 0 auto;
            line-height: 1.5;
        }
        
        /* Enhanced Search Section with Categories */
        .service-search {
            background: white;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.06);
            border: 1px solid #e5e7eb;
            position: relative;
        }
        
        .search-container {
            position: relative;
            margin-bottom: 20px;
        }
        
        .search-input {
            width: 100%;
            padding: 16px 50px 16px 20px;
            border: 2px solid #e5e7eb;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 500;
            background: #f8fafc;
            transition: all 0.3s ease;
            outline: none;
        }
        
        .search-input:focus {
            border-color: var(--spa-primary);
            background: white;
            box-shadow: 0 0 0 3px var(--spa-primary-light);
            transform: translateY(-1px);
        }
        
        .search-input::placeholder {
            color: #9ca3af;
            font-weight: 400;
        }
        
        .search-icon {
            position: absolute;
            right: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #9ca3af;
            font-size: 20px;
            pointer-events: none;
            transition: color 0.3s ease;
        }
        
        .search-input:focus + .search-icon {
            color: var(--spa-primary);
        }
        
        /* Search Divider */
        .search-divider {
            display: flex;
            align-items: center;
            margin: 20px 0;
            gap: 15px;
        }
        
        .divider-line {
            flex: 1;
            height: 1px;
            background: linear-gradient(90deg, transparent, #e5e7eb, transparent);
        }
        
        .divider-text {
            color: #9ca3af;
            font-size: 0.85rem;
            font-weight: 500;
            padding: 0 10px;
            background: white;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        /* Category Quick Selection */
        .category-quick-select {
            margin-bottom: 20px;
        }
        
        .category-label {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 12px;
            color: #6b7280;
            font-size: 0.9rem;
            font-weight: 500;
        }
        
        .category-label iconify-icon {
            color: var(--spa-primary);
            font-size: 16px;
        }
        
        .category-buttons {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }
        
        .category-btn {
            display: flex;
            align-items: center;
            gap: 6px;
            padding: 10px 16px;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            background: white;
            color: #6b7280;
            font-size: 0.85rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            white-space: nowrap;
        }
        
        .category-btn iconify-icon {
            font-size: 16px;
            transition: all 0.3s ease;
        }
        
        .category-btn:hover {
            border-color: var(--spa-primary);
            color: var(--spa-primary);
            transform: translateY(-1px);
            box-shadow: 0 4px 12px var(--spa-primary-light);
        }
        
        .category-btn:hover iconify-icon {
            color: var(--spa-primary);
        }
        
        .category-btn.active {
            background: linear-gradient(135deg, var(--spa-primary), var(--spa-secondary));
            border-color: var(--spa-primary);
            color: white;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(200, 148, 95, 0.25);
        }
        
        .category-btn.active iconify-icon {
            color: white;
        }
        
        /* Search Results Dropdown */
        .search-results {
            display: none;
            position: absolute;
            top: 100%;
            left: 0;
            right: 0;
            background: white;
            border-radius: 10px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.12);
            border: 1px solid #e5e7eb;
            z-index: 100;
            max-height: 280px;
            overflow-y: auto;
            margin-top: 4px;
        }
        
        .search-results.show {
            display: block;
            animation: slideDown 0.2s ease-out;
        }
        
        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .search-result-item {
            padding: 14px 18px;
            border-bottom: 1px solid #f1f5f9;
            cursor: pointer;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .search-result-item:last-child {
            border-bottom: none;
        }
        
        .search-result-item:hover {
            background: linear-gradient(135deg, var(--spa-primary-light), var(--spa-secondary-light));
            color: var(--spa-primary);
            transform: translateX(2px);
        }
        
        .search-result-item iconify-icon {
            font-size: 18px;
            color: var(--spa-primary);
            flex-shrink: 0;
        }
        
        .search-result-text {
            flex: 1;
        }
        
        .search-result-name {
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 2px;
            font-size: 0.95rem;
        }
        
        .search-result-description {
            font-size: 0.8rem;
            color: #6b7280;
            line-height: 1.3;
        }
        
        .search-result-item:hover .search-result-name {
            color: var(--spa-primary);
        }
        
        .no-results {
            padding: 20px;
            text-align: center;
            color: #9ca3af;
            font-style: italic;
            font-size: 0.9rem;
        }
        
        .selected-category {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 12px 16px;
            background: linear-gradient(135deg, var(--spa-primary-light), var(--spa-secondary-light));
            border: 2px solid var(--spa-primary);
            border-radius: 8px;
            margin-top: 12px;
            transition: all 0.3s ease;
        }
        
        .selected-category iconify-icon {
            color: var(--spa-primary);
            font-size: 18px;
        }
        
        .selected-category-name {
            font-weight: 600;
            color: var(--spa-primary);
            flex: 1;
            font-size: 0.95rem;
        }
        
        .clear-selection {
            background: none;
            border: none;
            color: #6b7280;
            cursor: pointer;
            padding: 4px;
            border-radius: 50%;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .clear-selection:hover {
            background: rgba(107, 114, 128, 0.1);
            color: #374151;
            transform: scale(1.1);
        }
        
        /* Trust Building Elements */
        .trust-indicators {
            display: flex;
            justify-content: center;
            gap: 30px;
            margin: 20px 0;
            padding: 15px;
            background: linear-gradient(135deg, var(--spa-primary-light), var(--spa-secondary-light));
            border-radius: 8px;
            border: 1px solid rgba(200, 148, 95, 0.1);
        }
        
        .trust-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.85rem;
            color: #6b7280;
        }
        
        .trust-item iconify-icon {
            color: #10b981;
            font-size: 16px;
        }
        
        /* Enhanced Services Section */
        .services-section {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.06);
            border: 1px solid #e5e7eb;
            margin-bottom: 25px;
        }
        
        .section-title {
            font-size: 1.4rem;
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .section-title::before {
            content: '';
            width: 4px;
            height: 22px;
            background: linear-gradient(135deg, var(--spa-primary), var(--spa-secondary));
            border-radius: 2px;
        }
        
        /* Improved Service Cards */
        .service-card {
            border: 2px solid #f1f5f9;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 16px;
            background: white;
            position: relative;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            overflow: hidden;
        }
        
        .service-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, var(--spa-primary-light), var(--spa-secondary-light));
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        
        .service-card:hover {
            border-color: var(--spa-primary);
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(200, 148, 95, 0.12);
        }
        
        .service-card:hover::before {
            opacity: 1;
        }
        
        .service-card.selected {
            border-color: var(--spa-primary);
            background: linear-gradient(135deg, var(--spa-primary-light), var(--spa-secondary-light));
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(200, 148, 95, 0.15);
        }
        
        .service-title {
            font-size: 1.05rem;
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 8px;
            padding-right: 50px;
            line-height: 1.4;
        }
        
        .service-meta {
            display: flex;
            gap: 16px;
            margin-bottom: 10px;
            flex-wrap: wrap;
        }
        
        .service-duration,
        .service-price {
            display: flex;
            align-items: center;
            gap: 5px;
            font-size: 0.85rem;
            font-weight: 500;
        }
        
        .service-duration {
            color: #6b7280;
        }
        
        .service-duration iconify-icon {
            color: var(--spa-primary);
            font-size: 14px;
        }
        
        .service-price {
            color: #059669;
            font-weight: 600;
        }
        
        .service-price iconify-icon {
            color: #059669;
            font-size: 14px;
        }
        
        .service-description {
            color: #6b7280;
            font-size: 0.85rem;
            line-height: 1.5;
            margin-bottom: 12px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        .add-service-btn {
            position: absolute;
            top: 18px;
            right: 18px;
            width: 36px;
            height: 36px;
            border: 2px solid #e5e7eb;
            border-radius: 50%;
            background: white;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            z-index: 2;
        }
        
        .add-service-btn iconify-icon {
            font-size: 18px;
            color: #9ca3af;
            transition: all 0.3s ease;
        }
        
        .add-service-btn:hover {
            transform: scale(1.1);
            border-color: var(--spa-primary);
            box-shadow: 0 4px 12px rgba(200, 148, 95, 0.2);
        }
        
        .add-service-btn:hover iconify-icon {
            color: var(--spa-primary);
        }
        
        .service-card.selected .add-service-btn {
            background: linear-gradient(135deg, var(--spa-primary), var(--spa-secondary));
            border-color: var(--spa-primary);
            transform: scale(1.1);
            box-shadow: 0 4px 15px rgba(200, 148, 95, 0.3);
        }
        
        .service-card.selected .add-service-btn iconify-icon {
            color: white;
        }
        
        /* Enhanced Booking Summary */
        .booking-summary {
            background: white;
            border-radius: 12px;
            padding: 22px;
            position: sticky;
            top: 25px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.06);
            border: 1px solid #e5e7eb;
        }
        
        .summary-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 18px;
            padding-bottom: 12px;
            border-bottom: 2px solid #f1f5f9;
        }
        
        .summary-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: #1f2937;
        }
        
        .summary-total {
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--spa-primary);
        }
        
        .selected-services {
            margin-bottom: 18px;
        }
        
        .selected-service {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px;
            background: #f8fafc;
            border-radius: 8px;
            margin-bottom: 8px;
            border-left: 3px solid var(--spa-primary);
            transition: all 0.3s ease;
        }
        
        .selected-service:hover {
            background: #f1f5f9;
            transform: translateX(3px);
        }
        
        .service-name {
            font-size: 0.85rem;
            color: #374151;
            font-weight: 500;
            flex: 1;
            margin-right: 8px;
        }
        
        .service-price-summary {
            font-weight: 600;
            color: var(--spa-primary);
            font-size: 0.9rem;
        }
        
        /* Improved CTA Button */
        .continue-btn {
            width: 100%;
            padding: 16px 20px;
            background: linear-gradient(135deg, var(--spa-primary), var(--spa-secondary));
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .continue-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: left 0.5s;
        }
        
        .continue-btn:hover::before {
            left: 100%;
        }
        
        .continue-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(200, 148, 95, 0.4);
        }
        
        .continue-btn:disabled {
            background: #e5e7eb;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
            color: #9ca3af;
        }
        
        .continue-btn:disabled::before {
            display: none;
        }
        
        .no-services-message {
            text-align: center;
            color: #9ca3af;
            padding: 25px 15px;
            font-size: 0.85rem;
            font-style: italic;
            background: #f8fafc;
            border-radius: 8px;
            border: 2px dashed #e5e7eb;
        }
        
        .no-services-message iconify-icon {
            font-size: 1.8rem;
            margin-bottom: 8px;
            color: #d1d5db;
        }
        
        /* Loading States */
        .loading-pulse {
            animation: pulse 1.5s infinite;
        }
        
        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.7; }
        }
        
        /* Animations */
        .fade-in {
            animation: fadeIn 0.6s ease-out;
        }
        
        @keyframes fadeIn {
            from { 
                opacity: 0; 
                transform: translateY(15px); 
            }
            to { 
                opacity: 1; 
                transform: translateY(0); 
            }
        }
        
        .slide-in {
            animation: slideIn 0.4s ease-out;
        }
        
        @keyframes slideIn {
            from { 
                opacity: 0; 
                transform: translateX(-15px); 
            }
            to { 
                opacity: 1; 
                transform: translateX(0); 
            }
        }
        
        /* Enhanced Mobile Responsiveness */
        @media (max-width: 768px) {
            .page-main-title {
                font-size: 1.8rem;
            }
            
            .progress-steps {
                flex-wrap: wrap;
                gap: 12px;
            }
            
            .step-item {
                flex: 1;
                min-width: 70px;
            }
            
            .step-circle {
                width: 35px;
                height: 35px;
                font-size: 14px;
            }
            
            .search-input {
                padding: 14px 45px 14px 16px;
                font-size: 15px;
            }
            
            .service-card {
                padding: 16px;
            }
            
            .add-service-btn {
                width: 32px;
                height: 32px;
                top: 16px;
                right: 16px;
            }
            
            .service-meta {
                flex-direction: column;
                gap: 6px;
            }
            
            .trust-indicators {
                flex-direction: column;
                gap: 12px;
                align-items: center;
            }
            
            .continue-btn {
                padding: 14px 18px;
                font-size: 0.95rem;
            }
        }
        
        /* Notification Styles */
        .notification {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 14px 18px;
            border-radius: 8px;
            color: white;
            font-weight: 500;
            z-index: 1000;
            transform: translateX(100%);
            transition: transform 0.3s ease;
            display: flex;
            align-items: center;
            gap: 10px;
            min-width: 280px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
            font-size: 0.9rem;
        }
        
        .notification.show {
            transform: translateX(0);
        }
        
        .notification.success {
            background: linear-gradient(135deg, #10b981, #059669);
        }
        
        .notification.error {
            background: linear-gradient(135deg, #ef4444, #dc2626);
        }
        
        .notification.spa-theme {
            background: linear-gradient(135deg, var(--spa-primary), var(--spa-secondary));
        }
        
        .notification iconify-icon {
            font-size: 1.1rem;
        }
    </style>
</head>
<body id="bg">
    <div class="page-wraper">
        <div id="loading-area"></div>
        
        <!-- Header -->
        <jsp:include page="/WEB-INF/view/common/home/header.jsp" />
        
        <!-- Content -->
        <div class="page-content">
            <!-- Inner page banner -->
            <div class="dlab-bnr-inr overlay-primary bg-pt" style="background-image: url(${pageContext.request.contextPath}/assets/home/images/banner/bnr2.jpg);">
                <div class="container">
                    <div class="dlab-bnr-inr-entry">
                        <h1 class="text-white">Đặt Lịch Dịch Vụ</h1>
                        <!-- Breadcrumb row -->
                        <div class="breadcrumb-row">
                            <ul class="list-inline">
                                <li><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
                                <li><a href="${pageContext.request.contextPath}/appointments/booking-selection">Đặt Dịch Vụ</a></li>
                                <li>Chọn Dịch Vụ</li>
                            </ul>
                        </div>
                        <!-- Breadcrumb row END -->
                    </div>
                </div>
            </div>
            <!-- Inner page banner END -->
            
            <!-- Main Content -->
            <div class="section-full content-inner">
                <div class="container">
                    <!-- Progress Breadcrumb -->
                    <div class="booking-progress fade-in">
                        <div class="progress-steps">
                            <div class="progress-line"></div>
                            
                            <div class="step-item completed">
                                <div class="step-circle">
                                    <iconify-icon icon="material-symbols:check"></iconify-icon>
                                </div>
                                <div class="step-label">Loại dịch vụ</div>
                            </div>
                            
                            <div class="step-item active">
                                <div class="step-circle">
                                    <iconify-icon icon="material-symbols:shopping-bag"></iconify-icon>
                                </div>
                                <div class="step-label">Chọn dịch vụ</div>
                            </div>
                            
                            <div class="step-item inactive">
                                <div class="step-circle">
                                    <iconify-icon icon="material-symbols:calendar-month"></iconify-icon>
                                </div>
                                <div class="step-label">Thời gian</div>
                            </div>
                            
                            <div class="step-item inactive">
                                <div class="step-circle">
                                    <iconify-icon icon="material-symbols:check-circle"></iconify-icon>
                                </div>
                                <div class="step-label">Xác nhận</div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Page Header -->
                    <div class="page-header fade-in">
                        <h1 class="page-main-title">Chọn Dịch Vụ Yêu Thích</h1>
                        <p class="page-subtitle">Khám phá và lựa chọn những dịch vụ spa tuyệt vời nhất cho trải nghiệm thư giãn hoàn hảo của bạn</p>
                    </div>
                    
                    <div class="row">
                        <div class="col-lg-8">
                            <!-- Enhanced Service Search & Categories -->
                            <div class="service-search fade-in">
                                <!-- Search Input Section -->
                                <div class="search-container">
                                    <input type="text" class="search-input" id="serviceSearch" 
                                           placeholder="Tìm kiếm dịch vụ (ví dụ: manicure, massage, facial...)">
                                    <iconify-icon icon="material-symbols:search" class="search-icon"></iconify-icon>
                                    
                                    <div class="search-results" id="searchResults">
                                        <!-- Search results will be populated here -->
                                    </div>
                                </div>
                                
                                <!-- Divider with "OR" -->
                                <div class="search-divider">
                                    <span class="divider-line"></span>
                                    <span class="divider-text">hoặc</span>
                                    <span class="divider-line"></span>
                                </div>
                                
                                <!-- Quick Category Selection -->
                                <div class="category-quick-select">
                                    <div class="category-label">
                                        <iconify-icon icon="material-symbols:category"></iconify-icon>
                                        <span>Chọn nhanh theo danh mục:</span>
                                    </div>
                                    <div class="category-buttons">
                                        <button class="category-btn active" data-category="featured">
                                            <iconify-icon icon="material-symbols:star"></iconify-icon>
                                            <span>Nổi bật</span>
                                        </button>
                                        <button class="category-btn" data-category="manicures">
                                            <iconify-icon icon="material-symbols:hand-gesture"></iconify-icon>
                                            <span>Manicures</span>
                                        </button>
                                        <button class="category-btn" data-category="pedicures">
                                            <iconify-icon icon="material-symbols:footprint"></iconify-icon>
                                            <span>Pedicures</span>
                                        </button>
                                        <button class="category-btn" data-category="brows">
                                            <iconify-icon icon="material-symbols:visibility"></iconify-icon>
                                            <span>Brows & Lashes</span>
                                        </button>
                                        <button class="category-btn" data-category="waxing">
                                            <iconify-icon icon="material-symbols:local-fire-department"></iconify-icon>
                                            <span>Waxing</span>
                                        </button>
                                        <button class="category-btn" data-category="all">
                                            <iconify-icon icon="material-symbols:grid-view"></iconify-icon>
                                            <span>Tất cả</span>
                                        </button>
                                    </div>
                                </div>
                                
                                <!-- Trust Indicators -->
                                <div class="trust-indicators">
                                    <div class="trust-item">
                                        <iconify-icon icon="material-symbols:verified"></iconify-icon>
                                        <span>100% An toàn</span>
                                    </div>
                                    <div class="trust-item">
                                        <iconify-icon icon="material-symbols:schedule"></iconify-icon>
                                        <span>Đặt lịch nhanh chóng</span>
                                    </div>
                                    <div class="trust-item">
                                        <iconify-icon icon="material-symbols:support-agent"></iconify-icon>
                                        <span>Hỗ trợ 24/7</span>
                                    </div>
                                </div>
                                
                                <!-- Selected Category Display (for search results) -->
                                <div class="selected-category" id="selectedCategory" style="display: none;">
                                    <iconify-icon icon="material-symbols:star"></iconify-icon>
                                    <span class="selected-category-name">Dịch vụ nổi bật</span>
                                    <button class="clear-selection" id="clearSelection">
                                        <iconify-icon icon="material-symbols:close"></iconify-icon>
                                    </button>
                                </div>
                            </div>
                            
                            <!-- Services List -->
                            <div class="services-section fade-in" id="servicesSection">
                                <h2 class="section-title">Dịch Vụ Nổi Bật</h2>
                                
                                <!-- Featured Services -->
                                <div class="service-card" data-service-id="1" data-price="3" data-category="featured">
                                    <div class="service-title">Pedicure Treatments - (client to provide flip flops)</div>
                                    <div class="service-meta">
                                        <div class="service-duration">
                                            <iconify-icon icon="material-symbols:schedule"></iconify-icon>
                                            <span>10 phút - 1 giờ, 40 phút</span>
                                        </div>
                                        <div class="service-price">
                                            <iconify-icon icon="material-symbols:payments"></iconify-icon>
                                            <span>từ 3 £</span>
                                        </div>
                                    </div>
                                    <div class="service-description">IMPORTANT MESSAGE - Perfect You are proud to offer our clients 100% sterilized equipment and premium quality service for the ultimate pedicure experience...</div>
                                    <div class="add-service-btn">
                                        <iconify-icon icon="material-symbols:add"></iconify-icon>
                                    </div>
                                </div>
                                
                                <div class="service-card" data-service-id="2" data-price="3" data-category="featured">
                                    <div class="service-title">Manicure Treatments</div>
                                    <div class="service-meta">
                                        <div class="service-duration">
                                            <iconify-icon icon="material-symbols:schedule"></iconify-icon>
                                            <span>5 phút - 1 giờ, 30 phút</span>
                                        </div>
                                        <div class="service-price">
                                            <iconify-icon icon="material-symbols:payments"></iconify-icon>
                                            <span>từ 3 £</span>
                                        </div>
                                    </div>
                                    <div class="service-description">IMPORTANT MESSAGE - Perfect You are proud to offer our clients 100% sterilized equipment and premium quality service for professional manicure treatments...</div>
                                    <div class="add-service-btn">
                                        <iconify-icon icon="material-symbols:add"></iconify-icon>
                                    </div>
                                </div>
                                
                                <div class="service-card" data-service-id="3" data-price="45" data-category="featured">
                                    <div class="service-title">BIAB Overlay</div>
                                    <div class="service-meta">
                                        <div class="service-duration">
                                            <iconify-icon icon="material-symbols:schedule"></iconify-icon>
                                            <span>1 giờ, 50 phút</span>
                                        </div>
                                        <div class="service-price">
                                            <iconify-icon icon="material-symbols:payments"></iconify-icon>
                                            <span>45 £</span>
                                        </div>
                                    </div>
                                    <div class="service-description">BIAB or in other words builder in the bottle. What is it? Gel like polish applied as a base coat to strengthen natural nails and provide a perfect foundation for nail art...</div>
                                    <div class="add-service-btn">
                                        <iconify-icon icon="material-symbols:add"></iconify-icon>
                                    </div>
                                </div>
                                
                                <!-- Additional Services for other categories (hidden by default) -->
                                <div class="service-card" data-service-id="4" data-price="25" data-category="manicures" style="display: none;">
                                    <div class="service-title">Classic Manicure</div>
                                    <div class="service-meta">
                                        <div class="service-duration">
                                            <iconify-icon icon="material-symbols:schedule"></iconify-icon>
                                            <span>45 phút</span>
                                        </div>
                                        <div class="service-price">
                                            <iconify-icon icon="material-symbols:payments"></iconify-icon>
                                            <span>25 £</span>
                                        </div>
                                    </div>
                                    <div class="service-description">Traditional manicure with cuticle care, nail shaping, and polish application for perfectly groomed hands...</div>
                                    <div class="add-service-btn">
                                        <iconify-icon icon="material-symbols:add"></iconify-icon>
                                    </div>
                                </div>
                                
                                <div class="service-card" data-service-id="5" data-price="35" data-category="manicures" style="display: none;">
                                    <div class="service-title">Gel Manicure</div>
                                    <div class="service-meta">
                                        <div class="service-duration">
                                            <iconify-icon icon="material-symbols:schedule"></iconify-icon>
                                            <span>1 giờ</span>
                                        </div>
                                        <div class="service-price">
                                            <iconify-icon icon="material-symbols:payments"></iconify-icon>
                                            <span>35 £</span>
                                        </div>
                                    </div>
                                    <div class="service-description">Long-lasting gel polish manicure with UV curing for chip-resistant, glossy finish that lasts up to 2 weeks...</div>
                                    <div class="add-service-btn">
                                        <iconify-icon icon="material-symbols:add"></iconify-icon>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-lg-4">
                            <!-- Booking Summary -->
                            <div class="booking-summary fade-in">
                                <div class="summary-header">
                                    <div class="summary-title">Tổng Thanh Toán</div>
                                    <div class="summary-total" id="totalAmount">miễn phí</div>
                                </div>
                                
                                <div class="selected-services" id="selectedServices">
                                    <div class="no-services-message">
                                        <iconify-icon icon="material-symbols:shopping-bag"></iconify-icon>
                                        <div>Chưa có dịch vụ nào được chọn</div>
                                        <small>Hãy chọn dịch vụ yêu thích của bạn</small>
                                    </div>
                                </div>
                                
                                <button type="button" class="continue-btn" id="continueBtn" disabled>
                                    <iconify-icon icon="material-symbols:arrow-forward"></iconify-icon>
                                    <span>Tiếp Tục Đặt Lịch</span>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Footer -->
        <jsp:include page="/WEB-INF/view/common/home/footer.jsp" />
        
        <button class="scroltop fa fa-chevron-up"></button>
    </div>
    
    <!-- Include Home Framework JavaScript -->
    <jsp:include page="/WEB-INF/view/common/home/js.jsp" />
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            let selectedServices = [];
            let totalAmount = 0;
            let currentCategory = 'featured';
            
            // Enhanced Progress Control System
            const progressSteps = ['type', 'service', 'time', 'confirm'];
            let currentStep = 1; // Current step (0-based index, we're on step 2 - service selection)
            
            function updateProgressLine() {
                const progressLine = document.querySelector('.progress-line');
                const stepItems = document.querySelectorAll('.step-item');
                const progressContainer = document.querySelector('.progress-steps');
                
                if (!progressLine || !stepItems.length || !progressContainer) return;
                
                // Calculate progress based on current step
                // Step 0: 0%, Step 1: 33.33%, Step 2: 66.66%, Step 3: 100%
                const progressPercentages = [0, 33.33, 66.66, 100];
                const targetWidth = progressPercentages[currentStep] || 0;
                
                // Get the actual width of the progress container
                const containerWidth = progressContainer.offsetWidth;
                const stepWidth = containerWidth / 4; // 4 steps
                const actualWidth = (targetWidth / 100) * (containerWidth - 50); // Subtract margins
                
                // Animate progress line width
                progressLine.style.width = `${actualWidth}px`;
                
                // Update step states with enhanced animations
                stepItems.forEach((step, index) => {
                    step.classList.remove('completed', 'active', 'inactive');
                    
                    if (index < currentStep) {
                        step.classList.add('completed');
                        // Add completion animation
                        setTimeout(() => {
                            const circle = step.querySelector('.step-circle');
                            if (circle) {
                                circle.style.transform = 'scale(1.02)';
                                setTimeout(() => {
                                    circle.style.transform = '';
                                }, 200);
                            }
                        }, index * 100);
                    } else if (index === currentStep) {
                        step.classList.add('active');
                        // Add active animation
                        setTimeout(() => {
                            const circle = step.querySelector('.step-circle');
                            if (circle) {
                                circle.style.transform = 'scale(1.08)';
                            }
                        }, 300);
                    } else {
                        step.classList.add('inactive');
                    }
                });
                
                // Add shimmer effect when progressing
                if (currentStep > 0) {
                    progressLine.style.animation = 'none';
                    setTimeout(() => {
                        progressLine.style.animation = '';
                    }, 100);
                }
            }
            
            function setProgressStep(step) {
                if (step >= 0 && step < progressSteps.length) {
                    currentStep = step;
                    updateProgressLine();
                    
                    // Store progress in session
                    sessionStorage.setItem('bookingProgress', currentStep.toString());
                    
                    // Show progress notification
                    const stepNames = ['Chọn loại dịch vụ', 'Chọn dịch vụ', 'Chọn thời gian', 'Xác nhận đặt lịch'];
                    if (step > 0 && step < stepNames.length) {
                        showNotification(`✅ Bước ${step + 1}: ${stepNames[step]}`, 'success');
                    }
                }
            }
            
            function nextStep() {
                if (currentStep < progressSteps.length - 1) {
                    setProgressStep(currentStep + 1);
                }
            }
            
            function previousStep() {
                if (currentStep > 0) {
                    setProgressStep(currentStep - 1);
                }
            }
            
            // Initialize progress from session or default to step 1 (service selection)
            const savedProgress = sessionStorage.getItem('bookingProgress');
            if (savedProgress && parseInt(savedProgress) >= 1) {
                currentStep = parseInt(savedProgress);
            } else {
                currentStep = 1; // We're on service selection page
            }
            
            // Set initial progress state with delay for smooth animation
            setTimeout(() => {
                updateProgressLine();
            }, 800);
            
            // Add window resize handler to recalculate progress line
            let resizeTimeout;
            window.addEventListener('resize', function() {
                clearTimeout(resizeTimeout);
                resizeTimeout = setTimeout(() => {
                    updateProgressLine();
                }, 100);
            });
            
            // Initialize WOW animations if available
            if (typeof WOW !== 'undefined') {
                new WOW().init();
            }
            
            // Service categories data with better keywords
            const serviceCategories = [
                {
                    id: 'featured',
                    name: 'Dịch vụ nổi bật',
                    description: 'Những dịch vụ được yêu thích nhất tại spa',
                    icon: 'material-symbols:star',
                    keywords: ['nổi bật', 'popular', 'featured', 'hot', 'trending', 'yêu thích', 'phổ biến']
                },
                {
                    id: 'manicures',
                    name: 'Dịch vụ Manicures',
                    description: 'Chăm sóc và làm đẹp móng tay chuyên nghiệp',
                    icon: 'material-symbols:hand-gesture',
                    keywords: ['manicure', 'móng tay', 'nail', 'hand', 'tay', 'làm móng', 'chăm sóc tay']
                },
                {
                    id: 'pedicures',
                    name: 'Dịch vụ Pedicures',
                    description: 'Chăm sóc và làm đẹp móng chân thư giãn',
                    icon: 'material-symbols:footprint',
                    keywords: ['pedicure', 'móng chân', 'foot', 'chân', 'feet', 'làm móng chân', 'chăm sóc chân']
                },
                {
                    id: 'brows',
                    name: 'Brows & Lashes',
                    description: 'Chăm sóc và tạo dáng lông mày, lông mi',
                    icon: 'material-symbols:visibility',
                    keywords: ['brow', 'lash', 'mày', 'mi', 'eyebrow', 'eyelash', 'lông mày', 'lông mi', 'tạo dáng mày']
                },
                {
                    id: 'threading',
                    name: 'Eyebrow Threading',
                    description: 'Tạo dáng lông mày bằng chỉ truyền thống',
                    icon: 'material-symbols:spa',
                    keywords: ['threading', 'chỉ', 'eyebrow', 'mày', 'tạo dáng', 'chỉ mày', 'làm mày']
                },
                {
                    id: 'waxing',
                    name: 'Dịch vụ Waxing',
                    description: 'Tẩy lông bằng sáp an toàn và hiệu quả',
                    icon: 'material-symbols:local-fire-department',
                    keywords: ['waxing', 'sáp', 'tẩy lông', 'wax', 'hair removal', 'triệt lông', 'nhổ lông']
                }
            ];
            
            // DOM elements
            const searchInput = document.getElementById('serviceSearch');
            const searchResults = document.getElementById('searchResults');
            const selectedCategory = document.getElementById('selectedCategory');
            const clearSelection = document.getElementById('clearSelection');
            const serviceCards = document.querySelectorAll('.service-card');
            const sectionTitle = document.querySelector('.section-title');
            
            // Improved search with debouncing
            let searchTimeout;
            searchInput.addEventListener('input', function() {
                clearTimeout(searchTimeout);
                const query = this.value.trim().toLowerCase();
                
                if (query.length === 0) {
                    searchResults.classList.remove('show');
                    return;
                }
                
                // Debounce search for better performance
                searchTimeout = setTimeout(() => {
                    performSearch(query);
                }, 300);
            });
            
            function performSearch(query) {
                // Smart search with fuzzy matching
                const filteredCategories = serviceCategories.filter(category => {
                    const nameMatch = category.name.toLowerCase().includes(query);
                    const descMatch = category.description.toLowerCase().includes(query);
                    const keywordMatch = category.keywords.some(keyword => 
                        keyword.toLowerCase().includes(query) || query.includes(keyword.toLowerCase())
                    );
                    return nameMatch || descMatch || keywordMatch;
                });
                
                displaySearchResults(filteredCategories, query);
            }
            
            // Enhanced search results display
            function displaySearchResults(categories, query = '') {
                if (categories.length === 0) {
                    searchResults.innerHTML = `
                        <div class="no-results">
                            <iconify-icon icon="material-symbols:search-off"></iconify-icon>
                            <div>Không tìm thấy loại dịch vụ cho "${query}"</div>
                            <small>Thử tìm với từ khóa khác</small>
                        </div>
                    `;
                } else {
                    let resultsHtml = '';
                    categories.forEach((category, index) => {
                        // Highlight matching text
                        let highlightedName = category.name;
                        if (query) {
                            const regex = new RegExp(`(${query})`, 'gi');
                            highlightedName = category.name.replace(regex, '<mark style="background: rgba(200, 148, 95, 0.2); padding: 0;">$1</mark>');
                        }
                        
                        resultsHtml += `
                            <div class="search-result-item" data-category="${category.id}" style="animation-delay: ${index * 0.05}s">
                                <iconify-icon icon="${category.icon}"></iconify-icon>
                                <div class="search-result-text">
                                    <div class="search-result-name">${highlightedName}</div>
                                    <div class="search-result-description">${category.description}</div>
                                </div>
                            </div>
                        `;
                    });
                    searchResults.innerHTML = resultsHtml;
                    
                    // Add click handlers with improved feedback
                    searchResults.querySelectorAll('.search-result-item').forEach(item => {
                        item.addEventListener('click', function() {
                            const categoryId = this.getAttribute('data-category');
                            selectCategory(categoryId);
                            
                            // Visual feedback
                            this.style.transform = 'scale(0.95)';
                            setTimeout(() => {
                                this.style.transform = '';
                            }, 150);
                        });
                    });
                }
                
                searchResults.classList.add('show');
            }
            
            // Enhanced category and search handling
            const categoryButtons = document.querySelectorAll('.category-btn');
            
            // Category button handling
            categoryButtons.forEach(btn => {
                btn.addEventListener('click', function() {
                    const category = this.getAttribute('data-category');
                    
                    // Update active button
                    categoryButtons.forEach(b => b.classList.remove('active'));
                    this.classList.add('active');
                    
                    // Clear search input and hide results
                    searchInput.value = '';
                    searchResults.classList.remove('show');
                    selectedCategory.style.display = 'none';
                    
                    // Update current category and filter services
                    currentCategory = category;
                    
                    // Update section title
                    const categoryNames = {
                        'featured': 'Dịch Vụ Nổi Bật',
                        'manicures': 'Dịch Vụ Manicures',
                        'pedicures': 'Dịch Vụ Pedicures',
                        'brows': 'Dịch Vụ Brows & Lashes',
                        'threading': 'Dịch Vụ Eyebrow Threading',
                        'waxing': 'Dịch Vụ Waxing',
                        'all': 'Tất Cả Dịch Vụ'
                    };
                    
                    sectionTitle.style.opacity = '0.5';
                    setTimeout(() => {
                        sectionTitle.textContent = categoryNames[category] || 'Dịch Vụ';
                        sectionTitle.style.opacity = '1';
                    }, 200);
                    
                    // Filter services
                    if (category === 'all') {
                        // Show all services
                        filterAllServices();
                    } else {
                        filterServices(category);
                    }
                    
                    // Visual feedback
                    this.style.transform = 'scale(0.95)';
                    setTimeout(() => {
                        this.style.transform = '';
                    }, 150);
                    
                    showNotification(`✨ Đã chọn: ${categoryNames[category]}`, 'success');
                });
            });
            
            // Function to show all services
            function filterAllServices() {
                const servicesSection = document.getElementById('servicesSection');
                servicesSection.classList.add('loading-pulse');
                
                setTimeout(() => {
                    let visibleCount = 0;
                    serviceCards.forEach((card, index) => {
                        card.style.display = 'block';
                        card.style.opacity = '0';
                        card.style.transform = 'translateY(20px)';
                        
                        // Staggered animation
                        setTimeout(() => {
                            card.style.opacity = '1';
                            card.style.transform = 'translateY(0)';
                            card.classList.add('fade-in');
                        }, visibleCount * 50);
                        
                        visibleCount++;
                    });
                    
                    servicesSection.classList.remove('loading-pulse');
                }, 300);
            }
            
            // Enhanced search handling - only show search results when typing
            function selectCategory(categoryId) {
                const category = serviceCategories.find(cat => cat.id === categoryId);
                if (!category) return;
                
                // This is for search results, not category buttons
                currentCategory = categoryId;
                
                // Hide search results and clear input
                searchResults.classList.remove('show');
                searchInput.value = '';
                searchInput.blur();
                
                // Reset category buttons to show we're in search mode
                categoryButtons.forEach(btn => btn.classList.remove('active'));
                
                // Show selected category indicator
                selectedCategory.style.display = 'flex';
                selectedCategory.style.opacity = '0';
                selectedCategory.style.transform = 'translateY(-10px)';
                
                setTimeout(() => {
                    selectedCategory.querySelector('iconify-icon').setAttribute('icon', category.icon);
                    selectedCategory.querySelector('.selected-category-name').textContent = category.name;
                    
                    selectedCategory.style.opacity = '1';
                    selectedCategory.style.transform = 'translateY(0)';
                }, 50);
                
                // Update section title
                sectionTitle.style.opacity = '0.5';
                setTimeout(() => {
                    sectionTitle.textContent = category.name;
                    sectionTitle.style.opacity = '1';
                }, 200);
                
                // Filter services
                filterServices(categoryId);
                
                showNotification(`🔍 Tìm thấy: ${category.name}`, 'success');
            }
            
            // Enhanced clear selection for search results
            clearSelection.addEventListener('click', function() {
                // Hide search category indicator
                selectedCategory.style.opacity = '0';
                selectedCategory.style.transform = 'translateY(-10px)';
                
                setTimeout(() => {
                    selectedCategory.style.display = 'none';
                    selectedCategory.style.opacity = '1';
                    selectedCategory.style.transform = 'translateY(0)';
                }, 200);
                
                // Reset to featured category button
                categoryButtons.forEach(btn => btn.classList.remove('active'));
                const featuredBtn = document.querySelector('.category-btn[data-category="featured"]');
                if (featuredBtn) {
                    featuredBtn.classList.add('active');
                }
                
                currentCategory = 'featured';
                sectionTitle.textContent = 'Dịch Vụ Nổi Bật';
                
                // Show featured services
                filterServices('featured');
                
                showNotification('🔄 Đã reset về dịch vụ nổi bật', 'success');
            });
            
            // Enhanced service filtering
            function filterServices(categoryId) {
                const servicesSection = document.getElementById('servicesSection');
                servicesSection.classList.add('loading-pulse');
                
                setTimeout(() => {
                    let visibleCount = 0;
                    serviceCards.forEach((card, index) => {
                        const cardCategory = card.getAttribute('data-category');
                        if (cardCategory === categoryId) {
                            card.style.display = 'block';
                            card.style.opacity = '0';
                            card.style.transform = 'translateY(20px)';
                            
                            // Staggered animation
                            setTimeout(() => {
                                card.style.opacity = '1';
                                card.style.transform = 'translateY(0)';
                                card.classList.add('fade-in');
                            }, visibleCount * 100);
                            
                            visibleCount++;
                        } else {
                            card.style.display = 'none';
                            card.classList.remove('fade-in');
                        }
                    });
                    
                    servicesSection.classList.remove('loading-pulse');
                    
                    // Show message if no services found
                    if (visibleCount === 0) {
                        const noServicesMsg = document.createElement('div');
                        noServicesMsg.className = 'no-services-message';
                        noServicesMsg.innerHTML = `
                            <iconify-icon icon="material-symbols:search-off"></iconify-icon>
                            <div>Chưa có dịch vụ nào trong danh mục này</div>
                            <small>Vui lòng chọn danh mục khác</small>
                        `;
                        servicesSection.appendChild(noServicesMsg);
                    }
                }, 300);
            }
            
            // Service selection handling
            serviceCards.forEach(card => {
                const addBtn = card.querySelector('.add-service-btn');
                
                card.addEventListener('click', function(e) {
                    // Don't trigger if clicking the button directly
                    if (e.target.closest('.add-service-btn')) return;
                    
                    toggleServiceSelection(this);
                });
                
                addBtn.addEventListener('click', function(e) {
                    e.stopPropagation();
                    toggleServiceSelection(card);
                });
            });
            
            function toggleServiceSelection(card) {
                if (card.classList.contains('loading')) return;
                
                card.classList.add('loading');
                const addBtn = card.querySelector('.add-service-btn');
                const addIcon = addBtn.querySelector('iconify-icon');
                const isSelected = card.classList.contains('selected');
                
                // Visual feedback
                addBtn.style.transform = 'scale(0.8)';
                
                setTimeout(() => {
                    if (isSelected) {
                        // Remove service
                        card.classList.remove('selected');
                        addIcon.setAttribute('icon', 'material-symbols:add');
                        
                        const serviceId = card.getAttribute('data-service-id');
                        selectedServices = selectedServices.filter(s => s.id !== serviceId);
                        
                        showNotification('Đã bỏ chọn dịch vụ', 'success');
                    } else {
                        // Add service
                        card.classList.add('selected');
                        addIcon.setAttribute('icon', 'material-symbols:check');
                        
                        const serviceData = {
                            id: card.getAttribute('data-service-id'),
                            name: card.querySelector('.service-title').textContent,
                            price: parseFloat(card.getAttribute('data-price')),
                            duration: card.querySelector('.service-duration span').textContent
                        };
                        selectedServices.push(serviceData);
                        
                        showNotification('Đã thêm dịch vụ', 'success');
                    }
                    
                    addBtn.style.transform = 'scale(1)';
                    card.classList.remove('loading');
                    updateSummary();
                }, 200);
            }
            
            function updateSummary() {
                const servicesContainer = document.getElementById('selectedServices');
                const totalAmountElement = document.getElementById('totalAmount');
                const continueBtn = document.getElementById('continueBtn');
                
                totalAmount = selectedServices.reduce((sum, service) => sum + service.price, 0);
                
                // Animate summary update
                servicesContainer.style.opacity = '0.5';
                totalAmountElement.style.opacity = '0.5';
                
                setTimeout(() => {
                    if (selectedServices.length === 0) {
                        servicesContainer.innerHTML = `
                            <div class="no-services-message">
                                <iconify-icon icon="material-symbols:shopping-bag"></iconify-icon>
                                <div>Chưa có dịch vụ nào được chọn</div>
                                <small>Hãy chọn dịch vụ yêu thích của bạn</small>
                            </div>
                        `;
                        totalAmountElement.textContent = 'miễn phí';
                        continueBtn.disabled = true;
                    } else {
                        let servicesHtml = '';
                        selectedServices.forEach((service, index) => {
                            servicesHtml += `
                                <div class="selected-service slide-in" style="animation-delay: ${index * 0.1}s">
                                    <div class="service-name">${service.name}</div>
                                    <div class="service-price-summary">£${service.price}</div>
                                </div>
                            `;
                        });
                        servicesContainer.innerHTML = servicesHtml;
                        totalAmountElement.textContent = `£${totalAmount}`;
                        continueBtn.disabled = false;
                    }
                    
                    servicesContainer.style.opacity = '1';
                    totalAmountElement.style.opacity = '1';
                }, 200);
            }
            
            // Enhanced continue button handling with progress integration
            document.getElementById('continueBtn').addEventListener('click', function() {
                if (selectedServices.length === 0) {
                    showNotification('Vui lòng chọn ít nhất một dịch vụ', 'error');
                    return;
                }
                
                // Add loading state
                const originalContent = this.innerHTML;
                this.innerHTML = `
                    <iconify-icon icon="material-symbols:hourglass-empty" class="loading-pulse"></iconify-icon>
                    <span>Đang xử lý...</span>
                `;
                this.disabled = true;
                
                // Store selected services
                sessionStorage.setItem('selectedServices', JSON.stringify(selectedServices));
                
                // Progress to next step
                nextStep(); // This will show step 3 (time selection)
                
                // Simulate processing with enhanced feedback
                setTimeout(() => {
                    showNotification(`✅ Đã chọn ${selectedServices.length} dịch vụ thành công!`, 'success');
                    
                    // Show progress completion for current step
                    setTimeout(() => {
                        showNotification('🕒 Chuyển đến chọn thời gian...', 'success');
                        
                        setTimeout(() => {
                            // Redirect to next step
                            window.location.href = '${pageContext.request.contextPath}/appointments/booking-datetime';
                        }, 800);
                    }, 600);
                }, 1000);
            });
            
            // Notification system
            function showNotification(message, type = 'success') {
                const notification = document.createElement('div');
                notification.className = `notification ${type}`;
                
                const icon = type === 'success' ? 'material-symbols:check-circle' : 'material-symbols:error';
                notification.innerHTML = `
                    <iconify-icon icon="${icon}"></iconify-icon>
                    <span>${message}</span>
                `;
                
                document.body.appendChild(notification);
                
                // Show notification
                setTimeout(() => notification.classList.add('show'), 100);
                
                // Hide notification
                setTimeout(() => {
                    notification.classList.remove('show');
                    setTimeout(() => notification.remove(), 300);
                }, 3000);
            }
            
            // Initialize
            updateSummary();
            
            // Add scroll-based animations
            const observerOptions = {
                threshold: 0.1,
                rootMargin: '0px 0px -50px 0px'
            };
            
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.classList.add('fade-in');
                    }
                });
            }, observerOptions);
            
            // Observe elements for animation
            document.querySelectorAll('.service-card, .booking-summary').forEach(el => {
                observer.observe(el);
            });
            
            // Enhanced click outside handling
            document.addEventListener('click', function(e) {
                const searchContainer = e.target.closest('.search-container');
                if (!searchContainer) {
                    searchResults.classList.remove('show');
                }
            });
            
            // Better focus handling for accessibility
            searchInput.addEventListener('focus', function() {
                if (this.value.trim() === '') {
                    displaySearchResults(serviceCategories);
                }
                
                // Add focus ring
                this.parentElement.style.boxShadow = '0 0 0 3px rgba(200, 148, 95, 0.1)';
            });
            
            searchInput.addEventListener('blur', function() {
                // Remove focus ring after delay to allow clicks
                setTimeout(() => {
                    this.parentElement.style.boxShadow = '';
                }, 200);
            });
            
            // Keyboard navigation for search results
            searchInput.addEventListener('keydown', function(e) {
                const items = searchResults.querySelectorAll('.search-result-item');
                if (items.length === 0) return;
                
                let currentIndex = Array.from(items).findIndex(item => item.classList.contains('highlighted'));
                
                switch(e.key) {
                    case 'ArrowDown':
                        e.preventDefault();
                        if (currentIndex < items.length - 1) {
                            if (currentIndex >= 0) items[currentIndex].classList.remove('highlighted');
                            items[currentIndex + 1].classList.add('highlighted');
                        }
                        break;
                    case 'ArrowUp':
                        e.preventDefault();
                        if (currentIndex > 0) {
                            items[currentIndex].classList.remove('highlighted');
                            items[currentIndex - 1].classList.add('highlighted');
                        }
                        break;
                    case 'Enter':
                        e.preventDefault();
                        if (currentIndex >= 0) {
                            const categoryId = items[currentIndex].getAttribute('data-category');
                            selectCategory(categoryId);
                        }
                        break;
                    case 'Escape':
                        searchResults.classList.remove('show');
                        this.blur();
                        break;
                }
            });
        });
    </script>
</body>
</html> 