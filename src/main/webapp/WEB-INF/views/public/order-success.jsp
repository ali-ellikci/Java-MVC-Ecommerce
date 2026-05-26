<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Sipariş Başarılı" scope="request"/>
<jsp:include page="/WEB-INF/views/includes/header.jsp"/>

<div class="container section d-flex justify-between align-center" style="min-height: 60vh; flex-direction: column; justify-content: center;">
  <div class="form-card" style="text-align: center; max-width: 500px; margin: 2rem auto;">
    <div style="font-size: 5rem; margin-bottom: 1.5rem; animation: pulse 2s infinite;">🎉</div>
    <h2 style="font-weight: 800; font-size: 2rem; background: linear-gradient(135deg, #fff 0%, #a78bfa 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text;">
      Tebrikler!
    </h2>
    <p style="margin-top: 1rem; color: var(--text-muted); font-size: 1.05rem;">
      Siparişiniz başarıyla alındı ve hazırlık sürecine başlandı.
    </p>

    <div class="d-flex gap-2" style="margin-top: 2.5rem; flex-direction: column;">
      <c:if test="${not empty param.id}">
        <a href="${pageContext.request.contextPath}/order-detail?id=${param.id}" class="btn btn-primary btn-full">
          📄 Sipariş Detayını Gör
        </a>
      </c:if>
      <a href="${pageContext.request.contextPath}/my-orders" class="btn btn-outline btn-full">
        📋 Tüm Siparişlerim
      </a>
      <a href="${pageContext.request.contextPath}/home" class="btn btn-outline btn-full" style="border-color: transparent;">
        🏠 Alışverişe Devam Et
      </a>
    </div>
  </div>
</div>

<style>
@keyframes pulse {
  0% { transform: scale(1); }
  50% { transform: scale(1.1); }
  100% { transform: scale(1); }
}
</style>

<jsp:include page="/WEB-INF/views/includes/footer.jsp"/>
