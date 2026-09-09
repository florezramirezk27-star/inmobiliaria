<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%--
    confirmar-logout.jsp — paso intermedio antes de cerrar sesión.
    Sirve LogoutServlet (GET /logout): aún no se ha invalidado la
    sesión, esto solo pregunta. El formulario POST /logout es el
    que efectivamente la cierra.
--%>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Cerrar sesión — Inmobiliaria</title>

    <link href="https://fonts.googleapis.com/css2?family=Bricolage+Grotesque:opsz,wght@12..96,400..800&family=Karla:wght@400;500;600;700&display=swap"
          rel="stylesheet">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
          crossorigin="anonymous">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
</head>

<body>

<%@ include file="/WEB-INF/includes/navbar.jspf" %>

<main class="container py-5" style="max-width: 560px;">

    <div class="tarjeta-prop p-4 p-md-5 text-center">

        <span class="chip chip-ocre d-inline-flex mb-3">Cerrar sesión</span>

        <h1 class="fuente-display mb-2">¿Seguro que deseas cerrar sesión?</h1>

        <p class="mb-4" style="color: var(--gris);">
            Deberás volver a ingresar tu correo y contraseña la próxima vez
            que quieras usar tu cuenta.
        </p>

        <form method="post" action="${pageContext.request.contextPath}/logout"
              class="d-flex flex-column flex-sm-row gap-2 justify-content-center">
            <button type="submit" class="btn btn-marca">
                Sí, cerrar sesión
            </button>
            <a href="${pageContext.request.contextPath}/"
               class="btn btn-contorno">
                Cancelar
            </a>
        </form>

    </div>

</main>

<%@ include file="/WEB-INF/includes/footer.jspf" %>

</body>
</html>