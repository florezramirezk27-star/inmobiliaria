<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%--
    citas-propiedad.jsp — citas de una propiedad puntual.

    No se accede directamente: CitaServlet (GET /propiedades/citas?id=X)
    hace el forward aquí, tanto para mostrar la página normalmente
    como para volver a mostrarla con un error si agendar() falló.

    Atributos que espera en el request:
      propiedad  Propiedad     (si el id era válido)
      citas      List<Cita>    (todas las de esa propiedad, puede ir vacía)
      errores    List<String>  (opcional; solo tras un intento de agendar fallido)
      error      String        (opcional; solo si el id no era válido)
--%>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>
        <c:choose>
            <c:when test="${not empty propiedad}">Citas — ${propiedad.titulo}</c:when>
            <c:otherwise>Citas</c:otherwise>
        </c:choose>
        — Inmobiliaria
    </title>

    <link href="https://fonts.googleapis.com/css2?family=Bricolage+Grotesque:opsz,wght@12..96,400..800&family=Karla:wght@400;500;600;700&display=swap"
          rel="stylesheet">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
          crossorigin="anonymous">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
</head>

<body>

<%-- Iconos en línea usados en la lista de citas --%>
<svg xmlns="http://www.w3.org/2000/svg" style="display:none" aria-hidden="true">
    <symbol id="ico-calendario" viewBox="0 0 24 24" fill="none" stroke="currentColor"
            stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
        <rect x="3" y="5" width="18" height="16" rx="2"/>
        <path d="M8 3v4M16 3v4M3 10h18"/>
    </symbol>
    <symbol id="ico-persona" viewBox="0 0 24 24" fill="none" stroke="currentColor"
            stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
        <circle cx="12" cy="8" r="4"/>
        <path d="M5 20c.6-3.4 3.3-5 7-5s6.4 1.6 7 5"/>
    </symbol>
    <symbol id="ico-nota" viewBox="0 0 24 24" fill="none" stroke="currentColor"
            stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
        <path d="M5 4h14a1 1 0 0 1 1 1v14a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1V5a1 1 0 0 1 1-1Z"/>
        <path d="M9 8h6M9 12h6M9 16h3"/>
    </symbol>
</svg>

<%@ include file="/WEB-INF/includes/navbar.jspf" %>

<main class="container my-5" style="max-width: 820px;">

    <div class="banner-panel banner-citas mb-4">
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">
            <div>
                <span class="badge badge-tag">INMOBILIARIA</span>
                <h1 class="fuente-display mt-2">Citas</h1>
                <c:if test="${not empty propiedad}">
                    <p class="descripcion">${propiedad.titulo} — ${propiedad.codigo}</p>
                </c:if>
            </div>

            <div class="d-flex flex-wrap align-items-center gap-2">
                <c:if test="${not empty propiedad}">
                    <span class="badge badge-tag">
                        ${fn:length(citas)} ${fn:length(citas) == 1 ? 'visita' : 'visitas'}
                    </span>
                    <a href="${pageContext.request.contextPath}/propiedades/detalle?id=${propiedad.id}"
                       class="btn btn-banner">
                        &larr; Volver a la propiedad
                    </a>
                </c:if>
            </div>
        </div>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-warning" role="alert">${error}</div>
    </c:if>

    <c:if test="${not empty param.agendada}">
        <div class="alert alert-success" role="alert">Visita agendada correctamente.</div>
    </c:if>

    <c:if test="${not empty errores}">
        <div class="alert alert-danger" role="alert">
            <ul class="mb-0">
                <c:forEach var="e" items="${errores}">
                    <li>${e}</li>
                </c:forEach>
            </ul>
        </div>
    </c:if>

    <c:if test="${not empty propiedad}">

        <%-- ---------- Formulario para agendar una visita nueva ---------- --%>
        <c:if test="${puedeCrearCita}">
        <form method="post" action="${pageContext.request.contextPath}/propiedades/citas"
              class="tarjeta-prop p-4 mb-4">

            <input type="hidden" name="propiedadId" value="${propiedad.id}">

            <h2 class="h5 mb-3">Agendar una visita</h2>

            <div class="row g-3">
                <div class="col-12 col-md-6">
                    <label class="form-label" for="fechaHora">Fecha y hora</label>
                    <input type="datetime-local" class="form-control" id="fechaHora" name="fechaHora" required>
                </div>
                <div class="col-12 col-md-6 d-flex align-items-end">
                    <button type="submit" class="btn btn-marca w-100">Solicitar visita</button>
                </div>
                <div class="col-12">
                    <label class="form-label" for="observacion">Observación (opcional)</label>
                    <input type="text" class="form-control" id="observacion" name="observacion"
                           maxlength="255" placeholder="Ej: prefiero en la tarde">
                </div>
            </div>
        </form>
        </c:if>

        <%-- ---------- Citas ya agendadas para esta propiedad ---------- --%>
        <h2 class="h5 mb-3">Visitas agendadas</h2>

        <c:choose>
            <c:when test="${empty citas}">
                <div class="sin-resultados">
                    <p class="mb-0">Todavía no hay ninguna visita agendada.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="d-flex flex-column gap-3">
                    <c:forEach var="cita" items="${citas}">
                        <div class="tarjeta-prop p-3">
                            <div class="d-flex gap-3">

                                <div class="avatar-cita"
                                     title="Cliente: ${cita.clienteNombreCompleto}">
                                    ${fn:substring(fn:trim(cita.clienteNombreCompleto), 0, 1)}
                                </div>

                                <div class="flex-grow-1">

                                    <div class="d-flex justify-content-between align-items-start flex-wrap gap-2">
                                        <div>
                                            <p class="fw-bold mb-1" style="font-size: 1.05rem;">
                                                <svg style="width: 16px; height: 16px; color: var(--verde); margin-right: 0.35rem; vertical-align: -2px;">
                                                    <use href="#ico-calendario"/>
                                                </svg>
                                                ${cita.fechaHoraFormateada}
                                            </p>
                                            <p class="mb-1" style="color: var(--gris); font-size: 0.92rem;">
                                                Solicitada por: ${cita.clienteNombreCompleto}
                                            </p>
                                            <c:if test="${not empty cita.observacion}">
                                                <p class="mb-0" style="font-size: 0.9rem;">
                                                    " ${cita.observacion} "
                                                </p>
                                            </c:if>
                                        </div>

                                        <c:set var="estadoCita" value="${cita.estado}"/>
                                        <c:choose>
                                            <c:when test="${estadoCita == 'CONFIRMADA' or estadoCita == 'REALIZADA'}">
                                                <span class="chip chip-verde">${cita.estado.etiqueta}</span>
                                            </c:when>
                                            <c:when test="${estadoCita == 'RECHAZADA' or estadoCita == 'CANCELADA'}">
                                                <span class="chip chip-rojo">${cita.estado.etiqueta}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="chip chip-ocre">${cita.estado.etiqueta}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <c:if test="${puedeGestionarCitas && cita.pendienteDeGestion}">
                                        <div class="d-flex gap-2 mt-3">
                                            <form method="post" action="${pageContext.request.contextPath}/propiedades/citas/estado">
                                                <input type="hidden" name="citaId" value="${cita.id}">
                                                <input type="hidden" name="nuevoEstado" value="CONFIRMADA">
                                                <input type="hidden" name="volver"
                                                       value="${pageContext.request.contextPath}/propiedades/citas?id=${propiedad.id}">
                                                <button type="submit" class="btn btn-sm btn-marca">Confirmar</button>
                                            </form>
                                            <form method="post" action="${pageContext.request.contextPath}/propiedades/citas/estado">
                                                <input type="hidden" name="citaId" value="${cita.id}">
                                                <input type="hidden" name="nuevoEstado" value="RECHAZADA">
                                                <input type="hidden" name="volver"
                                                       value="${pageContext.request.contextPath}/propiedades/citas?id=${propiedad.id}">
                                                <button type="submit" class="btn btn-sm btn-contorno">
                                                    Rechazar
                                                </button>
                                            </form>
                                        </div>
                                    </c:if>

                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>

    </c:if>

</main>

<%@ include file="/WEB-INF/includes/footer.jspf" %>

</body>
</html>