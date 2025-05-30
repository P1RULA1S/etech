<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true"%>
<%@ page import="com.productos.datos.conexion, java.sql.*, java.text.DecimalFormat" %>
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

    // Calcular total del carrito con IVA
    conexion con = new conexion();
    DecimalFormat df = new DecimalFormat("#.##");
    double totalSinIva = 0.0;
    final double IVA = 0.15;
    double totalConIva = 0.0;
    try {
        String sql = "SELECT SUM(c.cantidad * c.precio_unitario) as total FROM tb_carrito c WHERE c.id_us = ?";
        PreparedStatement ps = con.getConnection().prepareStatement(sql);
        ps.setInt(1, idUsuario);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            totalSinIva = rs.getDouble("total");
            totalConIva = totalSinIva * (1 + IVA);
        }
        rs.close();
        ps.close();
    } catch (SQLException e) {
        e.printStackTrace();
        totalSinIva = 0.0;
        totalConIva = 0.0;
    }

    if (totalSinIva == 0.0) {
        response.sendRedirect("carrito.jsp?error=El carrito está vacío");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Checkout - E-TECH</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="css/estilo_check.css" rel="stylesheet" type="text/css">
</head>
<body>
    <div class="container-fluid">
        <div class="row padding-top-20">
            <div class="col-12 col-sm-12 col-md-10 col-lg-10 col-xl-8 offset-md-1 offset-lg-1 offset-xl-2 padding-horizontal-40">
                <div class="row">
                    <div class="col-12 main-wrapper">
                        <div class="row">
                            <!-- Resumen de Compra -->
                            <div class="col-12 col-sm-12 col-md-6 col-lg-6 col-xl-6">
                                <div class="row panel-wrapper">
                                    <div class="col-12 panel-header basket-header">
                                        <div class="row">
                                            <div class="col-6 basket-title">
                                                <span class="description">Revisa tu</span><br>
                                                <span class="emphasized">Resumen de Compra</span>
                                            </div>
                                            <div class="col-6 order-number align-right">
                                                <span class="description">Orden #</span><br>
                                                <span class="emphasized">Pendiente</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-12 panel-body basket-body">
                                        <%
                                            try {
                                                String sql = "SELECT p.id_pr, p.nombre_pr, c.cantidad, c.precio_unitario, (c.cantidad * c.precio_unitario) AS subtotal " +
                                                            "FROM tb_carrito c JOIN tb_productos p ON c.id_pr = p.id_pr " +
                                                            "WHERE c.id_us = ?";
                                                PreparedStatement ps = con.getConnection().prepareStatement(sql);
                                                ps.setInt(1, idUsuario);
                                                ResultSet rs = ps.executeQuery();
                                                while (rs.next()) {
                                                    String nombre = rs.getString("nombre_pr");
                                                    int cantidad = rs.getInt("cantidad");
                                                    double precioUnitario = rs.getDouble("precio_unitario");
                                                    double subtotalSinIva = rs.getDouble("subtotal");
                                        %>
                                            <div class="row product">
                                                <div class="col-6"><%= nombre %></div>
                                                <div class="col-3 align-right"><%= cantidad %></div>
                                                <div class="col-3 align-right">$<%= df.format(subtotalSinIva) %></div>
                                            </div>
                                        <%
                                                }
                                                rs.close();
                                                ps.close();
                                            } catch (SQLException e) {
                                                e.printStackTrace();
                                        %>
                                            <div class="row">
                                                <div class="col-12 alert">
                                                    Error al cargar el resumen: <%= e.getMessage() %>
                                                </div>
                                            </div>
                                        <%
                                            } finally {
                                                con.close();
                                            }
                                        %>
                                    </div>
                                    <div class="col-12 panel-footer basket-footer">
                                        <hr>
                                        <div class="row">
                                            <div class="col-8 align-right description">Subtotal</div>
                                            <div class="col-4 align-right"><span class="emphasized">$<%= df.format(totalSinIva) %></span></div>
                                            <div class="col-8 align-right description">IVA (15%)</div>
                                            <div class="col-4 align-right"><span class="emphasized">$<%= df.format(totalSinIva * IVA) %></span></div>
                                        </div>
                                        <hr>
                                        <div class="row">
                                            <div class="col-8 align-right description">Total</div>
                                            <div class="col-4 align-right"><span class="very emphasized">$<%= df.format(totalConIva) %></span></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- Información de Pago -->
                            <div class="col-12 col-sm-12 col-md-6 col-lg-6 col-xl-6">
                                <div class="row panel-wrapper">
                                    <div class="col-12 panel-header creditcard-header">
                                        <div class="row">
                                            <div class="col-12 creditcard-title">
                                                <span class="description">Ingresa tu</span><br>
                                                <span class="emphasized">Información de Pago</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-12 panel-body creditcard-body">
                                        <%
                                            String error = request.getParameter("error");
                                            if (error != null) {
                                        %>
                                            <div class="alert"><%= error %></div>
                                        <%
                                            }
                                        %>
                                        <form id="paymentForm" action="confirmarCompra.jsp" method="post">
                                            <input type="hidden" name="metodoPago" value="tarjeta">
                                            <input type="hidden" name="total" value="<%= totalConIva %>">
                                            <fieldset>
                                                <label for="nombreTitular">Nombre en la Tarjeta</label><br>
                                                <i class="fa fa-user-o" aria-hidden="true"></i>
                                                <input type="text" id="nombreTitular" name="nombreTitular" placeholder="John Doe" title="Nombre en la Tarjeta" required>
                                            </fieldset>
                                            <fieldset>
                                                <label for="numeroTarjeta">Número de Tarjeta</label><br>
                                                <div class="card-input-container">
                                                    <i class="fa fa-credit-card" aria-hidden="true"></i>
                                                    <input type="text" id="numeroTarjeta" name="numeroTarjeta" placeholder="1234567890123456" title="Número de Tarjeta" maxlength="16" pattern="\d{16}" required>
                                                    <span id="cardType" class="card-type"></span>
                                                </div>
                                            </fieldset>
                                            <fieldset>
                                                <label for="fechaExpiracion">Fecha de Expiración</label><br>
                                                <i class="fa fa-calendar" aria-hidden="true"></i>
                                                <input type="text" id="fechaExpiracion" name="fechaExpiracion" placeholder="MM/AAAA" title="Fecha de Expiración" required>
                                            </fieldset>
                                            <fieldset>
                                                <label for="cvv">CVC/CCV</label>
                                                <i class="fa fa-lock" aria-hidden="true"></i>
                                                <input type="text" id="cvv" name="cvv" placeholder="123" title="CVC/CCV" maxlength="3" pattern="\d{3}" required>
                                            </fieldset>
                                        </form>
                                    </div>
                                    <div class="col-12 panel-footer creditcard-footer">
                                        <div class="row">
                                            <div class="col-12 align-right">
                                                <button class="cancel" onclick="window.location.href='carrito.jsp'">Cancelar</button>
                                                <button class="confirm" form="paymentForm" type="submit">Pagar</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/checkout.js"></script>
</body>
</html>