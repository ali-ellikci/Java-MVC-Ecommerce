<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="${product.name}" scope="request"/>
<jsp:include page="/WEB-INF/views/includes/header.jsp"/>

<div class="container">
  <div class="product-detail">

    <!-- Ürün Görseli -->
    <div>
      <img src="<c:out value='${product.imageUrl}'/>"
           alt="<c:out value='${product.name}'/>"
           class="product-detail__img"
           onerror="this.src='https://placehold.co/600x600/1a1a2e/6366f1?text=Ürün'">
    </div>

    <!-- Ürün Bilgileri -->
    <div class="product-detail__info">
      <div style="font-size:0.8rem; color:var(--primary); font-weight:600; text-transform:uppercase; letter-spacing:.08em; margin-bottom:.5rem;">
        <c:out value="${product.categoryName}"/>
      </div>

      <h1><c:out value="${product.name}"/></h1>

      <div class="product-detail__price">
        <fmt:formatNumber value="${product.price}" type="number" minFractionDigits="2" maxFractionDigits="2"/> ₺
      </div>

      <div class="product-detail__meta">
        <!-- Stok durumu -->
        <c:choose>
          <c:when test="${product.stock > 0}">
            <span class="meta-badge stock-ok">✓ Stokta Var (${product.stock} adet)</span>
          </c:when>
          <c:otherwise>
            <span class="meta-badge stock-out">✗ Stokta Yok</span>
          </c:otherwise>
        </c:choose>
        <span class="meta-badge">Kategori: <c:out value="${product.categoryName}"/></span>
      </div>

      <p style="color:var(--text-muted); margin-bottom:1.5rem; line-height:1.7;">
        <c:out value="${product.description}"/>
      </p>

      <!-- Sepete Ekle -->
      <c:if test="${sessionScope.cartMsg != null}">
        <div class="alert alert-warning mb-3">⚠️ <c:out value="${sessionScope.cartMsg}"/></div>
      </c:if>

      <c:choose>
        <c:when test="${product.inStock}">
          <form action="${pageContext.request.contextPath}/cart/add" method="post" class="d-flex gap-2">
            <input type="hidden" name="productId" value="${product.id}">
            <div>
              <label class="form-label" for="qty">Adet</label>
              <input type="number" id="qty" name="quantity" value="1" min="1" max="${product.stock}"
                     class="form-control" style="width:90px;">
            </div>
            <div style="align-self:flex-end;">
              <button type="submit" class="btn btn-primary btn-lg">🛒 Sepete Ekle</button>
            </div>
          </form>
        </c:when>
        <c:otherwise>
          <button class="btn btn-danger btn-lg" disabled>Stokta Yok</button>
        </c:otherwise>
      </c:choose>

      <div class="mt-4">
        <a href="${pageContext.request.contextPath}/products" class="btn btn-outline">← Ürünlere Dön</a>
      </div>
    </div>

  </div>
</div>

<jsp:include page="/WEB-INF/views/includes/footer.jsp"/>
