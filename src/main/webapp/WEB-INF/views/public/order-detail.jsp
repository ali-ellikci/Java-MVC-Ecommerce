<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Sipariş Detayı" scope="request"/>
<jsp:include page="/WEB-INF/views/includes/header.jsp"/>

<div class="container section">

  <c:if test="${param.success == 'true'}">
    <div class="alert alert-success">
      🎉 Siparişiniz başarıyla oluşturuldu! Teşekkür ederiz.
    </div>
  </c:if>

  <c:choose>
    <c:when test="${order != null}">

      <div class="page-header d-flex justify-between align-center">
        <div>
          <h1>Sipariş #${order.id}</h1>
          <p>${order.orderDate != null ? order.orderDate.toString().replace('T', ' ').substring(0,16) : '-'}</p>
        </div>
        <c:choose>
          <c:when test="${order.status == 'Beklemede'}">
            <span class="status-badge status-beklemede" style="font-size:.9rem;padding:.4rem 1rem;">${order.status}</span>
          </c:when>
          <c:when test="${order.status == 'Hazırlanıyor'}">
            <span class="status-badge status-hazirlaniyor" style="font-size:.9rem;padding:.4rem 1rem;">${order.status}</span>
          </c:when>
          <c:when test="${order.status == 'Kargoya Verildi'}">
            <span class="status-badge status-kargo" style="font-size:.9rem;padding:.4rem 1rem;">${order.status}</span>
          </c:when>
          <c:when test="${order.status == 'Tamamlandı'}">
            <span class="status-badge status-tamamlandi" style="font-size:.9rem;padding:.4rem 1rem;">${order.status}</span>
          </c:when>
          <c:otherwise>
            <span class="status-badge status-iptal" style="font-size:.9rem;padding:.4rem 1rem;">${order.status}</span>
          </c:otherwise>
        </c:choose>
      </div>

      <!-- Ürünler -->
      <div class="table-card mb-4">
        <table class="data-table">
          <thead>
            <tr>
              <th>Ürün</th>
              <th>Birim Fiyat</th>
              <th>Adet</th>
              <th>Ara Toplam</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="item" items="${order.items}">
              <tr>
                <td>
                  <div class="d-flex align-center gap-1">
                    <img src="<c:out value='${item.imageUrl}'/>"
                         style="width:44px;height:44px;object-fit:cover;border-radius:6px;"
                         onerror="this.style.display='none'"
                         alt="<c:out value='${item.productName}'/>">
                    <c:out value="${item.productName}"/>
                  </div>
                </td>
                <td><fmt:formatNumber value="${item.unitPrice}" type="number" minFractionDigits="2" maxFractionDigits="2"/> ₺</td>
                <td>${item.quantity}</td>
                <td><fmt:formatNumber value="${item.subtotal}" type="number" minFractionDigits="2" maxFractionDigits="2"/> ₺</td>
              </tr>
            </c:forEach>
          </tbody>
          <tfoot>
            <tr>
              <td colspan="3" style="text-align:right; font-weight:700; padding:.9rem 1rem;">Genel Toplam</td>
              <td style="font-weight:800; color:var(--primary);">
                <fmt:formatNumber value="${order.totalAmount}" type="number" minFractionDigits="2" maxFractionDigits="2"/> ₺
              </td>
            </tr>
          </tfoot>
        </table>
      </div>

      <a href="${pageContext.request.contextPath}/my-orders" class="btn btn-outline">← Siparişlerime Dön</a>

    </c:when>
    <c:otherwise>
      <div class="empty-state">
        <div class="icon">❌</div>
        <h3>Sipariş bulunamadı</h3>
        <a href="${pageContext.request.contextPath}/my-orders" class="btn btn-primary mt-3">Siparişlerime Dön</a>
      </div>
    </c:otherwise>
  </c:choose>
</div>

<jsp:include page="/WEB-INF/views/includes/footer.jsp"/>
