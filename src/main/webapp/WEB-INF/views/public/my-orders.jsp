<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Siparişlerim" scope="request"/>
<jsp:include page="/WEB-INF/views/includes/header.jsp"/>

<div class="container section">
  <div class="page-header">
    <h1>📋 Siparişlerim</h1>
    <p>Hoş geldin, <strong><c:out value="${sessionScope.loggedUser.fullName}"/></strong></p>
  </div>

  <c:choose>
    <c:when test="${not empty orders}">
      <div class="table-card">
        <table class="data-table">
          <thead>
            <tr>
              <th>Sipariş No</th>
              <th>Tarih</th>
              <th>Toplam</th>
              <th>Durum</th>
              <th>Detay</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="order" items="${orders}">
              <tr>
                <td><strong>#${order.id}</strong></td>
                <td>
                  <c:out value="${order.orderDateFormatted}"/>
                </td>
                <td>
                  <fmt:formatNumber value="${order.totalAmount}" type="number"
                                    minFractionDigits="2" maxFractionDigits="2"/> ₺
                </td>
                <td>
                  <c:choose>
                    <c:when test="${order.status == 'Beklemede'}">
                      <span class="status-badge status-beklemede">${order.status}</span>
                    </c:when>
                    <c:when test="${order.status == 'Hazırlanıyor'}">
                      <span class="status-badge status-hazirlaniyor">${order.status}</span>
                    </c:when>
                    <c:when test="${order.status == 'Kargoya Verildi'}">
                      <span class="status-badge status-kargo">${order.status}</span>
                    </c:when>
                    <c:when test="${order.status == 'Tamamlandı'}">
                      <span class="status-badge status-tamamlandi">${order.status}</span>
                    </c:when>
                    <c:otherwise>
                      <span class="status-badge status-iptal">${order.status}</span>
                    </c:otherwise>
                  </c:choose>
                </td>
                <td>
                  <a href="${pageContext.request.contextPath}/order-detail?id=${order.id}"
                     class="btn btn-outline btn-sm">Görüntüle</a>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
    </c:when>
    <c:otherwise>
      <div class="empty-state">
        <div class="icon">📦</div>
        <h3>Henüz siparişiniz yok</h3>
        <p>İlk siparişinizi vermek için alışverişe başlayın.</p>
        <a href="${pageContext.request.contextPath}/home" class="btn btn-primary mt-3">Alışverişe Başla</a>
      </div>
    </c:otherwise>
  </c:choose>
</div>

<jsp:include page="/WEB-INF/views/includes/footer.jsp"/>
