<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1">

    <title>Nueva solicitud - Inmobiliaria</title>

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/estilos.css">

</head>

<body>

<%@ include file="/WEB-INF/includes/navbar.jspf" %>

<main class="container my-5"
      style="max-width: 750px;">

    <div class="d-flex justify-content-between align-items-center mb-4">

        <h1 class="fuente-display">
            Nueva solicitud
        </h1>

        <a href="${pageContext.request.contextPath}/cliente/solicitudes"
           class="btn btn-contorno">
            Volver
        </a>

    </div>

    <c:if test="${not empty errores}">

        <div class="alert alert-danger">

            <strong>Revisa lo siguiente:</strong>

            <ul class="mb-0">

                <c:forEach var="mensaje"
                           items="${errores}">

                    <li>${mensaje}</li>

                </c:forEach>

            </ul>

        </div>

    </c:if>

    <c:if test="${not empty propiedad}">

        <div class="card shadow-sm mb-4">

            <div class="card-body">

                <h5 class="card-title">
                    ${propiedad.titulo}
                </h5>

                <p class="text-muted mb-0">
                    Código: ${propiedad.codigo}
                </p>

                <p class="mb-0">
                    Propiedad #${propiedad.id}
                </p>

            </div>

        </div>

    </c:if>

    <form method="post"
          action="${pageContext.request.contextPath}/cliente/solicitudes">

        <input type="hidden"
               name="id"
               value="${idPropiedad}">

        <input type="hidden"
               name="idPropiedad"
               value="${idPropiedad}">

        <div class="mb-3">

            <label for="tipo"
                   class="form-label">

                Tipo de solicitud

            </label>

            <select id="tipo"
                    name="tipo"
                    class="form-select"
                    required>

                <option value="">
                    Selecciona una opción
                </option>

                <option value="COMPRA">
                    Compra
                </option>

                <option value="ARRIENDO">
                    Arriendo
                </option>

            </select>

        </div>

        <div class="mb-4">

            <label for="comentario"
                   class="form-label">

                Comentario

            </label>

            <textarea id="comentario"
                      name="comentario"
                      class="form-control"
                      rows="5"
                      maxlength="255"
                      placeholder="Escribe información adicional...">${solicitud.comentario}</textarea>

        </div>

        <button type="submit"
                class="btn btn-marca">

            Crear solicitud

        </button>

    </form>

</main>

<%@ include file="/WEB-INF/includes/footer.jspf" %>

</body>
</html>