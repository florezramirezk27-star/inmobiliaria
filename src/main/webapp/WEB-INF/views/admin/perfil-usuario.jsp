<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Perfil del usuario — Inmobiliaria</title>

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

<%@ include file="/WEB-INF/includes/navbar.jspf" %>

<main class="container py-5">

    <div class="cabecera-seccion">
        <div>
            <h1 class="fuente-display mb-1">Perfil del usuario</h1>
            <p class="descripcion mb-0">Consulta y edita los datos de la cuenta seleccionada.</p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/usuarios" class="btn btn-volver">
            Volver a usuarios
        </a>
    </div>

    <div class="row g-4">

        <%-- Resumen de la cuenta --%>
        <div class="col-12 col-lg-4">
            <div class="panel">

                <h3 class="mb-4">Cuenta</h3>

                <dl class="row mb-0" style="font-size:.9375rem;">

                    <dt class="col-5" style="color:var(--text-secondary); font-weight:500;">ID</dt>
                    <dd class="col-7 text-end fw-semibold">${usuario.idUsuario}</dd>

                    <dt class="col-5" style="color:var(--text-secondary); font-weight:500;">Correo</dt>
                    <dd class="col-7 text-end" style="word-break:break-all;">${usuario.correo}</dd>

                    <dt class="col-5" style="color:var(--text-secondary); font-weight:500;">Estado</dt>
                    <dd class="col-7 text-end">
                        <c:choose>
                            <c:when test="${usuario.estado eq 'ACTIVO'}">
                                <span class="chip chip-verde">${usuario.estado}</span>
                            </c:when>
                            <c:when test="${usuario.estado eq 'BLOQUEADO'}">
                                <span class="chip chip-rojo">${usuario.estado}</span>
                            </c:when>
                            <c:otherwise>
                                <span class="chip chip-gris">${usuario.estado}</span>
                            </c:otherwise>
                        </c:choose>
                    </dd>

                </dl>

                <hr style="border-color: var(--border);">

                <p class="mb-2" style="color:var(--text-secondary); font-size:.875rem; font-weight:600;">
                    Roles asignados
                </p>
                <div class="d-flex flex-wrap gap-2">
                    <c:forEach var="rol" items="${roles}">
                        <span class="chip chip-azul">${rol.nombre}</span>
                    </c:forEach>
                </div>

            </div>
        </div>

        <%-- Formulario de perfil --%>
        <div class="col-12 col-lg-8">
            <form method="post"
                  action="${pageContext.request.contextPath}/admin/usuarios/perfil">

                <input type="hidden" name="idUsuario" value="${usuario.idUsuario}">

                <div class="panel mb-4">

                    <h3 class="mb-4">Datos personales</h3>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label" for="nombres">Nombres</label>
                            <input type="text" id="nombres" name="nombres"
                                   class="form-control" value="${perfil.nombres}">
                        </div>

                        <div class="col-md-6 mb-3">
                            <label class="form-label" for="apellidos">Apellidos</label>
                            <input type="text" id="apellidos" name="apellidos"
                                   class="form-control" value="${perfil.apellidos}">
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label" for="documento">Documento</label>
                            <input type="text" id="documento" name="documento"
                                   class="form-control" value="${perfil.documento}">
                        </div>

                        <div class="col-md-6 mb-3">
                            <label class="form-label" for="telefono">Teléfono</label>
                            <input type="text" id="telefono" name="telefono"
                                   class="form-control" value="${perfil.telefono}">
                        </div>
                    </div>

                    <div class="mb-0">
                        <label class="form-label" for="direccion">Dirección</label>
                        <input type="text" id="direccion" name="direccion"
                               class="form-control" value="${perfil.direccion}">
                    </div>

                </div>

                <div class="d-flex flex-wrap gap-2">
                    <button type="submit" class="btn btn-marca">Guardar cambios</button>
                    <a href="${pageContext.request.contextPath}/admin/usuarios"
                       class="btn btn-contorno">Cancelar</a>
                </div>

            </form>
        </div>

    </div>

</main>

<%@ include file="/WEB-INF/includes/footer.jspf" %>

</body>
</html>
