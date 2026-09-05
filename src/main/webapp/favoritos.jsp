<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%--
    favoritos.jsp — "Mis favoritos".

    No se accede directamente: FavoritoServlet (GET /favoritos) hace
    el forward aquí. Reutiliza la misma tarjeta y el mismo botón de
    favorito que catalogo.jsp, para que quitar un favorito desde esta
    página funcione exactamente igual (POST a /propiedades/favorito).

    Atributos que espera en el request:
      propiedades   List<Propiedad>       (obligatorio, puede ir vacía)
      favoritosIds  Set<Integer>          (todas coinciden con propiedades,
                                            se pasa para reusar el botón)
      errorConsulta String                (opcional; solo si el DAO falló)
--%>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Mis favoritos — Inmobiliaria</title>

    <link href="https://fonts.googleapis.com/css2?family=Bricolage+Grotesque:opsz,wght@12..96,400..800&family=Karla:wght@400;500;600;700&display=swap"
          rel="stylesheet">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
          crossorigin="anonymous">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
</head>

<body>

<svg xmlns="http://www.w3.org/2000/svg" style="display:none" aria-hidden="true">
    <symbol id="ico-habitacion" viewBox="0 0 24 24" fill="none" stroke="currentColor"
            stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
        <path d="M3 18v-6a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v6"/>
        <path d="M3 18h18M6 10V7a1 1 0 0 1 1-1h10a1 1 0 0 1 1 1v3"/>
    </symbol>
    <symbol id="ico-bano" viewBox="0 0 24 24" fill="none" stroke="currentColor"
            stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
        <path d="M4 12h16v3a4 4 0 0 1-4 4H8a4 4 0 0 1-4-4v-3Z"/>
        <path d="M7 12V6a2 2 0 0 1 4 0"/>
        <path d="M7 19l-1 2M17 19l1 2"/>
    </symbol>
    <symbol id="ico-area" viewBox="0 0 24 24" fill="none" stroke="currentColor"
            stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
        <rect x="4" y="4" width="16" height="16" rx="1.5"/>
        <path d="M8 4v4H4M16 20v-4h4"/>
    </symbol>
    <symbol id="ico-corazon" viewBox="0 0 24 24" stroke-linecap="round" stroke-linejoin="round">
        <path d="M12 20.5s-7-4.35-9.5-8.6C.9 8.9 2.4 5.5 5.9 5.5c2 0 3.4 1.1 4.4 2.5.9-1.4 2.3-2.5 4.4-2.5 3.5 0 5 3.4 3.4 6.4-2.5 4.25-9.1 8.6-9.1 8.6Z"/>
    </symbol>
</svg>

<%@ include file="/WEB-INF/includes/navbar.jspf" %>

<main class="container my-5 pt-4">

    <div class="mb-4">
        <h1 class="fuente-display mb-1">Mis favoritos</h1>
        <p class="mb-0" style="color: var(--gris);">
            <c:choose>
                <c:when test="${empty propiedades}">Todavía no has guardado ninguna propiedad.</c:when>
                <c:otherwise>${propiedades.size()} propiedad(es) guardada(s).</c:otherwise>
            </c:choose>
        </p>
    </div>

    <c:if test="${not empty errorConsulta}">
        <div class="alert alert-warning" role="alert">${errorConsulta}</div>
    </c:if>

    <c:if test="${empty propiedades and empty errorConsulta}">
        <div class="sin-resultados">
            <p class="mb-3">
                Marca el corazón de cualquier propiedad del catálogo para guardarla acá.
            </p>
            <a class="btn btn-marca" href="${pageContext.request.contextPath}/propiedades">Ver el catálogo</a>
        </div>
    </c:if>

    <div class="row g-4">
        <c:forEach var="p" items="${propiedades}">
            <div class="col-12 col-sm-6 col-lg-4">
                <div class="position-relative">

                    <form method="post" class="boton-favorito-form"
                          action="${pageContext.request.contextPath}/propiedades/favorito">
                        <input type="hidden" name="propiedadId" value="${p.id}">
                        <input type="hidden" name="volver"
                               value="${pageContext.request.contextPath}/favoritos">
                        <button type="submit"
                                class="boton-favorito ${favoritosIds.contains(p.id) ? 'activo' : ''}"
                                aria-label="Quitar de favoritos">
                            <svg><use href="#ico-corazon"/></svg>
                        </button>
                    </form>

                    <a class="text-decoration-none" style="color: inherit;"
                       href="${pageContext.request.contextPath}/propiedades/detalle?id=${p.id}">
                    <article class="tarjeta-prop">

                        <c:choose>
                            <c:when test="${p.tienePortada}">
                                <img class="foto-prop" src="${pageContext.request.contextPath}/${p.rutaPortada}"
                                     alt="Foto de ${p.titulo}">
                            </c:when>
                            <c:otherwise>
                                <div class="foto-prop"></div>
                            </c:otherwise>
                        </c:choose>

                        <span class="etiqueta-operacion">${p.operacion.etiqueta}</span>

                        <div class="cuerpo-tarjeta">
                            <p class="precio">
                                <fmt:formatNumber value="${p.precio}" type="currency"
                                                   currencySymbol="$ " groupingUsed="true" maxFractionDigits="0"/>
                                <c:if test="${p.precioMensual}"><span class="periodo">/ mes</span></c:if>
                            </p>
                            <p class="direccion">${p.titulo}</p>
                            <p class="barrio">${p.ubicacionCorta}</p>

                            <div class="fichas">
                                <c:if test="${p.habitaciones > 0}">
                                    <span class="ficha"><svg><use href="#ico-habitacion"/></svg>${p.habitaciones} hab</span>
                                </c:if>
                                <c:if test="${p.banos > 0}">
                                    <span class="ficha"><svg><use href="#ico-bano"/></svg>${p.banos} baños</span>
                                </c:if>
                                <c:if test="${not empty p.areaConstruida}">
                                    <span class="ficha"><svg><use href="#ico-area"/></svg>${p.areaConstruida} m²</span>
                                </c:if>
                            </div>
                        </div>
                    </article>
                    </a>

                </div>
            </div>
        </c:forEach>
    </div>

</main>

<%@ include file="/WEB-INF/includes/footer.jspf" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>

</body>
</html>
