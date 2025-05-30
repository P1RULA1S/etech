<%@ page language="java" contentType="text/plain; charset=UTF-8" pageEncoding="UTF-8" session="true"%>
<%@ page import="com.productos.datos.conexion, java.sql.*" %>
<%
// Configurar tipo de respuesta
response.setContentType("text/plain");

// Verificar sesión
Integer idUsuario = (Integer)session.getAttribute("idUsuario");
if (idUsuario == null) {
    response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
    out.print("error:session_invalid");
    return;
}

// Validar parámetros
String action = request.getParameter("action");
String idProductoStr = request.getParameter("id");

if (action == null || idProductoStr == null || !action.equals("toggle")) {
    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
    out.print("error:invalid_parameters");
    return;
}

int idProducto;
try {
    idProducto = Integer.parseInt(idProductoStr);
} catch (NumberFormatException e) {
    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
    out.print("error:invalid_product_id");
    return;
}

conexion con = new conexion();
Connection conn = null;
try {
    conn = con.getConnection();
    conn.setAutoCommit(false);

    // 1. Verificar si el producto existe
    String checkProductSql = "SELECT id_pr FROM tb_productos WHERE id_pr = ?";
    try (PreparedStatement ps = conn.prepareStatement(checkProductSql)) {
        ps.setInt(1, idProducto);
        try (ResultSet rs = ps.executeQuery()) {
            if (!rs.next()) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print("error:product_not_found");
                return;
            }
        }
    }

    // 2. Verificar si está en favoritos
    String checkFavSql = "SELECT id_fav FROM tb_favoritos WHERE id_us = ? AND id_pr = ?";
    try (PreparedStatement ps = conn.prepareStatement(checkFavSql)) {
        ps.setInt(1, idUsuario);
        ps.setInt(2, idProducto);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                // Eliminar de favoritos
                String deleteSql = "DELETE FROM tb_favoritos WHERE id_us = ? AND id_pr = ?";
                try (PreparedStatement psDelete = conn.prepareStatement(deleteSql)) {
                    psDelete.setInt(1, idUsuario);
                    psDelete.setInt(2, idProducto);
                    psDelete.executeUpdate();
                    out.print("removed");
                }
            } else {
                // Añadir a favoritos
                String insertSql = "INSERT INTO tb_favoritos (id_us, id_pr) VALUES (?, ?)";
                try (PreparedStatement psInsert = conn.prepareStatement(insertSql)) {
                    psInsert.setInt(1, idUsuario);
                    psInsert.setInt(2, idProducto);
                    psInsert.executeUpdate();
                    out.print("added");
                }
            }
        }
    }
    
    conn.commit();
    response.setStatus(HttpServletResponse.SC_OK);

} catch (SQLException e) {
    if (conn != null) {
        try { conn.rollback(); } catch (SQLException ex) {}
    }
    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    out.print("error:database_error");
    e.printStackTrace();
} finally {
    if (conn != null) {
        try { conn.setAutoCommit(true); conn.close(); } catch (SQLException e) {}
    }
    con.close();
}
%>