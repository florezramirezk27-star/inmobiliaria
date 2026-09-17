package com.inmobiliaria.web;

import com.inmobiliaria.dao.AuditoriaDAO;
import com.inmobiliaria.model.Auditoria;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/auditoria")
public class AuditoriaServlet extends HttpServlet {

    private final AuditoriaDAO auditoriaDAO = new AuditoriaDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        List<Auditoria> auditorias =
                auditoriaDAO.listarTodas();

        request.setAttribute(
                "auditorias",
                auditorias
        );

        request.getRequestDispatcher(
                "/WEB-INF/views/admin/auditoria.jsp"
        ).forward(request, response);
    }
}