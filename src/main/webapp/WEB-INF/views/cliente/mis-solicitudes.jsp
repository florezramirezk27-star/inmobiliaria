<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Mis solicitudes - Inmobiliaria</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/estilos.css?v=cliente-resto-final-1">
</head>

<body class="cliente-resto-page cliente-solicitudes-final">

<%@ include file="/WEB-INF/includes/navbar.jspf" %>

<main class="container my-5">

    <div class="cabecera-seccion">

        <div>
            <h1 class="fuente-display mb-1">Mis solicitudes</h1>
            <p class="descripcion mb-0">Consulta el estado de tus solicitudes de compra y arriendo.</p>
        </div>

        <a href="${pageContext.request.contextPath}/cliente/dashboard"
           class="btn btn-volver">
            Volver al panel
        </a>

    </div>

    <c:if test="${not empty param.creada}">
        <div class="alert alert-success">
            Solicitud creada correctamente.
        </div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">
            ${error}
        </div>
    </c:if>

    <c:if test="${empty solicitudes and empty error}">

        <div class="sin-resultados">
            <h3>Todavía no tienes solicitudes</h3>
            <p class="mb-0">Explora el catálogo y crea tu primera solicitud de compra o arriendo.</p>
            <a href="${pageContext.request.contextPath}/propiedades"
               class="btn btn-marca">
                Ver propiedades
            </a>
        </div>

    </c:if>

    <c:if test="${not empty solicitudes}">

        <div class="row g-4">

            <c:forEach var="solicitud"
                       items="${solicitudes}">

                <div class="col-12 col-lg-6">

                    <div class="panel h-100 d-flex flex-column">

                            <div class="d-flex justify-content-between align-items-start flex-wrap gap-2">

                                <div>

                                    <h3 class="h5 mb-1">
                                        Solicitud #${solicitud.id}
                                    </h3>

                                    <p class="mb-1" style="color: var(--gris); font-size:.9rem;">
                                        Propiedad #${solicitud.propiedadId}
                                    </p>

                                </div>

                                <c:set var="estadoSolicitud" value="${solicitud.estado}"/>
                                <c:choose>
                                    <c:when test="${estadoSolicitud == 'APROBADA'}">
                                        <span class="chip chip-verde">${solicitud.estado.etiqueta}</span>
                                    </c:when>
                                    <c:when test="${estadoSolicitud == 'RECHAZADA'}">
                                        <span class="chip chip-rojo">${solicitud.estado.etiqueta}</span>
                                    </c:when>
                                    <c:when test="${estadoSolicitud == 'EN_REVISION'}">
                                        <span class="chip chip-azul">${solicitud.estado.etiqueta}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="chip chip-ocre">${solicitud.estado.etiqueta}</span>
                                    </c:otherwise>
                                </c:choose>

                            </div>

                            <p class="mb-2 mt-3">

                                <strong>Tipo:</strong>

                                ${solicitud.tipo.etiqueta}

                            </p>

                            <c:if test="${not empty solicitud.comentario}">

                                <p class="mb-2">

                                    <strong>Comentario:</strong>

                                    ${solicitud.comentario}

                                </p>

                            </c:if>

                            <p class="mb-3" style="color: var(--gris); font-size:.9rem;">

                                Creada:
                                ${solicitud.creadoEn}

                            </p>

                            <div class="d-flex gap-2 flex-wrap mt-auto">

                                <a href="${pageContext.request.contextPath}/propiedades/detalle?id=${solicitud.propiedadId}"
                                   class="btn btn-contorno">

                                    Ver propiedad

                                </a>

                                <a href="${pageContext.request.contextPath}/cliente/solicitudes/documentos?solicitudId=${solicitud.id}"
                                   class="btn btn-marca">

                                    Documentos

                                </a>

                            </div>

                    </div>

                </div>

            </c:forEach>

        </div>

    </c:if>

</main>

<%@ include file="/WEB-INF/includes/footer.jspf" %>

</body>
</html>