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
    
    // 2. Verificar si el producto ya está en el carrito
    String sqlCheck = "SELECT cantidad FROM tb_carrito WHERE id_us = ? AND id_pr = ?";
    PreparedStatement psCheck = conn.prepareStatement(sqlCheck);
    psCheck.setInt(1, idUsuario);
    psCheck.setInt(2, idProducto);
    ResultSet rsCheck = psCheck.executeQuery();
    
    if (rsCheck.next()) {
        // Actualizar cantidad si ya existe
        int cantidadActual = rsCheck.getInt("cantidad");
        int nuevaCantidad = cantidadActual + cantidad;
        
        if (nuevaCantidad > stockDisponible) {
            response.sendRedirect("carrito.jsp?error=" + 
                URLEncoder.encode("La cantidad supera el stock disponible. Disponible: " + stockDisponible, "UTF-8"));
            return;
        }
        
        String sqlUpdate = "UPDATE tb_carrito SET cantidad = ? WHERE id_us = ? AND id_pr = ?";
        PreparedStatement psUpdate = conn.prepareStatement(sqlUpdate);
        psUpdate.setInt(1, nuevaCantidad);
        psUpdate.setInt(2, idUsuario);
        psUpdate.setInt(3, idProducto);
        psUpdate.executeUpdate();
        psUpdate.close();
    } else {
        // Insertar nuevo registro si no existe
        String sqlInsert = "INSERT INTO tb_carrito (id_us, id_pr, cantidad, precio_unitario) " +
                          "SELECT ?, ?, ?, precio_pr FROM tb_productos WHERE id_pr = ?";
        PreparedStatement psInsert = conn.prepareStatement(sqlInsert);
        psInsert.setInt(1, idUsuario);
        psInsert.setInt(2, idProducto);
        psInsert.setInt(3, cantidad);
        psInsert.setInt(4, idProducto);
        psInsert.executeUpdate();
        psInsert.close();
    }
    
    conn.commit(); // Confirmar transacción
    response.sendRedirect("carrito.jsp?message=" + 
        URLEncoder.encode("Producto añadido al carrito correctamente", "UTF-8"));
    
} catch (SQLException e) {
    if (conn != null) {
        try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
    }
    e.printStackTrace();
    response.sendRedirect("carrito.jsp?error=" + 
        URLEncoder.encode("Error al agregar al carrito: " + e.getMessage(), "UTF-8"));
} finally {
    if (conn != null) {
        try { conn.setAutoCommit(true); conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
    con.close();
}
%>