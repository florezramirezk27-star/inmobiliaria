<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Mi panel — Inmobiliaria</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
          rel="stylesheet">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
          rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
</head>

<body>

<%@ include file="/WEB-INF/includes/navbar.jspf" %>

<main class="container py-5">

    <div class="cabecera-seccion">
        <div>
            <span class="chip chip-verde mb-2">Cliente</span>
            <h1 class="fuente-display mb-1">
                <c:choose>
                    <c:when test="${not empty sessionScope.correo}">Hola, ${sessionScope.correo}</c:when>
                    <c:otherwise>Mi panel</c:otherwise>
                </c:choose>
            </h1>
            <p class="descripcion mb-0">
                Gestiona tus propiedades favoritas, citas y solicitudes desde un solo lugar.
            </p>
        </div>
        <a class="btn btn-marca" href="${pageContext.request.contextPath}/propiedades">
            <i class="bi bi-search" aria-hidden="true"></i> Buscar propiedades
        </a>
    </div>

    <div class="row g-4">

        <div class="col-12 col-sm-6 col-lg-3">
            <a class="tarjeta-acceso" href="${pageContext.request.contextPath}/cliente/perfil">
                <span class="icono"><i class="bi bi-person"></i></span>
                <h3>Mi perfil</h3>
                <p>Consulta y actualiza tu información personal.</p>
                <span class="accion">Ver perfil</span>
            </a>
        </div>

        <div class="col-12 col-sm-6 col-lg-3">
            <a class="tarjeta-acceso" href="${pageContext.request.contextPath}/cliente/favoritos">
                <span class="icono"><i class="bi bi-heart"></i></span>
                <h3>Mis favoritos</h3>
                <p>Las propiedades que guardaste para revisar después.</p>
                <span class="accion">Ver favoritos</span>
            </a>
        </div>

        <div class="col-12 col-sm-6 col-lg-3">
            <a class="tarjeta-acceso" href="${pageContext.request.contextPath}/citas">
                <span class="icono"><i class="bi bi-calendar-check"></i></span>
                <h3>Mis citas</h3>
                <p>Consulta el estado de tus visitas programadas.</p>
                <span class="accion">Ver citas</span>
            </a>
        </div>

        <div class="col-12 col-sm-6 col-lg-3">
            <a class="tarjeta-acceso" href="${pageContext.request.contextPath}/cliente/solicitudes">
                <span class="icono"><i class="bi bi-file-earmark-text"></i></span>
                <h3>Mis solicitudes</h3>
                <p>Tus solicitudes de compra y arriendo con su estado.</p>
                <span class="accion">Ver solicitudes</span>
            </a>
        </div>

    </div>

</main>

<%@ include file="/WEB-INF/includes/footer.jspf" %>

</body>
</html>
