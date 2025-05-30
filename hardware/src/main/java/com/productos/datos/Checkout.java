package com.productos.datos;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Date;
import java.text.SimpleDateFormat;

public class Checkout {
    private static final double IVA = 0.15; // IVA Ecuador 2025

    public static String procesarCompra(int idUsuario, String nombreTitular, String numeroTarjeta, 
            String fechaExpiracion, String cvv, conexion con) throws SQLException {
        Connection conn = null;
        try {
            conn = con.getConnection();
            conn.setAutoCommit(false);

            // Validar datos de la tarjeta
            if (!numeroTarjeta.matches("\\d{16}")) {
                return "error=Número de tarjeta inválido";
            }
            if (!fechaExpiracion.matches("\\d{2}/\\d{2}")) {
                return "error=Fecha de expiración inválida";
            }
            if (!cvv.matches("\\d{3}")) {
                return "error=CVV inválido";
            }
            String[] fechaParts = fechaExpiracion.split("/");
            int mes = Integer.parseInt(fechaParts[0]);
            int anio = Integer.parseInt(fechaParts[1]);
            int anioActual = new Date().getYear() % 100;
            int mesActual = new Date().getMonth() + 1;
            if (anio < anioActual || (anio == anioActual && mes < mesActual)) {
                return "error=La tarjeta está expirada";
            }

            // Calcular el total con IVA
            double totalSinIva = 0.0;
            double totalConIva = 0.0;
            String totalSql = "SELECT SUM(c.cantidad * c.precio_unitario) as total " +
                             "FROM tb_carrito c WHERE c.id_us = ?";
            PreparedStatement psTotal = conn.prepareStatement(totalSql);
            psTotal.setInt(1, idUsuario);
            ResultSet rsTotal = psTotal.executeQuery();
            if (rsTotal.next()) {
                totalSinIva = rsTotal.getDouble("total");
                totalConIva = totalSinIva * (1 + IVA);
            }
            rsTotal.close();
            psTotal.close();

            if (totalSinIva == 0.0) {
                return "error=El carrito está vacío";
            }

            // Verificar stock
            String checkStockSql = "SELECT c.id_pr, c.cantidad, p.cantidad_pr, p.nombre_pr " +
                                  "FROM tb_carrito c JOIN tb_productos p ON c.id_pr = p.id_pr " +
                                  "WHERE c.id_us = ?";
            PreparedStatement psCheckStock = conn.prepareStatement(checkStockSql);
            psCheckStock.setInt(1, idUsuario);
            ResultSet rsCheckStock = psCheckStock.executeQuery();
            while (rsCheckStock.next()) {
                int cantidadCarrito = rsCheckStock.getInt("cantidad");
                int stockDisponible = rsCheckStock.getInt("cantidad_pr");
                if (cantidadCarrito > stockDisponible) {
                    String nombreProducto = rsCheckStock.getString("nombre_pr");
                    rsCheckStock.close();
                    psCheckStock.close();
                    conn.rollback();
                    return "error=Stock insuficiente para " + nombreProducto;
                }
            }
            rsCheckStock.close();
            psCheckStock.close();

            // Insertar pedido
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String fechaPedido = sdf.format(new Date());
            String insertPedidoSql = "INSERT INTO tb_pedidos (id_us, fecha_pedido, total, metodo_pago, direccion) " +
                                    "VALUES (?, ?, ?, ?, ?)";
            PreparedStatement psPedido = conn.prepareStatement(insertPedidoSql, Statement.RETURN_GENERATED_KEYS);
            psPedido.setInt(1, idUsuario);
            psPedido.setString(2, fechaPedido);
            psPedido.setDouble(3, totalConIva);
            psPedido.setString(4, "tarjeta");
            psPedido.setString(5, "N/A");
            psPedido.executeUpdate();

            // Obtener ID del pedido
            ResultSet rsPedido = psPedido.getGeneratedKeys();
            int idPedido = 0;
            if (rsPedido.next()) {
                idPedido = rsPedido.getInt(1);
            }
            rsPedido.close();
            psPedido.close();

            // Mover productos del carrito a tb_detalle_pedido y actualizar stock
            String selectCarritoSql = "SELECT id_pr, cantidad, precio_unitario FROM tb_carrito WHERE id_us = ?";
            PreparedStatement psCarrito = conn.prepareStatement(selectCarritoSql);
            psCarrito.setInt(1, idUsuario);
            ResultSet rsCarrito = psCarrito.executeQuery();

            String insertDetalleSql = "INSERT INTO tb_detalle_pedido (id_pedido, id_pr, cantidad, precio_unitario, subtotal) " +
                                     "VALUES (?, ?, ?, ?, ?)";
            PreparedStatement psDetalle = conn.prepareStatement(insertDetalleSql);
            String updateStockSql = "UPDATE tb_productos SET cantidad_pr = cantidad_pr - ? WHERE id_pr = ?";
            PreparedStatement psStock = conn.prepareStatement(updateStockSql);

            while (rsCarrito.next()) {
                int idProducto = rsCarrito.getInt("id_pr");
                int cantidad = rsCarrito.getInt("cantidad");
                double precioUnitario = rsCarrito.getDouble("precio_unitario");
                double subtotalSinIva = cantidad * precioUnitario;
                double subtotalConIva = subtotalSinIva * (1 + IVA);

                psDetalle.setInt(1, idPedido);
                psDetalle.setInt(2, idProducto);
                psDetalle.setInt(3, cantidad);
                psDetalle.setDouble(4, precioUnitario);
                psDetalle.setDouble(5, subtotalConIva);
                psDetalle.executeUpdate();

                psStock.setInt(1, cantidad);
                psStock.setInt(2, idProducto);
                psStock.executeUpdate();
            }
            rsCarrito.close();
            psCarrito.close();
            psDetalle.close();
            psStock.close();

            // Vaciar carrito
            String deleteCarritoSql = "DELETE FROM tb_carrito WHERE id_us = ?";
            PreparedStatement psDelete = conn.prepareStatement(deleteCarritoSql);
            psDelete.setInt(1, idUsuario);
            psDelete.executeUpdate();
            psDelete.close();

            // Confirmar transacción
            conn.commit();
            return "success";
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}