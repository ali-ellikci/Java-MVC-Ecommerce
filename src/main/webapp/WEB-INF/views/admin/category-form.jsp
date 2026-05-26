<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Kategoriler" scope="request"/>
<!DOCTYPE html>
<html lang="tr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${category != null ? 'Kategori Düzenle' : 'Yeni Kategori'} | Admin Panel</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body class="admin-body">
<jsp:include page="/WEB-INF/views/admin/includes/sidebar.jsp"/>

<div class="admin-main">
  <div class="admin-topbar">
    <span class="admin-topbar-title">
      ${category != null ? '✏️ Kategori Düzenle' : '➕ Yeni Kategori'}
    </span>
    <div class="admin-user-info">
      <div class="admin-avatar">A</div>
      <span><c:out value="${sessionScope.adminUser.fullName}"/></span>
    </div>
  </div>

  <div class="admin-content">
    <div class="admin-page-header">
      <h1>${category != null ? 'Kategori Düzenle' : 'Yeni Kategori Ekle'}</h1>
      <a href="${pageContext.request.contextPath}/admin/categories" class="admin-btn admin-btn-ghost">← Geri</a>
    </div>

    <div class="admin-form-card">
      <c:if test="${not empty error}">
        <div class="admin-alert admin-alert-danger">⚠️ <c:out value="${error}"/></div>
      </c:if>

      <form action="${category != null ?
                     pageContext.request.contextPath.concat('/admin/category/edit') :
                     pageContext.request.contextPath.concat('/admin/category/add')}"
            method="post" id="categoryForm" novalidate>

        <c:if test="${category != null}">
          <input type="hidden" name="id" value="${category.id}">
        </c:if>

        <div class="admin-form-group">
          <label class="admin-label" for="cName">Kategori Adı *</label>
          <input type="text" id="cName" name="name"
                 class="admin-input"
                 value="<c:out value='${category != null ? category.name : \"\"}'/>">
        </div>

        <div class="admin-form-group">
          <label class="admin-label" for="cDesc">Açıklama</label>
          <textarea id="cDesc" name="description" class="admin-input"><c:out value="${category != null ? category.description : ''}"/></textarea>
        </div>

        <div class="admin-form-group">
          <label class="toggle-switch">
            <input type="checkbox" name="isActive"
                   ${category == null || category.active ? 'checked' : ''}>
            <div class="toggle-track"><div class="toggle-thumb"></div></div>
            Aktif
          </label>
        </div>

        <div class="d-flex gap-2 mt-3">
          <button type="submit" class="admin-btn admin-btn-primary" style="padding:.7rem 1.5rem;">
            ${category != null ? '💾 Güncelle' : '➕ Ekle'}
          </button>
          <a href="${pageContext.request.contextPath}/admin/categories" class="admin-btn admin-btn-ghost" style="padding:.7rem 1.5rem;">
            İptal
          </a>
        </div>
      </form>
    </div>
  </div>
</div>

<script>
// İstemci validasyon
document.getElementById('categoryForm').addEventListener('submit', function(e) {
  const name  = document.getElementById('cName').value.trim();
  if (!name) { 
    e.preventDefault(); 
    alert('Kategori adı boş olamaz.'); 
  }
});
</script>

</body>
</html>
