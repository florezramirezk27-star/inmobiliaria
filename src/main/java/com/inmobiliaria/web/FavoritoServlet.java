package com.inmobiliaria.web;

import com.inmobiliaria.dao.FavoritoDAO;
import com.inmobiliaria.model.Favorito;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/cliente/favoritos")
public class FavoritoServlet extends HttpServlet {

    private FavoritoDAO favoritoDAO;

    @Override
    public void init() throws ServletException {
        favoritoDAO = new FavoritoDAO();
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

        int idUsuario =
                (int) session.getAttribute("usuarioId");

        request.setAttribute(
                "favoritos",
                favoritoDAO.listarPorUsuario(idUsuario)
        );

        request.getRequestDispatcher(
                "/WEB-INF/views/cliente/favoritos.jsp"
        ).forward(request, response);
    }

    @Override
    protected void doPost(
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

        int idUsuario =
                (int) session.getAttribute("usuarioId");

        String accion = request.getParameter("accion");
        String idPropiedadParametro =
                request.getParameter("idPropiedad");

        if (idPropiedadParametro == null) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/cliente/favoritos"
            );
            return;
        }

        int idPropiedad =
                Integer.parseInt(idPropiedadParametro);

        if ("agregar".equalsIgnoreCase(accion)) {

            if (!favoritoDAO.existe(idUsuario, idPropiedad)) {

                Favorito favorito = new Favorito();

                favorito.setIdUsuario(idUsuario);
                favorito.setIdPropiedad(idPropiedad);

                favoritoDAO.agregar(favorito);
            }

        } else if ("eliminar".equalsIgnoreCase(accion)) {

            favoritoDAO.eliminar(
                    idUsuario,
                    idPropiedad
            );
        }

        response.sendRedirect(
                request.getContextPath()
                        + "/cliente/favoritos"
        );
    }
}