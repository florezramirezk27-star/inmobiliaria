<%@ page contentType="text/html;charset=UTF-8" language="java" %>

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

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Mis favoritos</title>

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

</head>

<body>

<div class="container py-5">

    <h1 class="mb-4">
        Mis favoritos
    </h1>

    <a
        href="${pageContext.request.contextPath}/cliente/dashboard"
        class="btn btn-contorno mb-4">

        Volver al panel

    </a>

    <% if (favoritos == null || favoritos.isEmpty()) { %>

        <div class="alert alert-info">
            No tienes propiedades favoritas todavía.
        </div>

    <% } else { %>

        <div class="row">

            <% for (Favorito favorito : favoritos) { %>

                <div class="col-md-4 mb-4">

                    <div class="card shadow-sm">

                        <div class="card-body">

                            <h5 class="card-title">
                                Propiedad #<%= favorito.getIdPropiedad() %>
                            </h5>

                            <p class="card-text">
                                Agregada:
                                <%= favorito.getFecha() %>
                            </p>

                            <form
                                method="post"
                                action="${pageContext.request.contextPath}/propiedades/favorito">

                                <input
                                    type="hidden"
                                    name="propiedadId"
                                    value="<%= favorito.getIdPropiedad() %>">

                                <input
                                    type="hidden"
                                    name="volver"
                                    value="${pageContext.request.contextPath}/cliente/favoritos">

                                <button
                                    type="submit"
                                    class="btn btn-danger">

                                    Eliminar

                                </button>

                            </form>

                        </div>

                    </div>

                </div>

            <% } %>

        </div>

    <% } %>

</div>

</body>

</html>