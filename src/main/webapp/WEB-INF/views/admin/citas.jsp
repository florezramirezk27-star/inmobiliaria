<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Citas — Panel Administrador</title>

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
          crossorigin="anonymous">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
</head>

<body>

<%@ include file="/WEB-INF/includes/navbar.jspf" %>

<main class="container py-5">

    <div class="banner-panel banner-usuarios mb-4">
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">
            <div>
                <span class="badge badge-tag">ADMINISTRADOR</span>
                <h1 class="fuente-display mt-2">Citas registradas</h1>
                <p class="descripcion">
                    Consulta todas las visitas agendadas en el sistema y su estado actual.
                </p>
            </div>

            <a href="${pageContext.request.contextPath}/admin/dashboard"
               class="btn btn-volver">
                &larr; Volver al panel
            </a>
        </div>
    </div>

    <%-- Resumen por estado, calculado sobre la lista del request. --%>
    <c:set var="totalSolicitadas" value="0"/>
    <c:set var="totalConfirmadas" value="0"/>
    <c:set var="totalRealizadas" value="0"/>
    <c:set var="totalRechazadas" value="0"/>
    <c:set var="totalCanceladas" value="0"/>

    <c:forEach var="cita" items="${citas}">
        <c:choose>
            <c:when test="${cita.estado == 'SOLICITADA'}">
                <c:set var="totalSolicitadas" value="${totalSolicitadas + 1}"/>
            </c:when>
            <c:when test="${cita.estado == 'CONFIRMADA'}">
                <c:set var="totalConfirmadas" value="${totalConfirmadas + 1}"/>
            </c:when>
            <c:when test="${cita.estado == 'REALIZADA'}">
                <c:set var="totalRealizadas" value="${totalRealizadas + 1}"/>
            </c:when>
            <c:when test="${cita.estado == 'RECHAZADA'}">
                <c:set var="totalRechazadas" value="${totalRechazadas + 1}"/>
            </c:when>
            <c:when test="${cita.estado == 'CANCELADA'}">
                <c:set var="totalCanceladas" value="${totalCanceladas + 1}"/>
            </c:when>
        </c:choose>
    </c:forEach>

    <div class="row g-3 mb-4">
        <div class="col-6 col-md-4 col-lg-2">
            <div class="metrica azul">
                <p class="rotulo">Total</p>
                <p class="numero">${fn:length(citas)}</p>
            </div>
        </div>
        <div class="col-6 col-md-4 col-lg-2">
            <div class="metrica ocre">
                <p class="rotulo">Solicitadas</p>
                <p class="numero">${totalSolicitadas}</p>
            </div>
        </div>
        <div class="col-6 col-md-4 col-lg-2">
            <div class="metrica verde">
                <p class="rotulo">Confirmadas</p>
                <p class="numero">${totalConfirmadas}</p>
            </div>
        </div>
        <div class="col-6 col-md-4 col-lg-2">
            <div class="metrica azul">
                <p class="rotulo">Realizadas</p>
                <p class="numero">${totalRealizadas}</p>
            </div>
        </div>
        <div class="col-6 col-md-4 col-lg-2">
            <div class="metrica rojo">
                <p class="rotulo">Rechazadas</p>
                <p class="numero">${totalRechazadas}</p>
            </div>
        </div>
        <div class="col-6 col-md-4 col-lg-2">
            <div class="metrica violeta">
                <p class="rotulo">Canceladas</p>
                <p class="numero">${totalCanceladas}</p>
            </div>
        </div>
    </div>

    <c:if test="${not empty errorConsulta}">
        <div class="alert alert-warning" role="alert">
            ${errorConsulta}
        </div>
    </c:if>

    <c:choose>

        <c:when test="${empty citas}">
            <div class="sin-resultados">
                <p class="mb-0">No hay citas registradas todavía.</p>
            </div>
        </c:when>

        <c:otherwise>
            <div class="tabla-scroll">
                <table class="table tabla-tema align-middle">
                    <thead>
                    <tr>
                        <th>Propiedad</th>
                        <th>Cliente</th>
                        <th>Fecha y hora</th>
                        <th>Estado</th>
                        <th>Observación</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="cita" items="${citas}">
                        <tr>
                            <td>
                                <span class="fw-semibold">${cita.propiedadTitulo}</span>
                                <c:if test="${not empty cita.propiedadCodigo}">
                                    <br>
                                    <span class="text-secondary small">${cita.propiedadCodigo}</span>
                                </c:if>
                            </td>
                            <td>${cita.clienteNombreCompleto}</td>
                            <td>${cita.fechaHoraFormateada}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${cita.estado == 'SOLICITADA'}">
                                        <span class="chip chip-ocre">${cita.estado.etiqueta}</span>
                                    </c:when>
                                    <c:when test="${cita.estado == 'CONFIRMADA'}">
                                        <span class="chip chip-verde">${cita.estado.etiqueta}</span>
                                    </c:when>
                                    <c:when test="${cita.estado == 'REALIZADA'}">
                                        <span class="chip chip-azul">${cita.estado.etiqueta}</span>
                                    </c:when>
                                    <c:when test="${cita.estado == 'RECHAZADA'}">
                                        <span class="chip chip-rojo">${cita.estado.etiqueta}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="chip chip-gris">${cita.estado.etiqueta}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty cita.observacion}">
                                        ${cita.observacion}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-secondary">—</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:otherwise>

    </c:choose>

</main>

<%@ include file="/WEB-INF/includes/footer.jspf" %>

</body>
</html>
