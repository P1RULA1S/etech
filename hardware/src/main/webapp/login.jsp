<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - E-TECH</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="css/estilo_login.css">
</head>
<body>
    <%
    // Verificación de sesión
    String usuario = (String) session.getAttribute("usuario");
    if (usuario != null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Obtener parámetros de mensaje y error
    String mensaje = request.getParameter("message") != null ? java.net.URLDecoder.decode(request.getParameter("message"), "UTF-8") : "";
    String error = request.getParameter("error") != null ? java.net.URLDecoder.decode(request.getParameter("error"), "UTF-8") : "";
    %>

    <div class="login-container">
        <h1><i class="fas fa-lock"></i> Iniciar Sesión</h1>
        
        <% if (!mensaje.isEmpty()) { %>
            <div class="alert alert-info">
                <i class="fas fa-info-circle"></i> <%= mensaje %>
            </div>
        <% } %>
        
        <% if (!error.isEmpty()) { %>
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i> <%= error %>
            </div>
        <% } %>
        
        <form action="validarLogin1.jsp" method="post">
            <div class="form-group">
                <label for="usuario"><i class="fas fa-envelope"></i> Correo electrónico:</label>
                <input type="email" id="usuario" name="usuario" required>
            </div>
            
            <div class="form-group">
                <label for="clave"><i class="fas fa-key"></i> Contraseña:</label>
                <input type="password" id="clave" name="clave" required>
            </div>
            
            <button type="submit" class="btn-login">
                <i class="fas fa-sign-in-alt"></i> Ingresar
            </button>
        </form>
        
        <button onclick="window.location.href='registro.jsp'" class="btn-login btn-register">
            <i class="fas fa-user-plus"></i> Registrarse
        </button>
    </div>
</body>
</html>