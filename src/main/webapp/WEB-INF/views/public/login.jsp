<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Giriş Yap" scope="request"/>
<jsp:include page="/WEB-INF/views/includes/header.jsp"/>

<div class="form-card">
  <h2>Hoş Geldiniz 👋</h2>
  <p>Alışverişe devam etmek için giriş yapın.</p>

  <c:if test="${not empty error}">
    <div class="alert alert-danger">⚠️ <c:out value="${error}"/></div>
  </c:if>

  <form action="${pageContext.request.contextPath}/login" method="post"
        novalidate id="loginForm">

    <c:if test="${not empty param.redirect}">
      <input type="hidden" name="redirect" value="<c:out value='${param.redirect}'/>">
    </c:if>

    <div class="form-group">
      <label class="form-label" for="loginEmail">E-posta</label>
      <input type="email" id="loginEmail" name="email"
             class="form-control"
             placeholder="ornek@email.com"
             value="<c:out value='${email}'/>"
             required autocomplete="email">
    </div>

    <div class="form-group">
      <label class="form-label" for="loginPassword">Şifre</label>
      <input type="password" id="loginPassword" name="password"
             class="form-control"
             placeholder="••••••••"
             required autocomplete="current-password">
    </div>

    <button type="submit" class="btn btn-primary btn-lg btn-full">Giriş Yap</button>
  </form>

  <p style="text-align:center; margin-top:1.25rem; font-size:.875rem; color:var(--text-muted);">
    Hesabınız yok mu?
    <a href="${pageContext.request.contextPath}/register" class="fw-bold">Kayıt Ol</a>
  </p>
</div>

<script>
// İstemci tarafı validasyon
document.getElementById('loginForm').addEventListener('submit', function(e) {
  const email = document.getElementById('loginEmail').value.trim();
  const pass  = document.getElementById('loginPassword').value;
  if (!email || !pass) {
    e.preventDefault();
    alert('Lütfen tüm alanları doldurun.');
  }
});
</script>

<jsp:include page="/WEB-INF/views/includes/footer.jsp"/>
