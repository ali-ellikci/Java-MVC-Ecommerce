<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Siparişler" scope="request"/>
<!DOCTYPE html>
<html lang="tr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Sipariş Detayı | Admin Panel</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body class="admin-body">
<jsp:include page="/WEB-INF/views/admin/includes/sidebar.jsp"/>

<div class="admin-main">
  <div class="admin-topbar">
    <span class="admin-topbar-title">📋 Sipariş Detayı (#${order.id})</span>
    <div class="admin-user-info">
      <div class="admin-avatar">A</div>
      <span><c:out value="${sessionScope.adminUser.fullName}"/></span>
    </div>
  </div>

  <div class="admin-content">
    <div class="admin-page-header">
      <h1>Sipariş Detayı</h1>
      <a href="${pageContext.request.contextPath}/admin/orders" class="admin-btn admin-btn-ghost">← Sipariş Listesine Dön</a>
    </div>

    <!-- Mesajlar -->
    <c:if test="${param.msg == 'updated'}">
      <div class="admin-alert admin-alert-success">✅ Sipariş durumu başarıyla güncellendi.</div>
    </c:if>

    <c:choose>
      <c:when test="${order != null}">
        <div style="display: grid; grid-template-columns: 1fr 300px; gap: 1.5rem; align-items: start;">
          <!-- Sol taraf: Sipariş Kalemleri -->
          <div class="admin-table-card">
            <div class="admin-table-header">
              <h3>Sipariş Kalemleri</h3>
            </div>
            <table class="admin-table">
              <thead>
                <tr>
                  <th>Görsel</th>
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
                      <img src="<c:out value='${item.imageUrl}'/>"
                           style="width:44px;height:44px;object-fit:cover;border-radius:6px;"
                           onerror="this.src='https://placehold.co/44x44/17172b/6366f1?text=?'"
                           alt="<c:out value='${item.productName}'/>">
                    </td>
                    <td><strong><c:out value="${item.productName}"/></strong></td>
                    <td><fmt:formatNumber value="${item.unitPrice}" type="number" minFractionDigits="2" maxFractionDigits="2"/> ₺</td>
                    <td>${item.quantity}</td>
                    <td><fmt:formatNumber value="${item.subtotal}" type="number" minFractionDigits="2" maxFractionDigits="2"/> ₺</td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </div>

          <!-- Sağ taraf: Sipariş Bilgileri & Durum Güncelleme -->
          <div class="admin-form-card" style="margin: 0; max-width: 100%;">
            <h2>Sipariş Bilgileri</h2>
            
            <div style="margin-bottom: 1rem;">
              <span class="admin-label">Müşteri</span>
              <div style="font-weight: 600; font-size: 0.95rem; margin-top: 2px;"><c:out value="${order.customerName}"/></div>
            </div>

            <div style="margin-bottom: 1rem;">
              <span class="admin-label">Sipariş Tarihi</span>
              <div style="font-size: 0.9rem; margin-top: 2px;">
                ${order.orderDate != null ? order.orderDate.toString().replace('T', ' ').substring(0,16) : '-'}
              </div>
            </div>

            <div style="margin-bottom: 1.5rem;">
              <span class="admin-label">Toplam Tutar</span>
              <div style="font-size: 1.25rem; font-weight: 800; color: #a5b4fc; margin-top: 2px;">
                <fmt:formatNumber value="${order.totalAmount}" type="number" minFractionDigits="2" maxFractionDigits="2"/> ₺
              </div>
            </div>

            <div style="margin-bottom: 1.5rem; padding-top: 1rem; border-top: 1px solid var(--admin-border);">
              <span class="admin-label">Mevcut Durum</span>
              <div style="margin: 0.5rem 0;">
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
              </div>
            </div>

            <form action="${pageContext.request.contextPath}/admin/order/update-status" method="post">
              <input type="hidden" name="orderId" value="${order.id}">
              <div class="admin-form-group">
                <label class="admin-label" for="statusSelect">Durumu Güncelle</label>
                <select id="statusSelect" name="status" class="admin-input">
                  <c:forEach var="statusOption" items="${statuses}">
                    <option value="${statusOption}" ${order.status == statusOption ? 'selected' : ''}>
                      ${statusOption}
                    </option>
                  </c:forEach>
                </select>
              </div>
              <button type="submit" class="admin-btn admin-btn-primary" style="width: 100%; justify-content: center; padding: 0.7rem;">
                💾 Kaydet
              </button>
            </form>
          </div>
        </div>
      </c:when>
      <c:otherwise>
        <div style="text-align:center; padding:3rem; color:var(--admin-muted);">
          Sipariş bulunamadı.
        </div>
      </c:otherwise>
    </c:choose>
  </div>
</div>

</body>
</html>
