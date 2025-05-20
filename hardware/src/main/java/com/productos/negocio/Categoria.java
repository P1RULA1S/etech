package com.productos.negocio;
import com.productos.datos.conexion;
import java.sql.*;

public class Categoria {

    public String mostrarCategoria() {
        String combo = "<select name='cmbCategoria'>";
        String sql = "SELECT * FROM tb_categoria";
        ResultSet rs = null;
        conexion con = new conexion();
        try {
            rs = con.Consulta(sql);
            while (rs.next()) {
                combo += "<option value='" + rs.getInt("id_cat") + "'>" 
                        + rs.getString("descripcion_cat") + "</option>";
            }
            combo += "</select>";
        } catch (SQLException e) {
            System.out.print(e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return combo;
    }
}