<%-- Document : stylesheet Created on : May 26, 2025, 10:15:46 PM Author : quang
--%> <%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- STYLESHEETS -->

<!-- Iconify Icons -->
<script src="https://code.iconify.design/iconify-icon/1.0.7/iconify-icon.min.js"></script>

<!-- Add this after other stylesheet links but before closing the stylesheet section -->

<!-- Google Fonts - Playfair Display -->
<link rel="preconnect" href="https://fonts.googleapis.com" />
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
<link
  href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600;700&display=swap"
  rel="stylesheet"
/>

<!-- Custom font overrides -->
<link
  rel="stylesheet"
  type="text/css"
  href="${pageContext.request.contextPath}/assets/home/css/custom-fonts.css"
/>
<link
  rel="stylesheet"
  type="text/css"
  href="${pageContext.request.contextPath}/assets/home/css/header-custom.css"
/>

<link
  rel="stylesheet"
  type="text/css"
  href="${pageContext.request.contextPath}/assets/home/css/plugins.css"
/>
<link
  rel="stylesheet"
  type="text/css"
  href="${pageContext.request.contextPath}/assets/home/css/style.min.css"
/>
<link
  rel="stylesheet"
  type="text/css"
  href="${pageContext.request.contextPath}/assets/home/css/templete.min.css"
/>
<link
  class="skin"
  rel="stylesheet"
  type="text/css"
  href="${pageContext.request.contextPath}/assets/home/css/skin/skin-3.css"
/>
<link
  rel="stylesheet"
  type="text/css"
  href="${pageContext.request.contextPath}/assets/home/css/styleSwitcher.css"
/>
<link
  rel="stylesheet"
  type="text/css"
  href="${pageContext.request.contextPath}/assets/home/plugins/perfect-scrollbar/css/perfect-scrollbar.css"
/>
<!-- Revolution Slider Css -->
<link
  rel="stylesheet"
  type="text/css"
  href="${pageContext.request.contextPath}/assets/home/plugins/revolution/revolution/css/layers.css"
/>
<link
  rel="stylesheet"
  type="text/css"
  href="${pageContext.request.contextPath}/assets/home/plugins/revolution/revolution/css/settings.css"
/>
<link
  rel="stylesheet"
  type="text/css"
  href="${pageContext.request.contextPath}/assets/home/plugins/revolution/revolution/css/navigation.css"
/>

<!-- Vietnamese-supported fonts -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&subset=vietnamese&display=swap" rel="stylesheet">

<!-- Add Roboto with Vietnamese support -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,300;0,400;0,500;0,700;0,900;1,300;1,400;1,500;1,700;1,900&subset=vietnamese&display=swap" rel="stylesheet">

<style>
/* Inter Vietnamese font implementation */
* {
    font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
}

body {
    font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif !important;
    font-weight: 400;
    line-height: 1.6;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    text-rendering: optimizeLegibility;
}

/* Headings with Inter */
h1, h2, h3, h4, h5, h6, .title, .heading, .dlab-title {
    font-family: 'Inter', sans-serif !important;
    font-weight: 600;
    line-height: 1.3;
}

/* Form elements */
input, textarea, select, .form-control {
    font-family: 'Inter', sans-serif !important;
    font-weight: 400;
}

/* Buttons */
.btn, button, .button {
    font-family: 'Inter', sans-serif !important;
    font-weight: 500;
}

/* Navigation */
.navbar, .nav, .menu {
    font-family: 'Inter', sans-serif !important;
    font-weight: 400;
}

/* Override any existing font declarations */
p, span, div, a, li, td, th, label {
    font-family: 'Inter', sans-serif !important;
}

/* Inter specific optimizations */
.inter-tight {
    letter-spacing: -0.01em;
}

.inter-display {
    font-weight: 700;
    letter-spacing: -0.02em;
}

/* Specific weights for different elements */
.font-light { font-weight: 300; }
.font-normal { font-weight: 400; }
.font-medium { font-weight: 500; }
.font-semibold { font-weight: 600; }
.font-bold { font-weight: 700; }
.font-extrabold { font-weight: 800; }
.font-black { font-weight: 900; }

/* Admin Style Dropdown Menu */
.admin-style-dropdown {
    background: #ffffff;
    border: 1px solid #e5e7eb;
    border-radius: 12px;
    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
    padding: 0;
    min-width: max-content;
    width: max-content;
    z-index: 1000;
}

.dropdown-header-admin {
    padding: 16px 20px;
    border-bottom: 1px solid #f3f4f6;
    background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
    border-radius: 12px 12px 0 0;
}

.avatar-circle {
    width: 32px;
    height: 32px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
}

.dropdown-item-admin {
    display: block;
    padding: 12px 20px;
    text-decoration: none;
    color: #374151;
    transition: all 0.2s ease;
    border: none;
    background: none;
}

.dropdown-item-admin:hover {
    background: #f8fafc;
    color: #1f2937;
    text-decoration: none;
}

.dropdown-divider-admin {
    height: 1px;
    background: #e5e7eb;
    margin: 8px 0;
}

/* Admin Framework Utility Classes */
.d-flex { display: flex; }
.align-items-center { align-items: center; }
.gap-2 { gap: 8px; }
.gap-3 { gap: 12px; }
.mb-0 { margin-bottom: 0; }
.fw-semibold { font-weight: 600; }
.fw-medium { font-weight: 500; }
.text-lg { font-size: 1.125rem; }
.text-xs { font-size: 0.75rem; }

/* Admin Framework Colors */
.bg-success-100 { background-color: #dcfce7; }
.text-success-600 { color: #16a34a; }
.bg-primary-100 { background-color: #dbeafe; }
.text-primary-600 { color: #2563eb; }
.text-neutral-900 { color: #111827; }
.text-secondary-light { color: #6b7280; }

/* Icon alignment fixes */
iconify-icon {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    vertical-align: middle;
}
</style>
