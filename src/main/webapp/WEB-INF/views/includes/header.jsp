<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle != null ? pageTitle : 'ShopZone'} | Java MVC E-Ticaret</title>
    <meta name="description" content="Java MVC ile geliştirilmiş modern e-ticaret portalı.">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>🛍</text></svg>">
</head>
<body>

<nav class="navbar">
  <div class="container d-flex align-center justify-between">

    <a href="${pageContext.request.contextPath}/home" class="navbar-brand"> Ana Sayfa</a>

    <div class="d-flex align-center gap-2" style="flex-wrap:wrap;">

      <!-- Kategori linkler -->
      <div class="d-flex gap-1" style="flex-wrap:wrap;">
        <a href="${pageContext.request.contextPath}/home" class="navbar-nav nav-link
           ${empty param.keyword && requestScope.selectedCategory == null && pageTitle == 'Ana Sayfa' ? 'active' : ''}">Tümü</a>
        <c:forEach var="cat" items="${categories}">
          <a href="${pageContext.request.contextPath}/products?categoryId=${cat.id}"
             class="navbar-nav nav-link
             ${selectedCategory != null && selectedCategory.id == cat.id ? 'active' : ''}">
            <c:out value="${cat.name}"/>
          </a>
        </c:forEach>
      </div>

      <!-- Sağ menü -->
      <div class="d-flex align-center gap-1">
        <!-- Admin Paneli - Sadece Admin Giriş Yapmışsa -->
        <c:if test="${not empty sessionScope.adminUser or (not empty sessionScope.loggedUser and sessionScope.loggedUser.role == 'admin')}">
          <a href="${pageContext.request.contextPath}/admin/dashboard" class="navbar-nav nav-link" title="Admin Panel">
            🔐 Admin
          </a>
        </c:if>

        <!-- Sepet -->
        <a href="${pageContext.request.contextPath}/cart" class="navbar-nav nav-link">
          🛒
          <c:if test="${not empty sessionScope.cart and sessionScope.cart.size() > 0}">
            <span class="cart-badge">${sessionScope.cart.size()}</span>
          </c:if>
        </a>

        <!-- Kullanıcı -->
        <c:choose>
          <c:when test="${not empty sessionScope.adminUser or (not empty sessionScope.loggedUser and sessionScope.loggedUser.role == 'admin')}">
            <!-- Admin çıkış -->
            <a href="${pageContext.request.contextPath}/admin/logout" class="btn btn-outline btn-sm">Çıkış</a>
          </c:when>
          <c:when test="${not empty sessionScope.loggedUser}">
            <!-- Normal müşteri -->
            <a href="${pageContext.request.contextPath}/my-orders" class="navbar-nav nav-link">
              👤 <c:out value="${sessionScope.loggedUser.fullName}"/>
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm">Çıkış</a>
          </c:when>
          <c:otherwise>
            <!-- Kimse giriş yapmamış -->
            <a href="${pageContext.request.contextPath}/login"    class="navbar-nav nav-link">Giriş</a>
            <a href="${pageContext.request.contextPath}/register" class="btn btn-primary btn-sm">Kayıt Ol</a>
          </c:otherwise>
        </c:choose>
      </div>

    </div>
  </div>
</nav>
