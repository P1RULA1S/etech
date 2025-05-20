<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.productos.datos.conexion, com.productos.seguridad.usuarios, java.sql.*" %>
<%
    conexion con = null;
    String mensaje = "";
    String redirectPage = "cambioClave.jsp";

    try {
        request.setCharacterEncoding("UTF-8");
        con = new conexion();
        
        String correo = (String) session.getAttribute("email");
        String claveActual = request.getParameter("txtClaveActual");
        String claveNueva = request.getParameter("txtClaveNueva");
        String repetirClave = request.getParameter("txtRepetirClave");

        // Validaciones básicas
        if (correo == null || claveActual == null || claveNueva == null || repetirClave == null) {
            throw new Exception("Todos los campos son obligatorios.");
        }

        usuarios usuario = new usuarios();
        
        // Verificar clave actual
        if (!usuario.verificarUsuario(correo, claveActual)) {
            throw new Exception("La clave actual es incorrecta.");
        }

        // Verificar coincidencia de claves nuevas
        if (!usuario.coincidirClaves(claveNueva, repetirClave)) {
            throw new Exception("La nueva clave y su repetición no coinciden.");
        }

        // Verificar longitud mínima
        if (claveNueva.length() < 6) {
            throw new Exception("La nueva clave debe tener al menos 6 caracteres.");
        }

        // Cambiar la clave
        if (usuario.cambiarClave(correo, claveNueva)) {
            mensaje = "Clave cambiada exitosamente.";
            redirectPage = "exito.jsp?mensaje=" + java.net.URLEncoder.encode(mensaje, "UTF-8");
        } else {
            throw new Exception("Error al cambiar la clave en la base de datos.");
        }

    } catch (SQLException e) {
        mensaje = "Error de base de datos: " + e.getMessage();
        request.setAttribute("error", mensaje);
    } catch (Exception e) {
        mensaje = e.getMessage();
        request.setAttribute("error", mensaje);
    } finally {
        try {
            if (con != null) con.close();
        } catch (Exception e) {
            System.err.println("Error al cerrar conexión: " + e.getMessage());
        }
        
        if (request.getAttribute("error") != null) {
            request.getRequestDispatcher(redirectPage).forward(request, response);
        } else {
            response.sendRedirect(redirectPage);
        }
    }
%>