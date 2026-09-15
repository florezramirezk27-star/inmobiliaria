<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1">

    <title>Tipos de propiedad - Inmobiliaria</title>

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <link
        rel="stylesheet"
        href="${pageContext.request.contextPath}/css/estilos.css">

</head>

<body>

<%@ include file="/WEB-INF/includes/navbar.jspf" %>

<main class="container py-5">

    <div class="banner-panel mb-4">

        <div class="d-flex
                    flex-wrap
                    justify-content-between
                    align-items-center
                    gap-3">

            <div>

                <span class="badge badge-tag">
                    ADMINISTRADOR
                </span>

                <h1 class="fuente-display mt-2">
                    Tipos de propiedad
                </h1>

                <p class="descripcion">
                    Administra las categorías de inmuebles
                    disponibles en el sistema.
                </p>

            </div>

            <a
                href="${pageContext.request.contextPath}/admin/dashboard"
                class="btn btn-banner">

                &larr; Volver al panel

            </a>

        </div>

    </div>


    <c:if test="${not empty sessionScope.exito}">

        <div class="alert alert-success">

            ${sessionScope.exito}

        </div>

        <c:remove var="exito" scope="session"/>

    </c:if>


    <c:if test="${not empty sessionScope.error}">

        <div class="alert alert-danger">

            ${sessionScope.error}

        </div>

        <c:remove var="error" scope="session"/>

    </c:if>


    <div class="row g-4">


        <!-- FORMULARIO -->

        <div class="col-lg-4">

            <div class="tarjeta-prop p-4">

                <c:choose>

                    <c:when test="${not empty tipoEditar}">

                        <h2 class="h4 mb-3">
                            Editar tipo
                        </h2>

                        <form
                            method="post"
                            action="${pageContext.request.contextPath}/admin/tipos-propiedad">

                            <input
                                type="hidden"
                                name="accion"
                                value="editar">

                            <input
                                type="hidden"
                                name="id"
                                value="${tipoEditar.idTipo}">


                            <div class="mb-3">

                                <label class="form-label">
                                    Nombre
                                </label>

                                <input
                                    type="text"
                                    name="nombre"
                                    class="form-control"
                                    maxlength="60"
                                    required
                                    value="${tipoEditar.nombre}">

                            </div>


                            <div class="mb-3">

                                <label class="form-label">
                                    Descripción
                                </label>

                                <textarea
                                    name="descripcion"
                                    class="form-control"
                                    rows="4"
                                    maxlength="255">${tipoEditar.descripcion}</textarea>

                            </div>


                            <div class="d-flex gap-2">

                                <button
                                    type="submit"
                                    class="btn btn-marca">

                                    Guardar cambios

                                </button>

                                <a
                                    href="${pageContext.request.contextPath}/admin/tipos-propiedad"
                                    class="btn btn-contorno">

                                    Cancelar

                                </a>

                            </div>

                        </form>

                    </c:when>


                    <c:otherwise>

                        <h2 class="h4 mb-3">
                            Nuevo tipo
                        </h2>

                        <form
                            method="post"
                            action="${pageContext.request.contextPath}/admin/tipos-propiedad">

                            <input
                                type="hidden"
                                name="accion"
                                value="crear">


                            <div class="mb-3">

                                <label class="form-label">
                                    Nombre
                                </label>

                                <input
                                    type="text"
                                    name="nombre"
                                    class="form-control"
                                    maxlength="60"
                                    required
                                    placeholder="Ej: Apartamento">

                            </div>


                            <div class="mb-3">

                                <label class="form-label">
                                    Descripción
                                </label>

                                <textarea
                                    name="descripcion"
                                    class="form-control"
                                    rows="4"
                                    maxlength="255"
                                    placeholder="Descripción del tipo de inmueble"></textarea>

                            </div>


                            <button
                                type="submit"
                                class="btn btn-marca">

                                Crear tipo

                            </button>

                        </form>

                    </c:otherwise>

                </c:choose>

            </div>

        </div>


        <!-- LISTADO -->

        <div class="col-lg-8">

            <div class="tarjeta-prop">

                <div class="p-4 border-bottom">

                    <div class="d-flex
                                justify-content-between
                                align-items-center">

                        <h2 class="h4 mb-0">
                            Tipos registrados
                        </h2>

                        <span class="chip chip-azul">
                            ${fn:length(tipos)}
                        </span>

                    </div>

                </div>


                <div class="table-responsive">

                    <table class="table tabla-tema mb-0">

                        <thead>

                        <tr>

                            <th>ID</th>

                            <th>Nombre</th>

                            <th>Descripción</th>

                            <th class="text-end">
                                Acciones
                            </th>

                        </tr>

                        </thead>


                        <tbody>

                        <c:forEach
                            var="tipo"
                            items="${tipos}">

                            <tr>

                                <td>
                                    #${tipo.idTipo}
                                </td>

                                <td class="fw-semibold">
                                    ${tipo.nombre}
                                </td>

                                <td>
                                    ${tipo.descripcion}
                                </td>

                                <td class="text-end">

                                    <div class="d-flex
                                                justify-content-end
                                                gap-2">

                                        <a
                                            href="${pageContext.request.contextPath}/admin/tipos-propiedad?id=${tipo.idTipo}"
                                            class="btn btn-sm btn-contorno">

                                            Editar

                                        </a>


                                        <form
                                            method="post"
                                            action="${pageContext.request.contextPath}/admin/tipos-propiedad"
                                            onsubmit="return confirmarEliminacion();">

                                            <input
                                                type="hidden"
                                                name="accion"
                                                value="eliminar">

                                            <input
                                                type="hidden"
                                                name="id"
                                                value="${tipo.idTipo}">

                                            <button
                                                type="submit"
                                                class="btn btn-sm btn-danger">

                                                Eliminar

                                            </button>

                                        </form>

                                    </div>

                                </td>

                            </tr>

                        </c:forEach>


                        <c:if test="${empty tipos}">

                            <tr>

                                <td
                                    colspan="4"
                                    class="text-center py-4">

                                    No hay tipos registrados.

                                </td>

                            </tr>

                        </c:if>

                        </tbody>

                    </table>

                </div>

            </div>

        </div>

    </div>

</main>

<%@ include file="/WEB-INF/includes/footer.jspf" %>


<script>

    function confirmarEliminacion() {

        return confirm(
            "¿Está seguro de eliminar este tipo de propiedad?"
        );

    }

</script>

</body>

</html>