<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.productos.datos.conexion, java.sql.*" %>
<%
String result = "error";
try {
    int idFav = Integer.parseInt(request.getParameter("idFav"));
    conexion con = new conexion();
    String sql = "DELETE FROM tb_favoritos WHERE id_fav = ?";
    PreparedStatement ps = con.getConnection().prepareStatement(sql);
    ps.setInt(1, idFav);
    int rowsAffected = ps.executeUpdate();
    if (rowsAffected > 0) {
        result = "success";
    }
    ps.close();
    con.close();
} catch (Exception e) {
    result = "Error: " + e.getMessage();
}
out.print(result);
%>