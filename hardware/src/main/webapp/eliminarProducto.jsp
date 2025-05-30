<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.productos.negocio.Producto, com.productos.datos.conexion, java.sql.*" %>
<%
    String mensaje = "";
    int id = 0;
    conexion con = new conexion();
    Connection conn = null;
    try {
        id = Integer.parseInt(request.getParameter("id"));
        conn = con.getConnection();
        conn.setAutoCommit(false); // Iniciar transacción

        // 1. Eliminar el producto de los carritos (tb_carrito)
        String sqlCarrito = "DELETE FROM tb_carrito WHERE id_pr = ?";
        PreparedStatement psCarrito = conn.prepareStatement(sqlCarrito);
        psCarrito.setInt(1, id);
        psCarrito.executeUpdate();
        psCarrito.close();

        // 2. Eliminar el producto del catálogo (tb_productos)
        Producto producto = new Producto();
        if (producto.eliminarProducto(id)) {
            mensaje = "Producto eliminado con éxito";
        } else {
            mensaje = "Error al eliminar el producto";
        }

        conn.commit(); // Confirmar transacción
    } catch (NumberFormatException e) {
        mensaje = "Error: ID de producto inválido";
    } catch (Exception e) {
        mensaje = "Error al eliminar el producto: " + e.getMessage();
        if (conn != null) {
            try {
                conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    } finally {
        if (conn != null) {
            try {
                conn.setAutoCommit(true);
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        con.close();
    }
    response.sendRedirect("GestionProductos.jsp?mensaje=" + java.net.URLEncoder.encode(mensaje, "UTF-8"));
%>