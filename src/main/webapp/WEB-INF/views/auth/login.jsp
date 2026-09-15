<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--
    login.jsp — vista ACTIVA. LoginServlet hace forward aquí.

    NO TOCAR:
      form action = ${contextPath}/login    method = post
      input name = "correo"                 input name = "password"
      request.getAttribute("error")         request.getParameter("registro")
--%>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Iniciar sesión — Inmobiliaria</title>

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

    <%-- Franja de identidad — se oculta en móvil --%>
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
            <h2>Encuentra el lugar para tu próxima historia.</h2>
            <p>
                Casas, apartamentos y locales en Bucaramanga y su área metropolitana,
                con fichas completas y visitas que agendas en línea.
            </p>
        </div>

        <p class="mb-0" style="font-size:.8125rem; color:rgba(255,255,255,.5);">
            Proyecto académico — Programación en Java
        </p>
    </aside>

    <%-- Formulario --%>
    <main class="auth-panel">
        <div class="auth-caja">

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

            <h1>Bienvenido de nuevo</h1>
            <p class="subtitulo">Ingresa a tu cuenta para continuar.</p>

            <% if (request.getParameter("registro") != null) { %>
                <div class="alert alert-success" role="alert">
                    Registro completado. Ya puedes iniciar sesión.
                </div>
            <% } %>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger" role="alert">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/login" method="post">

                <div class="mb-3">
                    <label class="form-label" for="correo">Correo electrónico</label>
                    <input type="email"
                           id="correo"
                           name="correo"
                           class="form-control"
                           autocomplete="email"
                           placeholder="tucorreo@ejemplo.com"
                           required
                           autofocus>
                </div>

                <div class="mb-4">
                    <label class="form-label" for="password">Contraseña</label>
                    <div class="position-relative">
                        <input type="password"
                               id="password"
                               name="password"
                               class="form-control"
                               autocomplete="current-password"
                               style="padding-right: 3rem;"
                               required>
                        <button type="button"
                                id="verClave"
                                class="btn-icon position-absolute"
                                style="top:50%; right:6px; transform:translateY(-50%); width:36px; height:36px; border:none; background:none; color:var(--text-secondary); cursor:pointer;"
                                aria-label="Mostrar u ocultar la contraseña">
                            <i class="bi bi-eye" aria-hidden="true"></i>
                        </button>
                    </div>
                </div>

                <button type="submit" class="btn btn-marca w-100 btn-grande">
                    Iniciar sesión
                </button>

            </form>

            <p class="auth-pie mb-0">
                ¿Aún no tienes una cuenta?
                <a href="${pageContext.request.contextPath}/registro">Crear cuenta</a>
            </p>

        </div>
    </main>

</div>

<script>
    // Mostrar / ocultar contraseña. Si el script falla, el campo
    // sigue funcionando como password normal.
    (function () {
        var boton = document.getElementById('verClave');
        var campo = document.getElementById('password');
        if (!boton || !campo) return;
        boton.addEventListener('click', function () {
            var oculto = campo.type === 'password';
            campo.type = oculto ? 'text' : 'password';
            boton.innerHTML = oculto
                ? '<i class="bi bi-eye-slash" aria-hidden="true"></i>'
                : '<i class="bi bi-eye" aria-hidden="true"></i>';
        });
    })();
</script>

</body>
</html>
