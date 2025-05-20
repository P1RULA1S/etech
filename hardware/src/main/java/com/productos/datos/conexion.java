package com.productos.datos;

import java.sql.*;

public class conexion {
    private Connection con;
    private String driver;
    private String user;
    private String pwd;
    private String cadena;
    
    public conexion() {
        this.driver = "org.postgresql.Driver";
        this.user = "postgres";
        this.pwd = "123";
        this.cadena = "jdbc:postgresql://localhost:5432/tb_hardware?useUnicode=true&characterEncoding=UTF-8";
        this.con = this.crearConexion();
    }
    
    private Connection crearConexion() {
        try {
            Class.forName(driver);
            return DriverManager.getConnection(cadena + "&charSet=UTF-8", user, pwd);
        } catch (ClassNotFoundException e) {
            System.out.println("Error al cargar el driver: " + e.getMessage());
        } catch (SQLException e) {
            System.out.println("Error al conectar a la base de datos: " + e.getMessage());
        }
        return null;
    }
    
    public Connection getConnection() {
        try {
            if (con == null || con.isClosed()) {
                con = crearConexion();
            }
        } catch (SQLException e) {
            System.out.println("Error al verificar conexión: " + e.getMessage());
        }
        return con;
    }
    
    public ResultSet Consulta(String sql) {
        try {
            Statement st = getConnection().createStatement();
            return st.executeQuery(sql);
        } catch (SQLException e) {
            System.out.println("Error en consulta: " + e.getMessage());
            return null;
        }
    }
    
    public PreparedStatement prepareStatement(String sql) throws SQLException {
        return getConnection().prepareStatement(sql);
    }
    
    public void close() {
        try {
            if (con != null && !con.isClosed()) {
                con.close();
            }
        } catch (SQLException e) {
            System.out.println("Error al cerrar conexión: " + e.getMessage());
        }
    }
    
    public int ejecutarActualizacion(String sql) {
        try (Statement st = getConnection().createStatement()) {
            return st.executeUpdate(sql);
        } catch (SQLException e) {
            System.out.println("Error al ejecutar actualización: " + e.getMessage());
            return -1;
        }
    }
    
    public static void closeResources(ResultSet rs, Statement st) {
        try {
            if (rs != null) rs.close();
            if (st != null) st.close();
        } catch (SQLException e) {
            System.out.println("Error al cerrar recursos: " + e.getMessage());
        }
    }
}