package com.productos.seguridad;

import com.productos.datos.conexion;
import java.sql.*;

public class EstadoCivil {
    public String mostrarEstadoCivil() {
        conexion con = new conexion();
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sql = "SELECT id_est, descripcion_est FROM tb_estadocivil";
        StringBuilder html = new StringBuilder();
        html.append("<select id=\"cmbECivil\" name=\"cmbECivil\" required>");
        html.append("<option value=\"\">Seleccione</option>");
        try {
            if (con.getConnection() == null) {
                throw new SQLException("No se pudo conectar a la base de datos.");
            }
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("id_est");
                String estado = rs.getString("descripcion_est");
                html.append("<option value=\"").append(id).append("\">").append(estado).append("</option>");
            }
            html.append("</select>");
            return html.toString();
        } catch (SQLException e) {
            System.err.println("Error en mostrarEstadoCivil: " + e.getMessage());
            return "<select id=\"cmbECivil\" name=\"cmbECivil\" required><option value=\"\">Error al cargar</option></select>";
        } finally {
            conexion.closeResources(rs, ps);
            con.close();
        }
    }
}