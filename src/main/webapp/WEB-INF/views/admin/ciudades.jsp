<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1">

    <title>Gestionar ciudades - Inmobiliaria</title>

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

        <div class="d-flex flex-wrap
                    justify-content-between
                    align-items-center
                    gap-3">

            <div>

                <span class="badge badge-tag">
                    ADMINISTRADOR
                </span>

                <h1 class="fuente-display mt-2">
                    Gestionar ciudades
                </h1>

                <p class="descripcion">
                    Administra las ciudades disponibles
                    para las propiedades del sistema.
                </p>

            </div>

            <a
                href="${pageContext.request.contextPath}/admin/dashboard"
                class="btn btn-volver">

                &larr; Volver al panel

            </a>

        </div>

    </div>


    <!-- MENSAJE DE ÉXITO -->

    <c:if test="${not empty sessionScope.exito}">

        <div class="alert alert-success">

            ${sessionScope.exito}

        </div>

        <c:remove var="exito" scope="session"/>

    </c:if>


    <!-- MENSAJE DE ERROR -->

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

                    <c:when test="${not empty ciudadEditar}">

                        <h2 class="h4 mb-3">
                            Editar ciudad
                        </h2>

                        <form
                            method="post"
                            action="${pageContext.request.contextPath}/admin/ciudades">

                            <input
                                type="hidden"
                                name="accion"
                                value="editar">

                            <input
                                type="hidden"
                                name="id"
                                value="${ciudadEditar.id}">


                            <div class="mb-3">

                                <label
                                    class="form-label">
                                    Nombre
                                </label>

                                <input
                                    type="text"
                                    name="nombre"
                                    class="form-control"
                                    maxlength="80"
                                    required
                                    value="${ciudadEditar.nombre}">

                            </div>


                            <div class="mb-3">

                                <label
                                    class="form-label">
                                    Departamento
                                </label>

                                <input
                                    type="text"
                                    name="departamento"
                                    class="form-control"
                                    maxlength="80"
                                    required
                                    value="${ciudadEditar.departamento}">

                            </div>


                            <div class="d-flex gap-2">

                                <button
                                    type="submit"
                                    class="btn btn-marca">

                                    Guardar cambios

                                </button>

                                <a
                                    href="${pageContext.request.contextPath}/admin/ciudades"
                                    class="btn btn-contorno">

                                    Cancelar

                                </a>

                            </div>

                        </form>

                    </c:when>


                    <c:otherwise>

                        <h2 class="h4 mb-3">
                            Nueva ciudad
                        </h2>

                        <form
                            method="post"
                            action="${pageContext.request.contextPath}/admin/ciudades">

                            <input
                                type="hidden"
                                name="accion"
                                value="crear">


                            <div class="mb-3">

                                <label
                                    class="form-label">
                                    Nombre
                                </label>

                                <input
                                    type="text"
                                    name="nombre"
                                    class="form-control"
                                    maxlength="80"
                                    required
                                    placeholder="Ej: Bucaramanga">

                            </div>


                            <div class="mb-3">

                                <label
                                    class="form-label">
                                    Departamento
                                </label>

                                <input
                                    type="text"
                                    name="departamento"
                                    class="form-control"
                                    maxlength="80"
                                    required
                                    placeholder="Ej: Santander">

                            </div>


                            <button
                                type="submit"
                                class="btn btn-marca">

                                Crear ciudad

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
                            Ciudades registradas
                        </h2>

                        <span class="chip chip-azul">
                            ${fn:length(ciudades)}
                        </span>

                    </div>

                </div>


                <div class="table-responsive">

                    <table class="table tabla-tema mb-0">

                        <thead>

                        <tr>

                            <th>ID</th>

                            <th>Ciudad</th>

                            <th>Departamento</th>

                            <th class="text-end">
                                Acciones
                            </th>

                        </tr>

                        </thead>


                        <tbody>

                        <c:forEach
                            var="ciudad"
                            items="${ciudades}">

                            <tr>

                                <td>
                                    #${ciudad.id}
                                </td>

                                <td class="fw-semibold">
                                    ${ciudad.nombre}
                                </td>

                                <td>
                                    ${ciudad.departamento}
                                </td>

                                <td class="text-end">

                                    <div class="d-flex
                                                justify-content-end
                                                gap-2">

                                        <a
                                            href="${pageContext.request.contextPath}/admin/ciudades?id=${ciudad.id}"
                                            class="btn btn-sm btn-contorno">

                                            Editar

                                        </a>


                                        <form
                                            method="post"
                                            action="${pageContext.request.contextPath}/admin/ciudades"
                                            onsubmit="return confirmarEliminacion();">

                                            <input
                                                type="hidden"
                                                name="accion"
                                                value="eliminar">

                                            <input
                                                type="hidden"
                                                name="id"
                                                value="${ciudad.id}">

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


                        <c:if test="${empty ciudades}">

                            <tr>

                                <td
                                    colspan="4"
                                    class="text-center py-4">

                                    No hay ciudades registradas.

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
            "¿Está seguro de eliminar esta ciudad?"
        );

    }

</script>

</body>

</html>