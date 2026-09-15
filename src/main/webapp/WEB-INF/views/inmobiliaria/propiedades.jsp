<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1">

    <title>Mis propiedades - Inmobiliaria</title>

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
                    AGENTE
                </span>

                <h1 class="fuente-display mt-2">
                    Mis propiedades
                </h1>

                <p class="descripcion">
                    Consulta el estado de cada propiedad y
                    da de baja las que ya no quieras ofrecer.
                </p>

            </div>

            <a
                href="${pageContext.request.contextPath}/inmobiliaria/dashboard"
                class="btn btn-volver">

                &larr; Volver al panel

            </a>

        </div>

    </div>


    <!-- ÉXITO -->

    <c:if test="${not empty sessionScope.exito}">

        <div class="alert alert-success">

            ${sessionScope.exito}

        </div>

        <c:remove var="exito" scope="session"/>

    </c:if>


    <!-- ERROR -->

    <c:if test="${not empty error or not empty sessionScope.error}">

        <c:choose>

            <c:when test="${not empty error}">

                <div class="alert alert-danger">
                    ${error}
                </div>

            </c:when>

            <c:otherwise>

                <div class="alert alert-danger">
                    ${sessionScope.error}
                </div>

                <c:remove var="error" scope="session"/>

            </c:otherwise>

        </c:choose>

    </c:if>


    <div class="tarjeta-prop">

        <div class="p-4 border-bottom
                    d-flex flex-wrap
                    justify-content-between
                    align-items-center gap-3">

            <div>

                <h2 class="h4 mb-1">
                    Listado de propiedades
                </h2>

                <p class="medida mb-0">
                    <span class="badge chip-gris">
                        ${fn:length(propiedades)} en total
                    </span>
                </p>

            </div>

            <a
                href="${pageContext.request.contextPath}/inmobiliaria/propiedades/formulario"
                class="btn btn-marca">

                + Publicar propiedad

            </a>

        </div>

        <c:choose>

            <c:when test="${not empty propiedades}">

                <div class="table-responsive">

                    <table class="table tabla-tema mb-0">

                        <thead>

                        <tr>
                            <th>Código</th>
                            <th>Propiedad</th>
                            <th>Operación</th>
                            <th>Ciudad</th>
                            <th>Estado</th>
                            <th class="text-end">Acciones</th>
                        </tr>

                        </thead>

                        <tbody>

                        <c:forEach var="p" items="${propiedades}">

                            <tr>

                                <td class="align-middle">
                                    <span class="badge chip-gris">
                                        #${p.codigo}
                                    </span>
                                </td>

                                <td class="align-middle">
                                    <a
                                        class="fw-semibold"
                                        href="${pageContext.request.contextPath}/propiedades/detalle?id=${p.id}">
                                        ${p.titulo}
                                    </a>
                                </td>

                                <td class="align-middle">
                                    ${p.operacion.etiqueta}
                                </td>

                                <td class="align-middle">
                                    ${p.ciudadNombre}
                                </td>

                                <td class="align-middle">
                                    <c:choose>
                                        <c:when test="${p.estado == 'PUBLICADA'}">
                                            <span class="chip chip-verde">${p.estado.etiqueta}</span>
                                        </c:when>
                                        <c:when test="${p.estado == 'BORRADOR'}">
                                            <span class="chip chip-gris">${p.estado.etiqueta}</span>
                                        </c:when>
                                        <c:when test="${p.estado == 'RESERVADA'}">
                                            <span class="chip chip-ocre">${p.estado.etiqueta}</span>
                                        </c:when>
                                        <c:when test="${p.estado == 'CERRADA'}">
                                            <span class="chip chip-rojo">${p.estado.etiqueta}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="chip chip-gris">${p.estado}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <td class="align-middle text-end">

                                    <div class="d-flex
                                                flex-wrap
                                                justify-content-end
                                                gap-2">

                                        <a
                                            class="btn btn-sm btn-contorno"
                                            href="${pageContext.request.contextPath}/inmobiliaria/propiedades/formulario?id=${p.id}">
                                            Editar
                                        </a>

                                        <c:if test="${p.estado ne 'CERRADA'}">

                                            <form
                                                method="post"
                                                action="${pageContext.request.contextPath}/inmobiliaria/propiedades"
                                                onsubmit="return confirmarBaja();">

                                                <input type="hidden" name="accion" value="darDeBaja">
                                                <input type="hidden" name="id" value="${p.id}">

                                                <button
                                                    type="submit"
                                                    class="btn btn-sm btn-warning">
                                                    Dar de baja
                                                </button>

                                            </form>

                                        </c:if>

                                    </div>

                                </td>

                            </tr>

                        </c:forEach>

                        </tbody>

                    </table>

                </div>

            </c:when>

            <c:otherwise>

                <div class="p-5 text-center">
                    <p class="m-0">
                        Todavía no tienes propiedades registradas.
                    </p>
                    <a
                        class="btn btn-marca mt-3"
                        href="${pageContext.request.contextPath}/inmobiliaria/propiedades/formulario">
                        Publicar una propiedad
                    </a>
                </div>

            </c:otherwise>

        </c:choose>

    </div>

</main>

<%@ include file="/WEB-INF/includes/footer.jspf" %>

<script>

    function confirmarBaja() {
        const mensaje =
            "¿Dar de baja esta propiedad?\n\n" +
            "Pasará a estado CERRADA y dejará de mostrarse " +
            "en el catálogo público. Esta acción se registra " +
            "en la auditoría.";
        return window.confirm(mensaje);
    }

</script>

</body>
</html>