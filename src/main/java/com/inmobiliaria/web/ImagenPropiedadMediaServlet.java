package com.inmobiliaria.web;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Locale;
import java.util.regex.Pattern;

@WebServlet("/media/propiedades/*")
public class ImagenPropiedadMediaServlet extends HttpServlet {

    private static final Pattern NOMBRE_PERMITIDO =
            Pattern.compile(
                    "prop-[1-9][0-9]*-"
                            + "[0-9a-fA-F]{8}-"
                            + "[0-9a-fA-F]{4}-"
                            + "[0-9a-fA-F]{4}-"
                            + "[0-9a-fA-F]{4}-"
                            + "[0-9a-fA-F]{12}"
                            + "\\.(jpg|png|webp)",
                    Pattern.CASE_INSENSITIVE
            );

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        String pathInfo = request.getPathInfo();

        if (pathInfo == null
                || pathInfo.length() < 2
                || pathInfo.indexOf('/', 1) >= 0
                || pathInfo.contains("\\")
                || pathInfo.contains("..")) {

            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String nombreArchivo = pathInfo.substring(1);

        if (!NOMBRE_PERMITIDO.matcher(nombreArchivo).matches()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        Path carpeta = carpetaDeImagenes();
        Path archivo =
                carpeta.resolve(nombreArchivo).normalize();

        if (!archivo.getParent().equals(carpeta)
                || !Files.isRegularFile(archivo)) {

            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        response.setContentType(tipoContenido(nombreArchivo));
        response.setHeader("X-Content-Type-Options", "nosniff");
        response.setHeader(
                "Cache-Control",
                "public, max-age=86400"
        );
        response.setContentLengthLong(Files.size(archivo));

        Files.copy(
                archivo,
                response.getOutputStream()
        );
    }

    private Path carpetaDeImagenes() throws IOException {

        String catalinaBase =
                System.getProperty("catalina.base");

        if (catalinaBase == null
                || catalinaBase.isBlank()) {
            throw new IOException(
                    "No esta definida la propiedad del sistema catalina.base."
            );
        }

        return Path.of(
                catalinaBase,
                "inmobiliaria-data",
                "imagenes",
                "propiedades"
        ).toAbsolutePath().normalize();
    }

    private String tipoContenido(String nombreArchivo) {

        String nombre =
                nombreArchivo.toLowerCase(Locale.ROOT);

        if (nombre.endsWith(".png")) {
            return "image/png";
        }

        if (nombre.endsWith(".webp")) {
            return "image/webp";
        }

        return "image/jpeg";
    }
}
