<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true"%>
<%@ page import="com.productos.seguridad.EstadoCivil, com.productos.seguridad.Perfil, java.text.SimpleDateFormat, java.util.Date" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Registro de Usuarios - E-TECH</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.cdnfonts.com/css/ethnocentric" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Bungee&family=Press+Start+2P&family=Quantico:ital,wght@0,400;0,700;1,400;1,700&display=swap" rel="stylesheet">
    <link href="css/estilo_Registro2.css" rel="stylesheet" type="text/css">
    <script>
        function validarFormulario() {
            const nombre = document.getElementById("txtNombre").value.trim();
            const cedula = document.getElementById("txtCedula").value.trim();
            const correo = document.getElementById("txtCorreo").value.trim();
            const estadoCivil = document.getElementById("cmbECivil").value;
            const perfil = document.getElementById("cmbPerfil").value;
            const fechaNacimiento = document.getElementById("fecha").value;

            if (!nombre || !cedula || !correo || !estadoCivil || !perfil || !fechaNacimiento) {
                alert("Todos los campos son obligatorios.");
                return false;
            }

            if (!/^[A-Za-z\s]+$/.test(nombre)) {
                alert("El nombre solo debe contener letras y espacios.");
                return false;
            }

            if (!/^[0-9]{10}$/.test(cedula)) {
                alert("La cédula debe tener exactamente 10 dígitos.");
                return false;
            }

            const regexCorreo = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
            if (!regexCorreo.test(correo)) {
                alert("El correo no es válido.");
                return false;
            }

            const fechaNac = new Date(fechaNacimiento);
            const hoy = new Date();
            let edad = hoy.getFullYear() - fechaNac.getFullYear();
            const mes = hoy.getMonth() - fechaNac.getMonth();
            if (mes < 0 || (mes === 0 && hoy.getDate() < fechaNac.getDate())) {
                edad--;
            }

            if (edad < 18) {
                alert("El usuario debe ser mayor de 18 años.");
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
    String fechaHora = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new Date());
%>

<div class="user-bar">
    <span><i class="fas fa-user-circle"></i> <%= usuario != null ? usuario : "Invitado" %> (<%= perfil != null ? perfil : "Sin perfil" %>)</span>
    <span><i class="fas fa-clock"></i> <%= fechaHora %></span>
    <a href="index.jsp"><i class="fas fa-home"></i> Volver al Inicio</a>
</div>

<header>
    <h1>E-TECH</h1>
</header>

<div class="registro-container">
    <div class="registro-form">
        <h3><i class="fas fa-user-plus"></i> REGISTRO DE USUARIO</h3>

        <% if (request.getAttribute("error") != null) { %>
            <div class="error-message">
                <i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <form action="validarRegistro.jsp" method="post" onsubmit="return validarFormulario()">
            <table class="registro-table">
                <tr>
                    <td><label for="txtNombre"><i class="fas fa-user"></i> Nombre Completo:</label></td>
                    <td><input type="text" id="txtNombre" name="txtNombre" required /></td>
                </tr>
                <tr>
                    <td><label for="txtCedula"><i class="fas fa-id-card"></i> Cédula:</label></td>
                    <td><input type="text" id="txtCedula" name="txtCedula" required maxlength="10" /></td>
                </tr>
                <tr>
                    <td><label for="txtCorreo"><i class="fas fa-envelope"></i> Correo Electrónico:</label></td>
                    <td><input type="email" id="txtCorreo" name="txtCorreo" required /></td>
                </tr>
                <tr>
                    <td><label for="cmbECivil"><i class="fas fa-heart"></i> Estado Civil:</label></td>
                    <td>
                        <%
                            EstadoCivil ec = new EstadoCivil();
                            out.println(ec.mostrarEstadoCivil());
                        %>
                    </td>
                </tr>
                <tr>
                    <td><label for="cmbPerfil"><i class="fas fa-user-tag"></i> Perfil:</label></td>
                    <td>
                        <%
                            Perfil p = new Perfil();
                            out.println(p.mostrarPerfil());
                        %>
                    </td>
                </tr>
                <tr>
                    <td><label for="fecha"><i class="fas fa-birthday-cake"></i> Fecha de Nacimiento:</label></td>
                    <td><input type="date" id="fecha" name="fecha" required /></td>
                </tr>
            </table>

            <div class="form-actions">
                <button type="submit" class="btn-submit">
                    <i class="fas fa-save"></i> Registrar Usuario
                </button>
                <button type="reset" class="btn-reset">
                    <i class="fas fa-undo"></i> Limpiar Formulario
                </button>
            </div>
        </form>
    </div>
</div>
</body>
</html>