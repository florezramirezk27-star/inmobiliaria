<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Iniciar sesión</title>

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

</head>

<body>

<div class="container py-5">

    <div class="row justify-content-center">

        <div class="col-md-6 col-lg-4">

            <div class="card shadow">

                <div class="card-body p-4">

                    <h2 class="text-center mb-4">
                        Iniciar sesión
                    </h2>

                    <% if (request.getParameter("registro") != null) { %>

                        <div class="alert alert-success">
                            Registro completado. Ya puedes iniciar sesión.
                        </div>

                    <% } %>

                    <% if (request.getAttribute("error") != null) { %>

                        <div class="alert alert-danger">
                            <%= request.getAttribute("error") %>
                        </div>

                    <% } %>

                    <form
                        action="${pageContext.request.contextPath}/login"
                        method="post">

                        <div class="mb-3">

                            <label class="form-label">
                                Correo electrónico
                            </label>

                            <input
                                type="email"
                                name="correo"
                                class="form-control"
                                required>

                        </div>

                        <div class="mb-3">

                            <label class="form-label">
                                Contraseña
                            </label>

                            <input
                                type="password"
                                name="password"
                                class="form-control"
                                required>

                        </div>

                        <button
                            type="submit"
                            class="btn btn-primary w-100">

                            Iniciar sesión

                        </button>

                    </form>

                    <div class="text-center mt-3">

                        <a
                            href="${pageContext.request.contextPath}/registro">

                            Crear una cuenta

                        </a>

                    </div>

                </div>

            </div>

        </div>

    </div>

</div>

</body>

</html>
