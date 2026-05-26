<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Ürünler" scope="request"/>
<!DOCTYPE html>
<html lang="tr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Ürün Yönetimi | Admin Panel</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body class="admin-body">
<jsp:include page="/WEB-INF/views/admin/includes/sidebar.jsp"/>

<div class="admin-main">
  <div class="admin-topbar">
    <span class="admin-topbar-title">📦 Ürün Yönetimi</span>
    <div class="admin-user-info">
      <div class="admin-avatar">A</div>
      <span><c:out value="${sessionScope.adminUser.fullName}"/></span>
    </div>
  </div>

  <div class="admin-content">
    <div class="admin-page-header">
      <h1>Ürünler</h1>
      <a href="${pageContext.request.contextPath}/admin/product/add" class="admin-btn admin-btn-primary">
        ➕ Yeni Ürün
      </a>
    </div>

    <!-- Mesajlar -->
    <c:choose>
      <c:when test="${param.msg == 'added'}">
        <div class="admin-alert admin-alert-success">✅ Ürün başarıyla eklendi.</div>
      </c:when>
      <c:when test="${param.msg == 'updated'}">
        <div class="admin-alert admin-alert-success">✅ Ürün güncellendi.</div>
      </c:when>
      <c:when test="${param.msg == 'deleted'}">
        <div class="admin-alert admin-alert-info">🗑️ Ürün silindi.</div>
      </c:when>
    </c:choose>

    <div class="admin-table-card">
      <table class="admin-table">
        <thead>
          <tr>
            <th>ID</th>
            <th>Görsel</th>
            <th>Ürün Adı</th>
            <th>Kategori</th>
            <th>Fiyat</th>
            <th>Stok</th>
            <th>Durum</th>
            <th>İşlemler</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="product" items="${products}">
            <tr>
              <td style="color:var(--admin-muted);">#${product.id}</td>
              <td>
                <img src="<c:out value='${product.imageUrl}'/>"
                     style="width:44px;height:44px;object-fit:cover;border-radius:6px;"
                     onerror="this.src='https://placehold.co/44x44/17172b/6366f1?text=?'"
                     alt="<c:out value='${product.name}'/>">
              </td>
              <td><strong><c:out value="${product.name}"/></strong></td>
              <td><c:out value="${product.categoryName}"/></td>
              <td><fmt:formatNumber value="${product.price}" type="number" minFractionDigits="2" maxFractionDigits="2"/> ₺</td>
              <td>
                <c:choose>
                  <c:when test="${product.stock == 0}">
                    <span style="color:#ef4444;">${product.stock}</span>
                  </c:when>
                  <c:when test="${product.stock <= 5}">
                    <span style="color:#f59e0b;">${product.stock}</span>
                  </c:when>
                  <c:otherwise>
                    <span style="color:#10b981;">${product.stock}</span>
                  </c:otherwise>
                </c:choose>
              </td>
              <td>
                <c:choose>
                  <c:when test="${product.active}">
                    <span class="badge badge-active">Aktif</span>
                  </c:when>
                  <c:otherwise>
                    <span class="badge badge-inactive">Pasif</span>
                  </c:otherwise>
                </c:choose>
              </td>
              <td>
                <div class="d-flex gap-1">
                  <a href="${pageContext.request.contextPath}/admin/product/edit?id=${product.id}"
                     class="admin-btn admin-btn-ghost admin-btn-sm">✏️ Düzenle</a>
                  <a href="${pageContext.request.contextPath}/admin/product/toggle?id=${product.id}"
                     class="admin-btn admin-btn-ghost admin-btn-sm">
                    <c:choose>
                      <c:when test="${product.active}">⏸</c:when>
                      <c:otherwise>▶️</c:otherwise>
                    </c:choose>
                  </a>
                  <a href="${pageContext.request.contextPath}/admin/product/delete?id=${product.id}"
                     class="admin-btn admin-btn-danger admin-btn-sm"
                     onclick="return confirm('Bu ürünü silmek istediğinizden emin misiniz?')">🗑️</a>
                </div>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>

      <c:if test="${empty products}">
        <div style="text-align:center; padding:3rem; color:var(--admin-muted);">
          Henüz ürün eklenmemiş.
        </div>
      </c:if>
    </div>
  </div>
</div>

</body>
</html>
