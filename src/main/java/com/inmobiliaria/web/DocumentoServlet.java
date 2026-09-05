package com.inmobiliaria.web;

import com.inmobiliaria.dao.DocumentoDAO;
import com.inmobiliaria.model.Documento;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.SQLException;
import java.util.Set;
import java.util.UUID;

/**
 * Subida y eliminación de documentos adjuntos a una solicitud.
 *
 * GET /cliente/solicitudes/documentos?solicitudId=3   -> listado de los documentos de la solicitud 3
 * GET /cliente/solicitudes/documentos?id=7            -> descarga el documento 7
 * POST /cliente/solicitudes/documentos?solicitudId=3  -> sube un archivo nuevo a la solicitud 3
 *
 * Solo la fila de la base de datos viaja por el DAO; el archivo físico se
 * guarda y se borra aquí, en el servlet, igual que hace
 * PropiedadFormServlet con las imágenes (ver su advertencia sobre la
 * carpeta real del WAR y los redeploys).
 */
@WebServlet("/cliente/solicitudes/documentos")
@MultipartConfig(
        maxFileSize = 10L * 1024 * 1024,      // 10 MB por archivo
        maxRequestSize = 30L * 1024 * 1024,   // 30 MB por envío completo
        fileSizeThreshold = 0
)
public class DocumentoServlet extends HttpServlet {

    private static final Set<String> TIPOS_MIME_PERMITIDOS = Set.of(
            "application/pdf",
            "image/jpeg",
            "image/png",
            "application/msword",
            "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    );

    private final DocumentoDAO documentoDAO = new DocumentoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idDocumento = request.getParameter("id");
        if (idDocumento != null && !idDocumento.isBlank()) {
            descargarDocumento(request, response);
            return;
        }

        String solicitudId = request.getParameter("solicitudId");
        if (solicitudId == null || solicitudId.isBlank()) {
            request.setAttribute("error", "Indica la solicitud de la que quieres ver los documentos.");
            request.getRequestDispatcher("/WEB-INF/views/cliente/documentos.jsp")
                    .forward(request, response);
            return;
        }

        try {
            int idSolicitud = Integer.parseInt(solicitudId.trim());
            request.setAttribute("solicitudId", idSolicitud);
            request.setAttribute("documentos", documentoDAO.listarPorSolicitud(idSolicitud));
        } catch (SQLException e) {
            getServletContext().log("Error al listar los documentos de la solicitud", e);
            request.setAttribute("error",
                    "No fue posible cargar los documentos en este momento. Intenta de nuevo en unos minutos.");
        } catch (NumberFormatException e) {
            request.setAttribute("error", "El identificador de la solicitud no es válido.");
        }

        request.getRequestDispatcher("/WEB-INF/views/cliente/documentos.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String solicitudId = request.getParameter("solicitudId");
        if (solicitudId == null || solicitudId.isBlank()) {
            request.setAttribute("error", "Indica la solicitud a la que quieres adjuntar el documento.");
            request.getRequestDispatcher("/WEB-INF/views/cliente/documentos.jsp")
                    .forward(request, response);
            return;
        }

        int idSolicitud;
        try {
            idSolicitud = Integer.parseInt(solicitudId.trim());
        } catch (NumberFormatException e) {
            request.setAttribute("error", "El identificador de la solicitud no es válido.");
            request.getRequestDispatcher("/WEB-INF/views/cliente/documentos.jsp")
                    .forward(request, response);
            return;
        }

        Part parte;
        try {
            parte = request.getPart("archivo");
        } catch (ServletException | IOException e) {
            getServletContext().log("No se pudo leer el archivo subido", e);
            request.setAttribute("error", "No se pudo leer el archivo enviado.");
            request.getRequestDispatcher("/WEB-INF/views/cliente/documentos.jsp")
                    .forward(request, response);
            return;
        }

        try {
            guardarDocumento(request, idSolicitud, parte);
            response.sendRedirect(request.getContextPath()
                    + "/cliente/solicitudes/documentos?solicitudId=" + idSolicitud + "&subido=1");

        } catch (SQLException | IOException e) {
            getServletContext().log("Error al guardar el documento", e);
            request.setAttribute("error",
                    "No fue posible guardar el documento en este momento. Intenta de nuevo en unos minutos.");
            request.setAttribute("solicitudId", idSolicitud);
            request.getRequestDispatcher("/WEB-INF/views/cliente/documentos.jsp")
                    .forward(request, response);
        }
    }

    // ============================================================
    // Apoyo interno
    // ============================================================

    private void guardarDocumento(HttpServletRequest request, int solicitudId, Part parte)
            throws IOException, SQLException {

        String nombreOriginal = parte.getSubmittedFileName();
        if (nombreOriginal == null || nombreOriginal.isBlank() || parte.getSize() == 0) {
            request.setAttribute("error", "Selecciona un archivo para subir.");
            return;
        }

        String tipoMime = parte.getContentType();
        if (tipoMime == null || !TIPOS_MIME_PERMITIDOS.contains(tipoMime.toLowerCase())) {
            request.setAttribute("error", "El tipo de archivo no está permitido. Sube un PDF, imagen o documento de Word.");
            return;
        }

        String extension = extensionSegura(nombreOriginal);
        String nombreArchivo = "doc-" + solicitudId + "-" + UUID.randomUUID() + extension;

        Path carpetaDestino = carpetaDeDocumentos(solicitudId);
        Files.createDirectories(carpetaDestino);
        Path archivoDestino = carpetaDestino.resolve(nombreArchivo);

        try (InputStream in = parte.getInputStream()) {
            Files.copy(in, archivoDestino, StandardCopyOption.REPLACE_EXISTING);
        }

        Documento documento = new Documento();
        documento.setSolicitudId(solicitudId);
        documento.setNombreArchivo(nombreOriginal);
        documento.setRuta("docs/solicitudes/" + solicitudId + "/" + nombreArchivo);

        documentoDAO.insertar(documento);
    }

    private void descargarDocumento(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String idParam = request.getParameter("id");

        try {
            int idDocumento = Integer.parseInt(idParam.trim());
            Documento documento = documentoDAO.buscarPorId(idDocumento);

            if (documento == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "El documento no existe.");
                return;
            }

            String realPath = getServletContext().getRealPath("/" + documento.getRuta());
            if (realPath == null || !Files.exists(Paths.get(realPath))) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "El archivo físico no está disponible.");
                return;
            }

            response.setContentType("application/octet-stream");
            response.setHeader("Content-Disposition",
                    "attachment; filename=\"" + documento.getNombreArchivo() + "\"");
            Files.copy(Paths.get(realPath), response.getOutputStream());

        } catch (SQLException e) {
            getServletContext().log("Error al descargar el documento", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "El identificador del documento no es válido.");
        }
    }

    private Path carpetaDeDocumentos(int solicitudId) {
        String real = getServletContext().getRealPath("/docs/solicitudes/" + solicitudId);
        return Paths.get(real);
    }

    private String extensionSegura(String nombreOriginal) {
        int punto = nombreOriginal.lastIndexOf('.');
        if (punto == -1) {
            return ".dat";
        }
        String ext = nombreOriginal.substring(punto).toLowerCase();
        return switch (ext) {
            case ".pdf", ".jpg", ".jpeg", ".png", ".doc", ".docx" -> ext;
            default -> ".dat";
        };
    }
}
