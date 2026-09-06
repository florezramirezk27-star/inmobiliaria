package com.inmobiliaria.web;

import com.inmobiliaria.dao.PerfilDAO;
import com.inmobiliaria.model.Perfil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/cliente/perfil")
public class PerfilServlet extends HttpServlet {

    private PerfilDAO perfilDAO;

    @Override
    public void init() throws ServletException {
        perfilDAO = new PerfilDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("usuarioId") == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login"
            );
            return;
        }

        int idUsuario = (int) session.getAttribute("usuarioId");

        Perfil perfil = perfilDAO.buscarPorUsuario(idUsuario);

        request.setAttribute("perfil", perfil);

        request.getRequestDispatcher(
                "/WEB-INF/views/cliente/perfil.jsp"
        ).forward(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("usuarioId") == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login"
            );
            return;
        }

        int idUsuario = (int) session.getAttribute("usuarioId");

        Perfil perfil = new Perfil();

        perfil.setIdUsuario(idUsuario);
        perfil.setNombres(request.getParameter("nombres"));
        perfil.setApellidos(request.getParameter("apellidos"));
        perfil.setDocumento(request.getParameter("documento"));
        perfil.setTelefono(request.getParameter("telefono"));
        perfil.setDireccion(request.getParameter("direccion"));
        perfil.setFoto(request.getParameter("foto"));

        try {

            perfilDAO.actualizarPerfil(perfil);

            response.sendRedirect(
                    request.getContextPath()
                            + "/cliente/perfil?actualizado=true"
            );

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "error",
                    "No fue posible actualizar el perfil."
            );

            request.setAttribute("perfil", perfil);

            request.getRequestDispatcher(
                    "/WEB-INF/views/cliente/perfil.jsp"
            ).forward(request, response);
        }
    }
}