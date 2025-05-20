package com.productos.seguridad;

import com.productos.datos.conexion;
import java.sql.*;

public class Perfil {
    public String mostrarPerfil() {
        conexion con = new conexion();
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sql = "SELECT id_per, descripcion_per FROM tb_perfil WHERE descripcion_per != 'Cliente'";
        StringBuilder html = new StringBuilder();
        html.append("<select id=\"cmbPerfil\" name=\"cmbPerfil\" required>");
        html.append("<option value=\"\">Seleccione</option>");
        try {
            if (con.getConnection() == null) {
                throw new SQLException("No se pudo conectar a la base de datos.");
            }
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("id_per");
                String perfil = rs.getString("descripcion_per");
                html.append("<option value=\"").append(id).append("\">").append(perfil).append("</option>");
            }
            html.append("</select>");
            return html.toString();
        } catch (SQLException e) {
            System.err.println("Error en mostrarPerfil: " + e.getMessage());
            return "<select id=\"cmbPerfil\" name=\"cmbPerfil\" required><option value=\"\">Error al cargar</option></select>";
        } finally {
            conexion.closeResources(rs, ps);
            con.close();
        }
    }
}