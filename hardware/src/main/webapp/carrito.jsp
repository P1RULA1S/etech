<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true"%>
<%@ page import="com.productos.datos.conexion, java.sql.*, java.text.DecimalFormat, java.net.URLDecoder, java.net.URLEncoder" %>
<%
    // Verificación de sesión
    String perfil = (String) session.getAttribute("perfil");
    if (perfil == null || !perfil.equalsIgnoreCase("Cliente")) {
        response.sendRedirect("index.jsp");
        return;
    }
    Integer idUsuario = (Integer) session.getAttribute("idUsuario");
    if (idUsuario == null) {
        response.sendRedirect("login.jsp?error=" + URLEncoder.encode("Sesión inválida, inicie sesión nuevamente", "UTF-8"));
        return;
    }

    conexion con = new conexion();
    DecimalFormat df = new DecimalFormat("#.##");
    double totalSinIva = 0.0;
    final double IVA = 0.15; // IVA Ecuador 2025
    double totalConIva = 0.0;

    // Decodificar parámetros para manejar tildes y ñ
    String message = request.getParameter("message");
    if (message != null) {
        message = URLDecoder.decode(message, "UTF-8");
    }
    String error = request.getParameter("error");
    if (error != null) {
        error = URLDecoder.decode(error, "UTF-8");
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Carrito de Compras - E-TECH</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.cdnfonts.com/css/ethnocentric" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Bungee&family=Press+Start+2P&family=Quantico:ital,wght@0,400;0,700;1,400;1,700&display=swap" rel="stylesheet">
    <link href="css/estilo1.1.css" rel="stylesheet" type="text/css">
    <link href="css/estilo_productos.css" rel="stylesheet" type="text/css">
    <style>
        .custom-alert {
            background-color: #333333;
            color: #ffffff;
            border: 2px solid #ff0000;
            border-radius: 5px;
            padding: 10px;
            margin-bottom: 15px;
            text-align: center;
            font-family: 'Quantico', sans-serif;
        }
        .custom-alert-success {
            border-color: #00ff00; /* Verde para éxito */
        }
        .custom-alert-error {
            border-color: #ff0000; /* Rojo para error */
        }
    </style>
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
        <a href="carrito.jsp" class="active"><i class="fas fa-shopping-cart"></i> Carrito</a>
        <a href="favoritos.jsp"><i class="fas fa-heart"></i> Favoritos</a>
        <a href="misCompras.jsp"><i class="fas fa-shopping-bag"></i> Mis Compras</a>
        <a href="cerrarSesion.jsp"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a>
    </nav>

    <div class="agrupar">
        <section class="productos-section">
            <h3 class="section-title">Tu Carrito de Compras</h3>
            <%
                if (message != null) {
            %>
                <div class="custom-alert custom-alert-success"><%= message %></div>
            <%
                }
                if (error != null) {
            %>
                <div class="custom-alert custom-alert-error"><%= error %></div>
            <%
                }
            %>
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>Producto</th>
                        <th>Cantidad</th>
                        <th>Precio Unitario</th>
                        <th>Subtotal (sin IVA)</th>
                        <th>Subtotal (con IVA 15%)</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try {
                            String sql = "SELECT p.id_pr, p.nombre_pr, c.cantidad, c.precio_unitario, (c.cantidad * c.precio_unitario) AS subtotal " +
                                        "FROM tb_carrito c JOIN tb_productos p ON c.id_pr = p.id_pr " +
                                        "WHERE c.id_us = ?";
                            PreparedStatement ps = con.getConnection().prepareStatement(sql);
                            ps.setInt(1, idUsuario);
                            ResultSet rs = ps.executeQuery();
                            if (!rs.isBeforeFirst()) {
                    %>
                        <tr>
                            <td colspan="6" class="text-center">El carrito está vacío</td>
                        </tr>
                    <%
                            } else {
                                while (rs.next()) {
                                    int idProducto = rs.getInt("id_pr");
                                    String nombre = rs.getString("nombre_pr");
                                    int cantidad = rs.getInt("cantidad");
                                    double precioUnitario = rs.getDouble("precio_unitario");
                                    double subtotalSinIva = rs.getDouble("subtotal");
                                    double subtotalConIva = subtotalSinIva * (1 + IVA);
                                    totalSinIva += subtotalSinIva;
                                    totalConIva += subtotalConIva;
                    %>
                    <tr>
                        <td><%= nombre %></td>
                        <td>
                            <form action="actualizarCantidadCarrito.jsp" method="post" class="d-inline">
                                <input type="hidden" name="id" value="<%= idProducto %>">
                                <input type="number" name="cantidad" value="<%= cantidad %>" min="1" class="form-control d-inline-block w-auto" style="width: 80px;">
                                <button type="submit" class="btn btn-sm btn-primary ms-1"><i class="fas fa-save"></i></button>
                            </form>
                        </td>
                        <td>$<%= df.format(precioUnitario) %></td>
                        <td>$<%= df.format(subtotalSinIva) %></td>
                        <td>$<%= df.format(subtotalConIva) %></td>
                        <td>
                            <a href="eliminarCarrito.jsp?id=<%= idProducto %>" class="btn btn-danger btn-sm"
                               onclick="return confirm('¿Eliminar este producto del carrito?');">
                                <i class="fas fa-trash"></i>
                            </a>
                        </td>
                    </tr>
                    <%
                                }
                            }
                            rs.close();
                            ps.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                    %>
                        <tr>
                            <td colspan="6" class="custom-alert custom-alert-error">
                                Error al cargar el carrito: <%= e.getMessage() %>
                            </td>
                        </tr>
                    <%
                        } finally {
                            con.close();
                        }
                    %>
                </tbody>
            </table>
            <div class="text-end">
                <h4>Subtotal (sin IVA): $<%= df.format(totalSinIva) %></h4>
                <h4>IVA (15%): $<%= df.format(totalSinIva * IVA) %></h4>
                <h4>Total (con IVA): $<%= df.format(totalConIva) %></h4>
                <%
                    if (totalConIva > 0) {
                %>
                    <a href="checkout.jsp" class="btn btn-primary">Proceder al Pago</a>
                <%
                    }
                %>
            </div>
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