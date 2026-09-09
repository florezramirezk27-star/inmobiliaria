<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Reportes — Inmobiliaria</title>

    <link href="https://fonts.googleapis.com/css2?family=Bricolage+Grotesque:opsz,wght@12..96,400..800&family=Karla:wght@400;500;600;700&display=swap"
          rel="stylesheet">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
          crossorigin="anonymous">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
</head>

<body>

<%@ include file="/WEB-INF/includes/navbar.jspf" %>

<main class="container py-5">

    <div class="banner-panel banner-reportes mb-4">
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">
            <div>
                <span class="badge badge-tag">ADMINISTRADOR</span>
                <h1 class="fuente-display mt-2">Reportes del sistema</h1>
                <p class="descripcion">
                    Los cinco reportes SQL definidos por el negocio, sobre
                    propiedades, citas y ciudades.
                </p>
            </div>

            <a href="${pageContext.request.contextPath}/admin/dashboard"
               class="btn btn-banner">
                &larr; Volver al panel
            </a>
        </div>
    </div>

    <%-- Métricas rápidas de cada reporte. --%>
    <div class="row g-3 mb-4">
        <div class="col-6 col-md-3">
            <div class="metrica verde">
                <p class="rotulo">Propiedades publicadas</p>
                <p class="numero">${fn:length(propiedadesPublicadas)}</p>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="metrica azul">
                <p class="rotulo">Citas activas</p>
                <p class="numero">${fn:length(citasActivas)}</p>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="metrica ocre">
                <p class="rotulo">Sin citas</p>
                <p class="numero">${fn:length(propiedadesSinCitas)}</p>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="metrica violeta">
                <p class="rotulo">Ciudades</p>
                <p class="numero">${fn:length(resumenPorCiudad)}</p>
            </div>
        </div>
    </div>

    <%-- ---------- REPORTE 1 ---------- --%>
    <div class="tarjeta-prop mb-4">
        <div class="d-flex flex-wrap align-items-center gap-2 px-4 py-3 border-bottom">
            <span class="chip chip-azul">1</span>
            <h2 class="h5 mb-0">Propiedades publicadas</h2>
            <span class="chip chip-verde ms-auto">${fn:length(propiedadesPublicadas)}</span>
        </div>

        <div class="table-responsive">
            <table class="table tabla-tema tabla-ocre">
                <thead>
                <tr>
                    <th>Código</th>
                    <th>Título</th>
                    <th>Ciudad</th>
                    <th>Tipo</th>
                    <th>Inmobiliaria</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="fila" items="${propiedadesPublicadas}">
                    <tr>
                        <td class="text-secondary">${fila.codigo}</td>
                        <td class="fw-semibold">${fila.titulo}</td>
                        <td>${fila.ciudad}</td>
                        <td><span class="chip chip-gris">${fila.tipo}</span></td>
                        <td class="text-secondary">${fila.inmobiliaria}</td>
                    </tr>
                </c:forEach>

                <c:if test="${empty propiedadesPublicadas}">
                    <tr>
                        <td colspan="5" class="text-center text-secondary py-4">
                            No hay propiedades publicadas todavía.
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <%-- ---------- REPORTE 2 ---------- --%>
    <div class="tarjeta-prop mb-4">
        <div class="d-flex flex-wrap align-items-center gap-2 px-4 py-3 border-bottom">
            <span class="chip chip-azul">2</span>
            <h2 class="h5 mb-0">Citas activas</h2>
            <span class="chip chip-verde ms-auto">${fn:length(citasActivas)}</span>
        </div>

        <div class="table-responsive">
            <table class="table tabla-tema tabla-ocre">
                <thead>
                <tr>
                    <th>Código</th>
                    <th>Propiedad</th>
                    <th>Cliente</th>
                    <th>Fecha</th>
                    <th>Estado</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="fila" items="${citasActivas}">
                    <tr>
                        <td class="text-secondary">${fila.codigo}</td>
                        <td class="fw-semibold">${fila.titulo}</td>
                        <td>${fila.cliente_nombre} ${fila.cliente_apellido}</td>
                        <td class="text-nowrap">${fila.fecha_hora}</td>
                        <td><span class="chip chip-verde">${fila.estado}</span></td>
                    </tr>
                </c:forEach>

                <c:if test="${empty citasActivas}">
                    <tr>
                        <td colspan="5" class="text-center text-secondary py-4">
                            No hay citas activas registradas.
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <%-- ---------- REPORTE 3 ---------- --%>
    <div class="tarjeta-prop mb-4">
        <div class="d-flex flex-wrap align-items-center gap-2 px-4 py-3 border-bottom">
            <span class="chip chip-azul">3</span>
            <h2 class="h5 mb-0">Características de una propiedad</h2>
            <span class="chip chip-verde ms-auto">${fn:length(caracteristicasPropiedad)}</span>
        </div>

        <div class="p-4 pb-3">
            <form method="get"
                  action="${pageContext.request.contextPath}/admin/reportes"
                  class="row g-3">
                <div class="col-md-8">
                    <label class="form-label small fw-bold text-secondary">
                        ID de la propiedad
                    </label>
                    <input type="number"
                           name="idPropiedad"
                           class="form-control"
                           min="1"
                           value="${idPropiedadSeleccionada}"
                           required>
                </div>
                <div class="col-md-4 d-flex align-items-end">
                    <button type="submit" class="btn btn-marca w-100">
                        Consultar características
                    </button>
                </div>
            </form>
        </div>

        <div class="table-responsive">
            <table class="table tabla-tema tabla-ocre">
                <thead>
                <tr>
                    <th>Código</th>
                    <th>Propiedad</th>
                    <th>Característica</th>
                    <th>Categoría</th>
                    <th>Cantidad</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="fila" items="${caracteristicasPropiedad}">
                    <tr>
                        <td class="text-secondary">${fila.codigo}</td>
                        <td class="fw-semibold">${fila.titulo}</td>
                        <td>${fila.caracteristica}</td>
                        <td><span class="chip chip-gris">${fila.categoria}</span></td>
                        <td>${fila.cantidad}</td>
                    </tr>
                </c:forEach>

                <c:if test="${empty caracteristicasPropiedad}">
                    <tr>
                        <td colspan="5" class="text-center text-secondary py-4">
                            No se encontraron características para esta propiedad.
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <%-- ---------- REPORTE 4 ---------- --%>
    <div class="tarjeta-prop mb-4">
        <div class="d-flex flex-wrap align-items-center gap-2 px-4 py-3 border-bottom">
            <span class="chip chip-azul">4</span>
            <h2 class="h5 mb-0">Propiedades publicadas sin citas</h2>
            <span class="chip chip-verde ms-auto">${fn:length(propiedadesSinCitas)}</span>
        </div>

        <div class="table-responsive">
            <table class="table tabla-tema tabla-ocre">
                <thead>
                <tr>
                    <th>Código</th>
                    <th>Título</th>
                    <th>Dirección</th>
                    <th>Ciudad</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="fila" items="${propiedadesSinCitas}">
                    <tr>
                        <td class="text-secondary">${fila.codigo}</td>
                        <td class="fw-semibold">${fila.titulo}</td>
                        <td class="text-secondary">${fila.direccion}</td>
                        <td><span class="chip chip-gris">${fila.ciudad}</span></td>
                    </tr>
                </c:forEach>

                <c:if test="${empty propiedadesSinCitas}">
                    <tr>
                        <td colspan="4" class="text-center text-secondary py-4">
                            Todas las propiedades publicadas tienen al menos una cita.
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <%-- ---------- REPORTE 5 ---------- --%>
    <div class="tarjeta-prop mb-4">
        <div class="d-flex flex-wrap align-items-center gap-2 px-4 py-3 border-bottom">
            <span class="chip chip-azul">5</span>
            <h2 class="h5 mb-0">Resumen por ciudad</h2>
            <span class="chip chip-verde ms-auto">${fn:length(resumenPorCiudad)}</span>
        </div>

        <div class="table-responsive">
            <table class="table tabla-tema tabla-ocre">
                <thead>
                <tr>
                    <th>Ciudad</th>
                    <th class="text-center">Total publicadas</th>
                    <th class="text-end">Precio promedio</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="fila" items="${resumenPorCiudad}">
                    <tr>
                        <td class="fw-semibold">${fila.ciudad}</td>
                        <td class="text-center">
                            <span class="chip chip-azul">${fila.total_publicadas}</span>
                        </td>
                        <td class="text-end fw-semibold">
                            <fmt:formatNumber value="${fila.precio_promedio}" type="currency"
                                              currencySymbol="$ " groupingUsed="true" maxFractionDigits="0"/>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty resumenPorCiudad}">
                    <tr>
                        <td colspan="3" class="text-center text-secondary py-4">
                            No hay datos por ciudad.
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>

</main>

<%@ include file="/WEB-INF/includes/footer.jspf" %>

</body>
</html>