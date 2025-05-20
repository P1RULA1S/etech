<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.productos.negocio.*"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Todos los Productos - E-TECH</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.cdnfonts.com/css/ethnocentric" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Bungee&family=Press+Start+2P&display=swap" rel="stylesheet">   
    <link href="css/estilo1.1.css" rel="stylesheet" type="text/css">
    <link href="css/estilo-productos.css" rel="stylesheet" type="text/css">
    <link href="css/estilo-tablas.css" rel="stylesheet" type="text/css">
	<link href="css/estilo-botones.css" rel="stylesheet" type="text/css">
</head>
<body>
    <main>
        <header>
            <h1>E-TECH</h1>
            <h2 id="destacado">Tecnología a tu alcance</h2>
            <h4 id="favorito">Construimos poder, Jugamos sin límites</h4>
        </header>
        
		<nav>
   			<a href="index.jsp"><i class="fas fa-home"></i> Menú</a>
   			<a href="productos.jsp"><i class="fas fa-list"></i> Productos</a>
    		<a href="categoria.jsp"><i class="fas fa-search"></i> Buscar</a>
    		<a href="login.jsp"><i class="fas fa-user"></i> Login</a>
		</nav>
        
        <div class="agrupar">
            <section>
                <h3>Todos nuestros productos</h3>
                
                <div class="productos-container">
                    <%
                    Producto producto = new Producto();
                    out.print(producto.consultarTodo1());
                    %>
                </div>
            </section>
            
            <aside>
                <a href="https://www.linkedin.com/in/elvis-garciaacevedo-13408335b">Ver más información sobre los desarrolladores</a>
            </aside>
        </div>
        
        <footer>
            <ul>
                <li>
                    <a href="https://www.facebook.com/share/15zHexzLbU/" target="_blank" rel="noopener noreferrer">
                        <img src="iconos/facebook.png" alt="Facebook" width="30" height="30"> 
                        <span>Facebook</span>
                    </a>
                </li>
                <li>
                    <a href="https://www.instagram.com/elvis.g.03?igsh=MXd6MzMzdTJqb2l6bw==" target="_blank" rel="noopener noreferrer">
                        <img src="iconos/instagram.png" alt="Instagram" width="30" height="30"> 
                        <span>Instagram</span>
                    </a>
                </li>
                <li>
                    <a href="https://x.com/tech_e51533" target="_blank" rel="noopener noreferrer">
                        <img src="iconos/gorjeo.png" alt="Twitter" width="30" height="30"> 
                        <span>Twitter</span>
                    </a>
                </li>
            </ul>
        </footer>
    </main>
</body>
</html>