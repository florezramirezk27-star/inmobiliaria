<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--
    registro.jsp — vista ACTIVA. RegistroServlet hace forward aquí.

    NO TOCAR:
      form action = ${contextPath}/registro   method = post
      names: nombres, apellidos, correo, password,
             confirmPassword, documento, telefono, direccion
      request.getAttribute("error")

    Cambio funcional menor y deliberado: "documento" lleva ahora
    required en el cliente, porque la columna es NOT NULL UNIQUE
    en la base de datos y sin él el INSERT fallaba.
--%>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Crear cuenta — Inmobiliaria</title>

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

<div class="auth-pantalla">

    <aside class="auth-visual">
        <a class="marca" href="${pageContext.request.contextPath}/">
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                 stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                <path d="M3 10.5 12 3l9 7.5"/>
                <path d="M5 9.5V20a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V9.5"/>
                <path d="M10 21v-6h4v6"/>
            </svg>
            Inmobiliaria
        </a>

        <div>
            <h2>Crea tu cuenta y guarda lo que te interesa.</h2>
            <p>
                Con una cuenta puedes guardar favoritos, agendar visitas
                y radicar solicitudes de compra o arriendo.
            </p>
        </div>

        <p class="mb-0" style="font-size:.8125rem; color:rgba(255,255,255,.5);">
            Proyecto académico — Programación en Java
        </p>
    </aside>

    <main class="auth-panel">
        <div class="auth-caja ancha">

            <a class="d-inline-flex align-items-center gap-2 d-lg-none mb-4"
               href="${pageContext.request.contextPath}/"
               style="font-weight:800; font-size:1.1875rem; color:var(--primary); text-decoration:none;">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#C4A66A"
                     stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                    <path d="M3 10.5 12 3l9 7.5"/>
                    <path d="M5 9.5V20a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V9.5"/>
                    <path d="M10 21v-6h4v6"/>
                </svg>
                Inmobiliaria
            </a>

            <h1>Crear cuenta</h1>
            <p class="subtitulo">Los campos marcados con <span style="color:var(--danger);">*</span> son obligatorios.</p>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger" role="alert">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/registro" method="post">

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label" for="nombres">
                            Nombres <span class="obligatorio">*</span>
                        </label>
                        <input type="text" id="nombres" name="nombres"
                               class="form-control" autocomplete="given-name" required>
                    </div>

                    <div class="col-md-6 mb-3">
                        <label class="form-label" for="apellidos">
                            Apellidos <span class="obligatorio">*</span>
                        </label>
                        <input type="text" id="apellidos" name="apellidos"
                               class="form-control" autocomplete="family-name" required>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label" for="correo">
                        Correo electrónico <span class="obligatorio">*</span>
                    </label>
                    <input type="email" id="correo" name="correo"
                           class="form-control" autocomplete="email"
                           placeholder="tucorreo@ejemplo.com" required>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label" for="password">
                            Contraseña <span class="obligatorio">*</span>
                        </label>
                        <input type="password" id="password" name="password"
                               class="form-control" autocomplete="new-password"
                               minlength="8" required>
                        <p class="campo-ayuda mb-0">Mínimo 8 caracteres.</p>
                    </div>

                    <div class="col-md-6 mb-3">
                        <label class="form-label" for="confirmPassword">
                            Confirmar contraseña <span class="obligatorio">*</span>
                        </label>
                        <input type="password" id="confirmPassword" name="confirmPassword"
                               class="form-control" autocomplete="new-password"
                               minlength="8" required>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label" for="documento">
                            Documento <span class="obligatorio">*</span>
                        </label>
                        <input type="text" id="documento" name="documento"
                               class="form-control" required>
                        <p class="campo-ayuda mb-0">Número de cédula, sin puntos ni espacios.</p>
                    </div>

                    <div class="col-md-6 mb-3">
                        <label class="form-label" for="telefono">Teléfono</label>
                        <input type="text" id="telefono" name="telefono"
                               class="form-control" autocomplete="tel">
                    </div>
                </div>

                <div class="mb-4">
                    <label class="form-label" for="direccion">Dirección</label>
                    <input type="text" id="direccion" name="direccion"
                           class="form-control" autocomplete="street-address">
                </div>

                <button type="submit" class="btn btn-marca w-100 btn-grande">
                    Crear cuenta
                </button>

            </form>

            <p class="auth-pie mb-0">
                ¿Ya tienes una cuenta?
                <a href="${pageContext.request.contextPath}/login">Inicia sesión</a>
            </p>

        </div>
    </main>

</div>

</body>
</html>
