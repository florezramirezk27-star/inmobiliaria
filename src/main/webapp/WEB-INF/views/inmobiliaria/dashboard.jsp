<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1">

    <title>Panel del Agente</title>

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
        AGENTE
    </span>

    <h1 class="fuente-display mt-3">
        Panel del Agente
    </h1>

    <p class="medida">
        Gestiona las propiedades y solicitudes de tu inmobiliaria.
    </p>

    <div class="row g-4 mt-3">

        <div class="col-md-6 col-lg-4">

            <div class="tarjeta-prop p-4">

                <h2 class="h5">
                    Gestionar solicitudes
                </h2>

                <p>
                    Consulta y gestiona las solicitudes
                    de tus propiedades.
                </p>

                <a href="${pageContext.request.contextPath}/inmobiliaria/solicitudes"
                   class="btn btn-marca">
                    Ver solicitudes
                </a>

            </div>

        </div>

        <div class="col-md-6 col-lg-4">

            <div class="tarjeta-prop p-4">

                <h2 class="h5">
                    Publicar propiedad
                </h2>

                <p>
                    Registra una nueva propiedad.
                </p>

                <a href="${pageContext.request.contextPath}/inmobiliaria/propiedades/formulario"
                   class="btn btn-marca">
                    Publicar propiedad
                </a>

            </div>

        </div>

        <div class="col-md-6 col-lg-4">

            <div class="tarjeta-prop p-4">

                <h2 class="h5">
                    Cerrar sesión
                </h2>

                <p>
                    Finaliza tu sesión actual.
                </p>

                <a href="${pageContext.request.contextPath}/logout"
                   class="btn btn-contorno">
                    Cerrar sesión
                </a>

            </div>

        </div>

    </div>

</main>

<%@ include file="/WEB-INF/includes/footer.jspf" %>

</body>
</html>