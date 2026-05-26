<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Kayıt Ol" scope="request"/>
<jsp:include page="/WEB-INF/views/includes/header.jsp"/>

<div class="form-card" style="max-width:560px;">
  <h2>Hesap Oluştur 🚀</h2>
  <p>Birkaç adımda alışverişe başlayın.</p>

  <c:if test="${not empty error}">
    <div class="alert alert-danger">⚠️ <c:out value="${error}"/></div>
  </c:if>

  <form action="${pageContext.request.contextPath}/register" method="post"
        id="registerForm" novalidate>

    <div class="form-group">
      <label class="form-label" for="regName">Ad Soyad *</label>
      <input type="text" id="regName" name="fullName"
             class="form-control"
             placeholder="Adınız Soyadınız"
             value="<c:out value='${fullName}'/>"
             required>
    </div>

    <div class="form-group">
      <label class="form-label" for="regEmail">E-posta *</label>
      <input type="email" id="regEmail" name="email"
             class="form-control"
             placeholder="ornek@email.com"
             value="<c:out value='${email}'/>"
             required>
    </div>

    <div class="form-group">
      <label class="form-label" for="regPassword">Şifre * (min. 6 karakter)</label>
      <input type="password" id="regPassword" name="password"
             class="form-control"
             placeholder="••••••••"
             minlength="6"
             required>
    </div>

    <div class="form-group">
      <label class="form-label" for="regPhone">Telefon</label>
      <input type="tel" id="regPhone" name="phone"
             class="form-control"
             placeholder="05xx xxx xx xx"
             value="<c:out value='${phone}'/>">
    </div>

    <div class="form-group">
      <label class="form-label" for="regAddress">Adres</label>
      <textarea id="regAddress" name="address"
                class="form-control"
                placeholder="Teslimat adresiniz"><c:out value='${address}'/></textarea>
    </div>

    <button type="submit" class="btn btn-primary btn-lg btn-full">Kayıt Ol</button>
  </form>

  <p style="text-align:center; margin-top:1.25rem; font-size:.875rem; color:var(--text-muted);">
    Zaten hesabınız var mı?
    <a href="${pageContext.request.contextPath}/login" class="fw-bold">Giriş Yap</a>
  </p>
</div>

<script>
document.getElementById('registerForm').addEventListener('submit', function(e) {
  const name  = document.getElementById('regName').value.trim();
  const email = document.getElementById('regEmail').value.trim();
  const pass  = document.getElementById('regPassword').value;
  if (!name || !email || !pass) {
    e.preventDefault();
    alert('Ad Soyad, E-posta ve Şifre zorunludur.');
    return;
  }
  if (pass.length < 6) {
    e.preventDefault();
    alert('Şifre en az 6 karakter olmalıdır.');
  }
});
</script>

<jsp:include page="/WEB-INF/views/includes/footer.jsp"/>
