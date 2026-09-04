package com.inmobiliaria.web;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;

import java.io.IOException;

/**
 * Fuerza UTF-8 en cada petición y respuesta de toda la aplicación.
 *
 * Se detectó probando el formulario de propiedades con datos reales:
 * sin esto, cualquier campo de texto enviado por POST con tildes o
 * eñes llega corrupto al servlet ("características" se guarda en la
 * base de datos como "caracterÃsticas"). La causa es que Tomcat
 * decodifica los parámetros del request con Latin-1 por defecto si
 * nadie le indica lo contrario, y hay que hacerlo ANTES de la primera
 * llamada a getParameter()/getPart() de cada request — por eso es un
 * Filter y no un ajuste dentro de cada servlet: así ningún servlet
 * nuevo (de cualquiera de los dos, propiedades o autenticación) puede
 * olvidarse de este paso.
 *
 * Es un problema aparte y distinto del que se corrigió en web.xml
 * para los archivos *.jspf (ese era sobre cómo Tomcat LEE el código
 * fuente de las vistas; este es sobre cómo decodifica los DATOS que
 * llegan del navegador en cada petición).
 */
@WebFilter("/*")
public class CodificacionFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) {
        // sin configuración que cargar
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // nada que liberar
    }
}
