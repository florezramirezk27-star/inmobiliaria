<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Auditoría — Inmobiliaria</title>

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

    <div class="banner-panel banner-auditoria mb-4">
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">
            <div>
                <span class="badge badge-tag">ADMINISTRADOR</span>
                <h1 class="fuente-display mt-2">Auditoría del sistema</h1>
                <p class="descripcion">
                    Registro de las acciones de administración realizadas sobre
                    usuarios, roles y perfiles.
                </p>
            </div>

            <a href="${pageContext.request.contextPath}/admin/dashboard"
               class="btn btn-banner">
                &larr; Volver al panel
            </a>
        </div>
    </div>

    <%-- Resumen de acciones por tipo. --%>
    <c:set var="registros" value="${fn:length(auditorias)}"/>
    <c:set var="nCreacion" value="0"/>
    <c:set var="nActualizacion" value="0"/>
    <c:set var="nEliminacion" value="0"/>

    <c:forEach var="a" items="${auditorias}">
        <c:set var="acc" value="${fn:toUpperCase(a.accion)}"/>
        <c:choose>
            <c:when test="${fn:contains(acc, 'INSERT') or fn:contains(acc, 'CREAR') or fn:contains(acc, 'REGISTRA')}">
                <c:set var="nCreacion" value="${nCreacion + 1}"/>
            </c:when>
            <c:when test="${fn:contains(acc, 'DELETE') or fn:contains(acc, 'ELIMIN') or fn:contains(acc, 'DESACTIVAR')}">
                <c:set var="nEliminacion" value="${nEliminacion + 1}"/>
            </c:when>
            <c:otherwise>
                <c:set var="nActualizacion" value="${nActualizacion + 1}"/>
            </c:otherwise>
        </c:choose>
    </c:forEach>

    <div class="row g-3 mb-4">
        <div class="col-6 col-md-3">
            <div class="metrica azul">
                <p class="rotulo">Registros</p>
                <p class="numero">${registros}</p>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="metrica verde">
                <p class="rotulo">Creaciones</p>
                <p class="numero">${nCreacion}</p>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="metrica ocre">
                <p class="rotulo">Actualizaciones</p>
                <p class="numero">${nActualizacion}</p>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="metrica rojo">
                <p class="rotulo">Bajas</p>
                <p class="numero">${nEliminacion}</p>
            </div>
        </div>
    </div>

    <div class="tarjeta-prop">
        <div class="table-responsive">

            <table class="table tabla-tema tabla-azul">

                <thead>
                <tr>
                    <th>ID</th>
                    <th>Usuario</th>
                    <th>Acción</th>
                    <th>Tabla</th>
                    <th>ID registro</th>
                    <th>Detalle</th>
                    <th>Fecha</th>
                </tr>
                </thead>

                <tbody>

                <c:forEach var="auditoria" items="${auditorias}">

                    <tr>

                        <td class="text-secondary">${auditoria.idAuditoria}</td>

                        <td>
                            <c:choose>
                                <c:when test="${auditoria.idUsuario != null}">
                                    <span class="fw-semibold">#${auditoria.idUsuario}</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="chip chip-gris">Sistema</span>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <td>
                            <c:set var="acc" value="${fn:toUpperCase(auditoria.accion)}"/>
                            <c:choose>
                                <c:when test="${fn:contains(acc, 'INSERT') or fn:contains(acc, 'CREAR') or fn:contains(acc, 'REGISTRA')}">
                                    <span class="chip chip-verde">${auditoria.accion}</span>
                                </c:when>
                                <c:when test="${fn:contains(acc, 'DELETE') or fn:contains(acc, 'ELIMIN') or fn:contains(acc, 'DESACTIVAR')}">
                                    <span class="chip chip-rojo">${auditoria.accion}</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="chip chip-ocre">${auditoria.accion}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <td class="text-secondary">${auditoria.tablaAfectada}</td>

                        <td class="text-secondary">
                            ${auditoria.idRegistro != null ? auditoria.idRegistro : '-'}
                        </td>

                        <td>${auditoria.detalle}</td>

                        <td class="text-secondary text-nowrap">
                            <fmt:formatDate value="${auditoria.creadoEn}"
                                            pattern="dd/MM/yyyy HH:mm"/>
                        </td>

                    </tr>

                </c:forEach>

                <c:if test="${empty auditorias}">
                    <tr>
                        <td colspan="7" class="text-center text-secondary py-4">
                            No hay acciones registradas todavía.
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