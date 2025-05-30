<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true"%>
<%@ page import="java.text.SimpleDateFormat, java.util.Date, com.productos.negocio.*, com.productos.datos.conexion, java.sql.*" %>
<%
String perfil = (String) session.getAttribute("perfil");
if (perfil == null || !perfil.equalsIgnoreCase("Cliente")) {
    response.sendRedirect("index.jsp");
    return;
}
String usuario = (String) session.getAttribute("usuario");
SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
String fechaHora = sdf.format(new Date());

// Contador de productos en el carrito
int contadorCarrito = 0;
Integer idUsuario = (Integer) session.getAttribute("idUsuario");
if (idUsuario == null) {
    System.out.println("Error crítico: idUsuario es null en producto_cliente.jsp. Atributos de sesión: " + session.getAttributeNames().toString());
    response.sendRedirect("login.jsp?error=Sesión inválida, inicie sesión nuevamente");
    return;
}
conexion con = new conexion();
try {
    String sql = "SELECT COUNT(*) FROM tb_carrito WHERE id_us = ?";
    PreparedStatement ps = con.getConnection().prepareStatement(sql);
    ps.setInt(1, idUsuario);
    ResultSet rs = ps.executeQuery();
    if (rs.next()) {
        contadorCarrito = rs.getInt(1);
    }
    rs.close();
    ps.close();
} catch (SQLException e) {
    e.printStackTrace();
} finally {
    con.close();
}
%>
<!DOCTYPE html>
<html lang="es">
<head>
	<meta http-equiv="Cache-Control" content="public, max-age=31536000">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Todos los Productos - E-TECH</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.cdnfonts.com/css/ethnocentric" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Bungee&family=Press+Start+2P&display=swap" rel="stylesheet">
    <link href="css/estilo1.1.css" rel="stylesheet" type="text/css">
    <link href="css/estilo_productos.css" rel="stylesheet" type="text/css">
</head>
<body>
<main>
    <div class="user-bar">
        <span><i class="fas fa-user-circle"></i> <%= usuario %> (Cliente)</span>
        <span><i class="fas fa-clock"></i> <%= fechaHora %></span>
    </div>

    <header>
        <h1>E-TECH</h1>
        <h2 id="destacado">Tecnología a tu alcance</h2>
        <h4 id="favorito">Construimos poder, Jugamos sin límites</h4>
    </header>

    <nav>
        <a href="index_cliente.jsp"><i class="fas fa-home"></i> Menú</a>
        <a href="producto_cliente.jsp" class="active"><i class="fas fa-list"></i> Productos</a>
        <a href="categoria_cliente.jsp"><i class="fas fa-search"></i> Categorías</a>
        <a href="carrito.jsp"><i class="fas fa-shopping-cart"></i> Carrito 
            <span class="badge"><%= contadorCarrito %></span>
        </a>
        <a href="misCompras.jsp"><i class="fas fa-shopping-bag"></i> Mis Compras</a>
        <a href="favoritos.jsp"><i class="fas fa-heart"></i> Favoritos</a>
        <a href="cerrarSesion.jsp"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a>
    </nav>

    <div class="agrupar">
        <section class="productos-section">
            <h3 class="section-title">Todos nuestros productos</h3>
            <%
            Producto producto = new Producto();
            String productosHtml = producto.consultarTodoEnTarjetas();
            out.print(productosHtml);
            %>
        </section>
    </div>

    <footer>
        <ul>
<li>
    <a href="https://www.facebook.com/share/15zHexzLbU/" target="_blank" rel="noopener noreferrer" aria-label="Visitar nuestra página en Facebook">
        <img src="iconos/facebook.png" alt="Facebook" width="30" height="30"> 
        <span>Facebook</span>
    </a>
</li>
<li>
    <a href="https://www.instagram.com/elvis.g.03?igsh=MXd6MzMzdTJqb2l6bw==" target="_blank" rel="noopener noreferrer" aria-label="Visitar nuestro perfil en Instagram">
        <img src="iconos/instagram.png" alt="Instagram" width="30" height="30"> 
        <span>Instagram</span>
    </a>
</li>
<li>
    <a href="https://x.com/tech_e51533" target="_blank" rel="noopener noreferrer" aria-label="Visitar nuestro perfil en Twitter">
        <img src="iconos/gorjeo.png" alt="Twitter" width="30" height="30"> 
        <span>Twitter</span>
    </a>
</li>
        </ul>
    </footer>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Manejar favoritos
        document.querySelectorAll('.favorite-icon').forEach(icon => {
            icon.addEventListener('click', function() {
                const productCard = this.closest('.product-card');
                if (!productCard) {
                    alert("Error: No se encontró la tarjeta del producto");
                    return;
                }
                const productId = productCard.getAttribute('data-product-id');
                if (!productId) {
                    alert("Error: ID de producto no encontrado");
                    return;
                }
                fetch('gestionarFavoritos.jsp?action=toggle&id=' + productId, {
                    method: 'POST'
                })
                .then(response => response.text())
                .then(data => {
                    if (data.trim() === "added") {
                        this.classList.remove('far');
                        this.classList.add('fas');
                        this.classList.add('active');
                        alert("Producto añadido a favoritos");
                    } else if (data.trim() === "removed") {
                        this.classList.remove('fas');
                        this.classList.add('far');
                        this.classList.remove('active');
                        alert("Producto eliminado de favoritos");
                    } else {
                        alert("Error al gestionar favorito: " + data);
                    }
                })
                .catch(error => alert("Error al gestionar favorito: " + error));
            });
        });

        // Manejar "ADD TO CART" con formulario
        document.querySelectorAll('.product-card .add-to-cart-btn').forEach(btn => {
            btn.addEventListener('click', function(e) {
                e.preventDefault();
                const productCard = this.closest('.product-card');
                if (!productCard) {
                    alert("Error: No se encontró la tarjeta del producto");
                    return;
                }
                const productId = productCard.getAttribute('data-product-id');
                if (!productId) {
                    alert("Error: ID de producto no encontrado");
                    return;
                }
                const form = document.createElement('form');
                form.action = 'agregarCarrito.jsp';
                form.method = 'post';
                form.style.display = 'none';
                const idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'id';
                idInput.value = productId;
                const cantidadInput = document.createElement('input');
                cantidadInput.type = 'hidden';
                cantidadInput.name = 'cantidad';
                cantidadInput.value = 1; // Cantidad fija por ahora
                form.appendChild(idInput);
                form.appendChild(cantidadInput);
                document.body.appendChild(form);
                form.submit();
            });
        });
    });
</script>
</body>
</html>