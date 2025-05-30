<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true"%>
<%@ page import="com.productos.datos.conexion, java.sql.*, java.net.URLEncoder"%>
<%
    Integer idUsuario = (Integer) session.getAttribute("idUsuario");
    if (idUsuario == null) {
        response.sendRedirect("login.jsp?error=" + URLEncoder.encode("Sesión inválida, inicie sesión nuevamente", "UTF-8"));
        return;
    }

    String idProducto = request.getParameter("id");
    if (idProducto == null || idProducto.trim().isEmpty()) {
        response.sendRedirect("carrito.jsp?error=" + URLEncoder.encode("ID de producto inválido", "UTF-8"));
        return;
    }

    int idProductoInt;
    try {
        idProductoInt = Integer.parseInt(idProducto);
    } catch (NumberFormatException e) {
        response.sendRedirect("carrito.jsp?error=" + URLEncoder.encode("ID de producto no es un número válido", "UTF-8"));
        return;
    }

    conexion con = new conexion();
    try {
        String sql = "DELETE FROM tb_carrito WHERE id_us = ? AND id_pr = ?";
        PreparedStatement ps = con.getConnection().prepareStatement(sql);
        ps.setInt(1, idUsuario);
        ps.setInt(2, idProductoInt);
        int rows = ps.executeUpdate();
        ps.close();

        if (rows == 0) {
            response.sendRedirect("carrito.jsp?error=" + URLEncoder.encode("Producto no encontrado en el carrito", "UTF-8"));
        } else {
            response.sendRedirect("carrito.jsp?message=" + URLEncoder.encode("Producto eliminado con éxito", "UTF-8"));
        }
    } catch (SQLException e) {
        e.printStackTrace();
        response.sendRedirect("carrito.jsp?error=" + URLEncoder.encode("Error al eliminar el producto: " + e.getMessage(), "UTF-8"));
    } finally {
        con.close();
    }
%>