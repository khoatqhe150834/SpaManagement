<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EDIT CUSTOMER</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/admin/css/style.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
    <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp" />
     <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />
    <div class="container mt-5">
        <div class="card">
            <div class="card-header">
                <h3>Chỉnh sửa Thông tin Khách hàng</h3>
            </div>
            <div class="card-body">
                <c:if test="${not empty customer}">
                    <form action="${pageContext.request.contextPath}/customer/update" method="POST">
                        <!-- Trường ẩn để gửi ID khách hàng -->
                        <input type="hidden" name="customerId" value="${customer.customerId}">

                        <div class="row">
                            <!-- Cột trái -->
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="fullName" class="form-label">Họ và Tên</label>
                                    <input type="text" class="form-control" id="fullName" name="fullName" value="<c:out value="${customer.fullName}"/>" required>
                                </div>
                                <div class="mb-3">
                                    <label for="email" class="form-label">Địa chỉ Email</label>
                                    <input type="email" class="form-control" id="email" name="email" value="<c:out value="${customer.email}"/>" required>
                                </div>
                                <div class="mb-3">
                                    <label for="phoneNumber" class="form-label">Số điện thoại</label>
                                    <input type="tel" class="form-control" id="phoneNumber" name="phoneNumber" value="<c:out value="${customer.phoneNumber}"/>">
                                </div>
                                <div class="mb-3">
                                    <label for="gender" class="form-label">Giới tính</label>
                                    <select class="form-select" id="gender" name="gender">
                                        <option value="MALE" ${customer.gender == 'MALE' ? 'selected' : ''}>Nam</option>
                                        <option value="FEMALE" ${customer.gender == 'FEMALE' ? 'selected' : ''}>Nữ</option>
                                        <option value="OTHER" ${customer.gender == 'OTHER' ? 'selected' : ''}>Khác</option>
                                    </select>
                                </div>
                                 <div class="mb-3">
                                    <label for="address" class="form-label">Địa chỉ</label>
                                    <textarea class="form-control" id="address" name="address" rows="3"><c:out value="${customer.address}"/></textarea>
                                </div>
                            </div>

                            <!-- Cột phải -->
                            <div class="col-md-6">
                               <div class="mb-3">
                                    <label for="birthday" class="form-label">Ngày sinh</label>
                                    <input type="date" class="form-control" id="birthday" name="birthday" value="<fmt:formatDate value="${customer.birthday}" pattern="yyyy-MM-dd" />">
                                </div>
                                <div class="mb-3">
                                    <label for="loyaltyPoints" class="form-label">Điểm thân thiết</label>
                                    <input type="number" class="form-control" id="loyaltyPoints" name="loyaltyPoints" value="${customer.loyaltyPoints}" min="0">
                                </div>
                                <div class="mb-3 form-check form-switch">
                                    <input class="form-check-input" type="checkbox" id="isActive" name="active" ${customer.active ? 'checked' : ''}>
                                    <label class="form-check-label" for="isActive">Tài khoản đang hoạt động</label>
                                </div>
                                <div class="mb-3 form-check form-switch">
                                    <input class="form-check-input" type="checkbox" id="isVerified" name="verified" ${customer.verified ? 'checked' : ''}>
                                    <label class="form-check-label" for="isVerified">Tài khoản đã xác minh</label>
                                </div>
                            </div>
                        </div>

                        <div class="card-footer text-end">
                            <a href="${pageContext.request.contextPath}/customer/list" class="btn btn-secondary">Hủy</a>
                            <button type="submit" class="btn btn-primary">Cập nhật Khách hàng</button>
                        </div>
                    </form>
                </c:if>

                <c:if test="${empty customer}">
                    <div class="alert alert-danger" role="alert">
                      Không tìm thấy khách hàng để chỉnh sửa. Vui lòng quay lại danh sách.
                    </div>
                </c:if>
            </div>
        </div>
    </div>
      <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
</body>
</html>
