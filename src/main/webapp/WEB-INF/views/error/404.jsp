<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Sayfa Bulunamadı" scope="request"/>
<jsp:include page="/WEB-INF/views/includes/header.jsp"/>

<div class="container section d-flex justify-between align-center" style="min-height: 60vh; flex-direction: column; justify-content: center; text-align: center;">
  <div class="form-card" style="max-width: 500px; margin: 2rem auto;">
    <div style="font-size: 6rem; font-weight: 800; line-height: 1; background: linear-gradient(135deg, #ef4444, #6366f1); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; margin-bottom: 1.5rem;">
      404
    </div>
    <h2 style="font-weight: 700; font-size: 1.5rem; margin-bottom: 0.5rem;">Aradığınız Sayfa Bulunamadı</h2>
    <p style="color: var(--text-muted); margin-bottom: 2rem;">
      Ulaşmaya çalıştığınız sayfa silinmiş, ismi değiştirilmiş veya geçici olarak kullanım dışı olabilir.
    </p>
    <a href="${pageContext.request.contextPath}/home" class="btn btn-primary btn-full">
      🏠 Ana Sayfaya Dön
    </a>
  </div>
</div>

<jsp:include page="/WEB-INF/views/includes/footer.jsp"/>
