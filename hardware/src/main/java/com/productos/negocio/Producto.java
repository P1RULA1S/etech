package com.productos.negocio;

import com.productos.datos.conexion;
import java.sql.*;

public class Producto {
	
    public String consultarTodo1() {
        String sql = "SELECT * FROM tb_productos ORDER BY id_pr";
        conexion con = new conexion();
        String tabla = "<table border=2><th>ID</th><th>Producto</th><th>Cantidad</th><th>Precio</th>";
        ResultSet rs = null;
        try {
            rs = con.Consulta(sql);
            if (rs != null) {
                while (rs.next()) {
                    tabla += "<tr><td>" + rs.getInt("id_pr") + "</td>"
                            + "<td>" + rs.getString("nombre_pr") + "</td>"
                            + "<td>" + rs.getInt("cantidad_pr") + "</td>"
                            + "<td>" + rs.getDouble("precio_pr") + "</td>"
                            + "</tr>";
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.print(e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                con.close(); // Asegúrate de tener este método en tu clase conexion
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        tabla += "</table>";
        return tabla;
    }

	
    public String consultarTodo() {
        String sql = "SELECT p.id_pr, p.nombre_pr, c.descripcion_cat, p.cantidad_pr, p.precio_pr " +
                    "FROM tb_productos p JOIN tb_categoria c ON p.id_cat = c.id_cat ORDER BY p.id_pr";
        conexion con = new conexion();
        String tabla = "";
        ResultSet rs = null;
        try {
            rs = con.Consulta(sql);
            if (rs != null) {
                while (rs.next()) {
                    tabla += "<tr>" +
                            "<td>" + rs.getInt("id_pr") + "</td>" +
                            "<td>" + rs.getString("nombre_pr") + "</td>" +
                            "<td>" + rs.getString("descripcion_cat") + "</td>" +
                            "<td>" + rs.getDouble("precio_pr") + "</td>" +
                            "<td>" + rs.getInt("cantidad_pr") + "</td>" +
                            "<td><a href='ProductoServlet?action=edit&id=" + rs.getInt("id_pr") + "' class='btn btn-warning btn-sm'>Actualizar</a></td>" +
                            "<td><a href='ProductoServlet?action=delete&id=" + rs.getInt("id_pr") + "' class='btn btn-danger btn-sm' onclick='return confirm(\"¿Estás seguro de eliminar este producto?\");'>Eliminar</a></td>" +
                            "</tr>";
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.print(e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return tabla;
    }
    
    public String buscarProductoCategoria(int cat) {
        String sentencia = "SELECT id_pr, nombre_pr, precio_pr, cantidad_pr FROM tb_productos WHERE id_cat = ?";
        conexion con = new conexion();
        ResultSet rs = null;
        String resultado = "<table border='1' style='width:100%; border-collapse:collapse;'>";
        resultado += "<tr><th>ID</th><th>Producto</th><th>Precio</th><th>Disponibles</th></tr>";
        
        try {
            PreparedStatement pst = con.getConnection().prepareStatement(sentencia);
            pst.setInt(1, cat);
            rs = pst.executeQuery();
            
            while (rs.next()) {
                resultado += "<tr>" +
                        "<td>" + rs.getInt("id_pr") + "</td>" +
                        "<td>" + rs.getString("nombre_pr") + "</td>" +
                        "<td>$" + String.format("%.2f", rs.getDouble("precio_pr")) + "</td>" +
                        "<td>" + rs.getInt("cantidad_pr") + "</td>" +
                        "</tr>";
            }
            resultado += "</table>";
        } catch (SQLException e) {
            System.out.print(e.getMessage());
            resultado = "<p>Error al cargar los productos</p>";
        } finally {
            try {
                if (rs != null) rs.close();
                con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return resultado;
    }

    public boolean actualizarProducto(int id, String nombre, int categoria, int cantidad, double precio) {
        String sql = "UPDATE tb_productos SET nombre_pr = ?, id_cat = ?, cantidad_pr = ?, precio_pr = ? WHERE id_pr = ?";
        conexion con = new conexion();
        try {
            PreparedStatement pst = con.getConnection().prepareStatement(sql);
            pst.setString(1, nombre);
            pst.setInt(2, categoria);
            pst.setInt(3, cantidad);
            pst.setDouble(4, precio);
            pst.setInt(5, id);
            int filasAfectadas = pst.executeUpdate();
            return filasAfectadas > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            con.close();
        }
    }

    public boolean eliminarProducto(int id) {
        String sql = "DELETE FROM tb_productos WHERE id_pr = ?";
        conexion con = new conexion();
        try {
            PreparedStatement pst = con.getConnection().prepareStatement(sql);
            pst.setInt(1, id);
            int filasAfectadas = pst.executeUpdate();
            return filasAfectadas > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            con.close();
        }
    }

    public boolean agregarProducto(String nombre, int categoria, int cantidad, double precio) {
        String sql = "INSERT INTO tb_productos (nombre_pr, id_cat, cantidad_pr, precio_pr) VALUES (?, ?, ?, ?)";
        conexion con = new conexion();
        try {
            PreparedStatement pst = con.getConnection().prepareStatement(sql);
            pst.setString(1, nombre);
            pst.setInt(2, categoria);
            pst.setInt(3, cantidad);
            pst.setDouble(4, precio);
            int filasAfectadas = pst.executeUpdate();
            return filasAfectadas > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            con.close();
        }
    }

    public ResultSet obtenerProductoPorId(int id) throws SQLException {
        String sql = "SELECT * FROM tb_productos WHERE id_pr = ?";
        conexion con = new conexion();
        PreparedStatement pst = con.getConnection().prepareStatement(sql);
        pst.setInt(1, id);
        return pst.executeQuery();
    }
}