<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="tr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin Giriş | ShopZone</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body style="background:var(--admin-bg); display:flex; align-items:center; justify-content:center; min-height:100vh; font-family:'Inter',sans-serif;">

<div style="width:100%;max-width:400px; padding:1rem;">
  <div style="text-align:center; margin-bottom:2rem;">
    <div style="font-size:2.5rem;">🔐</div>
    <h1 style="font-size:1.5rem; font-weight:800; margin-top:.5rem;">Admin Panel</h1>
    <p style="color:var(--admin-muted); font-size:.875rem;">Yönetici hesabınızla giriş yapın</p>
  </div>

  <div class="admin-form-card" style="max-width:100%;">
    <c:if test="${not empty error}">
      <div class="admin-alert admin-alert-danger">⚠️ <c:out value="${error}"/></div>
    </c:if>

    <form action="${pageContext.request.contextPath}/admin/login" method="post">
      <div class="admin-form-group">
        <label class="admin-label" for="adminEmail">E-posta</label>
        <input type="email" id="adminEmail" name="email"
               class="admin-input" placeholder="admin@admin.com" required>
      </div>
      <div class="admin-form-group">
        <label class="admin-label" for="adminPass">Şifre</label>
        <input type="password" id="adminPass" name="password"
               class="admin-input" placeholder="••••••••" required>
      </div>
      <button type="submit" class="admin-btn admin-btn-primary"
              style="width:100%; padding:.75rem; font-size:.9rem; justify-content:center; margin-top:.5rem;">
        Giriş Yap
      </button>
    </form>

    <p style="text-align:center; margin-top:1.25rem; font-size:.8rem; color:var(--admin-muted);">
      <a href="${pageContext.request.contextPath}/home" style="color:var(--admin-muted);">← Mağazaya Dön</a>
    </p>
  </div>
</div>

</body>
</html>
