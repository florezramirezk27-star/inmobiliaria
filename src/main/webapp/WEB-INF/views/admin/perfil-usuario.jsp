<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <title>Perfil del usuario</title>

    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
            rel="stylesheet">
</head>

<body>

<div class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-4">

        <h1>Perfil del usuario</h1>

        <a href="${pageContext.request.contextPath}/admin/usuarios"
           class="btn btn-contorno">
            Volver
        </a>

    </div>

    <div class="card">

        <div class="card-body">

            <p>
                <strong>ID:</strong>
                ${usuario.idUsuario}
            </p>

            <p>
                <strong>Correo:</strong>
                ${usuario.correo}
            </p>

            <p>
                <strong>Estado:</strong>
                ${usuario.estado}
            </p>

            <p>
                <strong>Rol:</strong>

                <c:forEach var="rol" items="${roles}">
                    <span class="badge bg-primary">
                        ${rol.nombre}
                    </span>
                </c:forEach>

            </p>

            <hr>

            <form method="post"
                  action="${pageContext.request.contextPath}/admin/usuarios/perfil">

                <input type="hidden"
                       name="idUsuario"
                       value="${usuario.idUsuario}">

                <div class="mb-3">

                    <label class="form-label">
                        Nombres
                    </label>

                    <input type="text"
                           name="nombres"
                           class="form-control"
                           value="${perfil.nombres}">
                </div>

                <div class="mb-3">

                    <label class="form-label">
                        Apellidos
                    </label>

                    <input type="text"
                           name="apellidos"
                           class="form-control"
                           value="${perfil.apellidos}">
                </div>

                <div class="mb-3">

                    <label class="form-label">
                        Documento
                    </label>

                    <input type="text"
                           name="documento"
                           class="form-control"
                           value="${perfil.documento}">
                </div>

                <div class="mb-3">

                    <label class="form-label">
                        Teléfono
                    </label>

                    <input type="text"
                           name="telefono"
                           class="form-control"
                           value="${perfil.telefono}">
                </div>

                <div class="mb-3">

                    <label class="form-label">
                        Dirección
                    </label>

                    <input type="text"
                           name="direccion"
                           class="form-control"
                           value="${perfil.direccion}">
                </div>

                <button type="submit"
                        class="btn btn-primary">
                    Guardar cambios
                </button>

            </form>

        </div>

    </div>

</div>

</body>
</html>