<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ page import="java.util.List" %>
<%@ page import="com.inmobiliaria.model.Favorito" %>

<%
    List<Favorito> favoritos =
            (List<Favorito>) request.getAttribute("favoritos");
%>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mis favoritos — Inmobiliaria</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
          rel="stylesheet">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
          rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
</head>

<body>

<%@ include file="/WEB-INF/includes/navbar.jspf" %>

<main class="container py-5">

    <div class="cabecera-seccion">
        <div>
            <h1 class="fuente-display mb-1">Mis favoritos</h1>
            <p class="descripcion mb-0">Propiedades que guardaste para revisar después.</p>
        </div>
        <a href="${pageContext.request.contextPath}/cliente/dashboard" class="btn btn-contorno">
            Volver al panel
        </a>
    </div>

    <% if (favoritos == null || favoritos.isEmpty()) { %>

        <div class="sin-resultados">
            <span class="sin-resultados-icono"><i class="bi bi-heart"></i></span>
            <h3>Todavía no tienes propiedades favoritas</h3>
            <p>Explora el catálogo y guarda los inmuebles que más te interesen.</p>
            <a class="btn btn-marca" href="${pageContext.request.contextPath}/propiedades">
                Explorar propiedades
            </a>
        </div>

    <% } else { %>

        <div class="row g-4">

            <% for (Favorito favorito : favoritos) { %>

                <div class="col-12 col-sm-6 col-lg-4">

                    <div class="panel h-100 d-flex flex-column">

                        <span class="chip chip-verde mb-3" style="align-self:flex-start;">
                            Guardada
                        </span>

                        <h3 class="mb-1">
                            Propiedad #<%= favorito.getIdPropiedad() %>
                        </h3>

                        <p class="mb-4" style="color:var(--text-secondary); font-size:.875rem;">
                            <i class="bi bi-calendar3" aria-hidden="true"></i>
                            Agregada el <%= favorito.getFecha() %>
                        </p>

                        <div class="d-grid gap-2 mt-auto">

                            <a class="btn btn-marca"
                               href="${pageContext.request.contextPath}/propiedades/detalle?id=<%= favorito.getIdPropiedad() %>">
                                Ver propiedad
                            </a>

                            <form method="post"
                                  action="${pageContext.request.contextPath}/propiedades/favorito"
                                  class="d-grid">

                                <input type="hidden" name="propiedadId"
                                       value="<%= favorito.getIdPropiedad() %>">

                                <input type="hidden" name="volver"
                                       value="${pageContext.request.contextPath}/cliente/favoritos">

                                <button type="submit" class="btn btn-contorno">
                                    <i class="bi bi-trash" aria-hidden="true"></i> Quitar
                                </button>

                            </form>

                        </div>

                    </div>

                </div>

            <% } %>

        </div>

    <% } %>

</main>

<%@ include file="/WEB-INF/includes/footer.jspf" %>

</body>
</html>
