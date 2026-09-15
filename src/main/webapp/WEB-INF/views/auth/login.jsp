<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--
    login.jsp — vista ACTIVA. LoginServlet hace forward aquí.

    Contrato (NO CAMBIAR):
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

    <style>
        .auth-fondo {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 1.5rem;
            background-color: #F0F4F1;
            background-image:
                radial-gradient(circle at 12% 20%, rgba(196,166,106,.28), transparent 30%),
                radial-gradient(circle at 88% 16%, rgba(47,118,100,.20), transparent 34%),
                radial-gradient(circle at 78% 88%, rgba(18,55,42,.14), transparent 36%);
        }

        .auth-tarjeta {
            width: 100%;
            max-width: 440px;
            background-color: #FFFFFF;
            border: 1px solid #E2E5E1;
            border-radius: 1.15rem;
            overflow: hidden;
            box-shadow: 0 26px 60px -32px rgba(18,55,42,.5);
        }

        .auth-cabecera {
            padding: 2rem 2rem 1.4rem;
            color: #FFFFFF;
            background: linear-gradient(135deg, #12372A 0%, #2F7664 100%);
        }
        .auth-cabecera .marca {
            display: inline-flex;
            align-items: center;
            gap: .5rem;
            font-size: 1.0625rem;
            font-weight: 800;
            color: #FFFFFF;
            text-decoration: none;
        }
        .auth-cabecera .marca i { color: #C4A66A; }
        .auth-cabecera h1 {
            margin: 1.4rem 0 .35rem;
            font-size: 1.55rem;
            font-weight: 800;
            color: #FFFFFF;
        }
        .auth-cabecera p { margin: 0; color: rgba(255,255,255,.82); font-size: .925rem; }

        .auth-cuerpo { padding: 1.75rem 2rem 2rem; }

        .auth-seccion {
            display: flex; align-items: center; gap: .85rem;
            margin-bottom: 1.4rem;
        }
        .auth-emblema {
            flex: 0 0 auto; width: 3rem; height: 3rem;
            display: flex; align-items: center; justify-content: center;
            border-radius: .9rem; font-size: 1.25rem; color: #FFFFFF;
            background: linear-gradient(135deg, #C4A66A, #A8864A);
            box-shadow: 0 10px 20px -10px rgba(168,134,74,.7);
        }
        .auth-titulo {
            margin: 0; font-size: 1.45rem; font-weight: 800;
            color: #17211D; letter-spacing: -0.02em;
        }
        .auth-subtitulo { margin: .25rem 0 0; font-size: .925rem; color: #66716C; }

        .grupo-entrada .input-group-text {
            min-width: 3rem; justify-content: center;
            color: #2F7664; background-color: #E7F0EC;
            border: 1px solid #E2E5E1; border-right: 0;
        }
        .grupo-entrada .form-control { border-left: 0; }
        .grupo-entrada:focus-within .input-group-text {
            color: #12372A; border-color: #2F7664;
        }
        .grupo-entrada:focus-within .form-control {
            border-color: #2F7664; box-shadow: 0 0 0 .2rem rgba(47,118,100,.14);
        }

        .btn-inmo {
            display: inline-flex; align-items: center; justify-content: center; gap: .5rem;
            width: 100%; min-height: 50px;
            border: 0; border-radius: .75rem;
            font-size: 1rem; font-weight: 700; color: #FFFFFF;
            background: linear-gradient(135deg, #2F7664, #12372A);
            transition: transform 150ms ease, box-shadow 150ms ease;
            padding: 0 1.5rem; cursor: pointer;
        }
        .btn-inmo:hover {
            color: #FFFFFF; transform: translateY(-1px);
            box-shadow: 0 12px 24px -12px rgba(18,55,42,.6);
        }

        .auth-pie {
            margin-top: 1.35rem; padding-top: 1.15rem;
            border-top: 1px solid #E2E5E1;
            text-align: center; font-size: .9375rem; color: #66716C;
        }
        .auth-pie a { font-weight: 700; color: #2F7664; text-decoration: none; }
        .auth-pie a:hover { color: #12372A; text-decoration: underline; }

        .auth-volver {
            display: inline-flex; align-items: center; gap: .4rem;
            margin-top: 1.25rem; font-size: .875rem; font-weight: 600;
            color: #2F7664; text-decoration: none;
        }
        .auth-volver:hover { color: #12372A; text-decoration: underline; }

        @media (max-width: 575.98px) {
            .auth-cabecera { padding: 1.5rem 1.4rem 1.1rem; }
            .auth-cuerpo   { padding: 1.4rem 1.4rem 1.6rem; }
        }
    </style>
</head>

<body>

<div class="auth-fondo">

    <div class="auth-tarjeta">

        <header class="auth-cabecera">
            <a class="marca" href="${pageContext.request.contextPath}/">
                <i class="bi bi-buildings" aria-hidden="true"></i>
                Inmobiliaria
            </a>
            <h1>Bienvenido de nuevo</h1>
            <p>Ingresa tu correo y contraseña para continuar.</p>
        </header>

        <div class="auth-cuerpo">

            <div class="auth-seccion">
                <span class="auth-emblema" aria-hidden="true">
                    <i class="bi bi-door-open"></i>
                </span>
                <div>
                    <h2 class="auth-titulo">Iniciar sesión</h2>
                    <p class="auth-subtitulo">Accede a tu panel personalizado.</p>
                </div>
            </div>

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
                    <div class="input-group grupo-entrada">
                        <span class="input-group-text" aria-hidden="true">
                            <i class="bi bi-envelope-at"></i>
                        </span>
                        <input type="email"
                               id="correo"
                               name="correo"
                               class="form-control"
                               autocomplete="email"
                               placeholder="tucorreo@ejemplo.com"
                               required
                               autofocus>
                    </div>
                </div>

                <div class="mb-4">
                    <label class="form-label" for="password">Contraseña</label>
                    <div class="input-group grupo-entrada">
                        <span class="input-group-text" aria-hidden="true">
                            <i class="bi bi-shield-lock"></i>
                        </span>
                        <input type="password"
                               id="password"
                               name="password"
                               class="form-control"
                               autocomplete="current-password"
                               placeholder="Tu contraseña"
                               required>
                    </div>
                </div>

                <button type="submit" class="btn-inmo">
                    Iniciar sesión
                    <i class="bi bi-arrow-right" aria-hidden="true"></i>
                </button>

            </form>

            <p class="auth-pie mb-0">
                ¿Aún no tienes una cuenta?
                <a href="${pageContext.request.contextPath}/registro">Crear cuenta</a>
            </p>

            <div class="text-center">
                <a class="auth-volver" href="${pageContext.request.contextPath}/">
                    <i class="bi bi-arrow-left" aria-hidden="true"></i>
                    Volver al inicio
                </a>
            </div>

        </div>

    </div>

</div>

</body>
</html>