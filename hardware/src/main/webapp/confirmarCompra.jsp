<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true"%>
<%@ page import="com.productos.datos.conexion, java.sql.*, java.util.Date, java.sql.Timestamp" %>
<%
    // Verificación de sesión
    String perfil = (String) session.getAttribute("perfil");
    if (perfil == null || !perfil.equalsIgnoreCase("Cliente")) {
        response.sendRedirect("index.jsp");
        return;
    }
    Integer idUsuario = (Integer) session.getAttribute("idUsuario");
    if (idUsuario == null) {
        String email = (String) session.getAttribute("email");
        if (email != null) {
            conexion con = new conexion();
            try {
                String sql = "SELECT id_us FROM tb_usuario WHERE correo_us = ?";
                PreparedStatement ps = con.getConnection().prepareStatement(sql);
                ps.setString(1, email);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    idUsuario = rs.getInt("id_us");
                    session.setAttribute("idUsuario", idUsuario);
                } else {
                    response.sendRedirect("login.jsp?error=Usuario no encontrado");
                    return;
                }
                rs.close();
                ps.close();
            } catch (SQLException e) {
                e.printStackTrace();
                response.sendRedirect("login.jsp?error=Error al recuperar ID de usuario");
                return;
            } finally {
                con.close();
            }
        } else {
            response.sendRedirect("login.jsp?error=Sesión inválida, inicie sesión nuevamente");
            return;
        }
    }

    // Obtener parámetros
    String metodoPago = request.getParameter("metodoPago");
    String nombreTitular = request.getParameter("nombreTitular");
    String numeroTarjeta = request.getParameter("numeroTarjeta");
    String fechaExpiracion = request.getParameter("fechaExpiracion");
    String cvv = request.getParameter("cvv");
    String totalStr = request.getParameter("total");

    // Validar parámetros
    if (metodoPago == null || totalStr == null || totalStr.trim().isEmpty()) {
        response.sendRedirect("checkout.jsp?error=Parámetros de pago incompletos o total vacío");
        return;
    }

    double totalConIva;
    try {
        totalConIva = Double.parseDouble(totalStr);
        if (totalConIva <= 0) {
            response.sendRedirect("checkout.jsp?error=Total debe ser mayor a 0");
            return;
        }
    } catch (NumberFormatException e) {
        response.sendRedirect("checkout.jsp?error=Total inválido: " + totalStr);
        return;
    }

    if (metodoPago.equals("tarjeta")) {
        // Validación simulada
        if (nombreTitular == null || numeroTarjeta == null || fechaExpiracion == null || cvv == null) {
            response.sendRedirect("checkout.jsp?error=Datos de tarjeta incompletos");
            return;
        }
        if (!numeroTarjeta.matches("\\d{16}")) {
            response.sendRedirect("checkout.jsp?error=Número de tarjeta debe tener 16 dígitos");
            return;
        }
        if (cvv.equals("000")) {
            response.sendRedirect("checkout.jsp?error=CVV no puede ser 000");
            return;
        }
        // Validar fecha de expiración (MM/AA o MM/AAAA)
        String[] fechaParts = fechaExpiracion.split("/");
        if (fechaParts.length != 2 || fechaParts[0].length() != 2 || (fechaParts[1].length() != 2 && fechaParts[1].length() != 4)) {
            response.sendRedirect("checkout.jsp?error=Fecha de expiración inválida (formato MM/AA o MM/AAAA)");
            return;
        }
        int mes = Integer.parseInt(fechaParts[0]);
        int anio = Integer.parseInt(fechaParts[1].length() == 2 ? "20" + fechaParts[1] : fechaParts[1]);
        int anioActual = new Date().getYear() + 1900; // Año completo (2025)
        if (anio <= 2024 || mes < 1 || mes > 12) {
            response.sendRedirect("checkout.jsp?error=La tarjeta debe expirar después de 2024");
            return;
        }
    }

    // Crear Timestamp para fecha_pedido
    Timestamp fechaPedido = new Timestamp(new Date().getTime());

    conexion con = new conexion();
    Connection conn = null;
    try {
        conn = con.getConnection();
        conn.setAutoCommit(false);

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
                response.sendRedirect("carrito.jsp?error=Stock insuficiente para " + nombreProducto);
                return;
            }
        }
        rsCheckStock.close();
        psCheckStock.close();

        // Insertar pedido
        String insertPedidoSql = "INSERT INTO tb_pedidos (id_us, fecha_pedido, total, metodo_pago) " +
                                "VALUES (?, ?, ?, ?)";
        PreparedStatement psPedido = conn.prepareStatement(insertPedidoSql, Statement.RETURN_GENERATED_KEYS);
        psPedido.setInt(1, idUsuario);
        psPedido.setTimestamp(2, fechaPedido);
        psPedido.setDouble(3, totalConIva);
        psPedido.setString(4, metodoPago);
        psPedido.executeUpdate();

        // Obtener ID del pedido
        ResultSet rsPedido = psPedido.getGeneratedKeys();
        int idPedido = 0;
        if (rsPedido.next()) {
            idPedido = rsPedido.getInt(1);
        } else {
            throw new SQLException("No se pudo obtener el ID del pedido generado.");
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

        final double IVA = 0.15;
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
        // Guardar idPedido en la sesión para mostrarlo en exitoCompra.jsp
        session.setAttribute("idPedido", idPedido);
        response.sendRedirect("exitoCompra.jsp");
    } catch (Exception e) {
        e.printStackTrace();
        if (conn != null) {
            try {
                conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        response.sendRedirect("checkout.jsp?error=Error al procesar la compra: " + e.getMessage());
    } finally {
        if (conn != null) {
            try {
                conn.setAutoCommit(true);
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        con.close();
    }
%>