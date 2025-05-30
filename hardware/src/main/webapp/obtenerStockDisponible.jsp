<%@ page language="java" contentType="text/plain; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.productos.datos.conexion, java.sql.*" %>
<%
String productIdStr = request.getParameter("id");
if (productIdStr == null) {
    response.setStatus(400);
    out.print("0");
    return;
}

try {
    int productId = Integer.parseInt(productIdStr);
    conexion con = new conexion();
    String sql = "SELECT cantidad_pr FROM tb_productos WHERE id_pr = ?";
    try (PreparedStatement ps = con.getConnection().prepareStatement(sql)) {
        ps.setInt(1, productId);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                out.print(rs.getInt("cantidad_pr"));
            } else {
                response.setStatus(404);
                out.print("0");
            }
        }
    }
    con.close();
} catch (Exception e) {
    response.setStatus(500);
    out.print("0");
    e.printStackTrace();
}
%>