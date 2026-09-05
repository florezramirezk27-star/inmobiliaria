<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%--
    detalle-propiedad.jsp — ficha completa de una propiedad.

    PropiedadDetalleServlet (GET /propiedades/detalle?id=X) hace el
    forward aquí con:
      propiedad        Propiedad         (si se encontró)
      imagenes         List<ImagenPropiedad>
      caracteristicas  List<Caracteristica>  (ya con categoría y cantidad)
      error            String  (si algo falló o el id no existe)
--%>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>
        <c:choose>
            <c:when test="${not empty propiedad}">${propiedad.titulo}</c:when>
            <c:otherwise>Propiedad no encontrada</c:otherwise>
        </c:choose>
        — Inmobiliaria
    </title>

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
    <symbol id="ico-parqueadero" viewBox="0 0 24 24" fill="none" stroke="currentColor"
            stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
        <rect x="3" y="3" width="18" height="18" rx="2"/>
        <path d="M9 16V8h4a3 3 0 0 1 0 6H9"/>
    </symbol>
    <symbol id="ico-corazon" viewBox="0 0 24 24" stroke-linecap="round" stroke-linejoin="round">
        <path d="M12 20.5s-7-4.35-9.5-8.6C.9 8.9 2.4 5.5 5.9 5.5c2 0 3.4 1.1 4.4 2.5.9-1.4 2.3-2.5 4.4-2.5 3.5 0 5 3.4 3.4 6.4-2.5 4.25-9.1 8.6-9.1 8.6Z"/>
    </symbol>
</svg>

<%@ include file="/WEB-INF/includes/navbar.jspf" %>

<main class="container my-5">

    <a href="${pageContext.request.contextPath}/propiedades" class="d-inline-block mb-4"
       style="color: var(--gris); text-decoration: none;">&larr; Volver al catálogo</a>

    <c:if test="${not empty error}">
        <div class="alert alert-warning" role="alert">${error}</div>
    </c:if>

    <c:if test="${not empty propiedad}">

        <%-- ---------- Galería ---------- --%>
        <c:choose>
            <c:when test="${not empty imagenes}">
                <div class="row g-2 mb-4">
                    <div class="col-12 col-md-8">
                        <img src="${pageContext.request.contextPath}/${imagenes[0].ruta}"
                             alt="${imagenes[0].textoAlt}"
                             class="w-100 rounded"
                             style="aspect-ratio: 16/10; object-fit: cover;">
                    </div>
                    <div class="col-12 col-md-4">
                        <div class="row g-2">
                            <c:forEach var="img" items="${imagenes}" varStatus="st" begin="1" end="4">
                                <div class="col-6 col-md-12">
                                    <img src="${pageContext.request.contextPath}/${img.ruta}"
                                         alt="${img.textoAlt}"
                                         class="w-100 rounded"
                                         style="aspect-ratio: 16/10; object-fit: cover;">
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="marcador-detalle mb-4"></div>
            </c:otherwise>
        </c:choose>

        <div class="row g-4">

            <%-- ---------- Columna principal ---------- --%>
            <div class="col-12 col-lg-8">

                <span class="etiqueta-operacion" style="position: static; display: inline-block; margin-bottom: 0.75rem;">
                    ${propiedad.operacion.etiqueta}
                </span>

                <h1 class="fuente-display mb-1">${propiedad.titulo}</h1>
                <p class="mb-3" style="color: var(--gris);">
                    ${propiedad.direccion}<c:if test="${not empty propiedad.barrio}"> — ${propiedad.ubicacionCorta}</c:if>
                </p>

                <div class="fichas mb-4" style="border-top: none; padding-top: 0;">
                    <c:if test="${propiedad.habitaciones > 0}">
                        <span class="ficha"><svg><use href="#ico-habitacion"/></svg>${propiedad.habitaciones} habitaciones</span>
                    </c:if>
                    <c:if test="${propiedad.banos > 0}">
                        <span class="ficha"><svg><use href="#ico-bano"/></svg>${propiedad.banos} baños</span>
                    </c:if>
                    <c:if test="${propiedad.parqueaderos > 0}">
                        <span class="ficha"><svg><use href="#ico-parqueadero"/></svg>${propiedad.parqueaderos} parqueaderos</span>
                    </c:if>
                    <c:if test="${not empty propiedad.areaConstruida}">
                        <span class="ficha"><svg><use href="#ico-area"/></svg>${propiedad.areaConstruida} m² construidos</span>
                    </c:if>
                    <c:if test="${not empty propiedad.areaLote}">
                        <span class="ficha"><svg><use href="#ico-area"/></svg>${propiedad.areaLote} m² de lote</span>
                    </c:if>
                </div>

                <c:if test="${not empty propiedad.descripcion}">
                    <h2 class="h5 mb-2">Descripción</h2>
                    <p class="medida mb-4">${propiedad.descripcion}</p>
                </c:if>

                <%-- ---------- Características agrupadas por categoría ---------- --%>
                <c:if test="${not empty caracteristicas}">
                    <h2 class="h5 mb-3">Características</h2>

                    <c:forEach var="categoria" items="${categoriasCaracteristica}">
                        <c:set var="hayEnCategoria" value="false"/>
                        <c:forEach var="c" items="${caracteristicas}">
                            <c:if test="${c.categoria == categoria}"><c:set var="hayEnCategoria" value="true"/></c:if>
                        </c:forEach>

                        <c:if test="${hayEnCategoria}">
                            <p class="fw-bold mb-2" style="font-size: 0.9rem; color: var(--gris); text-transform: uppercase; letter-spacing: 0.03em;">
                                <c:choose>
                                    <c:when test="${categoria == 'INTERIOR'}">Interior</c:when>
                                    <c:when test="${categoria == 'EXTERIOR'}">Exterior</c:when>
                                    <c:when test="${categoria == 'CONJUNTO'}">Conjunto</c:when>
                                    <c:otherwise>Seguridad</c:otherwise>
                                </c:choose>
                            </p>
                            <div class="d-flex flex-wrap gap-2 mb-3">
                                <c:forEach var="c" items="${caracteristicas}">
                                    <c:if test="${c.categoria == categoria}">
                                        <span class="badge rounded-pill"
                                              style="background-color: var(--verde-suave); color: var(--verde-hover); font-weight: 500; padding: 0.5rem 0.9rem;">
                                            ${c.nombre}<c:if test="${c.cantidad > 1}"> (${c.cantidad})</c:if>
                                        </span>
                                    </c:if>
                                </c:forEach>
                            </div>
                        </c:if>
                    </c:forEach>
                </c:if>

            </div>

            <%-- ---------- Columna lateral: precio y acciones ---------- --%>
            <div class="col-12 col-lg-4">
                <div class="tarjeta-prop p-4">
                    <p class="precio mb-1">
                        <fmt:formatNumber value="${propiedad.precio}" type="currency"
                                           currencySymbol="$ " groupingUsed="true" maxFractionDigits="0"/>
                        <c:if test="${propiedad.precioMensual}"><span class="periodo">/ mes</span></c:if>
                    </p>
                    <c:if test="${not empty propiedad.administracion and propiedad.administracion > 0}">
                        <p class="mb-3" style="color: var(--gris); font-size: 0.9rem;">
                            + <fmt:formatNumber value="${propiedad.administracion}" type="currency"
                                                 currencySymbol="$ " groupingUsed="true" maxFractionDigits="0"/>
                            de administración
                        </p>
                    </c:if>

                    <dl class="row mb-0" style="font-size: 0.92rem;">
                        <dt class="col-6" style="color: var(--gris); font-weight: 500;">Código</dt>
                        <dd class="col-6 text-end">${propiedad.codigo}</dd>

                        <c:if test="${not empty propiedad.estrato}">
                            <dt class="col-6" style="color: var(--gris); font-weight: 500;">Estrato</dt>
                            <dd class="col-6 text-end">${propiedad.estrato}</dd>
                        </c:if>

                        <c:if test="${not empty propiedad.antiguedadAnios}">
                            <dt class="col-6" style="color: var(--gris); font-weight: 500;">Antigüedad</dt>
                            <dd class="col-6 text-end">${propiedad.antiguedadAnios} años</dd>
                        </c:if>
                    </dl>

                    <hr>

                    <div class="d-grid gap-2">
                        <form method="post" class="d-grid"
                              action="${pageContext.request.contextPath}/propiedades/favorito">
                            <input type="hidden" name="propiedadId" value="${propiedad.id}">
                            <input type="hidden" name="volver"
                                   value="${pageContext.request.contextPath}/propiedades/detalle?id=${propiedad.id}">
                            <button type="submit" class="boton-favorito-grande ${esFavorito ? 'activo' : ''}">
                                <svg><use href="#ico-corazon"/></svg>
                                <c:choose>
                                    <c:when test="${esFavorito}">Quitar de favoritos</c:when>
                                    <c:otherwise>Agregar a favoritos</c:otherwise>
                                </c:choose>
                            </button>
                        </form>

                        <a class="btn btn-marca"
                           href="${pageContext.request.contextPath}/propiedades/citas?id=${propiedad.id}">
                            Agendar visita
                        </a>

                        <a class="btn btn-contorno" style="color: var(--tinta); border-color: var(--borde);"
                           href="${pageContext.request.contextPath}/propiedades/formulario?id=${propiedad.id}">
                            Editar propiedad
                        </a>
                    </div>
                </div>
            </div>

        </div>

    </c:if>

</main>

<%@ include file="/WEB-INF/includes/footer.jspf" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>

</body>
</html>
