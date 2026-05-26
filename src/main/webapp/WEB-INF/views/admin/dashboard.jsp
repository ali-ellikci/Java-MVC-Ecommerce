<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Dashboard" scope="request"/>
<!DOCTYPE html>
<html lang="tr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Dashboard | Admin Panel</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body class="admin-body">

<jsp:include page="/WEB-INF/views/admin/includes/sidebar.jsp"/>

<div class="admin-main">
  <div class="admin-topbar">
    <span class="admin-topbar-title">📊 Dashboard</span>
    <div class="admin-user-info">
      <div class="admin-avatar">A</div>
      <span><c:out value="${sessionScope.adminUser.fullName}"/></span>
    </div>
  </div>

  <div class="admin-content">
    <h2 style="font-size:1.1rem; color:var(--admin-muted); font-weight:500; margin-bottom:1.5rem;">
      Hoş geldiniz! İşte güncel özet bilgiler.
    </h2>

    <!-- İstatistik Kartları -->
    <div class="stats-grid">
      <div class="stat-card stat-card--purple">
        <div class="stat-icon">📦</div>
        <div class="stat-value">${totalProducts}</div>
        <div class="stat-label">Toplam Ürün</div>
      </div>
      <div class="stat-card stat-card--blue">
        <div class="stat-icon">🏷️</div>
        <div class="stat-value">${totalCategories}</div>
        <div class="stat-label">Toplam Kategori</div>
      </div>
      <div class="stat-card stat-card--green">
        <div class="stat-icon">👥</div>
        <div class="stat-value">${totalUsers}</div>
        <div class="stat-label">Müşteri</div>
      </div>
      <div class="stat-card stat-card--orange">
        <div class="stat-icon">🛒</div>
        <div class="stat-value">${totalOrders}</div>
        <div class="stat-label">Toplam Sipariş</div>
      </div>
      <div class="stat-card stat-card--red">
        <div class="stat-icon">⏳</div>
        <div class="stat-value">${pendingOrders}</div>
        <div class="stat-label">Bekleyen Sipariş</div>
      </div>
    </div>

    <!-- Hızlı Erişim -->
    <div style="display:grid; grid-template-columns: repeat(auto-fill, minmax(200px,1fr)); gap:1rem; margin-top:1rem;">
      <a href="${pageContext.request.contextPath}/admin/product/add"
         class="admin-btn admin-btn-primary" style="padding:.85rem 1.25rem; border-radius:10px;">
        ➕ Yeni Ürün Ekle
      </a>
      <a href="${pageContext.request.contextPath}/admin/category/add"
         class="admin-btn admin-btn-success" style="padding:.85rem 1.25rem; border-radius:10px;">
        ➕ Yeni Kategori
      </a>
      <a href="${pageContext.request.contextPath}/admin/orders"
         class="admin-btn admin-btn-ghost" style="padding:.85rem 1.25rem; border-radius:10px;">
        📋 Siparişleri Gör
      </a>
    </div>
  </div>
</div>

</body>
</html>
