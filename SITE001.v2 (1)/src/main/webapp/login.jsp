<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Iniciar Sesión</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/estilo_login.css">
</head>
<body>

    <div class="contenedor-login">
        <h1 class="titulo-login">Iniciar Sesión</h1>

        <form action="pagina_en_blanco.jsp" method="post" class="form-login">

            <!-- Usuario -->
            <div class="campo-login">
                <label for="txtUsuario">Usuario:</label>
                <input type="text" id="txtUsuario" name="txtUsuario" required placeholder="Ingresa tu usuario">
            </div>

            <!-- Contraseña -->
            <div class="campo-login">
                <label for="txtClave">Contraseña:</label>
                <input type="password" id="txtClave" name="txtClave" required placeholder="Ingresa tu contraseña">
            </div>

            <!-- Botón iniciar sesión -->
            <button type="submit" class="boton-login">Iniciar Sesión</button>

            <!-- Botón cambiar contraseña -->
            <button type="button" onclick="location.href='cambioClave.jsp'" class="boton-login">
                Cambiar Contraseña
            </button>

            <!-- Botón registrarse -->
            <button type="button" onclick="location.href='registro.jsp'" class="boton-login">
                Registrarse
            </button>
        </form>
    </div>

</body>
</html>

