<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1">

    <title>Reportes - Inmobiliaria</title>

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
        rel="stylesheet">

    <link
        rel="stylesheet"
        href="${pageContext.request.contextPath}/css/estilos.css">

</head>

<body>

<%@ include file="/WEB-INF/includes/navbar.jspf" %>

<main class="container py-5">

    <div class="banner-panel mb-4">

        <div class="d-flex flex-wrap
                    justify-content-between
                    align-items-center
                    gap-3">

            <div>

                <span class="badge badge-tag">
                    AGENTE
                </span>

                <h1 class="fuente-display mt-2">
                    Reportes de ventas y arriendos
                </h1>

                <p class="descripcion mb-0">
                    Información exclusiva de
                    <strong>${inmobiliaria.nombreComercial}</strong>.
                </p>

            </div>

            <a
                href="${pageContext.request.contextPath}/inmobiliaria/dashboard"
                class="btn btn-volver">
                &larr; Volver al panel
            </a>

        </div>

    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger" role="alert">
            ${error}
        </div>
    </c:if>

    <div class="row g-3 mb-4">

        <div class="col-md-4">
            <div class="metrica verde">
                <p class="rotulo">Tipos de operación</p>
                <p class="numero">${fn:length(resumenOperaciones)}</p>
            </div>
        </div>

        <div class="col-md-4">
            <div class="metrica azul">
                <p class="rotulo">Grupos de solicitudes</p>
                <p class="numero">${fn:length(solicitudesPorTipoEstado)}</p>
            </div>
        </div>

        <div class="col-md-4">
            <div class="metrica ocre">
                <p class="rotulo">Negociaciones aprobadas</p>
                <p class="numero">${fn:length(operacionesAprobadas)}</p>
            </div>
        </div>

    </div>

    <div class="tarjeta-prop mb-4">

        <div class="p-4 border-bottom">

            <h2 class="h4 mb-1">
                Propiedades por operación
            </h2>

            <p class="descripcion mb-0">
                Estado actual de la oferta de venta y arriendo
                de tu inmobiliaria.
            </p>

        </div>

        <div class="table-responsive">

            <table class="table tabla-tema mb-0">

                <thead>
                <tr>
                    <th>Operación</th>
                    <th class="text-center">Total</th>
                    <th class="text-center">Publicadas</th>
                    <th class="text-center">Borradores</th>
                    <th class="text-center">Reservadas</th>
                    <th class="text-center">Cerradas</th>
                    <th class="text-end">Precio promedio</th>
                </tr>
                </thead>

                <tbody>

                <c:forEach
                    var="fila"
                    items="${resumenOperaciones}">

                    <tr>

                        <td class="fw-semibold">
                            <c:choose>
                                <c:when test="${fila.operacion == 'VENTA'}">
                                    Venta
                                </c:when>
                                <c:otherwise>
                                    Arriendo
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <td class="text-center">
                            ${fila.total_propiedades}
                        </td>

                        <td class="text-center">
                            ${fila.publicadas}
                        </td>

                        <td class="text-center">
                            ${fila.borradores}
                        </td>

                        <td class="text-center">
                            ${fila.reservadas}
                        </td>

                        <td class="text-center">
                            ${fila.cerradas}
                        </td>

                        <td class="text-end fw-semibold">
                            <fmt:formatNumber
                                value="${fila.precio_promedio}"
                                type="currency"
                                currencySymbol="$ "
                                groupingUsed="true"
                                maxFractionDigits="0"/>
                        </td>

                    </tr>

                </c:forEach>

                <c:if test="${empty resumenOperaciones}">

                    <tr>
                        <td
                            colspan="7"
                            class="text-center text-secondary py-4">
                            No hay propiedades registradas.
                        </td>
                    </tr>

                </c:if>

                </tbody>

            </table>

        </div>

    </div>

    <div class="tarjeta-prop mb-4">

        <div class="p-4 border-bottom">

            <h2 class="h4 mb-1">
                Solicitudes de compra y arriendo
            </h2>

            <p class="descripcion mb-0">
                Cantidad de solicitudes recibidas,
                agrupadas por tipo y estado.
            </p>

        </div>

        <div class="table-responsive">

            <table class="table tabla-tema mb-0">

                <thead>
                <tr>
                    <th>Tipo</th>
                    <th>Estado</th>
                    <th class="text-center">Cantidad</th>
                </tr>
                </thead>

                <tbody>

                <c:forEach
                    var="fila"
                    items="${solicitudesPorTipoEstado}">

                    <tr>

                        <td class="fw-semibold">
                            <c:choose>
                                <c:when test="${fila.tipo == 'COMPRA'}">
                                    Compra
                                </c:when>
                                <c:otherwise>
                                    Arriendo
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <td>
                            <span class="chip chip-gris">
                                ${fila.estado}
                            </span>
                        </td>

                        <td class="text-center">
                            ${fila.total_solicitudes}
                        </td>

                    </tr>

                </c:forEach>

                <c:if test="${empty solicitudesPorTipoEstado}">

                    <tr>
                        <td
                            colspan="3"
                            class="text-center text-secondary py-4">
                            No hay solicitudes registradas.
                        </td>
                    </tr>

                </c:if>

                </tbody>

            </table>

        </div>

    </div>

    <div class="tarjeta-prop">

        <div class="p-4 border-bottom">

            <h2 class="h4 mb-1">
                Negociaciones aprobadas
            </h2>

            <p class="descripcion mb-0">
                Solicitudes de compra o arriendo que
                la inmobiliaria ya aprobó.
            </p>

        </div>

        <div class="table-responsive">

            <table class="table tabla-tema mb-0">

                <thead>
                <tr>
                    <th>Solicitud</th>
                    <th>Propiedad</th>
                    <th>Cliente</th>
                    <th>Tipo</th>
                    <th class="text-end">Valor inmueble</th>
                    <th>Actualización</th>
                </tr>
                </thead>

                <tbody>

                <c:forEach
                    var="fila"
                    items="${operacionesAprobadas}">

                    <tr>

                        <td>
                            #${fila.id_solicitud}
                        </td>

                        <td>
                            <span class="d-block fw-semibold">
                                ${fila.titulo}
                            </span>
                            <small class="text-secondary">
                                ${fila.codigo}
                            </small>
                        </td>

                        <td>
                            ${fila.cliente}
                        </td>

                        <td>
                            <span class="chip chip-verde">
                                ${fila.tipo}
                            </span>
                        </td>

                        <td class="text-end fw-semibold">
                            <fmt:formatNumber
                                value="${fila.precio}"
                                type="currency"
                                currencySymbol="$ "
                                groupingUsed="true"
                                maxFractionDigits="0"/>
                        </td>

                        <td class="text-nowrap">
                            ${fila.actualizado_en}
                        </td>

                    </tr>

                </c:forEach>

                <c:if test="${empty operacionesAprobadas}">

                    <tr>
                        <td
                            colspan="6"
                            class="text-center text-secondary py-4">
                            Todavía no hay negociaciones aprobadas.
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
