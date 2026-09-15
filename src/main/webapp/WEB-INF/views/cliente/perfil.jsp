<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ page import="com.inmobiliaria.model.Perfil" %>

<%
    Perfil perfil = (Perfil) request.getAttribute("perfil");
%>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi perfil — Inmobiliaria</title>

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
            <h1 class="fuente-display mb-1">Mi perfil</h1>
            <p class="descripcion mb-0">Mantén tus datos al día para agilizar tus solicitudes.</p>
        </div>
        <a href="${pageContext.request.contextPath}/cliente/dashboard" class="btn btn-contorno">
            Volver al panel
        </a>
    </div>

    <div class="row">
        <div class="col-12 col-lg-8">

            <% if ("true".equals(request.getParameter("actualizado"))) { %>
                <div class="alert alert-success" role="alert">
                    Perfil actualizado correctamente.
                </div>
            <% } %>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger" role="alert">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <form method="post"
                  action="${pageContext.request.contextPath}/cliente/perfil">

                <div class="panel mb-4">

                    <h3 class="mb-1">Información personal</h3>
                    <p class="mb-4" style="color:var(--text-secondary); font-size:.875rem;">
                        Los campos marcados con <span style="color:var(--danger);">*</span> son obligatorios.
                    </p>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label" for="nombres">
                                Nombres <span class="obligatorio">*</span>
                            </label>
                            <input type="text" id="nombres" name="nombres" class="form-control"
                                   value="<%= perfil != null ? perfil.getNombres() : "" %>" required>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label class="form-label" for="apellidos">
                                Apellidos <span class="obligatorio">*</span>
                            </label>
                            <input type="text" id="apellidos" name="apellidos" class="form-control"
                                   value="<%= perfil != null ? perfil.getApellidos() : "" %>" required>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label" for="documento">Documento</label>
                            <input type="text" id="documento" name="documento" class="form-control"
                                   value="<%= perfil != null && perfil.getDocumento() != null ? perfil.getDocumento() : "" %>">
                            <p class="campo-ayuda mb-0">Número de cédula, sin puntos ni espacios.</p>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label class="form-label" for="telefono">Teléfono</label>
                            <input type="text" id="telefono" name="telefono" class="form-control"
                                   value="<%= perfil != null && perfil.getTelefono() != null ? perfil.getTelefono() : "" %>">
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label" for="direccion">Dirección</label>
                        <input type="text" id="direccion" name="direccion" class="form-control"
                               value="<%= perfil != null && perfil.getDireccion() != null ? perfil.getDireccion() : "" %>">
                    </div>

                    <div class="mb-0">
                        <label class="form-label" for="foto">Foto de perfil</label>
                        <input type="text" id="foto" name="foto" class="form-control"
                               placeholder="https://..."
                               value="<%= perfil != null && perfil.getFoto() != null ? perfil.getFoto() : "" %>">
                        <p class="campo-ayuda mb-0">Pega la dirección web de una imagen.</p>
                    </div>

                </div>

                <div class="d-flex flex-wrap gap-2">
                    <button type="submit" class="btn btn-marca">
                        Guardar cambios
                    </button>
                    <a href="${pageContext.request.contextPath}/cliente/dashboard"
                       class="btn btn-contorno">
                        Cancelar
                    </a>
                </div>

            </form>

        </div>
    </div>

</main>

<%@ include file="/WEB-INF/includes/footer.jspf" %>

</body>
</html>
