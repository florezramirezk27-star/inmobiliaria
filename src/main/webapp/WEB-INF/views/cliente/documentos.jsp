<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1">

    <title>Documentos - Inmobiliaria</title>

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/estilos.css">

</head>

<body>

<%@ include file="/WEB-INF/includes/navbar.jspf" %>

<main class="container my-5"
      style="max-width: 850px;">

    <div class="d-flex justify-content-between align-items-center mb-4">

        <div>

            <h1 class="fuente-display">
                Documentos
            </h1>

            <p class="text-muted mb-0">
                Solicitud #${solicitudId}
            </p>

        </div>

        <a href="${pageContext.request.contextPath}/cliente/solicitudes"
           class="btn btn-contorno">
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

    <div class="card shadow-sm mb-4">

        <div class="card-body">

            <h5 class="card-title">
                Subir documento
            </h5>

            <p class="text-muted">
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

    </div>


    <!-- DOCUMENTOS EXISTENTES -->

    <div class="card shadow-sm">

        <div class="card-body">

            <h5 class="card-title mb-4">
                Documentos adjuntos
            </h5>

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
                                   class="btn btn-sm btn-primary">

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