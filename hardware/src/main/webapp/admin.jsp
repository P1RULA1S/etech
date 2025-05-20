<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true"%>
<%@ page import="java.text.SimpleDateFormat, java.util.Date" %>
<%
// Verificar que el usuario sea administrador
String perfil = (String) session.getAttribute("perfil");
if (perfil == null || !perfil.equalsIgnoreCase("Administrador")) {
    response.sendRedirect("index.jsp");
    return;
}

%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>E-TECH</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.cdnfonts.com/css/ethnocentric" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Bungee&family=Press+Start+2P&family=Quantico:ital,wght@0,400;0,700;1,400;1,700&display=swap" rel="stylesheet">
    <link href="css/estilo1.1.css" rel="stylesheet" type="text/css">
</head>
<body>
    <%
    // Obtener información de sesión
    String usuario = (String) session.getAttribute("usuario");
    
    // Obtener fecha y hora actual
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
    String fechaHora = sdf.format(new Date());
    %>
    
    <main>
        <div class="user-bar">
            <span><i class="fas fa-user-circle"></i> <%= usuario %> (Administrador)</span>
            <span><i class="fas fa-clock"></i> <%= fechaHora %></span>
        </div>
        
        <header>
            <h1>E-TECH</h1>
            <h2 id="destacado">Tecnología a tu alcance</h2>
            <h4 id="favorito">Construimos poder, Jugamos sin límites</h4>
        </header>
       
        <nav>
            <a href="index.jsp"><i class="fas fa-home"></i> Menú</a>
            <a href="registro2.jsp"><i class="fas fa-users"></i> Gestión de Usuarios</a>
            <a href="bitacora.jsp"><i class="fas fa-book"></i> Bitácora</a>
            <a href="cerrarSesion.jsp"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a>
        </nav>
        
        <div class="agrupar">
            <section>
                <h3>Panel de Administración</h3>
                <p>Bienvenido al panel de control administrativo. Desde aquí puedes gestionar todos los aspectos del sistema.</p>
                <div class="admin-features">
                    <div class="feature-card">
                        <i class="fas fa-users-cog fa-3x"></i>
                        <h4>Gestión de Usuarios</h4>
                        <p>Administra los usuarios del sistema, permisos y roles.</p>
                    </div>
                    <div class="feature-card">
                        <i class="fas fa-clipboard-list fa-3x"></i>
                        <h4>Bitácora</h4>
                        <p>Revisa el registro de actividades del sistema.</p>
                    </div>
                    <div class="feature-card">
                        <i class="fas fa-chart-line fa-3x"></i>
                        <h4>Reportes</h4>
                        <p>Genera reportes estadísticos del negocio.</p>
                    </div>
                </div>
            </section>           
            <aside>
                <a href="https://www.linkedin.com/in/elvis-garciaacevedo-13408335b">Ver más información sobre los desarrolladores</a>
            </aside>
            
            <div class="mapa">
                <h5>Encuéntranos aquí</h5>
                <div class="contenedor-mapa">
                    <iframe 
                        src="https://www.google.com/maps/d/embed?mid=1Tho-NGVuQqh3szwH-r1qA2NI27YJl3s" 
                        width="100%" 
                        height="300"
                        style="border:0;" 
                        allowfullscreen=""
                        loading="lazy">
                    </iframe>
                </div>
            </div>
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