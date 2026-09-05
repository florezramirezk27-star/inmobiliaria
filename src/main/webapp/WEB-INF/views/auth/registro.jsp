<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Crear cuenta</title>

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

</head>

<body>

<div class="container py-5">

    <div class="row justify-content-center">

        <div class="col-md-8 col-lg-6">

            <div class="card shadow">

                <div class="card-body p-4">

                    <h2 class="text-center mb-4">
                        Crear cuenta
                    </h2>

                    <% if (request.getAttribute("error") != null) { %>

                        <div class="alert alert-danger">
                            <%= request.getAttribute("error") %>
                        </div>

                    <% } %>

                    <form
                        action="${pageContext.request.contextPath}/registro"
                        method="post">

                        <div class="row">

                            <div class="col-md-6 mb-3">

                                <label class="form-label">
                                    Nombres
                                </label>

                                <input
                                    type="text"
                                    name="nombres"
                                    class="form-control"
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
                                    required>

                            </div>

                        </div>

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

                        <div class="row">

                            <div class="col-md-6 mb-3">

                                <label class="form-label">
                                    Contraseña
                                </label>

                                <input
                                    type="password"
                                    name="password"
                                    class="form-control"
                                    minlength="8"
                                    required>

                            </div>

                            <div class="col-md-6 mb-3">

                                <label class="form-label">
                                    Confirmar contraseña
                                </label>

                                <input
                                    type="password"
                                    name="confirmPassword"
                                    class="form-control"
                                    minlength="8"
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
                                class="form-control">

                        </div>

                        <div class="mb-3">

                            <label class="form-label">
                                Teléfono
                            </label>

                            <input
                                type="text"
                                name="telefono"
                                class="form-control">

                        </div>

                        <div class="mb-3">

                            <label class="form-label">
                                Dirección
                            </label>

                            <input
                                type="text"
                                name="direccion"
                                class="form-control">

                        </div>

                        <button
                            type="submit"
                            class="btn btn-primary w-100">

                            Crear cuenta

                        </button>

                    </form>

                    <div class="text-center mt-3">

                        <a
                            href="${pageContext.request.contextPath}/login">

                            ¿Ya tienes una cuenta? Inicia sesión

                        </a>

                    </div>

                </div>

            </div>

        </div>

    </div>

</div>

</body>

</html>
