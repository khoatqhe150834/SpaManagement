<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>
    <c:choose>
      <c:when test="${formAction eq 'edit'}">Sửa phiếu nhập</c:when>
      <c:otherwise>Tạo phiếu nhập mới</c:otherwise>
    </c:choose>
  </title>
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
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Roboto:wght@300;400;500;600&display=swap" rel="stylesheet" />
  <!-- Lucide Icons -->
  <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
  <link rel="stylesheet" href="<c:url value='/css/style.css'/>" />
</head>
<body class="bg-spa-cream font-sans">
<jsp:include page="/WEB-INF/view/common/sidebar.jsp" />

<main class="w-full md:w-[calc(100%-256px)] md:ml-64 min-h-screen transition-all">
  <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-12 lg:py-20">
    <!-- Header -->
    <div class="flex flex-wrap items-center justify-between gap-4 mb-8">
      <div>
        <h2 class="text-3xl font-serif text-spa-dark font-bold">
          <c:choose>
            <c:when test="${formAction eq 'edit'}">Sửa phiếu nhập</c:when>
            <c:otherwise>Tạo phiếu nhập mới</c:otherwise>
          </c:choose>
        </h2>
        <nav class="text-sm text-gray-500 flex items-center space-x-2 mt-1">
          <a href="${pageContext.request.contextPath}/dashboard" class="hover:text-primary">Dashboard</a>
          <span>/</span>
          <a href="../receipt" class="hover:text-primary">Phiếu nhập</a>
          <span>/</span>
          <span>
                            <c:choose>
                              <c:when test="${formAction eq 'edit'}">Chỉnh sửa</c:when>
                              <c:otherwise>Tạo mới</c:otherwise>
                            </c:choose>
                        </span>
        </nav>
      </div>
      <a href="../receipt" class="inline-flex items-center gap-2 h-10 px-4 bg-gray-500 text-white font-semibold rounded-lg hover:bg-gray-600 transition-colors">
        <i data-lucide="arrow-left" class="h-5 w-5"></i>
        <span>Quay lại</span>
      </a>
    </div>

    <form method="post" action="/inventory-manager/receipt/create">
      <!-- Receipt Info Card -->
      <div class="bg-white rounded-2xl shadow-lg mb-6">
        <div class="p-6 border-b border-gray-200">
          <h3 class="text-xl font-semibold text-spa-dark flex items-center gap-2">
            <i data-lucide="file-plus" class="h-6 w-6 text-primary"></i>
            Thông tin phiếu nhập
          </h3>
          <p class="text-gray-600 mt-1">Thông tin cơ bản của phiếu nhập kho</p>
        </div>

        <div class="p-6">
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <!-- Receipt Date -->
            <div class="space-y-2">
              <label class="block text-sm font-medium text-spa-dark">
                Ngày nhập <span class="text-red-500">*</span>
              </label>
              <div class="relative">
                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                  <i data-lucide="calendar" class="h-5 w-5 text-gray-400"></i>
                </div>
                <input type="date" name="receiptDate" value="<fmt:formatDate value='${receipt.receiptDate}' pattern='yyyy-MM-dd'/>" required class="block w-full pl-10 pr-3 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-primary transition-colors" />
              </div>
            </div>

            <!-- Supplier -->
            <div class="space-y-2">
              <label class="block text-sm font-medium text-spa-dark">
                Nhà cung cấp <span class="text-red-500">*</span>
              </label>
              <div class="relative">
                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                  <i data-lucide="truck" class="h-5 w-5 text-gray-400"></i>
                </div>
                <select name="supplierId" required class="block w-full pl-10 pr-8 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-primary transition-colors appearance-none">
                  <option value="">Chọn nhà cung cấp</option>
                  <c:forEach var="supplier" items="${suppliers}">
                    <option value="${supplier.supplierId}" <c:if test="${supplier.supplierId == receipt.supplierId}">selected</c:if>>${supplier.name}</option>
                  </c:forEach>
                </select>
                <div class="absolute inset-y-0 right-0 pr-3 flex items-center pointer-events-none">
                  <i data-lucide="chevron-down" class="h-4 w-4 text-gray-400"></i>
                </div>
              </div>
            </div>
          </div>

          <!-- Note -->
          <div class="space-y-2 mt-6">
            <label class="block text-sm font-medium text-spa-dark">Ghi chú</label>
            <div class="relative">
              <div class="absolute top-3 left-3 pointer-events-none">
                <i data-lucide="file-text" class="h-5 w-5 text-gray-400"></i>
              </div>
              <textarea name="note" rows="3" class="block w-full pl-10 pr-3 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-primary transition-colors resize-none" placeholder="Ghi chú về phiếu nhập...">${receipt.note}</textarea>
            </div>
          </div>
        </div>
      </div>

      <!-- Receipt Details Card -->
      <div class="bg-white rounded-2xl shadow-lg mb-6">
        <div class="p-6 border-b border-gray-200 flex items-center justify-between">
          <div>
            <h3 class="text-xl font-semibold text-spa-dark flex items-center gap-2">
              <i data-lucide="package" class="h-6 w-6 text-primary"></i>
              Chi tiết phiếu nhập
            </h3>
            <p class="text-gray-600 mt-1">Danh sách vật tư nhập kho</p>
          </div>
          <button type="button" onclick="addReceiptDetail()" class="inline-flex items-center gap-2 px-4 py-2 bg-primary text-white font-semibold rounded-lg hover:bg-primary-dark transition-colors">
            <i data-lucide="plus" class="h-4 w-4"></i>
            <span>Thêm vật tư</span>
          </button>
        </div>

        <div class="p-6">
          <div class="overflow-x-auto">
            <table class="w-full text-sm">
              <thead class="text-xs text-gray-700 uppercase bg-gray-50">
              <tr>
                <th class="px-4 py-3 text-left">Vật tư</th>
                <th class="px-4 py-3 text-center">Số lượng</th>
                <th class="px-4 py-3 text-center">Đơn giá</th>
                <th class="px-4 py-3 text-center">Thành tiền</th>
                <th class="px-4 py-3 text-left">Ghi chú</th>
                <th class="px-4 py-3 text-center">Thao tác</th>
              </tr>
              </thead>
              <tbody id="receiptDetailsTable">
              <c:choose>
                <c:when test="${not empty receiptDetails}">
                  <c:forEach var="detail" items="${receiptDetails}" varStatus="status">
                    <tr class="border-b hover:bg-gray-50">
                      <td class="px-4 py-3">
                        <select name="details[${status.index}].inventoryItemId" required class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-primary transition-colors appearance-none">
                          <option value="">Chọn vật tư</option>
                          <c:forEach var="item" items="${items}">
                            <option value="${item.inventoryItemId}" <c:if test="${item.inventoryItemId == detail.inventoryItemId}">selected</c:if>>${item.name} (${item.unit})</option>
                          </c:forEach>
                        </select>
                      </td>
                      <td class="px-4 py-3">
                        <input type="number" name="details[${status.index}].quantity" value="${detail.quantity}" min="1" required class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-primary transition-colors text-center" onchange="calculateRowTotal(this)" />
                      </td>
                      <td class="px-4 py-3">
                        <input type="number" name="details[${status.index}].unitPrice" value="${detail.unitPrice}" min="0" step="0.01" required class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-primary transition-colors text-center" onchange="calculateRowTotal(this)" />
                      </td>
                      <td class="px-4 py-3 text-center font-medium text-spa-dark">
                        <span class="row-total">${detail.quantity * detail.unitPrice}</span>
                      </td>
                      <td class="px-4 py-3">
                        <input type="text" name="details[${status.index}].note" value="${detail.note}" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-primary transition-colors" placeholder="Ghi chú..." />
                      </td>
                      <td class="px-4 py-3 text-center">
                        <button type="button" onclick="removeReceiptDetail(this)" class="p-2 bg-red-100 hover:bg-red-200 text-red-700 rounded-full transition-colors">
                          <i data-lucide="trash-2" class="w-4 h-4"></i>
                        </button>
                      </td>
                    </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr id="emptyRow">
                    <td colspan="6" class="px-4 py-8 text-center text-gray-500">
                      <div class="flex flex-col items-center gap-2">
                        <i data-lucide="package-x" class="h-8 w-8 text-gray-400"></i>
                        <span>Chưa có vật tư nào. Nhấn "Thêm vật tư" để bắt đầu.</span>
                      </div>
                    </td>
                  </tr>
                </c:otherwise>
              </c:choose>
              </tbody>
              <tfoot class="bg-gray-50">
              <tr>
                <td colspan="3" class="px-4 py-3 text-right font-semibold text-spa-dark">Tổng cộng:</td>
                <td class="px-4 py-3 text-center font-bold text-lg text-primary">
                  <span id="grandTotal">0</span>
                </td>
                <td colspan="2"></td>
              </tr>
              </tfoot>
            </table>
          </div>
        </div>
      </div>

      <!-- Form Actions -->
      <div class="flex flex-col sm:flex-row gap-3">
        <button type="submit" class="inline-flex items-center justify-center gap-2 px-6 py-3 bg-primary text-white font-semibold rounded-lg hover:bg-primary-dark focus:ring-2 focus:ring-primary focus:ring-offset-2 transition-colors">
          <i data-lucide="save" class="h-5 w-5"></i>
          <span>Lưu phiếu nhập</span>
        </button>
        <a href="../receipt" class="inline-flex items-center justify-center gap-2 px-6 py-3 bg-gray-100 text-gray-700 font-semibold rounded-lg hover:bg-gray-200 focus:ring-2 focus:ring-gray-300 focus:ring-offset-2 transition-colors">
          <i data-lucide="x" class="h-5 w-5"></i>
          <span>Hủy bỏ</span>
        </a>
      </div>
    </form>
  </div>
</main>

<script>
  if (typeof lucide !== 'undefined') {
    lucide.createIcons();
  }

  let detailIndex = ${not empty receiptDetails ? receiptDetails.size() : 0};

  function addReceiptDetail() {
    const emptyRow = document.getElementById('emptyRow');
    if (emptyRow) {
      emptyRow.remove();
    }

    const tbody = document.getElementById('receiptDetailsTable');
    const row = document.createElement('tr');
    row.className = 'border-b hover:bg-gray-50';
    row.innerHTML = `
                <td class="px-4 py-3">
                    <select name="details[` + detailIndex + `].inventoryItemId" required class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-primary transition-colors appearance-none">
                        <option value="">Chọn vật tư</option>
                        <c:forEach var="item" items="${items}">
                            <option value="${item.inventoryItemId}">${item.name} (${item.unit})</option>
                        </c:forEach>
                    </select>
                </td>
                <td class="px-4 py-3">
                    <input type="number" name="details[` + detailIndex + `].quantity" min="1" required class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-primary transition-colors text-center" onchange="calculateRowTotal(this)" />
                </td>
                <td class="px-4 py-3">
                    <input type="number" name="details[` + detailIndex + `].unitPrice" min="0" step="0.01" required class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-primary transition-colors text-center" onchange="calculateRowTotal(this)" />
                </td>
                <td class="px-4 py-3 text-center font-medium text-spa-dark">
                    <span class="row-total">0</span>
                </td>
                <td class="px-4 py-3">
                    <input type="text" name="details[` + detailIndex + `].note" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-primary transition-colors" placeholder="Ghi chú..." />
                </td>
                <td class="px-4 py-3 text-center">
                    <button type="button" onclick="removeReceiptDetail(this)" class="p-2 bg-red-100 hover:bg-red-200 text-red-700 rounded-full transition-colors">
                        <i data-lucide="trash-2" class="w-4 h-4"></i>
                    </button>
                </td>
            `;
    tbody.appendChild(row);
    detailIndex++;
    lucide.createIcons();
    updateGrandTotal();
  }

  function removeReceiptDetail(button) {
    const row = button.closest('tr');
    row.remove();

    const tbody = document.getElementById('receiptDetailsTable');
    if (tbody.children.length === 0) {
      tbody.innerHTML = `
                    <tr id="emptyRow">
                        <td colspan="6" class="px-4 py-8 text-center text-gray-500">
                            <div class="flex flex-col items-center gap-2">
                                <i data-lucide="package-x" class="h-8 w-8 text-gray-400"></i>
                                <span>Chưa có vật tư nào. Nhấn "Thêm vật tư" để bắt đầu.</span>
                            </div>
                        </td>
                    </tr>
                `;
      lucide.createIcons();
    }
    updateGrandTotal();
  }

  function calculateRowTotal(input) {
    const row = input.closest('tr');
    const quantity = parseFloat(row.querySelector('input[name*=".quantity"]').value) || 0;
    const unitPrice = parseFloat(row.querySelector('input[name*=".unitPrice"]').value) || 0;
    const total = quantity * unitPrice;

    row.querySelector('.row-total').textContent = total.toLocaleString('vi-VN');
    updateGrandTotal();
  }

  function updateGrandTotal() {
    const rowTotals = document.querySelectorAll('.row-total');
    let grandTotal = 0;

    rowTotals.forEach(span => {
      const value = parseFloat(span.textContent.replace(/,/g, '')) || 0;
      grandTotal += value;
    });

    document.getElementById('grandTotal').textContent = grandTotal.toLocaleString('vi-VN');
  }

  // Initialize calculations on page load
  document.addEventListener('DOMContentLoaded', function() {
    updateGrandTotal();
  });
</script>
</body>
</html>