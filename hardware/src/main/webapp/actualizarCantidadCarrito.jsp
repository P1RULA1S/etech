<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true"%>
<%@ page import="com.productos.datos.conexion, java.sql.*, java.net.URLEncoder" %>
<%
// Verificar sesión
String perfil = (String) session.getAttribute("perfil");
if (perfil == null || !perfil.equalsIgnoreCase("Cliente")) {
    response.sendRedirect("index.jsp");
    return;
}
Integer idUsuario = (Integer) session.getAttribute("idUsuario");
if (idUsuario == null) {
    response.sendRedirect("login.jsp?error=" + URLEncoder.encode("Sesión inválida, inicie sesión nuevamente", "UTF-8"));
    return;
}

// Obtener parámetros
int idProducto = 0;
int cantidad = 1;
try {
    idProducto = Integer.parseInt(request.getParameter("id"));
    cantidad = Integer.parseInt(request.getParameter("cantidad"));
} catch (NumberFormatException e) {
    response.sendRedirect("carrito.jsp?error=" + URLEncoder.encode("Parámetros inválidos", "UTF-8"));
    return;
}

if (cantidad < 1) {
    response.sendRedirect("carrito.jsp?error=" + URLEncoder.encode("La cantidad debe ser al menos 1", "UTF-8"));
    return;
}

conexion con = new conexion();
Connection conn = null;
try {
    conn = con.getConnection();
    conn.setAutoCommit(false); // Iniciar transacción
    
    // 1. Verificar stock disponible
    String sqlStock = "SELECT cantidad_pr FROM tb_productos WHERE id_pr = ?";
    PreparedStatement psStock = conn.prepareStatement(sqlStock);
    psStock.setInt(1, idProducto);
    ResultSet rsStock = psStock.executeQuery();
    
    if (!rsStock.next()) {
        response.sendRedirect("carrito.jsp?error=" + URLEncoder.encode("Producto no encontrado", "UTF-8"));
        return;
    }
    
    int stockDisponible = rsStock.getInt("cantidad_pr");
    if (cantidad > stockDisponible) {
        response.sendRedirect("carrito.jsp?error=" + 
            URLEncoder.encode("No hay suficiente stock. Disponible: " + stockDisponible, "UTF-8"));
        return;
    }
    
    // 2. Actualizar cantidad en el carrito
    String sqlUpdate = "UPDATE tb_carrito SET cantidad = ? WHERE id_us = ? AND id_pr = ?";
    PreparedStatement psUpdate = conn.prepareStatement(sqlUpdate);
    psUpdate.setInt(1, cantidad);
    psUpdate.setInt(2, idUsuario);
    psUpdate.setInt(3, idProducto);
    int affectedRows = psUpdate.executeUpdate();
    
    if (affectedRows == 0) {
        response.sendRedirect("carrito.jsp?error=" + URLEncoder.encode("Producto no encontrado en el carrito", "UTF-8"));
        return;
    }
    
    conn.commit(); // Confirmar transacción
    response.sendRedirect("carrito.jsp?message=" + 
        URLEncoder.encode("Cantidad actualizada correctamente", "UTF-8"));
    
} catch (SQLException e) {
    if (conn != null) {
        try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
    }
    e.printStackTrace();
    response.sendRedirect("carrito.jsp?error=" + 
        URLEncoder.encode("Error al actualizar cantidad: " + e.getMessage(), "UTF-8"));
} finally {
    if (conn != null) {
        try { conn.setAutoCommit(true); conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
    con.close();
}
%>