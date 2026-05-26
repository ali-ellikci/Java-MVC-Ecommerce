<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Siparişler" scope="request"/>
<!DOCTYPE html>
<html lang="tr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Sipariş Yönetimi | Admin Panel</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body class="admin-body">
<jsp:include page="/WEB-INF/views/admin/includes/sidebar.jsp"/>

<div class="admin-main">
  <div class="admin-topbar">
    <span class="admin-topbar-title">🛒 Sipariş Yönetimi</span>
    <div class="admin-user-info">
      <div class="admin-avatar">A</div>
      <span><c:out value="${sessionScope.adminUser.fullName}"/></span>
    </div>
  </div>

  <div class="admin-content">
    <div class="admin-page-header">
      <h1>Siparişler</h1>
    </div>

    <!-- Mesajlar -->
    <c:choose>
      <c:when test="${param.msg == 'updated'}">
        <div class="admin-alert admin-alert-success">✅ Sipariş durumu güncellendi.</div>
      </c:when>
    </c:choose>

    <div class="admin-table-card">
      <table class="admin-table">
        <thead>
          <tr>
            <th>Sipariş No</th>
            <th>Müşteri</th>
            <th>Tarih</th>
            <th>Toplam Tutar</th>
            <th>Durum</th>
            <th>İşlemler</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="order" items="${orders}">
            <tr>
              <td style="color:var(--admin-muted);"><strong>#${order.id}</strong></td>
              <td><strong><c:out value="${order.customerName}"/></strong></td>
              <td>
                <c:out value="${order.orderDateFormatted}"/>
              </td>
              <td>
                <fmt:formatNumber value="${order.totalAmount}" type="number" minFractionDigits="2" maxFractionDigits="2"/> ₺
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
                <div class="d-flex gap-1">
                  <a href="${pageContext.request.contextPath}/admin/order-detail?id=${order.id}"
                     class="admin-btn admin-btn-ghost admin-btn-sm">👁️ Detaylar</a>
                  
                  <form action="${pageContext.request.contextPath}/admin/order/update-status" method="post" style="display: inline-block; margin: 0;">
                    <input type="hidden" name="orderId" value="${order.id}">
                    <select name="status" onchange="this.form.submit()" class="admin-input" style="padding: 0.25rem 0.5rem; font-size: 0.75rem; border-radius: 6px; width: auto; display: inline-block;">
                      <c:forEach var="statusOption" items="${statuses}">
                        <option value="${statusOption}" ${order.status == statusOption ? 'selected' : ''}>
                          ${statusOption}
                        </option>
                      </c:forEach>
                    </select>
                  </form>
                </div>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>

      <c:if test="${empty orders}">
        <div style="text-align:center; padding:3rem; color:var(--admin-muted);">
          Henüz sipariş verilmemiş.
        </div>
      </c:if>
    </div>
  </div>
</div>

</body>
</html>
