<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cambiar Clave - E-TECH</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.cdnfonts.com/css/ethnocentric" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Bungee&family=Press+Start+2P&family=Quantico:ital,wght@0,400;0,700;1,400;1,700&display=swap" rel="stylesheet">
    <link href="css/estilo1.1.css" rel="stylesheet" type="text/css">
    <link href="css/cambioClave.css" rel="stylesheet" type="text/css">
    <script>
        function validarClaves() {
            const claveActual = document.getElementById("txtClaveActual").value;
            const claveNueva = document.getElementById("txtClaveNueva").value;
            const repetirClave = document.getElementById("txtRepetirClave").value;
            
            if (claveActual === "" || claveNueva === "" || repetirClave === "") {
                alert("Todos los campos son obligatorios.");
                return false;
            }
            
            if (claveNueva !== repetirClave) {
                alert("La nueva clave y su repetición no coinciden.");
                return false;
            }
            
            if (claveNueva.length < 6) {
                alert("La nueva clave debe tener al menos 6 caracteres.");
                return false;
            }
            
            return true;
        }
    </script>
</head>
<body>
    <%
    String usuario = (String) session.getAttribute("usuario");
    String perfil = (String) session.getAttribute("perfil");
    String fechaHora = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new java.util.Date());
    %>
    
    <div class="user-bar">
        <span><i class="fas fa-user-circle"></i> <%= usuario %> (<%= perfil %>)</span>
        <span><i class="fas fa-clock"></i> <%= fechaHora %></span>
        <a href="index.jsp"><i class="fas fa-home"></i> Volver al Inicio</a>
    </div>
    
    <header>
        <h1>E-TECH</h1>
        <h2 id="destacado">Tecnología a tu alcance</h2>
        <h4 id="favorito">Construimos poder, Jugamos sin límites</h4>
    </header>
    
    <nav>
        <a href="index.jsp"><i class="fas fa-home"></i> Menú</a>
        <a href="productos.jsp"><i class="fas fa-list"></i> Productos</a>
        <a href="categoria.jsp"><i class="fas fa-search"></i> Buscar</a>
    </nav>
    
    <div class="cambio-clave-container">
        <section class="cambio-clave-form">
            <h3><i class="fas fa-key"></i> CAMBIAR CLAVE</h3>
            <% if (request.getAttribute("error") != null) { %>
                <p class="error-message"><i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("error") %></p>
            <% } %>
            
            <form action="validarClave.jsp" method="post" onsubmit="return validarClaves()">
                <div class="form-group">
                    <label for="txtClaveActual"><i class="fas fa-lock"></i> Clave Actual:</label>
                    <input type="password" id="txtClaveActual" name="txtClaveActual" required />
                </div>
                
                <div class="form-group">
                    <label for="txtClaveNueva"><i class="fas fa-key"></i> Nueva Clave:</label>
                    <input type="password" id="txtClaveNueva" name="txtClaveNueva" required />
                </div>
                
                <div class="form-group">
                    <label for="txtRepetirClave"><i class="fas fa-key"></i> Repetir Nueva Clave:</label>
                    <input type="password" id="txtRepetirClave" name="txtRepetirClave" required />
                </div>
                
                <div class="form-actions">
                    <button type="submit" class="btn-submit">
                        <i class="fas fa-save"></i> Cambiar Clave
                    </button>
                    <button type="reset" class="btn-reset">
                        <i class="fas fa-undo"></i> Limpiar
                    </button>
                </div>
                
                <input type="hidden" name="txtCorreo" value="<%= session.getAttribute("email") %>" />
            </form>
        </section>
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
</body>
</html>