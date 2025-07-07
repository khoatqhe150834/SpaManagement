<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Dịch vụ - Spa Hương Sen</title>

    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
      tailwind.config = {
        theme: {
          extend: {
            colors: {
              primary: "#D4AF37",
              "primary-dark": "#B8941F",
              secondary: "#FADADD",
              "spa-cream": "#FFF8F0",
              "spa-dark": "#333333",
            },
            fontFamily: {
              serif: ["Playfair Display", "serif"],
              sans: ["Roboto", "sans-serif"],
            },
          },
        },
      };
    </script>

    <!-- Google Fonts -->
    <link
      href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Roboto:wght@300;400;500;600&display=swap"
      rel="stylesheet"
    />

    <!-- Lucide Icons -->
    <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>

    <!-- Custom CSS -->
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>" />
  </head>

  <body class="bg-spa-cream">
    <jsp:include page="/WEB-INF/view/common/header.jsp" />

    <!-- Main Content -->
    <main class="pt-20">
      <!-- Page Header -->
      <section
        class="bg-gradient-to-r from-primary to-primary-dark text-white py-16"
      >
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h1 class="text-4xl md:text-5xl font-serif font-bold mb-4">
            Dịch Vụ Spa
          </h1>
          <p class="text-xl opacity-90 max-w-2xl mx-auto">
            Khám phá các dịch vụ chăm sóc sắc đẹp cao cấp được thiết kế đặc biệt
            cho phụ nữ Việt Nam
          </p>
        </div>
      </section>

      <!-- Search and Filter Section -->
      <section class="bg-white py-8 border-b border-gray-200">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div
            class="flex flex-col md:flex-row gap-4 items-center justify-between"
          >
            <!-- Search Bar -->
            <div class="relative flex-1 max-w-md">
              <input
                type="text"
                id="search-input"
                placeholder="Tìm kiếm dịch vụ..."
                class="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-full focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent"
              />
              <i
                data-lucide="search"
                class="absolute left-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-gray-400"
              ></i>
            </div>

            <!-- Filter Toggle (Mobile) -->
            <button
              id="mobile-filter-btn"
              class="md:hidden flex items-center px-4 py-2 bg-primary text-white rounded-full"
            >
              <i data-lucide="filter" class="h-4 w-4 mr-2"></i>
              Bộ lọc
            </button>

            <!-- Results Info -->
            <div class="text-gray-600">
              <span id="results-count">Hiển thị 0 kết quả</span>
            </div>
          </div>
        </div>
      </section>

      <!-- Services Content -->
      <section class="py-12">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="flex gap-8">
            <!-- Sidebar Filters -->
            <aside
              id="filters-sidebar"
              class="hidden md:block w-64 flex-shrink-0"
            >
              <div class="bg-white rounded-lg p-6 shadow-lg sticky top-24">
                <div class="flex items-center justify-between mb-6">
                  <h3 class="text-lg font-semibold text-spa-dark">Bộ lọc</h3>
                  <button
                    id="clear-filters"
                    class="text-primary hover:text-primary-dark text-sm"
                  >
                    Xóa tất cả
                  </button>
                </div>

                <!-- Service Types -->
                <div class="mb-6">
                  <h4 class="font-medium text-spa-dark mb-3">Loại dịch vụ</h4>
                  <select 
                    id="service-type-select" 
                    class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent text-sm"
                  >
                    <option value="all">Tất cả dịch vụ</option>
                    <!-- Service types will be loaded dynamically -->
                  </select>
                </div>

                <!-- Price Range - Dynamic double slider will be inserted here -->


              </div>
            </aside>

            <!-- Services Grid -->
            <div class="flex-1">
              <!-- Sort Options -->
              <div class="flex justify-between items-center mb-6">
                <h2 class="text-2xl font-serif font-bold text-spa-dark">
                  Tất cả dịch vụ
                </h2>
                <select
                  id="sort-select"
                  class="border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary"
                >
                  <option value="default">Sắp xếp theo</option>
                  <option value="name-asc">Tên A-Z</option>
                  <option value="name-desc">Tên Z-A</option>
                  <option value="price-asc">Giá thấp đến cao</option>
                  <option value="price-desc">Giá cao đến thấp</option>
                  <option value="rating-desc">Đánh giá cao nhất</option>
                </select>
              </div>

              <!-- Services List -->
              <div
                id="services-grid"
                class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8"
              >
                <!-- Services will be dynamically loaded here -->
              </div>

              <!-- Pagination -->
              <div
                id="pagination"
                class="flex justify-center items-center space-x-2"
              >
                <!-- Pagination will be dynamically loaded here -->
              </div>
            </div>
          </div>
        </div>
      </section>
    </main>

    <!-- Service Detail Modal -->
    <div id="service-modal" class="modal">
      <div
        class="modal-content bg-white rounded-lg max-w-4xl mx-4 max-h-[90vh] overflow-y-auto"
      >
        <div
          class="sticky top-0 bg-white border-b border-gray-200 p-4 flex justify-between items-center"
        >
          <h3
            id="modal-title"
            class="text-xl font-serif font-bold text-spa-dark"
          ></h3>
          <button id="close-modal" class="text-gray-500 hover:text-gray-700">
            <i data-lucide="x" class="h-6 w-6"></i>
          </button>
        </div>

        <div id="modal-body" class="p-6">
          <!-- Modal content will be dynamically loaded -->
        </div>
      </div>
    </div>

    <!-- Mobile Filter Modal -->
    <div id="mobile-filter-modal" class="modal">
      <div
        class="modal-content bg-white rounded-lg max-w-md mx-4 max-h-[90vh] overflow-y-auto"
      >
        <div
          class="sticky top-0 bg-white border-b border-gray-200 p-4 flex justify-between items-center"
        >
          <h3 class="text-lg font-semibold">Bộ lọc</h3>
          <button
            id="close-mobile-filter"
            class="text-gray-500 hover:text-gray-700"
          >
            <i data-lucide="x" class="h-6 w-6"></i>
          </button>
        </div>

        <div class="p-4">
          <!-- Mobile Service Type Filter -->
          <div class="mb-6">
            <h4 class="font-medium text-spa-dark mb-3">Loại dịch vụ</h4>
            <select 
              id="mobile-service-type-select" 
              class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent text-sm"
            >
              <option value="all">Tất cả dịch vụ</option>
              <!-- Service types will be loaded dynamically -->
            </select>
          </div>

          <div class="flex gap-2 mt-6">
            <button
              id="clear-mobile-filters"
              class="w-full border border-gray-300 text-gray-700 py-2 rounded-lg"
            >
              Xóa bộ lọc
            </button>
          </div>
        </div>
      </div>
    </div>

    <jsp:include page="/WEB-INF/view/common/footer.jsp" />

    <!-- JavaScript -->
    <script src="<c:url value='/js/app.js'/>"></script>
    <script src="<c:url value='/js/homepage-sections.js'/>"></script>
    <script src="<c:url value='/js/services-api.js'/>"></script>
    
  </body>
</html>
