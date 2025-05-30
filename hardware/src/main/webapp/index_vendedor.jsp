<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true"%>
<%@ page import="java.text.SimpleDateFormat, java.util.Date" %>
<%
String perfil = (String) session.getAttribute("perfil");
if (perfil == null || !perfil.equalsIgnoreCase("Vendedor")) {
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
    <title>E-TECH - Vendedor</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.cdnfonts.com/css/ethnocentric" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Bungee&family=Press+Start+2P&family=Quantico:ital,wght@0,400;0,700;1,400;1,700&display=swap" rel="stylesheet">
    <link href="css/estilo1.1.css" rel="stylesheet" type="text/css">
</head>
<body>
<script> window.onUsersnapLoad = function(api) { api.init(); }; var script = document.createElement('script'); script.defer = 1; script.src = 'https://widget.usersnap.com/global/load/66480ce5-b480-4aa8-bb0d-06f5441226e9?onload=onUsersnapLoad'; document.getElementsByTagName('head')[0].appendChild(script); </script>
<main>
    <div class="user-bar">
        <span><i class="fas fa-user-circle"></i> <%= usuario %> (Vendedor)</span>
        <span><i class="fas fa-clock"></i> <%= fechaHora %></span>
    </div>

    <header>
        <h1>E-TECH</h1>
        <h2 id="destacado">Panel de Vendedor</h2>
    </header>

    <nav>
       <a href="index_vendedor.jsp"><i class="fas fa-home"></i> Menú</a>
        <a href="GestionProductos.jsp"><i class="fas fa-cog"></i> GestionProductos</a>
		<a href="cambioClave.jsp"><i class="fas fa-key"></i> Cambiar Contraseña</a>
        <a href="cerrarSesion.jsp"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a>
    </nav>
    
    <div class="agrupar">
        <section>
            <h3>Bienvenido</h3>
            <p>Desde aquí puedes gestionar tus productos.</p>
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