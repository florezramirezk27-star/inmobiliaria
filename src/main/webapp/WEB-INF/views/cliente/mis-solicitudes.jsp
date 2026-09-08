<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Mis solicitudes - Inmobiliaria</title>

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/estilos.css">
</head>

<body>

<%@ include file="/WEB-INF/includes/navbar.jspf" %>

<main class="container my-5">

    <div class="d-flex justify-content-between align-items-center mb-4">

        <div>
            <h1 class="fuente-display">Mis solicitudes</h1>

            <p style="color: var(--gris);">
                Consulta el estado de tus solicitudes de compra y arriendo.
            </p>
        </div>

        <a href="${pageContext.request.contextPath}/cliente/dashboard"
           class="btn btn-contorno">
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

        <div class="alert alert-info">
            Todavía no tienes solicitudes.
        </div>

        <a href="${pageContext.request.contextPath}/propiedades"
           class="btn btn-marca">
            Ver propiedades
        </a>

    </c:if>

    <c:if test="${not empty solicitudes}">

        <div class="row g-4">

            <c:forEach var="solicitud"
                       items="${solicitudes}">

                <div class="col-12 col-lg-6">

                    <div class="card h-100 shadow-sm">

                        <div class="card-body">

                            <div class="d-flex justify-content-between align-items-start">

                                <div>

                                    <h5 class="card-title mb-1">
                                        Solicitud #${solicitud.id}
                                    </h5>

                                    <p class="text-muted mb-3">
                                        Propiedad #${solicitud.propiedadId}
                                    </p>

                                </div>

                                <span class="badge bg-primary">
                                    ${solicitud.estado.etiqueta}
                                </span>

                            </div>

                            <p class="mb-2">

                                <strong>Tipo:</strong>

                                ${solicitud.tipo.etiqueta}

                            </p>

                            <c:if test="${not empty solicitud.comentario}">

                                <p class="mb-2">

                                    <strong>Comentario:</strong>

                                    ${solicitud.comentario}

                                </p>

                            </c:if>

                            <p class="text-muted mb-3">

                                Creada:
                                ${solicitud.creadoEn}

                            </p>

                            <div class="d-flex gap-2 flex-wrap">

                                <a href="${pageContext.request.contextPath}/propiedades/detalle?id=${solicitud.propiedadId}"
                                   class="btn btn-outline-primary">

                                    Ver propiedad

                                </a>

                                <a href="${pageContext.request.contextPath}/cliente/solicitudes/documentos?solicitudId=${solicitud.id}"
                                   class="btn btn-primary">

                                    Documentos

                                </a>

                            </div>

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