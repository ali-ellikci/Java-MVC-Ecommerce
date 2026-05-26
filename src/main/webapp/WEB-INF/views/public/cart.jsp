<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Sepetim" scope="request"/>
<jsp:include page="/WEB-INF/views/includes/header.jsp"/>

<div class="container section">
  <div class="page-header">
    <h1>🛒 Sepetim</h1>
  </div>

  <c:if test="${not empty sessionScope.cartMsg}">
    <div class="alert alert-warning"><c:out value="${sessionScope.cartMsg}"/></div>
  </c:if>

  <c:choose>
    <c:when test="${not empty sessionScope.cart}">

      <div style="display:grid; grid-template-columns:1fr 340px; gap:2rem; align-items:start;">

        <!-- Sepet Tablosu -->
        <div class="table-card">
          <table class="cart-table">
            <thead>
              <tr>
                <th>Ürün</th>
                <th>Fiyat</th>
                <th>Adet</th>
                <th>Toplam</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              <c:set var="grandTotal" value="0"/>
              <c:forEach var="entry" items="${sessionScope.cart}">
                <c:set var="item" value="${entry.value}"/>
                <c:set var="grandTotal" value="${grandTotal + item.subtotal}"/>
                <tr>
                  <td>
                    <div class="d-flex align-center gap-1">
                      <img src="<c:out value='${item.imageUrl}'/>"
                           alt="<c:out value='${item.productName}'/>"
                           class="cart-img"
                           onerror="this.src='https://placehold.co/56x56/1a1a2e/6366f1?text=?'">
                      <span><c:out value="${item.productName}"/></span>
                    </div>
                  </td>
                  <td><fmt:formatNumber value="${item.price}" type="number" minFractionDigits="2" maxFractionDigits="2"/> ₺</td>
                  <td>
                    <form action="${pageContext.request.contextPath}/cart/update" method="post"
                          style="display:inline-flex; gap:.35rem; align-items:center;">
                      <input type="hidden" name="productId" value="${item.productId}">
                      <input type="number" name="quantity" value="${item.quantity}"
                             min="1" max="${item.maxStock}"
                             class="qty-input"
                             onchange="this.form.submit()">
                    </form>
                  </td>
                  <td><fmt:formatNumber value="${item.subtotal}" type="number" minFractionDigits="2" maxFractionDigits="2"/> ₺</td>
                  <td>
                    <form action="${pageContext.request.contextPath}/cart/remove" method="post">
                      <input type="hidden" name="productId" value="${item.productId}">
                      <button type="submit" class="btn btn-danger btn-sm">✕</button>
                    </form>
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>

        <!-- Özet Kutusu -->
        <div class="cart-summary">
          <h3 style="margin-bottom:1rem; font-size:1rem;">Sipariş Özeti</h3>
          <div class="cart-total-row">
            <span>Ara Toplam</span>
            <span><fmt:formatNumber value="${grandTotal}" type="number" minFractionDigits="2" maxFractionDigits="2"/> ₺</span>
          </div>
          <div class="cart-total-row">
            <span>Kargo</span>
            <span style="color:var(--success);">Ücretsiz</span>
          </div>
          <div class="cart-total-row">
            <span>Genel Toplam</span>
            <span style="color:var(--primary);">
              <fmt:formatNumber value="${grandTotal}" type="number" minFractionDigits="2" maxFractionDigits="2"/> ₺
            </span>
          </div>

          <div class="mt-4">
            <c:choose>
              <c:when test="${not empty sessionScope.loggedUser}">
                <form action="${pageContext.request.contextPath}/order/create" method="post">
                  <button type="submit" class="btn btn-primary btn-lg btn-full">
                    ✅ Sipariş Ver
                  </button>
                </form>
              </c:when>
              <c:otherwise>
                <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-lg btn-full">
                  🔒 Giriş Yap &amp; Sipariş Ver
                </a>
                <p style="font-size:.8rem; color:var(--text-muted); margin-top:.75rem; text-align:center;">
                  Sipariş vermek için giriş yapmanız gerekiyor.
                </p>
              </c:otherwise>
            </c:choose>
          </div>

          <a href="${pageContext.request.contextPath}/home"
             class="btn btn-outline btn-full mt-3">← Alışverişe Devam Et</a>
        </div>
      </div>

    </c:when>
    <c:otherwise>
      <div class="empty-state">
        <div class="icon">🛒</div>
        <h3>Sepetiniz boş</h3>
        <p>Ürünleri keşfetmek için ana sayfaya dönün.</p>
        <a href="${pageContext.request.contextPath}/home" class="btn btn-primary mt-3">Alışverişe Başla</a>
      </div>
    </c:otherwise>
  </c:choose>
</div>

<jsp:include page="/WEB-INF/views/includes/footer.jsp"/>
