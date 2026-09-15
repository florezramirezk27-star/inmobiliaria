<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Documentos de la solicitud — Inmobiliaria</title>

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

<main class="container my-5" style="max-width: 850px;">

    <div class="cabecera-seccion mb-4">
        <div>
            <h1 class="fuente-display mb-1">Documentos de la solicitud</h1>
            <p class="descripcion mb-0">Solicitud #${solicitudId}</p>
        </div>
        <a href="${pageContext.request.contextPath}/inmobiliaria/solicitudes" class="btn btn-volver">
            <i class="bi bi-arrow-left me-1" aria-hidden="true"></i>
            Volver a solicitudes
        </a>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger" role="alert">
            ${error}
        </div>
    </c:if>

    <div class="card shadow-sm">

        <div class="card-body">

            <h5 class="card-title mb-3">
                <i class="bi bi-folder2-open me-2" aria-hidden="true"></i>
                Documentos adjuntos por el cliente
            </h5>

            <p class="text-muted small">
                Descarga aquí los documentos que el cliente adjuntó a la solicitud
                de una propiedad de tu inmobiliaria.
            </p>

            <c:choose>

                <c:when test="${empty documentos}">

                    <div class="alert alert-info mb-0" role="alert">
                        Esta solicitud todavía no tiene documentos adjuntos.
                    </div>

                </c:when>

                <c:otherwise>

                    <div class="list-group">

                        <c:forEach var="documento" items="${documentos}">

                            <div class="list-group-item d-flex justify-content-between
                                        align-items-center flex-wrap gap-2">

                                <div>
                                    <strong>
                                        <i class="bi bi-file-earmark-text me-1" aria-hidden="true"></i>
                                        ${documento.nombreArchivo}
                                    </strong>
                                    <small class="d-block text-muted">
                                        Subido: ${documento.subidoEn}
                                    </small>
                                </div>

                                <a href="${pageContext.request.contextPath}/inmobiliaria/solicitudes/documentos?id=${documento.id}"
                                   class="btn btn-marca btn-sm">
                                    <i class="bi bi-download me-1" aria-hidden="true"></i>
                                    Descargar
                                </a>

                            </div>

                        </c:forEach>

                    </div>

                </c:otherwise>

            </c:choose>

        </div>

    </div>

</main>

<%@ include file="/WEB-INF/includes/footer.jspf" %>

</body>
</html>