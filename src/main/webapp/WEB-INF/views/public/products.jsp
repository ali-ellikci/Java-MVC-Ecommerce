<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="${selectedCategory != null ? selectedCategory.name : 'Ürünler'}" scope="request"/>
<jsp:include page="/WEB-INF/views/includes/header.jsp"/>

<div class="container">
  <div class="page-header">
    <h1>
      <c:choose>
        <c:when test="${selectedCategory != null}">
          <c:out value="${selectedCategory.name}"/>
        </c:when>
        <c:otherwise>Tüm Ürünler</c:otherwise>
      </c:choose>
    </h1>
    <p>${products.size()} ürün listeleniyor</p>
  </div>

  <!-- Kategori filtre butonları -->
  <div class="d-flex gap-1 mb-4" style="flex-wrap:wrap;">
    <a href="${pageContext.request.contextPath}/products"
       class="cat-btn ${selectedCategory == null ? 'active' : ''}">Tümü</a>
    <c:forEach var="cat" items="${categories}">
      <a href="${pageContext.request.contextPath}/products?categoryId=${cat.id}"
         class="cat-btn ${selectedCategory != null && selectedCategory.id == cat.id ? 'active' : ''}">
        <c:out value="${cat.name}"/>
      </a>
    </c:forEach>
  </div>

  <c:choose>
    <c:when test="${not empty products}">
      <div class="products-grid">
        <c:forEach var="product" items="${products}">
          <div class="product-card">
            <div class="product-card__img-wrap">
              <img src="<c:out value='${product.imageUrl}'/>"
                   alt="<c:out value='${product.name}'/>"
                   class="product-card__img"
                   loading="lazy"
                   onerror="this.src='https://placehold.co/400x400/1a1a2e/6366f1?text=Ürün'">
              <c:if test="${!product.inStock}">
                <span class="out-of-stock-badge">Stokta Yok</span>
              </c:if>
            </div>
            <div class="product-card__body">
              <div class="product-card__category"><c:out value="${product.categoryName}"/></div>
              <div class="product-card__name"><c:out value="${product.name}"/></div>
              <div class="product-card__desc"><c:out value="${product.description}"/></div>
              <div class="product-card__price">
                <fmt:formatNumber value="${product.price}" type="number" minFractionDigits="2" maxFractionDigits="2"/> ₺
              </div>
              <div class="product-card__actions">
                <a href="${pageContext.request.contextPath}/product-detail?id=${product.id}"
                   class="btn btn-outline btn-sm">Detay</a>
                <c:choose>
                  <c:when test="${product.inStock}">
                    <form action="${pageContext.request.contextPath}/cart/add" method="post" style="flex:1;">
                      <input type="hidden" name="productId" value="${product.id}">
                      <input type="hidden" name="quantity"  value="1">
                      <button type="submit" class="btn btn-primary btn-sm w-100">🛒 Sepete Ekle</button>
                    </form>
                  </c:when>
                  <c:otherwise>
                    <button class="btn btn-outline btn-sm w-100" disabled>Stokta Yok</button>
                  </c:otherwise>
                </c:choose>
              </div>
            </div>
          </div>
        </c:forEach>
      </div>
    </c:when>
    <c:otherwise>
      <div class="empty-state">
        <div class="icon">📦</div>
        <h3>Bu kategoride ürün bulunamadı</h3>
        <a href="${pageContext.request.contextPath}/products" class="btn btn-primary mt-3">Tüm Ürünler</a>
      </div>
    </c:otherwise>
  </c:choose>
</div>

<jsp:include page="/WEB-INF/views/includes/footer.jsp"/>
