<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true"%>
<%@ page import="com.productos.datos.conexion, java.sql.*, java.net.URLEncoder"%>
<%
    Integer idUsuario = (Integer) session.getAttribute("idUsuario");
    if (idUsuario == null) {
        response.sendRedirect("login.jsp?error=" + URLEncoder.encode("Sesión inválida, inicie sesión nuevamente", "UTF-8"));
        return;
    }

    String idProducto = request.getParameter("id");
    String cantidadStr = request.getParameter("cantidad");
    int cantidad = 0;

    try {
        cantidad = Integer.parseInt(cantidadStr);
        if (cantidad <= 0) {
            response.sendRedirect("carrito.jsp?error=" + URLEncoder.encode("Cantidad debe ser mayor a 0", "UTF-8"));
            return;
        }
    } catch (NumberFormatException e) {
        response.sendRedirect("carrito.jsp?error=" + URLEncoder.encode("Cantidad inválida", "UTF-8"));
        return;
    }

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
        // Verificar stock disponible
        String stockSql = "SELECT stock_pr FROM tb_productos WHERE id_pr = ?";
        PreparedStatement stockPs = con.getConnection().prepareStatement(stockSql);
        stockPs.setInt(1, idProductoInt);
        ResultSet stockRs = stockPs.executeQuery();
        int stockDisponible = 0;
        if (stockRs.next()) {
            stockDisponible = stockRs.getInt("stock_pr");
        } else {
            stockRs.close();
            stockPs.close();
            response.sendRedirect("carrito.jsp?error=" + URLEncoder.encode("Producto no encontrado", "UTF-8"));
            return;
        }
        stockRs.close();
        stockPs.close();

        if (cantidad > stockDisponible) {
            response.sendRedirect("carrito.jsp?error=" + URLEncoder.encode("No hay suficiente stock disponible. Stock actual: " + stockDisponible, "UTF-8"));
            return;
        }

        // Actualizar cantidad
        String sql = "UPDATE tb_carrito SET cantidad = ? WHERE id_us = ? AND id_pr = ?";
        PreparedStatement ps = con.getConnection().prepareStatement(sql);
        ps.setInt(1, cantidad);
        ps.setInt(2, idUsuario);
        ps.setInt(3, idProductoInt);
        int rows = ps.executeUpdate();
        ps.close();

        if (rows == 0) {
            response.sendRedirect("carrito.jsp?error=" + URLEncoder.encode("Producto no encontrado en el carrito", "UTF-8"));
        } else {
            response.sendRedirect("carrito.jsp?message=" + URLEncoder.encode("Cantidad actualizada con éxito", "UTF-8"));
        }
    } catch (SQLException e) {
        e.printStackTrace();
        response.sendRedirect("carrito.jsp?error=" + URLEncoder.encode("Error al actualizar la cantidad: " + e.getMessage(), "UTF-8"));
    } finally {
        con.close();
    }
%>