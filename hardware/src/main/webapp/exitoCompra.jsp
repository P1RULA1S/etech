<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true"%>
<%
    // Verificación de sesión
    String perfil = (String) session.getAttribute("perfil");
    if (perfil == null || !perfil.equalsIgnoreCase("Cliente")) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Compra Exitosa - E-TECH</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.cdnfonts.com/css/ethnocentric" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Bungee&family=Press+Start+2P&family=Quantico:ital,wght@0,400;0,700;1,400;1,700&display=swap" rel="stylesheet">
    <link href="css/estilo1.1.css" rel="stylesheet" type="text/css">
    <link href="css/estilo_productos.css" rel="stylesheet" type="text/css">
    <link href="css/estilo_exito.css" rel="stylesheet" type="text/css">
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
            <a href="misCompras.jsp"><i class="fas fa-shopping-bag"></i> Mis Compras</a>
            <a href="cerrarSesion.jsp"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a>
        </nav>

        <div class="agrupar">
            <section class="productos-section">
                <h3 class="section-title">¡Compra Exitosa!</h3>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> Tu compra ha sido procesada correctamente.
                </div>
                <div class="text-center">
                    <a href="producto_cliente.jsp" class="btn btn-primary">Volver a Productos</a>
                    <a href="index_cliente.jsp" class="btn btn-secondary">Ir al Menú</a>
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