<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");

    // Obtener parámetros del formulario
    String nombre = request.getParameter("txtNombre");
    String cedula = request.getParameter("txtCedula");
    String correo = request.getParameter("txtCorreo");
    String estadoCivil = request.getParameter("cmbECivil");
    String residencia = request.getParameter("rdResidencia");
    String fechaNacimiento = request.getParameter("fecha");
    String colorFavorito = request.getParameter("colorFavorito");
    String clave = request.getParameter("txtClave"); // Obtener la contraseña
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Datos Recibidos</title>
</head>
<body style="font-family: Arial; padding: 2rem; background-color: #f4f4f4; color: #333;">
    <h2>Datos enviados desde el formulario:</h2>
    <p><strong>Nombre:</strong> <%= (nombre != null) ? nombre : "No ingresado" %></p>
    <p><strong>Cédula:</strong> <%= (cedula != null) ? cedula : "No ingresada" %></p>
    <p><strong>Correo:</strong> <%= (correo != null) ? correo : "No ingresado" %></p>
    <p><strong>Estado Civil:</strong> <%= (estadoCivil != null) ? estadoCivil : "No seleccionado" %></p>
    <p><strong>Residencia:</strong> <%= (residencia != null) ? residencia : "No seleccionada" %></p>
    <p><strong>Fecha de nacimiento:</strong> <%= (fechaNacimiento != null) ? fechaNacimiento : "No ingresada" %></p>
    <p><strong>Color favorito:</strong>
        <font color="<%= (colorFavorito != null && !colorFavorito.trim().isEmpty()) ? colorFavorito : "#000000" %>">
            Este es tu color favorito
        </font>
    </p>
    <p><strong>Contraseña:</strong> <%= (clave != null) ? "Contraseña recibida." : "No ingresada" %></p>
</body>
</html>
