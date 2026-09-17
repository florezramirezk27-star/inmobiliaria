<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Solicitudes — Inmobiliaria</title>

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
            <h1 class="fuente-display mb-1">Solicitudes recibidas</h1>
            <p class="descripcion mb-0">Aprueba o rechaza las solicitudes sobre tus propiedades.</p>
        </div>
        <a href="${pageContext.request.contextPath}/inmobiliaria/dashboard" class="btn btn-volver">
            Volver al panel
        </a>
    </div>

    <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger" role="alert">
            <%= request.getAttribute("error") %>
        </div>
    <% } %>

    <% if (solicitudes == null || solicitudes.isEmpty()) { %>

        <div class="sin-resultados">
            <span class="sin-resultados-icono"><i class="bi bi-inbox"></i></span>
            <h3>No hay solicitudes por ahora</h3>
            <p>Cuando un cliente solicite una de tus propiedades, aparecerá aquí.</p>
            <a class="btn btn-volver" href="${pageContext.request.contextPath}/inmobiliaria/dashboard">
                Volver al panel
            </a>
        </div>

    <% } else { %>

        <div class="tabla-scroll">

            <table class="table tabla-tema mb-0">

                <thead>
                <tr>
                    <th>ID</th>
                    <th>Cliente</th>
                    <th>Propiedad</th>
                    <th>Tipo</th>
                    <th>Estado</th>
                    <th class="text-end">Acciones</th>
                </tr>
                </thead>

                <tbody>

                <% for (Solicitud solicitud : solicitudes) {
                       String estado = solicitud.getEstado().name();
                       String claseChip = "chip-gris";
                       if ("APROBADA".equals(estado))         claseChip = "chip-verde";
                       else if ("RECHAZADA".equals(estado))   claseChip = "chip-rojo";
                       else if ("PENDIENTE".equals(estado))   claseChip = "chip-ocre";
                       else if ("EN_REVISION".equals(estado)) claseChip = "chip-azul";
                %>

                    <tr>
                        <td class="fw-semibold">#<%= solicitud.getId() %></td>
                        <td><%= solicitud.getClienteId() %></td>
                        <td><%= solicitud.getPropiedadId() %></td>
                        <td><%= solicitud.getTipo().getEtiqueta() %></td>

                        <td>
                            <span class="chip <%= claseChip %>">
                                <%= solicitud.getEstado().getEtiqueta() %>
                            </span>
                        </td>

                        <td class="text-end">

                            <div class="d-inline-flex gap-2">

                                <a href="${pageContext.request.contextPath}/inmobiliaria/solicitudes/documentos?solicitudId=<%= solicitud.getId() %>"
                                   class="btn btn-contorno"
                                   style="min-height:38px; padding:0 .9rem; font-size:.8125rem;"
                                   title="Ver documentos de esta solicitud">
                                    <i class="bi bi-folder2-open" aria-hidden="true"></i>
                                    Documentos
                                </a>

                                <form method="post"
                                      action="${pageContext.request.contextPath}/inmobiliaria/solicitudes"
                                      class="d-inline">
                                    <input type="hidden" name="id" value="<%= solicitud.getId() %>">
                                    <input type="hidden" name="estado" value="APROBADA">
                                    <button type="submit" class="btn btn-marca"
                                            style="min-height:38px; padding:0 .9rem; font-size:.8125rem;">
                                        Aprobar
                                    </button>
                                </form>

                                <form method="post"
                                      action="${pageContext.request.contextPath}/inmobiliaria/solicitudes"
                                      class="d-inline">
                                    <input type="hidden" name="id" value="<%= solicitud.getId() %>">
                                    <input type="hidden" name="estado" value="RECHAZADA">
                                    <button type="submit" class="btn btn-peligro"
                                            style="min-height:38px; padding:0 .9rem; font-size:.8125rem;">
                                        Rechazar
                                    </button>
                                </form>

                            </div>

                        </td>
                    </tr>

                <% } %>

                </tbody>

            </table>

        </div>

    <% } %>

</main>

<%@ include file="/WEB-INF/includes/footer.jspf" %>

</body>
</html>
