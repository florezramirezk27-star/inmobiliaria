<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1">

    <title>Panel Administrador</title>

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <link
        rel="stylesheet"
        href="${pageContext.request.contextPath}/css/estilos.css">

</head>

<body>

<%@ include file="/WEB-INF/includes/navbar.jspf" %>

<main class="container py-5">

    <div class="mb-5">

        <span class="badge"
              style="background-color: var(--verde-suave);
                     color: var(--verde);">
            ADMINISTRADOR
        </span>

        <h1 class="fuente-display mt-3">
            Panel del Administrador
        </h1>

        <p class="medida">
            Gestiona usuarios, roles, auditoría y reportes
            del sistema inmobiliario.
        </p>

    </div>

    <div class="row g-4">

        <div class="col-md-6 col-lg-3">

            <div class="tarjeta-prop p-4">

                <h2 class="h5">
                    Usuarios
                </h2>

                <p>
                    Gestiona usuarios, estados y perfiles.
                </p>

                <a href="${pageContext.request.contextPath}/admin/usuarios"
                   class="btn btn-marca">
                    Gestionar usuarios
                </a>

            </div>

        </div>

        <div class="col-md-6 col-lg-3">

            <div class="tarjeta-prop p-4">

                <h2 class="h5">
                    Auditoría
                </h2>

                <p>
                    Consulta las acciones realizadas en el sistema.
                </p>

                <a href="${pageContext.request.contextPath}/admin/auditoria"
                   class="btn btn-marca">
                    Ver auditoría
                </a>

            </div>

        </div>

        <div class="col-md-6 col-lg-3">

            <div class="tarjeta-prop p-4">

                <h2 class="h5">
                    Reportes
                </h2>

                <p>
                    Consulta los cinco reportes SQL del sistema.
                </p>

                <a href="${pageContext.request.contextPath}/admin/reportes"
                   class="btn btn-marca">
                    Ver reportes
                </a>

            </div>

        </div>

        <div class="col-md-6 col-lg-3">

            <div class="tarjeta-prop p-4">

                <h2 class="h5">
                    Citas
                </h2>

                <p>
                    Consulta las citas registradas.
                </p>

                <a href="${pageContext.request.contextPath}/propiedades/citas?id=1"
                   class="btn btn-marca">
                    Consultar citas
                </a>

            </div>

        </div>

    </div>

</main>

<%@ include file="/WEB-INF/includes/footer.jspf" %>

</body>
</html>