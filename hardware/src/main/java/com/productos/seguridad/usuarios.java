package com.productos.seguridad;

import com.productos.datos.conexion;
import java.sql.*;

public class usuarios {
    private String nombre;
    private String perfil;
    private String email;
    private int idPerfil;

    public boolean verificarUsuario(String correo, String clave) {
        conexion con = new conexion();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            String sql = "SELECT u.nombre_us, p.descripcion_per AS perfil, p.id_per AS id_perfil " +
                         "FROM tb_usuario u " +
                         "JOIN tb_perfil p ON u.id_per = p.id_per " +
                         "WHERE u.correo_us = ? AND u.clave_us = ?";
            ps = con.getConnection().prepareStatement(sql);
            ps.setString(1, correo);
            ps.setString(2, clave);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                this.nombre = rs.getString("nombre_us");
                this.perfil = rs.getString("perfil");
                this.email = correo;
                this.idPerfil = rs.getInt("id_perfil");
                return true;
            }
            return false;
        } catch (SQLException e) {
            System.err.println("Error en verificarUsuario: " + e.getMessage());
            return false;
        } finally {
            conexion.closeResources(rs, ps);
            con.close();
        }
    }

    public boolean existeUsuario(String correo) {
        conexion con = new conexion();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            String sql = "SELECT 1 FROM tb_usuario WHERE correo_us = ?";
            ps = con.getConnection().prepareStatement(sql);
            ps.setString(1, correo);
            rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            System.err.println("Error en existeUsuario: " + e.getMessage());
            return false;
        } finally {
            conexion.closeResources(rs, ps);
            con.close();
        }
    }

    public boolean ingresarUsuario(int nperfil, int idEst, String ncedula, String nnombre, String ncorreo) {
        return ingresarUsuario(nperfil, idEst, 1, ncedula, nnombre, ncorreo, "654321");
    }

    public boolean ingresarUsuario(int nperfil, int idEst, int idRes, String ncedula, String nnombre, String ncorreo, String nclave) {
        conexion con = new conexion();
        PreparedStatement ps = null;
        String sql = "INSERT INTO tb_usuario (id_per, id_est, id_res, cedula_us, nombre_us, correo_us, clave_us) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            Connection conn = con.getConnection();
            if (conn == null) {
                throw new SQLException("No se pudo conectar a la base de datos.");
            }
            ps = conn.prepareStatement(sql);
            ps.setInt(1, nperfil);
            ps.setInt(2, idEst);
            ps.setInt(3, idRes);
            ps.setString(4, ncedula);
            ps.setString(5, nnombre);
            ps.setString(6, ncorreo);
            ps.setString(7, nclave);
            int filas = ps.executeUpdate();
            return filas > 0;
        } catch (SQLException e) {
            System.err.println("Error en ingresarUsuario: " + e.getMessage());
            return false;
        } finally {
            conexion.closeResources(null, ps);
            con.close();
        }
    }

    public boolean cambiarClave(String ncorreo, String nclave) {
        conexion con = new conexion();
        PreparedStatement ps = null;
        String sql = "UPDATE tb_usuario SET clave_us = ? WHERE correo_us = ?";
        try {
            Connection conn = con.getConnection();
            if (conn == null) {
                throw new SQLException("No se pudo conectar a la base de datos.");
            }
            ps = conn.prepareStatement(sql);
            ps.setString(1, nclave);
            ps.setString(2, ncorreo);
            int filas = ps.executeUpdate();
            return filas > 0;
        } catch (SQLException e) {
            System.err.println("Error en cambiarClave: " + e.getMessage());
            return false;
        } finally {
            conexion.closeResources(null, ps);
            con.close();
        }
    }

    public boolean coincidirClaves(String nclave, String nrepetir) {
        return nclave != null && nrepetir != null && nclave.equals(nrepetir);
    }

    public boolean esAdministrador() {
        return "Administrador".equalsIgnoreCase(this.perfil);
    }

    public boolean esVendedor() {
        return "Vendedor".equalsIgnoreCase(this.perfil);
    }

    public boolean esCliente() {
        return "Cliente".equalsIgnoreCase(this.perfil);
    }

    public String getNombre() { return nombre; }
    public String getPerfil() { return perfil; }
    public String getEmail() { return email; }
    public int getIdPerfil() { return idPerfil; }
}