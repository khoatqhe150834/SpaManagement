<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cập nhật nhân viên</title>
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
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Roboto:wght@300;400;500;600&display=swap" rel="stylesheet" />
    <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
</head>
<body class="bg-spa-cream font-sans">
    <jsp:include page="/WEB-INF/view/common/header.jsp" />
    <div class="flex">
        <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
        <main class="flex-1 py-12 lg:py-20 ml-64">
            <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8">
                <h1 class="text-3xl font-serif text-spa-dark font-bold mb-8">Cập Nhật Nhân Viên</h1>
                <form action="staff" method="post" class="bg-white rounded-2xl shadow-lg p-8 space-y-6">
                    <input type="hidden" name="service" value="update" />
                    <input type="hidden" name="userId" value="${staff.user.userId}" />
                    <div>
                        <label for="fullName" class="block font-semibold mb-2">Họ và tên</label>
                        <input type="text" name="fullName" id="fullName" value="${staff.user.fullName}" class="w-full border rounded-lg px-3 py-2 bg-gray-100" readonly />
                    </div>
                    <div>
                        <label for="bio" class="block font-semibold mb-2">Tiểu sử <span class="text-red-500">*</span></label>
                        <textarea name="bio" id="bio" rows="4" minlength="20" maxlength="500" required class="w-full border rounded-lg px-3 py-2 resize-none">${staff.bio}</textarea>
                        <div class="flex justify-end text-xs text-gray-500 mt-1"><span id="bioCharCount">0</span>/500</div>
                    </div>
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <div>
                            <label for="serviceTypeId" class="block font-semibold mb-2">Loại dịch vụ <span class="text-red-500">*</span></label>
                            <select name="serviceTypeId" id="serviceTypeId" required class="w-full border rounded-lg px-3 py-2">
                                <option value="">-- Chọn loại dịch vụ --</option>
                                <c:forEach var="serviceType" items="${serviceTypes}">
                                    <option value="${serviceType.serviceTypeId}" ${serviceType.serviceTypeId == staff.serviceType.serviceTypeId ? "selected" : ""}>${serviceType.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div>
                            <label for="availabilityStatus" class="block font-semibold mb-2">Trạng thái làm việc <span class="text-red-500">*</span></label>
                            <select name="availabilityStatus" id="availabilityStatus" required class="w-full border rounded-lg px-3 py-2">
                                <option value="">-- Chọn trạng thái --</option>
                                <option value="AVAILABLE" ${staff.availabilityStatus == 'AVAILABLE' ? "selected" : ""}>Sẵn sàng</option>
                                <option value="BUSY" ${staff.availabilityStatus == 'BUSY' ? "selected" : ""}>Đang bận</option>
                                <option value="OFFLINE" ${staff.availabilityStatus == 'OFFLINE' ? "selected" : ""}>Ngoại tuyến</option>
                                <option value="ON_LEAVE" ${staff.availabilityStatus == 'ON_LEAVE' ? "selected" : ""}>Đang nghỉ phép</option>
                            </select>
                        </div>
                        <div>
                            <label for="yearsOfExperience" class="block font-semibold mb-2">Số năm kinh nghiệm <span class="text-red-500">*</span></label>
                            <input type="number" name="yearsOfExperience" id="yearsOfExperience" value="${staff.yearsOfExperience}" class="w-full border rounded-lg px-3 py-2" required min="0" max="60" />
                        </div>
                    </div>
                    <div class="flex justify-end gap-3">
                        <a href="staff" class="px-6 py-2 rounded-lg border border-red-500 text-red-600 hover:bg-red-50 font-semibold">Hủy</a>
                        <button type="submit" class="px-6 py-2 rounded-lg bg-primary text-white font-semibold hover:bg-primary-dark">Cập nhật</button>
                    </div>
                </form>
            </div>
        </main>
    </div>
    <jsp:include page="/WEB-INF/view/common/footer.jsp" />
    <script>
        // ... script JS validation, chuyển class sang Tailwind nếu cần ...
    </script>
</body>
</html>

