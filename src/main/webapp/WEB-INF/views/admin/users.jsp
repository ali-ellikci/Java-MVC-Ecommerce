<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Kullanıcılar" scope="request"/>
<!DOCTYPE html>
<html lang="tr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Kullanıcı Yönetimi | Admin Panel</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body class="admin-body">
<jsp:include page="/WEB-INF/views/admin/includes/sidebar.jsp"/>

<div class="admin-main">
  <div class="admin-topbar">
    <span class="admin-topbar-title">👥 Kullanıcı Yönetimi</span>
    <div class="admin-user-info">
      <div class="admin-avatar">A</div>
      <span><c:out value="${sessionScope.adminUser.fullName}"/></span>
    </div>
  </div>

  <div class="admin-content">
    <div class="admin-page-header">
      <h1>Kullanıcılar</h1>
    </div>

    <div class="admin-table-card">
      <table class="admin-table">
        <thead>
          <tr>
            <th>ID</th>
            <th>Ad Soyad</th>
            <th>E-posta</th>
            <th>Telefon</th>
            <th>Adres</th>
            <th>Rol</th>
            <th>Kayıt Tarihi</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="user" items="${users}">
            <tr>
              <td style="color:var(--admin-muted);">#${user.id}</td>
              <td><strong><c:out value="${user.fullName}"/></strong></td>
              <td><c:out value="${user.email}"/></td>
              <td><c:out value="${user.phone != null ? user.phone : '-'}"/></td>
              <td style="max-width: 250px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                <c:out value="${user.address != null ? user.address : '-'}"/>
              </td>
              <td>
                <c:choose>
                  <c:when test="${user.role == 'admin'}">
                    <span class="badge badge-active" style="background: rgba(99,102,241,0.15); color: #a5b4fc;">Yönetici</span>
                  </c:when>
                  <c:otherwise>
                    <span class="badge badge-inactive">Müşteri</span>
                  </c:otherwise>
                </c:choose>
              </td>
              <td>
                ${user.createdAt != null ? user.createdAt.toString().replace('T', ' ').substring(0,16) : '-'}
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>

      <c:if test="${empty users}">
        <div style="text-align:center; padding:3rem; color:var(--admin-muted);">
          Kullanıcı bulunamadı.
        </div>
      </c:if>
    </div>
  </div>
</div>

</body>
</html>
