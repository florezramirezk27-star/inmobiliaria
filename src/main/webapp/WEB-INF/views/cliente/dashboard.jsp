<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1">

    <title>Panel del Cliente</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

    <link
        rel="stylesheet"
        href="${pageContext.request.contextPath}/css/estilos.css">

</head>

<body>

<%@ include file="/WEB-INF/includes/navbar.jspf" %>

<main class="container py-5">

    <span class="badge"
          style="background-color: var(--verde-suave);
                 color: var(--verde);">
        CLIENTE
    </span>

    <h1 class="fuente-display mt-3">
        Panel del Cliente
    </h1>

    <p class="medida">
        Gestiona tus propiedades favoritas, citas y solicitudes
        desde un solo lugar.
    </p>

    <div class="row g-4 mt-3">

        <div class="col-md-6 col-lg-4">

            <div class="tarjeta-prop p-4">

                <h2 class="h5">
                    Mi perfil
                </h2>

                <p>
                    Consulta y actualiza tu información personal.
                </p>

                <a href="${pageContext.request.contextPath}/cliente/perfil"
                   class="btn btn-marca">
                    Ver perfil
                </a>

            </div>

        </div>

        <div class="col-md-6 col-lg-4">

            <div class="tarjeta-prop p-4">

                <h2 class="h5">
                    Mis favoritos
                </h2>

                <p>
                    Las propiedades que guardaste para revisar después.
                </p>

                <a href="${pageContext.request.contextPath}/cliente/favoritos"
                   class="btn btn-marca">
                    Ver favoritos
                </a>

            </div>

        </div>

        <div class="col-md-6 col-lg-4">

            <div class="tarjeta-prop p-4">

                <h2 class="h5">
                    Mis citas
                </h2>

                <p>
                    Consulta el estado de tus visitas programadas.
                </p>

                <a href="${pageContext.request.contextPath}/citas"
                   class="btn btn-marca">
                    Ver citas
                </a>

            </div>

        </div>

        <div class="col-md-6 col-lg-4">

            <div class="tarjeta-prop p-4">

                <h2 class="h5">
                    Mis solicitudes
                </h2>

                <p>
                    Tus solicitudes de compra y arriendo con su estado.
                </p>

                <a href="${pageContext.request.contextPath}/cliente/solicitudes"
                   class="btn btn-marca">
                    Ver solicitudes
                </a>

            </div>

        </div>

    </div>

</main>

<%@ include file="/WEB-INF/includes/footer.jspf" %>

</body>
</html>