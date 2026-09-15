<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1">

    <title>Documentos - Inmobiliaria</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/estilos.css">

</head>

<body>

<%@ include file="/WEB-INF/includes/navbar.jspf" %>

<main class="container my-5"
      style="max-width: 850px;">

    <div class="cabecera-seccion">

        <div>

            <h1 class="fuente-display mb-1">
                Documentos
            </h1>

            <p class="descripcion mb-0">
                Solicitud #${solicitudId}
            </p>

        </div>

        <a href="${pageContext.request.contextPath}/cliente/solicitudes"
           class="btn btn-volver">
            Mis solicitudes
        </a>

    </div>

    <c:if test="${param.subido == '1'}">

        <div class="alert alert-success">
            Documento subido correctamente.
        </div>

    </c:if>

    <c:if test="${not empty error}">

        <div class="alert alert-danger">
            ${error}
        </div>

    </c:if>


    <!-- SUBIR DOCUMENTO -->

    <div class="panel mb-4">

            <h3 class="h5 mb-1">
                Subir documento
            </h3>

            <p class="mb-4" style="color: var(--gris); font-size:.9rem;">
                Formatos permitidos: PDF, JPG, PNG, DOC y DOCX.
                Máximo 10 MB.
            </p>

            <form method="post"
                  enctype="multipart/form-data"
                  action="${pageContext.request.contextPath}/cliente/solicitudes/documentos">

                <input type="hidden"
                       name="solicitudId"
                       value="${solicitudId}">

                <div class="mb-3">

                    <input type="file"
                           name="archivo"
                           class="form-control"
                           accept=".pdf,.jpg,.jpeg,.png,.doc,.docx"
                           required>

                </div>

                <button type="submit"
                        class="btn btn-marca">

                    Subir documento

                </button>

            </form>

    </div>


    <!-- DOCUMENTOS EXISTENTES -->

    <div class="panel">

            <h3 class="h5 mb-4">
                Documentos adjuntos
            </h3>

            <c:choose>

                <c:when test="${empty documentos}">

                    <div class="alert alert-info mb-0">

                        Esta solicitud todavía no tiene documentos.

                    </div>

                </c:when>

                <c:otherwise>

                    <div class="list-group">

                        <c:forEach var="documento"
                                   items="${documentos}">

                            <div class="list-group-item
                                        d-flex
                                        justify-content-between
                                        align-items-center
                                        flex-wrap
                                        gap-2">

                                <div>

                                    <strong>
                                        ${documento.nombreArchivo}
                                    </strong>

                                    <small class="d-block text-muted">

                                        Subido:
                                        ${documento.subidoEn}

                                    </small>

                                </div>

                                <a href="${pageContext.request.contextPath}/cliente/solicitudes/documentos?id=${documento.id}"
                                   class="btn btn-sm btn-marca">

                                    Descargar

                                </a>

                            </div>

                        </c:forEach>

                    </div>

                </c:otherwise>

            </c:choose>

    </div>

</main>

<%@ include file="/WEB-INF/includes/footer.jspf" %>

</body>
</html>