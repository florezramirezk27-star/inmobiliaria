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

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css?v=editorial-final-2">

    <style>
    * { box-sizing: border-box; }

    body {
        margin: 0;
        min-height: 100vh;
        font-family: "Inter", system-ui, -apple-system, sans-serif;
        color: #17211D;
        background: #F5F4EF;
    }

    .login-pantalla {
        min-height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 3rem 1.5rem;
        position: relative;
        overflow: hidden;
        background:
            radial-gradient(circle at 10% 15%, rgba(196,166,106,.14), transparent 27%),
            radial-gradient(circle at 90% 82%, rgba(47,118,100,.12), transparent 31%),
            #F5F4EF;
    }

    .login-pantalla::before {
        content: "";
        position: absolute;
        width: 430px;
        height: 430px;
        right: -180px;
        top: -180px;
        border-radius: 50%;
        border: 1px solid rgba(18,55,42,.07);
        box-shadow:
            0 0 0 60px rgba(18,55,42,.018),
            0 0 0 120px rgba(18,55,42,.012);
    }

    .login-shell {
        width: min(1040px, 100%);
        min-height: 620px;
        display: grid;
        grid-template-columns: 46% 54%;
        position: relative;
        z-index: 1;
        overflow: hidden;
        border: 1px solid rgba(18,55,42,.08);
        border-radius: 26px;
        background: #FFFFFF;
        box-shadow:
            0 38px 90px rgba(18,55,42,.14),
            0 8px 26px rgba(18,55,42,.06);
    }

    .login-editorial {
        position: relative;
        display: flex;
        flex-direction: column;
        padding: 2.6rem 2.7rem;
        overflow: hidden;
        color: #FFFFFF;
        background:
            radial-gradient(circle at 86% 20%, rgba(196,166,106,.16), transparent 28%),
            linear-gradient(145deg, #09271D 0%, #0D3427 58%, #174A39 100%);
    }

    .login-editorial::before {
        content: "";
        position: absolute;
        inset: 0;
        background-image:
            linear-gradient(rgba(255,255,255,.025) 1px, transparent 1px),
            linear-gradient(90deg, rgba(255,255,255,.025) 1px, transparent 1px);
        background-size: 54px 54px;
        pointer-events: none;
    }

    .login-marca {
        position: relative;
        z-index: 2;
        display: inline-flex;
        align-items: center;
        gap: .6rem;
        width: fit-content;
        color: #FFFFFF;
        font-weight: 800;
        font-size: 1.08rem;
        letter-spacing: -.025em;
        text-decoration: none;
    }

    .login-marca:hover {
        color: #FFFFFF;
        text-decoration: none;
    }

    .login-marca i {
        color: #C4A66A;
    }

    .login-editorial-contenido {
        position: relative;
        z-index: 2;
        margin: auto 0;
    }

    .login-eyebrow {
        display: inline-flex;
        align-items: center;
        gap: .55rem;
        margin-bottom: 1.25rem;
        color: rgba(255,255,255,.64);
        font-size: .69rem;
        font-weight: 700;
        letter-spacing: .13em;
        text-transform: uppercase;
    }

    .login-eyebrow::before {
        content: "";
        width: 7px;
        height: 7px;
        border-radius: 50%;
        background: #C4A66A;
        box-shadow: 0 0 0 5px rgba(196,166,106,.1);
    }

    .login-editorial h2 {
        max-width: 10ch;
        margin: 0 0 1.25rem;
        color: #FFFFFF;
        font-size: clamp(2.2rem, 3.3vw, 3.55rem);
        font-weight: 800;
        line-height: 1.02;
        letter-spacing: -.05em;
    }

    .login-editorial h2 span {
        display: block;
        color: #D3DFD9;
        font-weight: 500;
    }

    .login-editorial-texto {
        max-width: 39ch;
        margin: 0;
        color: rgba(255,255,255,.69);
        font-size: .95rem;
        line-height: 1.72;
    }

    .login-beneficios {
        display: grid;
        gap: .75rem;
        margin-top: 2rem;
    }

    .login-beneficio {
        display: flex;
        align-items: center;
        gap: .75rem;
        color: rgba(255,255,255,.78);
        font-size: .81rem;
        font-weight: 500;
    }

    .login-beneficio span {
        width: 33px;
        height: 33px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        flex: 0 0 auto;
        border: 1px solid rgba(255,255,255,.12);
        border-radius: 9px;
        color: #D7BE87;
        background: rgba(255,255,255,.055);
    }

    .login-editorial-pie {
        position: relative;
        z-index: 2;
        display: flex;
        justify-content: space-between;
        gap: 1rem;
        padding-top: 1.4rem;
        border-top: 1px solid rgba(255,255,255,.09);
        color: rgba(255,255,255,.44);
        font-size: .69rem;
    }

    .login-plano {
        position: absolute;
        width: 280px;
        height: 220px;
        right: -70px;
        bottom: 40px;
        opacity: .52;
        transform: rotate(-4deg);
        pointer-events: none;
    }

    .login-plano-marco {
        position: absolute;
        inset: 0;
        border: 1px solid rgba(255,255,255,.13);
    }

    .login-plano-marco::before {
        content: "";
        position: absolute;
        inset: 17px;
        border: 1px solid rgba(255,255,255,.055);
    }

    .login-plano-a,
    .login-plano-b,
    .login-plano-c {
        position: absolute;
        border: 1px solid rgba(255,255,255,.13);
    }

    .login-plano-a {
        width: 105px;
        height: 78px;
        left: 35px;
        top: 34px;
    }

    .login-plano-b {
        width: 82px;
        height: 125px;
        right: 29px;
        top: 34px;
    }

    .login-plano-c {
        width: 145px;
        height: 63px;
        left: 35px;
        bottom: 30px;
    }

    .login-plano-circulo {
        position: absolute;
        width: 65px;
        height: 65px;
        right: 40px;
        bottom: 31px;
        border: 1px solid rgba(196,166,106,.42);
        border-radius: 50%;
    }

    .login-formulario-panel {
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 3rem clamp(2.25rem, 5vw, 4.4rem);
        background: #FFFFFF;
    }

    .login-formulario {
        width: 100%;
        max-width: 430px;
    }

    .login-formulario-superior {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 2.2rem;
    }

    .login-seguro {
        display: inline-flex;
        align-items: center;
        gap: .4rem;
        padding: .42rem .65rem;
        border: 1px solid #E2E8E4;
        border-radius: 999px;
        color: #63716A;
        background: #F8FAF8;
        font-size: .7rem;
        font-weight: 700;
    }

    .login-seguro i {
        color: #2F7664;
    }

    .login-volver {
        display: inline-flex;
        align-items: center;
        gap: .35rem;
        color: #6C7771;
        font-size: .76rem;
        font-weight: 600;
        text-decoration: none;
    }

    .login-volver:hover {
        color: #12372A;
        text-decoration: none;
    }

    .login-icono {
        width: 49px;
        height: 49px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        margin-bottom: 1.25rem;
        border-radius: 14px;
        color: #9E7D40;
        background: #F4EBDD;
        font-size: 1.15rem;
    }

    .login-formulario h1 {
        margin: 0 0 .55rem;
        color: #17211D;
        font-size: clamp(2rem, 2.3vw, 2.45rem);
        font-weight: 800;
        line-height: 1.05;
        letter-spacing: -.045em;
    }

    .login-subtitulo {
        margin: 0 0 2rem;
        color: #6D7872;
        font-size: .94rem;
        line-height: 1.6;
    }

    .login-formulario .form-label {
        margin-bottom: .48rem;
        color: #31413A;
        font-size: .78rem;
        font-weight: 700;
    }

    .login-campo {
        min-height: 53px;
        display: flex;
        align-items: stretch;
        overflow: hidden;
        border: 1px solid #DDE3DF;
        border-radius: 12px;
        background: #FBFCFB;
        transition: border-color 150ms ease, box-shadow 150ms ease;
    }

    .login-campo:focus-within {
        border-color: #3A806C;
        background: #FFFFFF;
        box-shadow: 0 0 0 3px rgba(47,118,100,.11);
    }

    .login-campo-icono {
        width: 50px;
        display: flex;
        align-items: center;
        justify-content: center;
        flex: 0 0 auto;
        color: #2F7664;
        background: #EDF4F0;
    }

    .login-campo .form-control {
        min-height: 51px;
        padding: .65rem .9rem;
        border: 0;
        border-radius: 0;
        background: transparent;
        box-shadow: none;
        font-size: .92rem;
    }

    .login-campo .form-control:focus {
        box-shadow: none;
    }

    .login-password-toggle {
        width: 48px;
        flex: 0 0 auto;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        border: 0;
        color: #79847F;
        background: transparent;
        cursor: pointer;
    }

    .login-password-toggle:hover {
        color: #12372A;
        background: #F2F5F3;
    }

    .login-submit {
        width: 100%;
        min-height: 54px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: .6rem;
        border: 0;
        border-radius: 12px;
        color: #FFFFFF;
        background: linear-gradient(135deg, #347E68, #12372A);
        font-size: .94rem;
        font-weight: 700;
        box-shadow: 0 12px 28px rgba(18,55,42,.15);
        cursor: pointer;
        transition: transform 150ms ease, box-shadow 150ms ease;
    }

    .login-submit:hover {
        transform: translateY(-1px);
        box-shadow: 0 16px 30px rgba(18,55,42,.21);
    }

    .login-cuenta {
        margin: 1.65rem 0 0;
        padding-top: 1.35rem;
        border-top: 1px solid #E7EAE7;
        color: #748079;
        text-align: center;
        font-size: .85rem;
    }

    .login-cuenta a {
        margin-left: .2rem;
        color: #2F7664;
        font-weight: 700;
        text-decoration: none;
    }

    @media (max-width: 899.98px) {
        .login-pantalla { padding: 1.5rem; }

        .login-shell {
            width: min(560px, 100%);
            min-height: auto;
            grid-template-columns: 1fr;
            border-radius: 22px;
        }

        .login-editorial { display: none; }

        .login-formulario-panel {
            min-height: 650px;
            padding: 2.5rem clamp(1.5rem, 7vw, 3.2rem);
        }
    }

    @media (max-width: 575.98px) {
        .login-pantalla {
            align-items: flex-start;
            padding: 1rem;
            background: #FFFFFF;
        }

        .login-shell {
            border: 0;
            border-radius: 0;
            box-shadow: none;
        }

        .login-formulario-panel {
            min-height: calc(100vh - 2rem);
            align-items: flex-start;
            padding: 2rem .55rem;
        }
    }
</style>
</head>

<body>

<div class="login-pantalla">

    <main class="login-shell">

        <section class="login-editorial"
                 aria-label="Información de la plataforma">

            <a class="login-marca"
               href="${pageContext.request.contextPath}/">

                <i class="bi bi-buildings"
                   aria-hidden="true"></i>

                Inmobiliaria
            </a>

            <div class="login-editorial-contenido">

                <span class="login-eyebrow">
                    Gestión inmobiliaria digital
                </span>

                <h2>
                    Todo lo que necesitas
                    <span>en un solo lugar.</span>
                </h2>

                <p class="login-editorial-texto">
                    Explora inmuebles, agenda visitas y administra tus
                    solicitudes desde una experiencia simple y segura.
                </p>

                <div class="login-beneficios">

                    <div class="login-beneficio">
                        <span><i class="bi bi-search"></i></span>
                        Propiedades organizadas y fáciles de explorar
                    </div>

                    <div class="login-beneficio">
                        <span><i class="bi bi-calendar-check"></i></span>
                        Agenda y seguimiento desde tu panel
                    </div>

                    <div class="login-beneficio">
                        <span><i class="bi bi-shield-check"></i></span>
                        Acceso protegido según tu perfil
                    </div>

                </div>

            </div>

            <div class="login-editorial-pie">
                <span>Bucaramanga · Santander</span>
                <span>Plataforma inmobiliaria</span>
            </div>

            <div class="login-plano" aria-hidden="true">
                <div class="login-plano-marco"></div>
                <div class="login-plano-a"></div>
                <div class="login-plano-b"></div>
                <div class="login-plano-c"></div>
                <div class="login-plano-circulo"></div>
            </div>

        </section>

        <section class="login-formulario-panel">

            <div class="login-formulario">

                <div class="login-formulario-superior">

                    <span class="login-seguro">
                        <i class="bi bi-shield-check"></i>
                        Acceso seguro
                    </span>

                    <a class="login-volver"
                       href="${pageContext.request.contextPath}/">
                        <i class="bi bi-arrow-left"></i>
                        Inicio
                    </a>

                </div>

                <span class="login-icono" aria-hidden="true">
                    <i class="bi bi-door-open"></i>
                </span>

                <h1>Bienvenido de nuevo</h1>

                <p class="login-subtitulo">
                    Ingresa tus datos para acceder a tu panel personalizado.
                </p>

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

                <form action="${pageContext.request.contextPath}/login"
                      method="post">

                    <div class="mb-3">

                        <label class="form-label" for="correo">
                            Correo electrónico
                        </label>

                        <div class="login-campo">

                            <span class="login-campo-icono"
                                  aria-hidden="true">
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

                        <label class="form-label" for="password">
                            Contraseña
                        </label>

                        <div class="login-campo">

                            <span class="login-campo-icono"
                                  aria-hidden="true">
                                <i class="bi bi-shield-lock"></i>
                            </span>

                            <input type="password"
                                   id="password"
                                   name="password"
                                   class="form-control"
                                   autocomplete="current-password"
                                   placeholder="Tu contraseña"
                                   required>

                            <button type="button"
                                    class="login-password-toggle"
                                    id="togglePassword"
                                    aria-label="Mostrar contraseña"
                                    title="Mostrar contraseña">

                                <i class="bi bi-eye"
                                   id="togglePasswordIcon"
                                   aria-hidden="true"></i>
                            </button>

                        </div>

                    </div>

                    <button type="submit"
                            class="login-submit">

                        Iniciar sesión

                        <i class="bi bi-arrow-right"
                           aria-hidden="true"></i>
                    </button>

                </form>

                <p class="login-cuenta">
                    ¿Aún no tienes una cuenta?
                    <a href="${pageContext.request.contextPath}/registro">
                        Crear cuenta
                    </a>
                </p>

            </div>

        </section>

    </main>

</div>

<script>
    const togglePassword =
        document.getElementById("togglePassword");

    const password =
        document.getElementById("password");

    const togglePasswordIcon =
        document.getElementById("togglePasswordIcon");

    if (togglePassword && password && togglePasswordIcon) {

        togglePassword.addEventListener("click", function () {

            const mostrar =
                password.type === "password";

            password.type =
                mostrar ? "text" : "password";

            togglePasswordIcon.className =
                mostrar
                    ? "bi bi-eye-slash"
                    : "bi bi-eye";

            togglePassword.setAttribute(
                "aria-label",
                mostrar
                    ? "Ocultar contraseña"
                    : "Mostrar contraseña"
            );

            togglePassword.setAttribute(
                "title",
                mostrar
                    ? "Ocultar contraseña"
                    : "Mostrar contraseña"
            );
        });
    }
</script>

</body>
</html>