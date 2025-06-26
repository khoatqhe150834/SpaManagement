<%-- Document : stylesheet Created on : May 26, 2025, 10:15:46 PM Author : quang
--%> <%@page contentType="text/html" pageEncoding="UTF-8"%>

<!-- Make context path available to JavaScript -->
<script>
    window.APP_CONTEXT_PATH = '${pageContext.request.contextPath}';
</script>

<!-- STYLESHEETS -->

<!-- Iconify Icons -->
<script src="https://code.iconify.design/iconify-icon/1.0.7/iconify-icon.min.js"></script>

<!-- Add this after other stylesheet links but before closing the stylesheet section -->

<!-- Google Fonts - Luxurious Spa Typography -->
<link rel="preconnect" href="https://fonts.googleapis.com" />
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />

<!-- Primary spa font - Lora (sophisticated serif with warmth) -->
<link
  href="https://fonts.googleapis.com/css2?family=Lora:ital,wght@0,400;0,500;0,600;0,700;1,400;1,500;1,600;1,700&subset=vietnamese&display=swap"
  rel="stylesheet"
/>

<!-- Heading font - Source Sans Pro (clean, professional sans-serif) -->
<link
  href="https://fonts.googleapis.com/css2?family=Source+Sans+Pro:ital,wght@0,300;0,400;0,600;0,700;0,900;1,300;1,400;1,600;1,700;1,900&subset=vietnamese&display=swap"
  rel="stylesheet"
/>

<!-- Accent font - Crimson Text (luxury serif for special elements) -->
<link
  href="https://fonts.googleapis.com/css2?family=Crimson+Text:ital,wght@0,400;0,600;0,700;1,400;1,600;1,700&subset=vietnamese&display=swap"
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
  href="${pageContext.request.contextPath}/assets/home/css/spa-pricing-improvements.css"
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

<!-- Note: All spa-themed fonts are now imported above -->

<style>
/* Luxurious Spa Font Implementation */
/* Primary font: Lora - sophisticated serif with warmth and elegance */
* {
    font-family: 'Lora', Georgia, 'Times New Roman', serif;
}

body {
    font-family: 'Lora', Georgia, 'Times New Roman', serif !important;
    font-weight: 400;
    line-height: 1.7;
    letter-spacing: 0.01em;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    text-rendering: optimizeLegibility;
    color: #2a2a2a;
}

/* Headings with Source Sans Pro - clean and professional */
h1, h2, h3, h4, h5, h6, .title, .heading, .dlab-title {
    font-family: 'Source Sans Pro', 'Helvetica Neue', Arial, sans-serif !important;
    font-weight: 600;
    line-height: 1.3;
    letter-spacing: 0.01em;
    color: #1a1a1a;
}

/* Special luxury elements with Crimson Text */
.luxury-text, .spa-title, .hero-title, .elegant-accent, .brand-name {
    font-family: 'Crimson Text', Georgia, serif !important;
    font-weight: 600;
    letter-spacing: 0.02em;
    line-height: 1.4;
}

/* Form elements with primary font */
input, textarea, select, .form-control {
    font-family: 'Lora', Georgia, serif !important;
    font-weight: 400;
    font-size: 16px;
    line-height: 1.5;
}

/* Buttons with heading font for clarity */
.btn, button, .button, .site-button {
    font-family: 'Source Sans Pro', Arial, sans-serif !important;
    font-weight: 600;
    letter-spacing: 0.05em;
    text-transform: uppercase;
    font-size: 14px;
}

/* Navigation with heading font */
.navbar, .nav, .menu, .main-nav {
    font-family: 'Source Sans Pro', Arial, sans-serif !important;
    font-weight: 400;
    letter-spacing: 0.02em;
}

/* Body text elements */
p, span, div, a, li, td, th, label {
    font-family: 'Lora', Georgia, serif !important;
}

/* Specific font weights for spa aesthetic */
.font-light { font-weight: 300; }
.font-normal { font-weight: 400; }
.font-medium { font-weight: 500; }
.font-semibold { font-weight: 600; }
.font-bold { font-weight: 700; }
.font-extrabold { font-weight: 800; }
.font-black { font-weight: 900; }

/* Spa-specific typography classes */
.spa-elegant {
    font-family: 'Crimson Text', Georgia, serif !important;
    font-weight: 400;
    font-style: italic;
    letter-spacing: 0.02em;
    line-height: 1.6;
}

.spa-modern {
    font-family: 'Source Sans Pro', Arial, sans-serif !important;
    font-weight: 300;
    letter-spacing: 0.08em;
    text-transform: uppercase;
}

.spa-classic {
    font-family: 'Lora', Georgia, serif !important;
    font-weight: 500;
    letter-spacing: 0.01em;
    line-height: 1.7;
}

/* Enhanced readability for Vietnamese text */
.vietnamese-text {
    line-height: 1.8;
    letter-spacing: 0.005em;
    font-weight: 400;
}

/* Special styling for prices and important information */
.price, .important-info {
    font-family: 'Source Sans Pro', Arial, sans-serif !important;
    font-weight: 700;
    letter-spacing: 0.02em;
}

/* Testimonials and quotes with elegant styling */
.testimonial-text, blockquote {
    font-family: 'Crimson Text', Georgia, serif !important;
    font-style: italic;
    font-weight: 400;
    line-height: 1.8;
    letter-spacing: 0.01em;
    font-size: 18px;
}

/* Luxury call-to-action elements */
.luxury-cta {
    font-family: 'Source Sans Pro', Arial, sans-serif !important;
    font-weight: 600;
    letter-spacing: 0.1em;
    text-transform: uppercase;
}

/* Spa service descriptions */
.spa-service-description {
    font-family: 'Lora', Georgia, serif !important;
    font-weight: 400;
    line-height: 1.8;
    font-size: 16px;
    letter-spacing: 0.01em;
}

/* Admin Style Dropdown Menu with new fonts */
.admin-style-dropdown {
    background: #ffffff;
    border: 1px solid #e5e7eb;
    border-radius: 12px;
    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
    padding: 0;
    min-width: max-content;
    width: max-content;
    z-index: 1000;
    font-family: 'Source Sans Pro', Arial, sans-serif !important;
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
    font-family: 'Source Sans Pro', Arial, sans-serif !important;
    font-weight: 400;
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
