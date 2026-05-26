<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- Admin Sidebar Include --%>
<aside class="admin-sidebar">
  <div class="sidebar-brand">
    <div class="sidebar-brand-text">🛍 Admin</div>
    <div class="sidebar-brand-sub">Admin Panel</div>
  </div>

  <nav class="sidebar-nav">
    <div class="sidebar-section-title">Ana</div>
    <a href="${pageContext.request.contextPath}/admin/dashboard"
       class="sidebar-link ${pageTitle == 'Dashboard' ? 'active' : ''}">
      <span class="icon">📊</span> Dashboard
    </a>

    <div class="sidebar-section-title">Yönetim</div>
    <a href="${pageContext.request.contextPath}/admin/products"
       class="sidebar-link ${pageTitle == 'Ürünler' ? 'active' : ''}">
      <span class="icon">📦</span> Ürünler
    </a>
    <a href="${pageContext.request.contextPath}/admin/categories"
       class="sidebar-link ${pageTitle == 'Kategoriler' ? 'active' : ''}">
      <span class="icon">🏷️</span> Kategoriler
    </a>
    <a href="${pageContext.request.contextPath}/admin/orders"
       class="sidebar-link ${pageTitle == 'Siparişler' ? 'active' : ''}">
      <span class="icon">🛒</span> Siparişler
    </a>
    <a href="${pageContext.request.contextPath}/admin/users"
       class="sidebar-link ${pageTitle == 'Kullanıcılar' ? 'active' : ''}">
      <span class="icon">👥</span> Kullanıcılar
    </a>

    <div class="sidebar-section-title">Mağaza</div>
    <a href="${pageContext.request.contextPath}/home" class="sidebar-link">
      <span class="icon">🌐</span> Mağazayı Gör
    </a>
  </nav>

  <div class="sidebar-footer">
    <a href="${pageContext.request.contextPath}/admin/logout"
       class="sidebar-link" style="color:#ef4444;">
      <span class="icon">🚪</span> Çıkış Yap
    </a>
  </div>
</aside>
