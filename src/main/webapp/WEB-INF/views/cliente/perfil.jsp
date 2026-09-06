<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="com.inmobiliaria.model.Perfil" %>

<%
    Perfil perfil = (Perfil) request.getAttribute("perfil");
%>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Mi perfil</title>

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

</head>

<body>

<div class="container py-5">

    <div class="row justify-content-center">

        <div class="col-md-8">

            <div class="card shadow">

                <div class="card-body p-4">

                    <h2 class="mb-4">
                        Mi perfil
                    </h2>

                    <% if ("true".equals(request.getParameter("actualizado"))) { %>

                        <div class="alert alert-success">
                            Perfil actualizado correctamente.
                        </div>

                    <% } %>

                    <% if (request.getAttribute("error") != null) { %>

                        <div class="alert alert-danger">
                            <%= request.getAttribute("error") %>
                        </div>

                    <% } %>

                    <form
                        method="post"
                        action="${pageContext.request.contextPath}/cliente/perfil">

                        <div class="row">

                            <div class="col-md-6 mb-3">

                                <label class="form-label">
                                    Nombres
                                </label>

                                <input
                                    type="text"
                                    name="nombres"
                                    class="form-control"
                                    value="<%= perfil != null ? perfil.getNombres() : "" %>"
                                    required>

                            </div>

                            <div class="col-md-6 mb-3">

                                <label class="form-label">
                                    Apellidos
                                </label>

                                <input
                                    type="text"
                                    name="apellidos"
                                    class="form-control"
                                    value="<%= perfil != null ? perfil.getApellidos() : "" %>"
                                    required>

                            </div>

                        </div>

                        <div class="mb-3">

                            <label class="form-label">
                                Documento
                            </label>

                            <input
                                type="text"
                                name="documento"
                                class="form-control"
                                value="<%= perfil != null && perfil.getDocumento() != null ? perfil.getDocumento() : "" %>">

                        </div>

                        <div class="mb-3">

                            <label class="form-label">
                                Teléfono
                            </label>

                            <input
                                type="text"
                                name="telefono"
                                class="form-control"
                                value="<%= perfil != null && perfil.getTelefono() != null ? perfil.getTelefono() : "" %>">

                        </div>

                        <div class="mb-3">

                            <label class="form-label">
                                Dirección
                            </label>

                            <input
                                type="text"
                                name="direccion"
                                class="form-control"
                                value="<%= perfil != null && perfil.getDireccion() != null ? perfil.getDireccion() : "" %>">

                        </div>

                        <div class="mb-3">

                            <label class="form-label">
                                Foto URL
                            </label>

                            <input
                                type="text"
                                name="foto"
                                class="form-control"
                                value="<%= perfil != null && perfil.getFoto() != null ? perfil.getFoto() : "" %>">

                        </div>

                        <button
                            type="submit"
                            class="btn btn-primary">

                            Guardar cambios

                        </button>

                        <a
                            href="${pageContext.request.contextPath}/cliente/dashboard"
                            class="btn btn-secondary">

                            Volver

                        </a>

                    </form>

                </div>

            </div>

        </div>

    </div>

</div>

</body>

</html>