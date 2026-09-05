<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>
<%@ page import="com.inmobiliaria.model.Solicitud" %>

<%
    List<Solicitud> solicitudes =
            (List<Solicitud>) request.getAttribute("solicitudes");
%>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Solicitudes</title>

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

</head>

<body>

<div class="container py-5">

    <h1>Solicitudes de mis propiedades</h1>

    <% if (request.getAttribute("error") != null) { %>

        <div class="alert alert-danger">
            <%= request.getAttribute("error") %>
        </div>

    <% } %>

    <% if (solicitudes == null || solicitudes.isEmpty()) { %>

        <div class="alert alert-info">
            No hay solicitudes actualmente.
        </div>

    <% } else { %>

        <div class="table-responsive">

            <table class="table table-bordered table-striped">

                <thead>

                <tr>

                    <th>ID</th>
                    <th>Cliente</th>
                    <th>Propiedad</th>
                    <th>Tipo</th>
                    <th>Estado</th>
                    <th>Acciones</th>

                </tr>

                </thead>

                <tbody>

                <% for (Solicitud solicitud : solicitudes) { %>

                    <tr>

                        <td>
                            <%= solicitud.getId() %>
                        </td>

                        <td>
                            <%= solicitud.getClienteId() %>
                        </td>

                        <td>
                            <%= solicitud.getPropiedadId() %>
                        </td>

                        <td>
                            <%= solicitud.getTipo().getEtiqueta() %>
                        </td>

                        <td>
                            <%= solicitud.getEstado().getEtiqueta() %>
                        </td>

                        <td>

                            <form
                                method="post"
                                action="${pageContext.request.contextPath}/inmobiliaria/solicitudes"
                                class="d-inline">

                                <input
                                    type="hidden"
                                    name="id"
                                    value="<%= solicitud.getId() %>">

                                <input
                                    type="hidden"
                                    name="estado"
                                    value="APROBADA">

                                <button
                                    type="submit"
                                    class="btn btn-success btn-sm">

                                    Aprobar

                                </button>

                            </form>

                            <form
                                method="post"
                                action="${pageContext.request.contextPath}/inmobiliaria/solicitudes"
                                class="d-inline">

                                <input
                                    type="hidden"
                                    name="id"
                                    value="<%= solicitud.getId() %>">

                                <input
                                    type="hidden"
                                    name="estado"
                                    value="RECHAZADA">

                                <button
                                    type="submit"
                                    class="btn btn-danger btn-sm">

                                    Rechazar

                                </button>

                            </form>

                        </td>

                    </tr>

                <% } %>

                </tbody>

            </table>

        </div>

    <% } %>

</div>

</body>

</html>
