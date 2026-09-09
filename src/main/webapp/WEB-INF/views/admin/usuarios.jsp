<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Administrar usuarios — Inmobiliaria</title>

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

<main class="container py-5">

    <div class="banner-panel banner-usuarios mb-4">
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">
            <div>
                <span class="badge badge-tag">ADMINISTRADOR</span>
                <h1 class="fuente-display mt-2">Administrar usuarios</h1>
                <p class="descripcion">
                    Gestiona el estado de cada cuenta y los roles de acceso al sistema.
                </p>
            </div>

            <a href="${pageContext.request.contextPath}/admin/dashboard"
               class="btn btn-banner">
                &larr; Volver al panel
            </a>
        </div>
    </div>

    <%-- Resumen: totales calculados sobre la lista del request. --%>
    <c:set var="totalActivos" value="0"/>
    <c:forEach var="u" items="${usuarios}">
        <c:if test="${u.estado == 'ACTIVO'}">
            <c:set var="totalActivos" value="${totalActivos + 1}"/>
        </c:if>
    </c:forEach>
    <c:set var="totalInactivos" value="${fn:length(usuarios) - totalActivos}"/>

    <div class="row g-3 mb-4">
        <div class="col-6 col-md-4">
            <div class="metrica azul">
                <p class="rotulo">Usuarios registrados</p>
                <p class="numero">${fn:length(usuarios)}</p>
            </div>
        </div>
        <div class="col-6 col-md-4">
            <div class="metrica verde">
                <p class="rotulo">Activos</p>
                <p class="numero">${totalActivos}</p>
            </div>
        </div>
        <div class="col-6 col-md-4">
            <div class="metrica rojo">
                <p class="rotulo">Inactivos</p>
                <p class="numero">${totalInactivos}</p>
            </div>
        </div>
    </div>

    <%-- Tarjetas de usuario: toda la información a la vista, sin scroll lateral. --%>
    <c:if test="${empty usuarios}">
        <div class="sin-resultados">
            <p class="mb-0">No hay usuarios registrados todavía.</p>
        </div>
    </c:if>

    <div class="row g-4">

        <c:forEach var="usuario" items="${usuarios}">

            <div class="col-12 col-md-6 col-xl-4">

                <div class="tarjeta-prop d-flex flex-column">
                    <div class="d-flex gap-3 p-3 border-bottom">

                        <div class="avatar-cita"
                             style="width: 48px; height: 48px; font-size: 1.15rem;"
                             title="${usuario.correo}">
                            ${fn:substring(fn:toUpperCase(fn:trim(usuario.correo)), 0, 1)}
                        </div>

                        <div class="flex-grow-1" style="min-width: 0;">
                            <p class="fw-semibold mb-1 text-truncate" title="${usuario.correo}">
                                ${usuario.correo}
                            </p>
                            <div class="d-flex flex-wrap gap-1">
                                <c:forEach var="rol" items="${requestScope['roles_'.concat(usuario.idUsuario)]}">
                                    <c:choose>
                                        <c:when test="${rol.nombre == 'ADMIN'}">
                                            <span class="chip chip-azul">${rol.descripcion != null ? rol.descripcion : rol.nombre}</span>
                                        </c:when>
                                        <c:when test="${rol.nombre == 'AGENTE'}">
                                            <span class="chip chip-ocre">${rol.descripcion != null ? rol.descripcion : rol.nombre}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="chip chip-verde">${rol.descripcion != null ? rol.descripcion : rol.nombre}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </div>
                        </div>

                        <c:choose>
                            <c:when test="${usuario.estado == 'ACTIVO'}">
                                <span class="chip chip-verde align-self-start">Activo</span>
                            </c:when>
                            <c:otherwise>
                                <span class="chip chip-rojo align-self-start">Inactivo</span>
                            </c:otherwise>
                        </c:choose>

                    </div>

                    <div class="p-3 d-flex flex-column gap-2 flex-grow-1">

                        <div class="d-flex justify-content-between gap-2">
                            <span class="text-secondary text-nowrap">ID de usuario</span>
                            <span class="fw-semibold">#${usuario.idUsuario}</span>
                        </div>

                        <div class="d-flex justify-content-between gap-2">
                            <span class="text-secondary text-nowrap">Fecha creación</span>
                            <span>${usuario.fechaCreacion}</span>
                        </div>

                        <div class="d-flex justify-content-between gap-2">
                            <span class="text-secondary text-nowrap">Último acceso</span>
                            <span>${usuario.fechaUltimoAcceso != null ? usuario.fechaUltimoAcceso : 'Nunca'}</span>
                        </div>

                        <hr class="my-2">

                        <span class="rotulo d-block mb-1" style="font-size: 0.8rem; font-weight: 700; color: var(--gris); text-transform: uppercase; letter-spacing: 0.05em;">
                            Gestionar rol
                        </span>

                        <form method="post"
                              action="${pageContext.request.contextPath}/admin/usuarios"
                              class="d-flex gap-2 align-items-center">

                            <input type="hidden" name="id" value="${usuario.idUsuario}">
                            <input type="hidden" name="accion" value="cambiarRol">

                            <select name="idRol" class="form-select form-select-sm flex-grow-1">
                                <c:forEach var="rol" items="${roles}">
                                    <option value="${rol.idRol}">
                                        ${rol.nombre}
                                    </option>
                                </c:forEach>
                            </select>

                            <button type="submit" class="btn btn-sm btn-contorno text-nowrap">
                                Cambiar rol
                            </button>
                        </form>

                    </div>

                    <div class="p-3 pt-0 d-flex gap-2">

                        <c:choose>

                            <c:when test="${usuario.estado == 'ACTIVO'}">

                                <form method="post"
                                      action="${pageContext.request.contextPath}/admin/usuarios"
                                      class="flex-fill">
                                    <input type="hidden" name="id" value="${usuario.idUsuario}">
                                    <input type="hidden" name="accion" value="desactivar">
                                    <button type="submit" class="btn btn-sm w-100"
                                            style="background-color: #FBE9E7; color: #C0392B; border: 1px solid #F0C4BF; font-weight: 600; border-radius: 6px;">
                                        Desactivar
                                    </button>
                                </form>

                            </c:when>

                            <c:otherwise>

                                <form method="post"
                                      action="${pageContext.request.contextPath}/admin/usuarios"
                                      class="flex-fill">
                                    <input type="hidden" name="id" value="${usuario.idUsuario}">
                                    <input type="hidden" name="accion" value="activar">
                                    <button type="submit" class="btn btn-sm w-100"
                                            style="background-color: var(--verde-suave); color: var(--verde-hover); border: 1px solid #C5DBD1; font-weight: 600; border-radius: 6px;">
                                        Activar
                                    </button>
                                </form>

                            </c:otherwise>

                        </c:choose>

                        <a href="${pageContext.request.contextPath}/admin/usuarios/perfil?id=${usuario.idUsuario}"
                           class="btn btn-sm btn-marca flex-fill">
                            Ver perfil
                        </a>

                    </div>
                </div>

            </div>

        </c:forEach>

    </div>

</main>

<%@ include file="/WEB-INF/includes/footer.jspf" %>

</body>
</html>