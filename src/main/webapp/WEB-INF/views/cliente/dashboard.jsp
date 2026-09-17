<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1">

    <title>Panel del Cliente — Inmobiliaria</title>

    <link rel="preconnect"
          href="https://fonts.googleapis.com">

    <link rel="preconnect"
          href="https://fonts.gstatic.com"
          crossorigin>

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
          rel="stylesheet">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
          rel="stylesheet">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/estilos.css?v=cliente-final-1">
</head>

<body>

<%@ include file="/WEB-INF/includes/navbar.jspf" %>

<main class="cliente-dashboard">

    <section class="container cliente-dashboard-superior">

        <div class="cliente-hero">

            <div class="cliente-hero-copy">

                <span class="cliente-eyebrow">
                    <span></span>
                    PANEL DEL CLIENTE
                </span>

                <h1 class="fuente-display">
                    Tu espacio para gestionar
                    <em>cada paso.</em>
                </h1>

                <p>
                    Organiza tu perfil, propiedades favoritas, visitas y
                    solicitudes desde un mismo lugar.
                </p>

                <a class="cliente-hero-cta"
                   href="${pageContext.request.contextPath}/propiedades">

                    Explorar propiedades

                    <i class="bi bi-arrow-up-right"
                       aria-hidden="true"></i>
                </a>

            </div>

            <div class="cliente-hero-panel"
                 aria-label="Secciones disponibles">

                <div class="cliente-hero-panel-cabecera">

                    <span class="cliente-hero-panel-icono">
                        <i class="bi bi-grid-1x2"
                           aria-hidden="true"></i>
                    </span>

                    <div>
                        <small>Tu espacio personal</small>
                        <strong>4 accesos principales</strong>
                    </div>

                </div>

                <div class="cliente-ruta">

                    <span>01</span>
                    <p>Perfil</p>

                </div>

                <div class="cliente-ruta">

                    <span>02</span>
                    <p>Favoritos</p>

                </div>

                <div class="cliente-ruta">

                    <span>03</span>
                    <p>Citas</p>

                </div>

                <div class="cliente-ruta">

                    <span>04</span>
                    <p>Solicitudes</p>

                </div>

            </div>

            <div class="cliente-plano"
                 aria-hidden="true">

                <div class="cliente-plano-a"></div>
                <div class="cliente-plano-b"></div>
                <div class="cliente-plano-c"></div>
                <div class="cliente-plano-circulo"></div>

            </div>

        </div>

    </section>

    <section class="container cliente-accesos">

        <div class="cliente-seccion-cabecera">

            <div>

                <span class="cliente-seccion-kicker">
                    ACCESOS RÁPIDOS
                </span>

                <h2>¿Qué quieres gestionar?</h2>

                <p>
                    Entra directamente a la sección que necesitas.
                </p>

            </div>

            <a class="cliente-catalogo-link"
               href="${pageContext.request.contextPath}/propiedades">

                Ver catálogo

                <i class="bi bi-arrow-right"
                   aria-hidden="true"></i>
            </a>

        </div>

        <div class="cliente-cards">

            <a class="cliente-card cliente-card-perfil"
               href="${pageContext.request.contextPath}/cliente/perfil">

                <div class="cliente-card-top">

                    <span class="cliente-card-icono">
                        <i class="bi bi-person"
                           aria-hidden="true"></i>
                    </span>

                    <span class="cliente-card-tag">
                        CUENTA
                    </span>

                </div>

                <div class="cliente-card-contenido">

                    <h3>Mi perfil</h3>

                    <p>
                        Consulta y actualiza tu información personal.
                    </p>

                </div>

                <span class="cliente-card-accion">

                    Ver perfil

                    <i class="bi bi-arrow-right"
                       aria-hidden="true"></i>
                </span>

            </a>

            <a class="cliente-card cliente-card-favoritos"
               href="${pageContext.request.contextPath}/cliente/favoritos">

                <div class="cliente-card-top">

                    <span class="cliente-card-icono">
                        <i class="bi bi-heart"
                           aria-hidden="true"></i>
                    </span>

                    <span class="cliente-card-tag">
                        GUARDADOS
                    </span>

                </div>

                <div class="cliente-card-contenido">

                    <h3>Mis favoritos</h3>

                    <p>
                        Revisa las propiedades que guardaste para después.
                    </p>

                </div>

                <span class="cliente-card-accion">

                    Ver favoritos

                    <i class="bi bi-arrow-right"
                       aria-hidden="true"></i>
                </span>

            </a>

            <a class="cliente-card cliente-card-citas"
               href="${pageContext.request.contextPath}/citas">

                <div class="cliente-card-top">

                    <span class="cliente-card-icono">
                        <i class="bi bi-calendar-check"
                           aria-hidden="true"></i>
                    </span>

                    <span class="cliente-card-tag">
                        VISITAS
                    </span>

                </div>

                <div class="cliente-card-contenido">

                    <h3>Mis citas</h3>

                    <p>
                        Consulta el estado de tus visitas programadas.
                    </p>

                </div>

                <span class="cliente-card-accion">

                    Ver citas

                    <i class="bi bi-arrow-right"
                       aria-hidden="true"></i>
                </span>

            </a>

            <a class="cliente-card cliente-card-solicitudes"
               href="${pageContext.request.contextPath}/cliente/solicitudes">

                <div class="cliente-card-top">

                    <span class="cliente-card-icono">
                        <i class="bi bi-file-earmark-text"
                           aria-hidden="true"></i>
                    </span>

                    <span class="cliente-card-tag">
                        TRÁMITES
                    </span>

                </div>

                <div class="cliente-card-contenido">

                    <h3>Mis solicitudes</h3>

                    <p>
                        Consulta tus solicitudes de compra o arriendo y su estado.
                    </p>

                </div>

                <span class="cliente-card-accion">

                    Ver solicitudes

                    <i class="bi bi-arrow-right"
                       aria-hidden="true"></i>
                </span>

            </a>

        </div>

        <div class="cliente-explorar">

            <div class="cliente-explorar-icono"
                 aria-hidden="true">

                <i class="bi bi-buildings"></i>

            </div>

            <div class="cliente-explorar-copy">

                <span>SIGUE EXPLORANDO</span>

                <h2>
                    Encuentra tu próxima propiedad.
                </h2>

                <p>
                    Consulta el catálogo completo y guarda las opciones
                    que más te interesen.
                </p>

            </div>

            <a class="btn btn-marca"
               href="${pageContext.request.contextPath}/propiedades">

                Explorar catálogo

                <i class="bi bi-arrow-up-right"
                   aria-hidden="true"></i>
            </a>

        </div>

    </section>

</main>

<%@ include file="/WEB-INF/includes/footer.jspf" %>

</body>
</html>
