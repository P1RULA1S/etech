<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Registro de Cliente</title>
    <link href="css/estilo_regis.css" rel="stylesheet" type="text/css">
    <style>
        .error-message {
            color: red;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid red;
            background-color: #ffeeee;
        }
        #provincia {
            color: #2a9d8f;
            font-weight: bold;
            margin-top: 5px;
        }
    </style>
    <script>
        function mostrarProvincia() {
            const cedula = document.getElementById("txtCedula").value;
            const provincias = {
                "01": "Azuay", "02": "Bolívar", "03": "Cañar", "04": "Carchi", "05": "Cotopaxi",
                "06": "Chimborazo", "07": "El Oro", "08": "Esmeraldas", "09": "Guayas", "10": "Imbabura",
                "11": "Loja", "12": "Los Ríos", "13": "Manabí", "14": "Morona Santiago", "15": "Napo",
                "16": "Pastaza", "17": "Pichincha", "18": "Tungurahua", "19": "Zamora Chinchipe",
                "20": "Galápagos", "21": "Sucumbíos", "22": "Orellana", "23": "Santo Domingo de los Tsáchilas",
                "24": "Santa Elena", "30": "Exterior"
            };
            const codigo = cedula.substring(0, 2);
            const provincia = provincias[codigo] || "Desconocida";
            document.getElementById("provincia").textContent = "Provincia: " + provincia;
        }

        function calcularEdad() {
            const fecha = document.getElementById("fecha").value;
            if (fecha) {
                const [year, month] = fecha.split("-");
                const hoy = new Date();
                const nacimiento = new Date(year, month - 1);
                let edad = hoy.getFullYear() - nacimiento.getFullYear();
                if (hoy.getMonth() < nacimiento.getMonth()) {
                    edad--;
                }
                document.getElementById("edad").textContent = "Edad: " + edad + " años";
            }
        }
    </script>
</head>
<body>
    <div class="registro">
        <section>
            <h3>REGISTRO DE CLIENTE</h3>

            <%-- Mostrar mensajes de error --%>
            <% if (request.getAttribute("error") != null) { %>
                <div class="error-message"><%= request.getAttribute("error") %></div>
            <% } %>

            <form action="RegistroServlet" method="post" enctype="multipart/form-data">
                <table border="1" style="border-collapse: collapse; width: 100%;">
                    <tr>
                        <td><label for="txtNombre">Nombre Completo:</label></td>
                        <td>
                            <input type="text" id="txtNombre" name="txtNombre" required
                                   value="<%= request.getParameter("txtNombre") != null ? request.getParameter("txtNombre") : "" %>"
                                   title="Ingrese su nombre completo." />
                            *
                        </td>
                    </tr>
                    <tr>
                        <td><label for="txtCedula">Cédula:</label></td>
                        <td>
                            <input type="text" id="txtCedula" name="txtCedula" maxlength="10"
                                   pattern="[0-9]{10}" required
                                   value="<%= request.getParameter("txtCedula") != null ? request.getParameter("txtCedula") : "" %>"
                                   title="Ingrese una cédula de 10 dígitos."
                                   oninput="mostrarProvincia()" />
                            <div id="provincia"></div> *
                        </td>
                    </tr>
                    <tr>
                        <td><label for="txtCorreo">Correo Electrónico:</label></td>
                        <td>
                            <input type="email" id="txtCorreo" name="txtCorreo" required
                                   value="<%= request.getParameter("txtCorreo") != null ? request.getParameter("txtCorreo") : "" %>"
                                   placeholder="usuario@dominio.com"
                                   title="Ingrese un correo electrónico válido." />
                            *
                        </td>
                    </tr>
                    <tr>
                        <td><label for="cmbECivil">Estado Civil:</label></td>
                        <td>
                            <select id="cmbECivil" name="cmbECivil" required>
                                <option value="">--Seleccione--</option>
                                <option value="Casado" <%= "Casado".equals(request.getParameter("cmbECivil")) ? "selected" : "" %>>Casado</option>
                                <option value="Soltero" <%= "Soltero".equals(request.getParameter("cmbECivil")) ? "selected" : "" %>>Soltero</option>
                                <option value="Divorciado" <%= "Divorciado".equals(request.getParameter("cmbECivil")) ? "selected" : "" %>>Divorciado</option>
                                <option value="Viudo" <%= "Viudo".equals(request.getParameter("cmbECivil")) ? "selected" : "" %>>Viudo</option>
                            </select>
                            *
                        </td>
                    </tr>
                    <tr>
                        <td>Residencia:</td>
                        <td>
                            <input type="radio" id="residenciaSur" name="rdResidencia" value="Sur" required
                                   <%= "Sur".equals(request.getParameter("rdResidencia")) ? "checked" : "" %> />
                            <label for="residenciaSur">Sur</label>
                            <input type="radio" id="residenciaNorte" name="rdResidencia" value="Norte"
                                   <%= "Norte".equals(request.getParameter("rdResidencia")) ? "checked" : "" %> />
                            <label for="residenciaNorte">Norte</label>
                            <input type="radio" id="residenciaCentro" name="rdResidencia" value="Centro"
                                   <%= "Centro".equals(request.getParameter("rdResidencia")) ? "checked" : "" %> />
                            <label for="residenciaCentro">Centro</label>
                            *
                        </td>
                    </tr>
                    <tr>
                        <td><label for="fecha">Fecha de Nacimiento:</label></td>
                        <td>
                            <input type="month" id="fecha" name="fecha" required
                                   value="<%= request.getParameter("fecha") != null ? request.getParameter("fecha") : "" %>"
                                   title="Seleccione su fecha de nacimiento."
                                   onchange="calcularEdad()" />
                            <div id="edad"></div> *
                        </td>
                    </tr>
                    <tr>
                        <td><label for="colorFavorito">Color Favorito:</label></td>
                        <td>
                            <input type="color" id="colorFavorito" name="colorFavorito"
                                   value="<%= request.getParameter("colorFavorito") != null ? request.getParameter("colorFavorito") : "#000000" %>" />
                        </td>
                    </tr>
                    <tr>
                        <td><label for="fileFoto">Foto de Perfil:</label></td>
                        <td>
                            <input type="file" id="fileFoto" name="fileFoto" accept=".jpg,.jpeg,.png"
                                   title="Seleccione una imagen en formato JPG o PNG." />
                        </td>
                    </tr>
                    <tr>
                        <td><label for="fileCV">Hoja de Vida (PDF):</label></td>
                        <td>
                            <input type="file" id="fileCV" name="fileCV" accept=".pdf" required
                                   title="Seleccione un archivo PDF (máximo 5MB)." />
                            *
                        </td>
                    </tr>
                    <tr>
                        <td><label for="txtClave">Contraseña:</label></td>
                        <td>
                            <input type="password" id="txtClave" name="txtClave" required minlength="8"
                                   title="La contraseña debe tener al menos 8 caracteres." />
                            *
                        </td>
                    </tr>
                    <tr>
                        <td><label for="txtRepetirClave">Repetir Contraseña:</label></td>
                        <td>
                            <input type="password" id="txtRepetirClave" name="txtRepetirClave" required minlength="8"
                                   title="Repita la contraseña." />
                            *
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align: center;">
                            <input type="submit" value="Registrarse" />
                            <input type="reset" value="Limpiar" />
                        </td>
                    </tr>
                </table>
            </form>
        </section>
    </div>
</body>
</html>