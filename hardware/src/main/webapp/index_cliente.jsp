<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true"%>
<%@ page import="java.text.SimpleDateFormat, java.util.Date" %>
<%
String perfil = (String) session.getAttribute("perfil");
if (perfil == null || !perfil.equalsIgnoreCase("Cliente")) {
    response.sendRedirect("index.jsp");
    return;
}
String usuario = (String) session.getAttribute("usuario");
SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
String fechaHora = sdf.format(new Date());
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>E-TECH - Cliente</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.cdnfonts.com/css/ethnocentric" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Bungee&family=Press+Start+2P&family=Quantico:ital,wght@0,400;0,700;1,400;1,700&display=swap" rel="stylesheet">
    <link href="css/estilo1.1.css" rel="stylesheet" type="text/css">
</head>
<body>
<main>
    <div class="user-bar">
        <span><i class="fas fa-user-circle"></i> <%= usuario %> (Cliente)</span>
        <span><i class="fas fa-clock"></i> <%= fechaHora %></span>
    </div>

    <header>
        <h1>E-TECH</h1>
        <h2 id="destacado">Panel de Cliente</h2>
    </header>

    <nav>
        <a role="navigation" aria-label="Menú principal" href="index.jsp"><i class="fas fa-home"></i> Menú</a>
        <a role="navigation" aria-label="Productos Existentes" href="producto_cliente.jsp"><i class="fas fa-list"></i> Productos</a>
        <a role="navigation" aria-label="Busqueda por categoria" href="categoria_cliente.jsp"><i class="fas fa-search"></i> Categorías</a>
        <a role="navigation" aria-label="Ver mis productos agregados" href="carrito.jsp"><i class="fas fa-shopping-cart"></i> Carrito</a>
        <a role="navigation" aria-label="Ver mis favoritos " href="favoritos.jsp"><i class="fas fa-heart"></i> Favoritos</a>
        <a role="navigation" aria-label="Observar mis compras" href="misCompras.jsp"><i class="fas fa-shopping-bag"></i> Mis Compras</a>
        <a role="navigation" aria-label="Cerrar sesión" href="cerrarSesion.jsp"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a>
    </nav>
    
    <div class="agrupar">
        <section>
            <h3>Bienvenido</h3>
            <p>Aquí puedes ver y gestionar los productos en tu carrito y favoritos.</p>
        </section>
    </div>

    <footer>
        <ul>
            <li><a href="https://www.facebook.com/share/15zHexzLbU/" target="_blank"><img src="iconos/facebook.png" width="30"> Facebook</a></li>
            <li><a href="https://www.instagram.com/elvis.g.03" target="_blank"><img src="iconos/instagram.png" width="30"> Instagram</a></li>
            <li><a href="https://x.com/tech_e51533" target="_blank"><img src="iconos/gorjeo.png" width="30"> Twitter</a></li>
        </ul>
    </footer>
</main>
</body>
</html>