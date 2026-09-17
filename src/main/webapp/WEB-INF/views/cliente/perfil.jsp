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

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Mi perfil — Inmobiliaria</title>

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
          href="${pageContext.request.contextPath}/css/estilos.css?v=perfil-final-1">
</head>

<body>

<%@ include file="/WEB-INF/includes/navbar.jspf" %>

<main class="perfil-cliente-page">

    <div class="container">

        <div class="perfil-cliente-cabecera">

            <div>

                <span class="perfil-cliente-kicker">
                    <span></span>
                    CUENTA PERSONAL
                </span>

                <h1 class="fuente-display">
                    Mi perfil
                </h1>

                <p>
                    Mantén tus datos al día para agilizar tus solicitudes.
                </p>

            </div>

            <a href="${pageContext.request.contextPath}/cliente/dashboard"
               class="perfil-volver">

                <i class="bi bi-arrow-left"
                   aria-hidden="true"></i>

                Volver al panel
            </a>

        </div>

        <div class="perfil-cliente-layout">

            <aside class="perfil-resumen">

                <div class="perfil-resumen-superior">

                    <span class="perfil-avatar"
                          aria-hidden="true">

                        <i class="bi bi-person"></i>
                    </span>

                    <span class="perfil-resumen-tag">
                        CLIENTE
                    </span>

                </div>

                <h2>
                    Tu información,
                    <span>siempre organizada.</span>
                </h2>

                <p class="perfil-resumen-texto">
                    Estos datos se utilizan para identificarte y facilitar
                    la gestión de tus solicitudes dentro de la plataforma.
                </p>

                <div class="perfil-resumen-lista">

                    <div>

                        <span>
                            <i class="bi bi-person-check"
                               aria-hidden="true"></i>
                        </span>

                        <div>
                            <strong>Información personal</strong>
                            <small>Nombres y apellidos</small>
                        </div>

                    </div>

                    <div>

                        <span>
                            <i class="bi bi-card-text"
                               aria-hidden="true"></i>
                        </span>

                        <div>
                            <strong>Identificación</strong>
                            <small>Documento y datos de contacto</small>
                        </div>

                    </div>

                    <div>

                        <span>
                            <i class="bi bi-geo-alt"
                               aria-hidden="true"></i>
                        </span>

                        <div>
                            <strong>Ubicación</strong>
                            <small>Dirección de contacto</small>
                        </div>

                    </div>

                </div>

                <div class="perfil-resumen-pie">

                    <i class="bi bi-shield-check"
                       aria-hidden="true"></i>

                    Información asociada a tu cuenta
                </div>

                <div class="perfil-resumen-plano"
                     aria-hidden="true">

                    <span></span>
                    <span></span>
                    <span></span>

                </div>

            </aside>

            <section class="perfil-formulario-card">

                <div class="perfil-formulario-cabecera">

                    <div class="perfil-formulario-icono"
                         aria-hidden="true">

                        <i class="bi bi-person-gear"></i>

                    </div>

                    <div>

                        <span>DATOS DE LA CUENTA</span>

                        <h2>Información personal</h2>

                        <p>
                            Los campos marcados con
                            <strong>*</strong>
                            son obligatorios.
                        </p>

                    </div>

                </div>

                <% if ("true".equals(request.getParameter("actualizado"))) { %>

                    <div class="alert alert-success perfil-alerta"
                         role="alert">

                        <i class="bi bi-check-circle"
                           aria-hidden="true"></i>

                        <span>
                            Perfil actualizado correctamente.
                        </span>

                    </div>

                <% } %>

                <% if (request.getAttribute("error") != null) { %>

                    <div class="alert alert-danger perfil-alerta"
                         role="alert">

                        <i class="bi bi-exclamation-circle"
                           aria-hidden="true"></i>

                        <span>
                            <%= request.getAttribute("error") %>
                        </span>

                    </div>

                <% } %>

                <form method="post"
                      action="${pageContext.request.contextPath}/cliente/perfil"
                      class="perfil-formulario">

                    <div class="perfil-form-grid">

                        <div class="perfil-campo">

                            <label class="form-label"
                                   for="nombres">

                                Nombres
                                <span class="obligatorio">*</span>

                            </label>

                            <div class="perfil-input">

                                <span aria-hidden="true">
                                    <i class="bi bi-person"></i>
                                </span>

                                <input type="text"
                                       id="nombres"
                                       name="nombres"
                                       class="form-control"
                                       autocomplete="given-name"
                                       value="<%= perfil != null ? perfil.getNombres() : "" %>"
                                       required>

                            </div>

                        </div>

                        <div class="perfil-campo">

                            <label class="form-label"
                                   for="apellidos">

                                Apellidos
                                <span class="obligatorio">*</span>

                            </label>

                            <div class="perfil-input">

                                <span aria-hidden="true">
                                    <i class="bi bi-person"></i>
                                </span>

                                <input type="text"
                                       id="apellidos"
                                       name="apellidos"
                                       class="form-control"
                                       autocomplete="family-name"
                                       value="<%= perfil != null ? perfil.getApellidos() : "" %>"
                                       required>

                            </div>

                        </div>

                        <div class="perfil-campo">

                            <label class="form-label"
                                   for="documento">

                                Documento

                            </label>

                            <div class="perfil-input">

                                <span aria-hidden="true">
                                    <i class="bi bi-card-text"></i>
                                </span>

                                <input type="text"
                                       id="documento"
                                       name="documento"
                                       class="form-control"
                                       value="<%= perfil != null && perfil.getDocumento() != null ? perfil.getDocumento() : "" %>">

                            </div>

                            <p class="perfil-ayuda">
                                Número de cédula, sin puntos ni espacios.
                            </p>

                        </div>

                        <div class="perfil-campo">

                            <label class="form-label"
                                   for="telefono">

                                Teléfono

                            </label>

                            <div class="perfil-input">

                                <span aria-hidden="true">
                                    <i class="bi bi-telephone"></i>
                                </span>

                                <input type="text"
                                       id="telefono"
                                       name="telefono"
                                       class="form-control"
                                       autocomplete="tel"
                                       value="<%= perfil != null && perfil.getTelefono() != null ? perfil.getTelefono() : "" %>">

                            </div>

                        </div>

                    </div>

                    <div class="perfil-divisor">

                        <span></span>

                        <small>
                            INFORMACIÓN COMPLEMENTARIA
                        </small>

                        <span></span>

                    </div>

                    <div class="perfil-campo mb-3">

                        <label class="form-label"
                               for="direccion">

                            Dirección

                        </label>

                        <div class="perfil-input">

                            <span aria-hidden="true">
                                <i class="bi bi-geo-alt"></i>
                            </span>

                            <input type="text"
                                   id="direccion"
                                   name="direccion"
                                   class="form-control"
                                   autocomplete="street-address"
                                   value="<%= perfil != null && perfil.getDireccion() != null ? perfil.getDireccion() : "" %>">

                        </div>

                    </div>

                    <div class="perfil-campo">

                        <label class="form-label"
                               for="foto">

                            Foto de perfil

                        </label>

                        <div class="perfil-input">

                            <span aria-hidden="true">
                                <i class="bi bi-image"></i>
                            </span>

                            <input type="text"
                                   id="foto"
                                   name="foto"
                                   class="form-control"
                                   placeholder="https://..."
                                   value="<%= perfil != null && perfil.getFoto() != null ? perfil.getFoto() : "" %>">

                        </div>

                        <p class="perfil-ayuda">
                            Pega la dirección web de una imagen.
                        </p>

                    </div>

                    <div class="perfil-acciones">

                        <a href="${pageContext.request.contextPath}/cliente/dashboard"
                           class="btn perfil-cancelar">

                            Cancelar

                        </a>

                        <button type="submit"
                                class="btn perfil-guardar">

                            <i class="bi bi-check2"
                               aria-hidden="true"></i>

                            Guardar cambios

                        </button>

                    </div>

                </form>

            </section>

        </div>

    </div>

</main>

<%@ include file="/WEB-INF/includes/footer.jspf" %>

</body>
</html>
