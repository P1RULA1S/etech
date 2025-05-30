<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true"%>
<%@ page import="com.productos.datos.conexion, java.sql.*, java.text.DecimalFormat, java.text.SimpleDateFormat" %>
<%
    // Verificación de sesión
    String perfil = (String) session.getAttribute("perfil");
    if (perfil == null || !perfil.equalsIgnoreCase("Cliente")) {
        response.sendRedirect("index.jsp");
        return;
    }
    Integer idUsuario = (Integer) session.getAttribute("idUsuario");
    if (idUsuario == null) {
        response.sendRedirect("login.jsp?error=Sesión inválida, inicie sesión nuevamente");
        return;
    }

    // Formato para fechas y decimales
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
    DecimalFormat df = new DecimalFormat("#.##");

    // Consultar los pedidos del usuario
    conexion con = new conexion();
    StringBuilder pedidosHTML = new StringBuilder();
    try {
        // Consulta para obtener los pedidos
        String sqlPedidos = "SELECT id_pedido, fecha_pedido, total, metodo_pago " +
                           "FROM tb_pedidos WHERE id_us = ? ORDER BY fecha_pedido DESC";
        PreparedStatement psPedidos = con.getConnection().prepareStatement(sqlPedidos);
        psPedidos.setInt(1, idUsuario);
        ResultSet rsPedidos = psPedidos.executeQuery();

        if (!rsPedidos.isBeforeFirst()) {
            pedidosHTML.append("<div class='alert alert-info text-center'>No tienes pedidos realizados.</div>");
        } else {
            while (rsPedidos.next()) {
                int idPedido = rsPedidos.getInt("id_pedido");
                String fechaPedido = sdf.format(rsPedidos.getTimestamp("fecha_pedido"));
                double total = rsPedidos.getDouble("total");
                String metodoPago = rsPedidos.getString("metodo_pago");

                pedidosHTML.append("<div class='card mb-3'>")
                           .append("<div class='card-header'>")
                           .append("<h5 class='mb-0'>Orden #").append(idPedido).append(" - ").append(fechaPedido).append("</h5>")
                           .append("</div>")
                           .append("<div class='card-body'>")
                           .append("<p><strong>Total:</strong> $").append(df.format(total)).append("</p>")
                           .append("<p><strong>Método de Pago:</strong> ").append(metodoPago).append("</p>")
                           .append("<h6>Productos:</h6>")
                           .append("<ul class='list-group list-group-flush'>");

                // Consulta para obtener los detalles del pedido
                String sqlDetalles = "SELECT dp.id_pr, dp.cantidad, dp.precio_unitario, dp.subtotal, p.nombre_pr " +
                                    "FROM tb_detalle_pedido dp JOIN tb_productos p ON dp.id_pr = p.id_pr " +
                                    "WHERE dp.id_pedido = ?";
                PreparedStatement psDetalles = con.getConnection().prepareStatement(sqlDetalles);
                psDetalles.setInt(1, idPedido);
                ResultSet rsDetalles = psDetalles.executeQuery();

                while (rsDetalles.next()) {
                    String nombreProducto = rsDetalles.getString("nombre_pr");
                    int cantidad = rsDetalles.getInt("cantidad");
                    double precioUnitario = rsDetalles.getDouble("precio_unitario");
                    double subtotal = rsDetalles.getDouble("subtotal");

                    pedidosHTML.append("<li class='list-group-item'>")
                               .append("<div class='d-flex justify-content-between'>")
                               .append("<span>").append(nombreProducto).append(" (x").append(cantidad).append(")</span>")
                               .append("<span>$").append(df.format(subtotal)).append("</span>")
                               .append("</div>")
                               .append("</li>");
                }
                rsDetalles.close();
                psDetalles.close();

                pedidosHTML.append("</ul>")
                           .append("</div>")
                           .append("</div>");
            }
        }
        rsPedidos.close();
        psPedidos.close();
    } catch (SQLException e) {
        e.printStackTrace();
        pedidosHTML.append("<div class='alert alert-danger text-center'>Error al cargar tus pedidos: ").append(e.getMessage()).append("</div>");
    } finally {
        con.close();
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Mis Compras - E-TECH</title>
    <link href="https://fonts.cdnfonts.com/css/ethnocentric" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Bungee&family=Press+Start+2P&family=Quantico:ital,wght@0,400;0,700;1,400;1,700&display=swap" rel="stylesheet">
    <link href="css/estilo1.1.css" rel="stylesheet" type="text/css">
    <link href="css/estilo_productos.css" rel="stylesheet" type="text/css">
    
</head>
<body>
    <main>
        <header>
            <h1>E-TECH</h1>
            <h2 id="destacado">Tecnología a tu alcance</h2>
            <h4 id="favorito">Construimos poder, Jugamos sin límites</h4>
        </header>

        <nav>
            <a href="index_cliente.jsp"><i class="fas fa-home"></i> Menú</a>
            <a href="producto_cliente.jsp"><i class="fas fa-list"></i> Productos</a>
            <a href="categoria_cliente.jsp"><i class="fas fa-search"></i> Categorías</a>
            <a href="carrito.jsp"><i class="fas fa-shopping-cart"></i> Carrito</a>
            <a href="favoritos.jsp"><i class="fas fa-heart"></i> Favoritos</a>
            <a href="misCompras.jsp" class="active"><i class="fas fa-shopping-bag"></i> Mis Compras</a>
            <a href="cerrarSesion.jsp"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a>
        </nav>

        <div class="agrupar">
            <section class="productos-section">
                <h3 class="section-title">Mis Compras</h3>
                <%= pedidosHTML.toString() %>
            </section>
        </div>

        <footer>
            <ul>
                <li>
                    <a href="https://www.facebook.com/share/15zHexzLbU/" target="_blank" rel="noopener noreferrer">
                        <img src="iconos/facebook.png" alt="Facebook" width="30"> <span>Facebook</span>
                    </a>
                </li>
                <li>
                    <a href="https://www.instagram.com/elvis.g.03?igsh=MXd6MzMzdTJqb2l6bw==" target="_blank" rel="noopener noreferrer">
                        <img src="iconos/instagram.png" alt="Instagram" width="30"> <span>Instagram</span>
                    </a>
                </li>
                <li>
                    <a href="https://x.com/tech_e51533" target="_blank" rel="noopener noreferrer">
                        <img src="iconos/gorjeo.png" alt="Twitter" width="30"> <span>Twitter</span>
                    </a>
                </li>
            </ul>
        </footer>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>