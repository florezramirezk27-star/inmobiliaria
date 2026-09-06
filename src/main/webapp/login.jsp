<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Iniciar Sesión</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; padding-top: 60px; background-color: #f5f7fa; }
        form { width: 320px; margin: 0 auto; padding: 30px; background: #fff; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,.1); text-align: left; }
        input { width: 100%; padding: 10px; margin: 8px 0 16px; border: 1px solid #ccc; border-radius: 5px; box-sizing: border-box; }
        button { width: 100%; padding: 10px; background: #0d6efd; color: #fff; border: none; border-radius: 5px; cursor: pointer; }
        .error { color: #dc3545; text-align: center; }
    </style>
</head>
<body>
    <h1>Iniciar Sesión</h1>

    <% if (request.getAttribute("error") != null) { %>
        <p class="error"><%= request.getAttribute("error") %></p>
    <% } %>

    <form action="<%= request.getContextPath() %>/login" method="post">
        <label>Correo</label>
        <input type="email" name="correo" required>

        <label>Contraseña</label>
        <input type="password" name="password" required>

        <button type="submit">Ingresar</button>
    </form>

    <p><a href="<%= request.getContextPath() %>/registro">¿No tienes cuenta? Regístrate</a></p>
</body>
</html>
