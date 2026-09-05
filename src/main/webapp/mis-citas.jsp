<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%--
    mis-citas.jsp — todas las visitas agendadas por el usuario
    (cliente de prueba, ver el javadoc de CitaServlet), en cualquier
    propiedad.

    Atributos que espera en el request:
      citas          List<Cita>   (puede ir vacía)
      errorConsulta  String       (opcional; solo si el DAO falló)
--%>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Mis citas — Inmobiliaria</title>

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

<main class="container my-5" style="max-width: 780px;">

    <h1 class="fuente-display mb-1">Mis citas</h1>
    <p class="mb-4" style="color: var(--gris);">
        <c:choose>
            <c:when test="${empty citas}">Todavía no has agendado ninguna visita.</c:when>
            <c:otherwise>${citas.size()} visita(s) agendada(s).</c:otherwise>
        </c:choose>
    </p>

    <c:if test="${not empty errorConsulta}">
        <div class="alert alert-warning" role="alert">${errorConsulta}</div>
    </c:if>

    <c:if test="${empty citas and empty errorConsulta}">
        <div class="sin-resultados">
            <p class="mb-3">Agenda una visita desde la ficha de cualquier propiedad.</p>
            <a class="btn btn-marca" href="${pageContext.request.contextPath}/propiedades">Ver el catálogo</a>
        </div>
    </c:if>

    <div class="d-flex flex-column gap-3">
        <c:forEach var="cita" items="${citas}">
            <a class="text-decoration-none" style="color: inherit;"
               href="${pageContext.request.contextPath}/propiedades/detalle?id=${cita.propiedadId}">
                <div class="tarjeta-prop p-3">
                    <div class="d-flex justify-content-between align-items-start flex-wrap gap-2">
                        <div>
                            <p class="direccion mb-1">${cita.propiedadTitulo}</p>
                            <p class="mb-1" style="color: var(--gris); font-size: 0.9rem;">${cita.propiedadCodigo}</p>
                            <p class="fw-bold mb-0">${cita.fechaHoraFormateada}</p>
                        </div>
                        <span class="badge rounded-pill"
                              style="background-color: var(--verde-suave); color: var(--verde-hover); font-weight: 600; padding: 0.4rem 0.8rem;">
                            ${cita.estado.etiqueta}
                        </span>
                    </div>
                </div>
            </a>
        </c:forEach>
    </div>

</main>

<%@ include file="/WEB-INF/includes/footer.jspf" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>

</body>
</html>
