<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="Busca casas y apartamentos en arriendo o venta en Bucaramanga y su área metropolitana.">

    <title>Inmobiliaria — Casas y apartamentos en Bucaramanga</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Bricolage+Grotesque:opsz,wght@12..96,400..800&family=Karla:wght@400;500;600;700&display=swap"
          rel="stylesheet">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
          crossorigin="anonymous">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
</head>

<body>

<%-- Iconos en línea, sin dependencias externas --%>
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
</svg>

<%@ include file="/WEB-INF/includes/navbar.jspf" %>

<!-- ============================================================
     Hero
     ============================================================ -->
<header class="hero">
    <div class="container">
        <h1 class="fuente-display">Encuentra dónde vivir en Bucaramanga</h1>
        <p>
            Apartamentos, casas y locales publicados por propietarios y agentes verificados
            en el área metropolitana.
        </p>
    </div>
</header>

<!-- ============================================================
     Buscador — superpuesto sobre el borde inferior del hero.
     Sprint 2: apuntar el action a PropiedadServlet y conservar los
     valores enviados con ${param.xxx}.
     ============================================================ -->
<section class="container" aria-labelledby="titulo-buscador">
    <h2 id="titulo-buscador" class="visually-hidden">Buscar propiedades</h2>

    <form class="buscador" action="${pageContext.request.contextPath}/propiedades" method="get">

        <div class="operacion btn-group mb-3" role="group" aria-label="Tipo de operación">
            <input type="radio" class="btn-check" name="operacion" id="op-arriendo" value="arriendo" checked>
            <label class="btn" for="op-arriendo">Arriendo</label>

            <input type="radio" class="btn-check" name="operacion" id="op-venta" value="venta">
            <label class="btn" for="op-venta">Venta</label>
        </div>

        <div class="row g-3 align-items-end">

            <div class="col-12 col-md-4">
                <label class="form-label" for="ciudad">Ciudad</label>
                <select class="form-select" id="ciudad" name="ciudad">
                    <option value="">Todas</option>
                    <option value="bucaramanga">Bucaramanga</option>
                    <option value="floridablanca">Floridablanca</option>
                    <option value="giron">Girón</option>
                    <option value="piedecuesta">Piedecuesta</option>
                </select>
            </div>

            <div class="col-12 col-md-3">
                <label class="form-label" for="tipo">Tipo de inmueble</label>
                <select class="form-select" id="tipo" name="tipo">
                    <option value="">Todos</option>
                    <option value="apartamento">Apartamento</option>
                    <option value="casa">Casa</option>
                    <option value="local">Local comercial</option>
                    <option value="lote">Lote</option>
                </select>
            </div>

            <div class="col-12 col-md-3">
                <label class="form-label" for="precioMax">Precio máximo</label>
                <input type="number" class="form-control" id="precioMax" name="precioMax"
                       min="0" step="100000" placeholder="Sin límite">
            </div>

            <div class="col-12 col-md-2 d-grid">
                <button type="submit" class="btn btn-marca">Buscar</button>
            </div>

        </div>
    </form>
</section>

<!-- ============================================================
     Catálogo
     Sprint 2: reemplazar las tarjetas fijas por
     <c:forEach var="p" items="${propiedades}"> ... </c:forEach>
     con los datos que envíe PropiedadServlet.
     ============================================================ -->
<main class="container my-5 pt-4" id="catalogo">

    <div class="d-flex flex-wrap justify-content-between align-items-end gap-2 mb-4">
        <h2 class="fuente-display mb-0">Publicaciones recientes</h2>
        <a href="${pageContext.request.contextPath}/propiedades">Ver todas las propiedades</a>
    </div>

    <div class="row g-4">

        <!-- Tarjeta 1 -->
        <div class="col-12 col-sm-6 col-lg-4">
            <article class="tarjeta-prop">
                <div class="foto-prop">
                    <span class="etiqueta-operacion">Arriendo</span>
                </div>
                <div class="cuerpo-tarjeta">
                    <p class="precio">$ 1.850.000 <span class="periodo">/ mes</span></p>
                    <p class="direccion">Apartamento en Cabecera del Llano</p>
                    <p class="barrio">Bucaramanga, Santander</p>
                    <div class="fichas">
                        <span class="ficha"><svg><use href="#ico-habitacion"/></svg>3 hab</span>
                        <span class="ficha"><svg><use href="#ico-bano"/></svg>2 baños</span>
                        <span class="ficha"><svg><use href="#ico-area"/></svg>92 m²</span>
                    </div>
                </div>
            </article>
        </div>

        <!-- Tarjeta 2 -->
        <div class="col-12 col-sm-6 col-lg-4">
            <article class="tarjeta-prop">
                <div class="foto-prop">
                    <span class="etiqueta-operacion">Venta</span>
                </div>
                <div class="cuerpo-tarjeta">
                    <p class="precio">$ 420.000.000</p>
                    <p class="direccion">Casa en Cañaveral</p>
                    <p class="barrio">Floridablanca, Santander</p>
                    <div class="fichas">
                        <span class="ficha"><svg><use href="#ico-habitacion"/></svg>4 hab</span>
                        <span class="ficha"><svg><use href="#ico-bano"/></svg>3 baños</span>
                        <span class="ficha"><svg><use href="#ico-area"/></svg>168 m²</span>
                    </div>
                </div>
            </article>
        </div>

        <!-- Tarjeta 3 -->
        <div class="col-12 col-sm-6 col-lg-4">
            <article class="tarjeta-prop">
                <div class="foto-prop">
                    <span class="etiqueta-operacion">Arriendo</span>
                </div>
                <div class="cuerpo-tarjeta">
                    <p class="precio">$ 1.150.000 <span class="periodo">/ mes</span></p>
                    <p class="direccion">Apartaestudio en Provenza</p>
                    <p class="barrio">Bucaramanga, Santander</p>
                    <div class="fichas">
                        <span class="ficha"><svg><use href="#ico-habitacion"/></svg>1 hab</span>
                        <span class="ficha"><svg><use href="#ico-bano"/></svg>1 baño</span>
                        <span class="ficha"><svg><use href="#ico-area"/></svg>45 m²</span>
                    </div>
                </div>
            </article>
        </div>

        <!-- Tarjeta 4 -->
        <div class="col-12 col-sm-6 col-lg-4">
            <article class="tarjeta-prop">
                <div class="foto-prop">
                    <span class="etiqueta-operacion">Venta</span>
                </div>
                <div class="cuerpo-tarjeta">
                    <p class="precio">$ 295.000.000</p>
                    <p class="direccion">Apartamento en Real de Minas</p>
                    <p class="barrio">Bucaramanga, Santander</p>
                    <div class="fichas">
                        <span class="ficha"><svg><use href="#ico-habitacion"/></svg>3 hab</span>
                        <span class="ficha"><svg><use href="#ico-bano"/></svg>2 baños</span>
                        <span class="ficha"><svg><use href="#ico-area"/></svg>78 m²</span>
                    </div>
                </div>
            </article>
        </div>

        <!-- Tarjeta 5 -->
        <div class="col-12 col-sm-6 col-lg-4">
            <article class="tarjeta-prop">
                <div class="foto-prop">
                    <span class="etiqueta-operacion">Arriendo</span>
                </div>
                <div class="cuerpo-tarjeta">
                    <p class="precio">$ 3.200.000 <span class="periodo">/ mes</span></p>
                    <p class="direccion">Local comercial en Sotomayor</p>
                    <p class="barrio">Bucaramanga, Santander</p>
                    <div class="fichas">
                        <span class="ficha"><svg><use href="#ico-bano"/></svg>1 baño</span>
                        <span class="ficha"><svg><use href="#ico-area"/></svg>120 m²</span>
                    </div>
                </div>
            </article>
        </div>

        <!-- Tarjeta 6 -->
        <div class="col-12 col-sm-6 col-lg-4">
            <article class="tarjeta-prop">
                <div class="foto-prop">
                    <span class="etiqueta-operacion">Venta</span>
                </div>
                <div class="cuerpo-tarjeta">
                    <p class="precio">$ 610.000.000</p>
                    <p class="direccion">Casa campestre en Ruitoque</p>
                    <p class="barrio">Girón, Santander</p>
                    <div class="fichas">
                        <span class="ficha"><svg><use href="#ico-habitacion"/></svg>5 hab</span>
                        <span class="ficha"><svg><use href="#ico-bano"/></svg>4 baños</span>
                        <span class="ficha"><svg><use href="#ico-area"/></svg>240 m²</span>
                    </div>
                </div>
            </article>
        </div>

    </div>

    <%-- Estado vacío listo para el Sprint 2:
    <c:if test="${empty propiedades}">
        <div class="sin-resultados">
            <p class="mb-3">No hay propiedades publicadas todavía.</p>
            <a class="btn btn-marca" href="${pageContext.request.contextPath}/propiedades/nueva">Publicar la primera</a>
        </div>
    </c:if>
    --%>

</main>

<%@ include file="/WEB-INF/includes/footer.jspf" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>

</body>
</html>
