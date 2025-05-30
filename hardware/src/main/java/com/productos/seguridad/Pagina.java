package com.productos.seguridad;

import com.productos.datos.conexion;
import java.sql.*;

public class Pagina {
    public String mostrarMenu(int nperfil) {
        StringBuilder menu = new StringBuilder();
        conexion con = new conexion();
        ResultSet rs = null;
        PreparedStatement ps = null;
        
        try {
            String sql = "SELECT pag.nombre_pag, pag.url_pag " +
                         "FROM tb_pagina pag " +
                         "JOIN tb_perfilpagina pper ON pag.id_pag = pper.id_pag " +
                         "WHERE pper.id_per = ?";
            
            ps = con.prepareStatement(sql);
            ps.setInt(1, nperfil);
            rs = ps.executeQuery();
            
            while(rs.next()) {
                menu.append("<li class='nav-item'>")
                    .append("<a class='nav-link' href='")
                    .append(rs.getString("url_pag"))
                    .append("'>")
                    .append("<i class='fas fa-arrow-right'></i> ")
                    .append(rs.getString("nombre_pag"))
                    .append("</a></li>");
            }
            
        } catch (SQLException e) {
            System.out.println("Error en mostrarMenu: " + e.getMessage());
        } finally {
            conexion.closeResources(rs, ps);
            con.close();
        }
        
        return menu.toString();
    }
}