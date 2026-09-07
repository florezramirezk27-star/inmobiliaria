<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <title>Reportes</title>

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">
</head>

<body>

<div class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-4">

        <h1>Reportes del sistema</h1>

        <a href="${pageContext.request.contextPath}/admin/dashboard"
           class="btn btn-secondary">
            Volver al panel
        </a>

    </div>

    <!-- REPORTE 1 -->
    <div class="card mb-4">

        <div class="card-header bg-primary text-white">
            1. Propiedades publicadas
        </div>

        <div class="card-body">

            <div class="table-responsive">

                <table class="table table-striped">

                    <thead>
                    <tr>
                        <th>Código</th>
                        <th>Título</th>
                        <th>Ciudad</th>
                        <th>Tipo</th>
                        <th>Inmobiliaria</th>
                    </tr>
                    </thead>

                    <tbody>

                    <c:forEach var="fila"
                               items="${propiedadesPublicadas}">

                        <tr>
                            <td>${fila.codigo}</td>
                            <td>${fila.titulo}</td>
                            <td>${fila.ciudad}</td>
                            <td>${fila.tipo}</td>
                            <td>${fila.inmobiliaria}</td>
                        </tr>

                    </c:forEach>

                    </tbody>

                </table>

            </div>

        </div>
    </div>


    <!-- REPORTE 2 -->
    <div class="card mb-4">

        <div class="card-header bg-success text-white">
            2. Citas activas
        </div>

        <div class="card-body">

            <div class="table-responsive">

                <table class="table table-striped">

                    <thead>
                    <tr>
                        <th>Código</th>
                        <th>Propiedad</th>
                        <th>Cliente</th>
                        <th>Fecha</th>
                        <th>Estado</th>
                    </tr>
                    </thead>

                    <tbody>

                    <c:forEach var="fila"
                               items="${citasActivas}">

                        <tr>
                            <td>${fila.codigo}</td>
                            <td>${fila.titulo}</td>

                            <td>
                                ${fila.cliente_nombre}
                                ${fila.cliente_apellido}
                            </td>

                            <td>${fila.fecha_hora}</td>

                            <td>
                                <span class="badge bg-success">
                                    ${fila.estado}
                                </span>
                            </td>
                        </tr>

                    </c:forEach>

                    </tbody>

                </table>

            </div>

        </div>
    </div>


    <!-- REPORTE 3 -->
    <div class="card mb-4">

        <div class="card-header bg-info">
            3. Características de una propiedad
        </div>

        <div class="card-body">

            <form method="get"
                  action="${pageContext.request.contextPath}/admin/reportes"
                  class="row g-3 mb-4">

                <div class="col-md-8">

                    <label class="form-label">
                        ID de la propiedad
                    </label>

                    <input type="number"
                           name="idPropiedad"
                           class="form-control"
                           min="1"
                           value="${idPropiedadSeleccionada}"
                           required>

                </div>

                <div class="col-md-4 d-flex align-items-end">

                    <button type="submit"
                            class="btn btn-info w-100">
                        Consultar características
                    </button>

                </div>

            </form>

            <div class="table-responsive">

                <table class="table table-striped">

                    <thead>
                    <tr>
                        <th>Código</th>
                        <th>Propiedad</th>
                        <th>Característica</th>
                        <th>Categoría</th>
                        <th>Cantidad</th>
                    </tr>
                    </thead>

                    <tbody>

                    <c:forEach var="fila"
                               items="${caracteristicasPropiedad}">

                        <tr>

                            <td>${fila.codigo}</td>

                            <td>${fila.titulo}</td>

                            <td>${fila.caracteristica}</td>

                            <td>${fila.categoria}</td>

                            <td>${fila.cantidad}</td>

                        </tr>

                    </c:forEach>

                    <c:if test="${empty caracteristicasPropiedad}">

                        <tr>
                            <td colspan="5"
                                class="text-center">

                                No se encontraron características
                                para esta propiedad.

                            </td>
                        </tr>

                    </c:if>

                    </tbody>

                </table>

            </div>

        </div>
    </div>


    <!-- REPORTE 4 -->
    <div class="card mb-4">

        <div class="card-header bg-warning">
            4. Propiedades publicadas sin citas
        </div>

        <div class="card-body">

            <div class="table-responsive">

                <table class="table table-striped">

                    <thead>
                    <tr>
                        <th>Código</th>
                        <th>Título</th>
                        <th>Dirección</th>
                        <th>Ciudad</th>
                    </tr>
                    </thead>

                    <tbody>

                    <c:forEach var="fila"
                               items="${propiedadesSinCitas}">

                        <tr>
                            <td>${fila.codigo}</td>
                            <td>${fila.titulo}</td>
                            <td>${fila.direccion}</td>
                            <td>${fila.ciudad}</td>
                        </tr>

                    </c:forEach>

                    </tbody>

                </table>

            </div>

        </div>
    </div>


    <!-- REPORTE 5 -->
    <div class="card mb-4">

        <div class="card-header bg-dark text-white">
            5. Resumen por ciudad
        </div>

        <div class="card-body">

            <div class="table-responsive">

                <table class="table table-striped">

                    <thead>
                    <tr>
                        <th>Ciudad</th>
                        <th>Total publicadas</th>
                        <th>Precio promedio</th>
                    </tr>
                    </thead>

                    <tbody>

                    <c:forEach var="fila"
                               items="${resumenPorCiudad}">

                        <tr>
                            <td>${fila.ciudad}</td>
                            <td>${fila.total_publicadas}</td>
                            <td>${fila.precio_promedio}</td>
                        </tr>

                    </c:forEach>

                    </tbody>

                </table>

            </div>

        </div>
    </div>

</div>

</body>
</html>