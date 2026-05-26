<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Ana Sayfa" scope="request"/>
<jsp:include page="/WEB-INF/views/includes/header.jsp"/>

<!-- HERO -->
<section class="hero">
  <div class="container">
    <h1>Alışverişin Yeni Adresi</h1>
    <p>Binlerce ürün, rekabetçi fiyatlar ve hızlı teslimat ile dilediğinizi keşfedin.</p>

    <!-- Arama Formu -->
    <form action="${pageContext.request.contextPath}/home" method="get" class="search-box">
      <input type="text" name="keyword" id="searchInput"
             placeholder="Ürün ara..."
             value="<c:out value='${keyword}'/>"
             aria-label="Ürün arama kutusu">
      <button type="submit" class="btn btn-primary">🔍 Ara</button>
    </form>
  </div>
</section>

<!-- KATEGORİ FİLTRE BARI -->
<div class="category-filter">
  <div class="container">
    <a href="${pageContext.request.contextPath}/home"
       class="cat-btn ${empty keyword ? 'active' : ''}">Tümü</a>
    <c:forEach var="cat" items="${categories}">
      <a href="${pageContext.request.contextPath}/products?categoryId=${cat.id}"
         class="cat-btn">
        <c:out value="${cat.name}"/>
      </a>
    </c:forEach>
  </div>
</div>

<!-- ÜRÜN LİSTESİ -->
<div class="container">

  <!-- Arama sonucu mesajı -->
  <c:if test="${not empty keyword}">
    <div class="page-header">
      <h1>"<c:out value="${keyword}"/>" için arama sonuçları</h1>
      <p>${products.size()} ürün bulundu &nbsp;|&nbsp;
         <a href="${pageContext.request.contextPath}/home">× Aramayı temizle</a></p>
    </div>
  </c:if>

  <!-- Ürün kartları -->
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
              <div class="product-card__category">
                <c:out value="${product.categoryName}"/>
              </div>
              <div class="product-card__name">
                <c:out value="${product.name}"/>
              </div>
              <div class="product-card__desc">
                <c:out value="${product.description}"/>
              </div>
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
                      <button type="submit" class="btn btn-primary btn-sm w-100">
                        🛒 Sepete Ekle
                      </button>
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
        <h3>Ürün bulunamadı</h3>
        <p>Arama kriterlerinize uygun ürün yok.</p>
        <a href="${pageContext.request.contextPath}/home" class="btn btn-primary mt-3">Ana Sayfaya Dön</a>
      </div>
    </c:otherwise>
  </c:choose>

</div>

<jsp:include page="/WEB-INF/views/includes/footer.jsp"/>
