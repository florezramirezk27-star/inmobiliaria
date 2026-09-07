<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Administrar usuarios</title>

    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
            rel="stylesheet">
</head>

<body>

<div class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1>Administrar usuarios</h1>

        <a href="${pageContext.request.contextPath}/admin/dashboard"
           class="btn btn-secondary">
            Volver al panel
        </a>
    </div>

    <div class="table-responsive">

        <table class="table table-striped table-bordered">

            <thead class="table-dark">

            <tr>
                <th>ID</th>
                <th>Correo</th>
                <th>Estado</th>
                <th>Rol</th>
                <th>Gestionar rol</th>
                <th>Fecha creación</th>
                <th>Último acceso</th>
                <th>Acción</th>
            </tr>

            </thead>

            <tbody>

            <c:forEach var="usuario" items="${usuarios}">

                <tr>

                    <td>${usuario.idUsuario}</td>

                    <td>${usuario.correo}</td>

                    <td>
                        <span class="badge
                            ${usuario.estado == 'ACTIVO'
                                ? 'bg-success'
                                : 'bg-danger'}">

                            ${usuario.estado}

                        </span>
                    </td>

                    <td>
                        <c:forEach
                                var="rol"
                                items="${requestScope['roles_'.concat(usuario.idUsuario)]}">

                            <span class="badge bg-primary">
                                ${rol.nombre}
                            </span>

                        </c:forEach>
                    </td>

                    <td>

                        <form method="post"
                              action="${pageContext.request.contextPath}/admin/usuarios">

                            <input type="hidden"
                                   name="id"
                                   value="${usuario.idUsuario}">

                            <input type="hidden"
                                   name="accion"
                                   value="cambiarRol">

                            <select name="idRol"
                                    class="form-select form-select-sm mb-2">

                                <c:forEach var="rol" items="${roles}">

                                    <option value="${rol.idRol}">
                                        ${rol.nombre}
                                    </option>

                                </c:forEach>

                            </select>

                            <button type="submit"
                                    class="btn btn-sm btn-warning">
                                Cambiar rol
                            </button>

                        </form>

                    </td>

                    <td>${usuario.fechaCreacion}</td>

                    <td>
                        ${usuario.fechaUltimoAcceso != null
                            ? usuario.fechaUltimoAcceso
                            : 'Nunca'}
                    </td>

                    <td>

                        <c:choose>

                            <c:when test="${usuario.estado == 'ACTIVO'}">

                                <form method="post"
                                      action="${pageContext.request.contextPath}/admin/usuarios"
                                      class="d-inline">

                                    <input type="hidden"
                                           name="id"
                                           value="${usuario.idUsuario}">

                                    <input type="hidden"
                                           name="accion"
                                           value="desactivar">

                                    <button type="submit"
                                            class="btn btn-sm btn-danger">
                                        Desactivar
                                    </button>

                                </form>

                            </c:when>

                            <c:otherwise>

                                <form method="post"
                                      action="${pageContext.request.contextPath}/admin/usuarios"
                                      class="d-inline">

                                    <input type="hidden"
                                           name="id"
                                           value="${usuario.idUsuario}">

                                    <input type="hidden"
                                           name="accion"
                                           value="activar">

                                    <button type="submit"
                                            class="btn btn-sm btn-success">
                                        Activar
                                    </button>

                                </form>

                            </c:otherwise>

                        </c:choose>

                        <a href="${pageContext.request.contextPath}/admin/usuarios/perfil?id=${usuario.idUsuario}"
                           class="btn btn-sm btn-info">
                            Ver perfil
                        </a>

                    </td>

                </tr>

            </c:forEach>

            </tbody>

        </table>

    </div>

</div>

</body>
</html>