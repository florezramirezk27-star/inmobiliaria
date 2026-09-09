<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1">

    <title>Panel Cliente</title>

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

    <span class="badge"
          style="background-color: var(--verde-suave);
                 color: var(--verde);">
        CLIENTE
    </span>

    <h1 class="fuente-display mt-3">
        Panel del Cliente
    </h1>

    <p class="medida">
        Bienvenido al sistema inmobiliario.
        Desde aquí puedes consultar tus propiedades,
        citas, solicitudes y favoritos.
    </p>

    <div class="row g-4 mt-3">

        <div class="col-md-6 col-lg-3">
            <div class="tarjeta-prop p-4">

                <h2 class="h5">Mi perfil</h2>

                <p>Consulta y actualiza tu información.</p>

                <a href="${pageContext.request.contextPath}/cliente/perfil"
                   class="btn btn-marca">
                    Ver perfil
                </a>

            </div>
        </div>

        <div class="col-md-6 col-lg-3">
            <div class="tarjeta-prop p-4">

                <h2 class="h5">Mis favoritos</h2>

                <p>Consulta las propiedades que guardaste.</p>

                <a href="${pageContext.request.contextPath}/cliente/favoritos"
                   class="btn btn-marca">
                    Ver favoritos
                </a>

            </div>
        </div>

        <div class="col-md-6 col-lg-3">
            <div class="tarjeta-prop p-4">

                <h2 class="h5">Mis citas</h2>

                <p>Consulta tus visitas programadas.</p>

                <a href="${pageContext.request.contextPath}/citas"
                   class="btn btn-marca">
                    Ver citas
                </a>

            </div>
        </div>

        <div class="col-md-6 col-lg-3">
            <div class="tarjeta-prop p-4">

                <h2 class="h5">Mis solicitudes</h2>

                <p>Consulta tus solicitudes de compra y arriendo.</p>

                <a href="${pageContext.request.contextPath}/cliente/solicitudes"
                   class="btn btn-marca">
                    Ver solicitudes
                </a>

            </div>
        </div>

    </div>

</main>

<%@ include file="/WEB-INF/includes/footer.jspf" %>

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

</body>
</html>