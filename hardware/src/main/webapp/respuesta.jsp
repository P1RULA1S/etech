<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Datos Recibidos</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 2rem;
            background-color: #f4f4f4;
            color: #333;
        }
        h2 {
            color: #2a9d8f;
        }
        p {
            margin: 0.5rem 0;
        }
        .error {
            color: #e76f51;
            background-color: #ffe6e6;
            padding: 10px;
            border-radius: 5px;
        }
        .success {
            color: #2a9d8f;
            background-color: #e6f3f3;
            padding: 10px;
            border-radius: 5px;
        }
        a {
            color: #2a9d8f;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <h2>Datos enviados desde el formulario:</h2>
    <% if (request.getAttribute("error") != null) { %>
        <p class="error"><%= request.getAttribute("error") %></p>
    <% } %>
    <% if (request.getAttribute("mensaje") != null) { %>
        <p class="success"><%= request.getAttribute("mensaje") %></p>
    <% } %>
    <p><strong>Nombre:</strong> <%= request.getAttribute("nombre") != null ? request.getAttribute("nombre") : "No ingresado" %></p>
    <p><strong>Cédula:</strong> <%= request.getAttribute("cedula") != null ? request.getAttribute("cedula") : "No ingresada" %></p>
    <p><strong>Provincia:</strong> <%= request.getAttribute("provincia") != null ? request.getAttribute("provincia") : "No identificada" %></p>
    <p><strong>Correo:</strong> <%= request.getAttribute("correo") != null ? request.getAttribute("correo") : "No ingresado" %></p>
    <p><strong>Estado Civil:</strong> <%= request.getAttribute("estadoCivil") != null ? request.getAttribute("estadoCivil") : "No seleccionado" %></p>
    <p><strong>Residencia:</strong> <%= request.getAttribute("residencia") != null ? request.getAttribute("residencia") : "No seleccionada" %></p>
    <p><strong>Fecha de Nacimiento:</strong> <%= request.getAttribute("fechaNacimiento") != null ? request.getAttribute("fechaNacimiento") : "No ingresada" %></p>
    <p><strong>Color Favorito:</strong>
        <span style="color: <%= request.getAttribute("colorFavorito") != null && !((String)request.getAttribute("colorFavorito")).trim().isEmpty() ? request.getAttribute("colorFavorito") : "#000000" %>;">
            Este es tu color favorito
        </span>
    </p>
    <p><strong>Contraseña:</strong> <%= request.getAttribute("clave") != null ? request.getAttribute("clave") : "No ingresada" %></p>
    <p><a href="index.jsp"><i class="fas fa-home"></i> Regresar al menú</a></p>
</body>
</html>