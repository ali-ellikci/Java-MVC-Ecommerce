<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Ürünler" scope="request"/>
<!DOCTYPE html>
<html lang="tr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${product != null ? 'Ürün Düzenle' : 'Yeni Ürün'} | Admin Panel</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body class="admin-body">
<jsp:include page="/WEB-INF/views/admin/includes/sidebar.jsp"/>

<div class="admin-main">
  <div class="admin-topbar">
    <span class="admin-topbar-title">
      ${product != null ? '✏️ Ürün Düzenle' : '➕ Yeni Ürün'}
    </span>
    <div class="admin-user-info">
      <div class="admin-avatar">A</div>
      <span><c:out value="${sessionScope.adminUser.fullName}"/></span>
    </div>
  </div>

  <div class="admin-content">
    <div class="admin-page-header">
      <h1>${product != null ? 'Ürün Düzenle' : 'Yeni Ürün Ekle'}</h1>
      <a href="${pageContext.request.contextPath}/admin/products" class="admin-btn admin-btn-ghost">← Geri</a>
    </div>

    <div class="admin-form-card">
      <c:if test="${not empty error}">
        <div class="admin-alert admin-alert-danger">⚠️ <c:out value="${error}"/></div>
      </c:if>

      <form action="${product != null ?
                     pageContext.request.contextPath.concat('/admin/product/edit') :
                     pageContext.request.contextPath.concat('/admin/product/add')}"
            method="post" id="productForm" novalidate>

        <c:if test="${product != null}">
          <input type="hidden" name="id" value="${product.id}">
        </c:if>

        <div class="admin-form-group">
          <label class="admin-label" for="pName">Ürün Adı *</label>
          <input type="text" id="pName" name="name"
                 class="admin-input"
                 value="<c:out value='${product != null ? product.name : \"\"}'/>">
        </div>

        <div class="admin-form-group">
          <label class="admin-label" for="pCategory">Kategori *</label>
          <select id="pCategory" name="categoryId" class="admin-input">
            <option value="">-- Kategori Seçin --</option>
            <c:forEach var="cat" items="${categories}">
              <option value="${cat.id}"
                ${product != null && product.categoryId == cat.id ? 'selected' : ''}>
                <c:out value="${cat.name}"/>
              </option>
            </c:forEach>
          </select>
        </div>

        <div class="admin-form-group">
          <label class="admin-label" for="pDesc">Açıklama</label>
          <textarea id="pDesc" name="description" class="admin-input"><c:out value="${product != null ? product.description : ''}"/></textarea>
        </div>

        <div style="display:grid; grid-template-columns:1fr 1fr; gap:1rem;">
          <div class="admin-form-group">
            <label class="admin-label" for="pPrice">Fiyat (₺) *</label>
            <input type="number" id="pPrice" name="price"
                   class="admin-input" step="0.01" min="0.01"
                   value="${product != null ? product.price : ''}">
          </div>
          <div class="admin-form-group">
            <label class="admin-label" for="pStock">Stok Miktarı *</label>
            <input type="number" id="pStock" name="stock"
                   class="admin-input" min="0"
                   value="${product != null ? product.stock : '0'}">
          </div>
        </div>

        <div class="admin-form-group">
          <label class="admin-label" for="pImage">Görsel URL</label>
          <input type="url" id="pImage" name="imageUrl"
                 class="admin-input"
                 placeholder="https://..."
                 value="<c:out value='${product != null ? product.imageUrl : \"\"}'/>">
        </div>

        <!-- Görsel önizleme -->
        <c:if test="${product != null and not empty product.imageUrl}">
          <div style="margin-bottom:1rem;">
            <img id="imgPreview" src="<c:out value='${product.imageUrl}'/>"
                 style="height:100px; border-radius:8px; object-fit:cover;"
                 onerror="this.style.display='none'">
          </div>
        </c:if>

        <div class="admin-form-group">
          <label class="toggle-switch">
            <input type="checkbox" name="isActive"
                   ${product == null || product.active ? 'checked' : ''}>
            <div class="toggle-track"><div class="toggle-thumb"></div></div>
            Aktif
          </label>
        </div>

        <div class="d-flex gap-2 mt-3">
          <button type="submit" class="admin-btn admin-btn-primary" style="padding:.7rem 1.5rem;">
            ${product != null ? '💾 Güncelle' : '➕ Ekle'}
          </button>
          <a href="${pageContext.request.contextPath}/admin/products" class="admin-btn admin-btn-ghost" style="padding:.7rem 1.5rem;">
            İptal
          </a>
        </div>
      </form>
    </div>
  </div>
</div>

<script>
// Görsel önizleme
document.getElementById('pImage').addEventListener('input', function() {
  let prev = document.getElementById('imgPreview');
  if (!prev) {
    prev = document.createElement('img');
    prev.id = 'imgPreview';
    prev.style.cssText = 'height:100px;border-radius:8px;object-fit:cover;margin-top:8px;display:block;';
    this.parentNode.appendChild(prev);
  }
  prev.src = this.value;
  prev.onerror = () => prev.style.display = 'none';
  prev.onload  = () => prev.style.display = 'block';
});

// İstemci validasyon
document.getElementById('productForm').addEventListener('submit', function(e) {
  const name  = document.getElementById('pName').value.trim();
  const cat   = document.getElementById('pCategory').value;
  const price = parseFloat(document.getElementById('pPrice').value);
  const stock = parseInt(document.getElementById('pStock').value);
  if (!name)       { e.preventDefault(); alert('Ürün adı boş olamaz.'); return; }
  if (!cat)        { e.preventDefault(); alert('Kategori seçilmelidir.'); return; }
  if (isNaN(price) || price <= 0) { e.preventDefault(); alert("Fiyat 0'dan büyük olmalıdır."); return; }
  if (isNaN(stock) || stock < 0)  { e.preventDefault(); alert('Stok miktarı negatif olamaz.'); return; }
});
</script>

</body>
</html>
