<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Kategoriler" scope="request"/>
<!DOCTYPE html>
<html lang="tr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Kategori Yönetimi | Admin Panel</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body class="admin-body">
<jsp:include page="/WEB-INF/views/admin/includes/sidebar.jsp"/>

<div class="admin-main">
  <div class="admin-topbar">
    <span class="admin-topbar-title">🏷️ Kategori Yönetimi</span>
    <div class="admin-user-info">
      <div class="admin-avatar">A</div>
      <span><c:out value="${sessionScope.adminUser.fullName}"/></span>
    </div>
  </div>

  <div class="admin-content">
    <div class="admin-page-header">
      <h1>Kategoriler</h1>
      <a href="${pageContext.request.contextPath}/admin/category/add" class="admin-btn admin-btn-primary">
        ➕ Yeni Kategori
      </a>
    </div>

    <!-- Mesajlar -->
    <c:choose>
      <c:when test="${param.msg == 'added'}">
        <div class="admin-alert admin-alert-success">✅ Kategori başarıyla eklendi.</div>
      </c:when>
      <c:when test="${param.msg == 'updated'}">
        <div class="admin-alert admin-alert-success">✅ Kategori güncellendi.</div>
      </c:when>
      <c:when test="${param.msg == 'deleted'}">
        <div class="admin-alert admin-alert-info">🗑️ Kategori tamamen silindi.</div>
      </c:when>
      <c:when test="${param.msg == 'deactivated'}">
        <div class="admin-alert admin-alert-warning">⚠️ Kategoriye bağlı ürünler olduğu için tamamen silinmedi, pasif duruma getirildi.</div>
      </c:when>
    </c:choose>

    <div class="admin-table-card">
      <table class="admin-table">
        <thead>
          <tr>
            <th>ID</th>
            <th>Kategori Adı</th>
            <th>Açıklama</th>
            <th>Durum</th>
            <th>İşlemler</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="category" items="${categories}">
            <tr>
              <td style="color:var(--admin-muted);">#${category.id}</td>
              <td><strong><c:out value="${category.name}"/></strong></td>
              <td><c:out value="${category.description}"/></td>
              <td>
                <c:choose>
                  <c:when test="${category.active}">
                    <span class="badge badge-active">Aktif</span>
                  </c:when>
                  <c:otherwise>
                    <span class="badge badge-inactive">Pasif</span>
                  </c:otherwise>
                </c:choose>
              </td>
              <td>
                <div class="d-flex gap-1">
                  <a href="${pageContext.request.contextPath}/admin/category/edit?id=${category.id}"
                     class="admin-btn admin-btn-ghost admin-btn-sm">✏️ Düzenle</a>
                  <a href="${pageContext.request.contextPath}/admin/category/delete?id=${category.id}"
                     class="admin-btn admin-btn-danger admin-btn-sm"
                     onclick="return confirm('Bu kategoriyi silmek istediğinizden emin misiniz? Bağlı ürünler varsa kategori pasif duruma getirilecektir.')">🗑️ Sil</a>
                </div>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>

      <c:if test="${empty categories}">
        <div style="text-align:center; padding:3rem; color:var(--admin-muted);">
          Henüz kategori eklenmemiş.
        </div>
      </c:if>
    </div>
  </div>
</div>

</body>
</html>
