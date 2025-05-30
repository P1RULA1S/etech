package com.productos.seguridad;

import com.productos.datos.conexion;
import java.sql.*;

public class usuarios {
    private String nombre;
    private String perfil;
    private String email;
    private String cedula;
    private int idPerfil;
    private int idUsuario;
    private int estadoActivo; // 1 = Activo, 0 = Bloqueado

    public boolean verificarUsuario(String correo, String clave) {
        conexion con = new conexion();
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sql = ""; // Declare sql outside try block
        
        try {
            sql = "SELECT u.id_us, u.nombre_us, p.descripcion_per AS perfil, p.id_per AS id_perfil, u.estado_activo " +
                  "FROM tb_usuario u " +
                  "JOIN tb_perfil p ON u.id_per = p.id_per " +
                  "WHERE u.correo_us = ? AND u.clave_us = ?";
            ps = con.getConnection().prepareStatement(sql);
            ps.setString(1, correo);
            ps.setString(2, clave);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                this.idUsuario = rs.getInt("id_us");
                this.nombre = rs.getString("nombre_us");
                this.perfil = rs.getString("perfil");
                this.email = correo;
                this.idPerfil = rs.getInt("id_perfil");
                this.estadoActivo = rs.getInt("estado_activo");
                System.out.println("Usuario autenticado - idUsuario: " + this.idUsuario + 
                                   ", nombre: " + this.nombre + ", perfil: " + this.perfil + 
                                   ", email: " + this.email + ", estadoActivo: " + this.estadoActivo);
                return true;
            }
            System.out.println("Fallo en autenticación para correo: " + correo + " - Verifica correo y contraseña en la base de datos.");
            return false;
        } catch (SQLException e) {
            System.err.println("Error en verificarUsuario - SQL: " + e.getMessage() + " - Consulta: " + sql);
            return false;
        } finally {
            conexion.closeResources(rs, ps);
            con.close();
        }
    }
    
    public boolean bloquearUsuario(int idUsuario) {
        conexion con = new conexion();
        PreparedStatement ps = null;
        try {
            Connection conn = con.getConnection();
            if (conn == null) {
                throw new SQLException("No se pudo conectar a la base de datos.");
            }
            String sql = "UPDATE tb_usuario SET estado_activo = 0 WHERE id_us = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            int filas = ps.executeUpdate();
            return filas > 0;
        } catch (SQLException e) {
            System.err.println("Error al bloquear usuario: " + e.getMessage());
            return false;
        } finally {
            conexion.closeResources(null, ps);
            con.close();
        }
    }

    public boolean desbloquearUsuario(int idUsuario) {
        conexion con = new conexion();
        PreparedStatement ps = null;
        try {
            Connection conn = con.getConnection();
            if (conn == null) {
                throw new SQLException("No se pudo conectar a la base de datos.");
            }
            String sql = "UPDATE tb_usuario SET estado_activo = 1 WHERE id_us = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            int filas = ps.executeUpdate();
            return filas > 0;
        } catch (SQLException e) {
            System.err.println("Error al desbloquear usuario: " + e.getMessage());
            return false;
        } finally {
            conexion.closeResources(null, ps);
            con.close();
        }
    }

    public boolean actualizarUsuario(int idUsuario, String nombre, String cedula, String correo) {
        conexion con = new conexion();
        PreparedStatement ps = null;
        try {
            Connection conn = con.getConnection();
            if (conn == null) {
                throw new SQLException("No se pudo conectar a la base de datos.");
            }
            String sql = "UPDATE tb_usuario SET nombre_us = ?, cedula_us = ?, correo_us = ? WHERE id_us = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, nombre);
            ps.setString(2, cedula);
            ps.setString(3, correo);
            ps.setInt(4, idUsuario);
            int filas = ps.executeUpdate();
            return filas > 0;
        } catch (SQLException e) {
            System.err.println("Error al actualizar usuario: " + e.getMessage());
            return false;
        } finally {
            conexion.closeResources(null, ps);
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

    // Getters y Setters
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public String getPerfil() { return perfil; }
    public void setPerfil(String perfil) { this.perfil = perfil; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getCedula() { return cedula; }
    public void setCedula(String cedula) { this.cedula = cedula; }
    public int getIdPerfil() { return idPerfil; }
    public void setIdPerfil(int idPerfil) { this.idPerfil = idPerfil; }
    public int getIdUsuario() { return idUsuario; }
    public void setIdUsuario(int idUsuario) { this.idUsuario = idUsuario; }
    public int getEstadoActivo() { return estadoActivo; }
    public void setEstadoActivo(int estadoActivo) { this.estadoActivo = estadoActivo; }
}