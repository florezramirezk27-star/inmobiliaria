<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <title>Auditoría</title>

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">
</head>

<body>

<div class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-4">

        <h1>Auditoría del sistema</h1>

        <a href="${pageContext.request.contextPath}/admin/dashboard"
           class="btn btn-secondary">
            Volver
        </a>

    </div>

    <div class="table-responsive">

        <table class="table table-striped table-bordered">

            <thead class="table-dark">

            <tr>
                <th>ID</th>
                <th>Usuario</th>
                <th>Acción</th>
                <th>Tabla</th>
                <th>ID registro</th>
                <th>Detalle</th>
                <th>Fecha</th>
            </tr>

            </thead>

            <tbody>

            <c:forEach var="auditoria"
                       items="${auditorias}">

                <tr>

                    <td>${auditoria.idAuditoria}</td>

                    <td>
                        ${auditoria.idUsuario != null
                            ? auditoria.idUsuario
                            : 'Sistema'}
                    </td>

                    <td>
                        <span class="badge bg-primary">
                            ${auditoria.accion}
                        </span>
                    </td>

                    <td>
                        ${auditoria.tablaAfectada}
                    </td>

                    <td>
                        ${auditoria.idRegistro != null
                            ? auditoria.idRegistro
                            : '-'}
                    </td>

                    <td>
                        ${auditoria.detalle}
                    </td>

                    <td>
                        ${auditoria.creadoEn}
                    </td>

                </tr>

            </c:forEach>

            </tbody>

        </table>

    </div>

</div>

</body>
</html>