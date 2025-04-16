<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Registro</title>
<link href="css/estilo_regis.css" rel="stylesheet" type="text/css">
<script src="js/validaciones.js"></script>
</head>
<body>
<div class="registro">
<section>
    <h3>DATOS PERSONALES</h3>
    <form action="respuesta.jsp" method="post" >
      <table border="1" style="border-collapse: collapse; width: 100%;">

      
        <tr>
          <td><label for="txtNombre">Nombre:</label></td>
          <td><input type="text" id="txtNombre" name="txtNombre" required title="Ingrese su nombre completo." /> *</td>
        </tr>
        <tr>
          <td><label for="txtCedula">Cédula:</label></td>
          <td>
            <input type="text" id="txtCedula" name="txtCedula" maxlength="10"
                   pattern="[0-9]{10}" required 
                   title="Ingrese una cédula de 10 dígitos. Solo números." 
                   oninput="mostrarProvincia()" />
            <div id="provincia"></div> *
          </td>
        </tr>
        <tr>
          <td><label for="txtCorreo">Correo electrónico:</label></td>
          <td><input type="email" id="txtCorreo" name="txtCorreo" required
                     placeholder="usuario@dominio.com"
                     title="Ingrese un correo electrónico válido." /> *</td>
        </tr>
        <tr>
          <td><label for="cmbECivil">Estado Civil:</label></td>
          <td>
            <select id="cmbECivil" name="cmbECivil" required title="Seleccione su estado civil.">
              <option value="">--Seleccione--</option>
              <option value="Soltero">Soltero</option>
              <option value="Casado">Casado</option>
              <option value="Divorciado">Divorciado</option>
              <option value="Viudo">Viudo</option>
            </select> *
          </td>
        </tr>
        <tr>
          <td>Residencia:</td>
          <td>
            <input type="radio" id="residenciaSur" name="rdResidencia" value="Sur" required />
            <!-- Etiqueta asociada al botón de radio para seleccionar la opción-->
            <label for="residenciaSur">Sur</label>
            <input type="radio" id="residenciaNorte" name="rdResidencia" value="Norte" />
            <label for="residenciaNorte">Norte</label>
            <input type="radio" id="residenciaCentro" name="rdResidencia" value="Centro" />
            <label for="residenciaCentro">Centro</label> *
          </td>
        </tr>
        <tr>
          <td><label for="fileFoto">Seleccionar una imagen:</label></td>
          <td><input type="file" id="fileFoto" name="fileFoto" accept=".jpg, .jpeg, .png" /></td>
        </tr>

        <!-- Hoja de vida en PDF -->
        <tr>
          <td><label for="fileCV">Hoja de vida (PDF):</label></td>
          <td><input type="file" id="fileCV" name="fileCV" accept=".pdf" required title="Solo archivos PDF. Tamaño máximo 5MB." /></td>
        </tr>
        <tr>
          <td><label for="fecha">Fecha de nacimiento:</label></td>
          <td>
            <input type="month" id="fecha" name="fecha" required title="Seleccione su fecha de nacimiento." onchange="calcularEdad()" />
            <div id="edad"></div> *
          </td>
        </tr>
        <tr>
          <td><label for="colorFavorito">Color favorito:</label></td>
          <td><input type="color" id="colorFavorito" name="colorFavorito" /></td>
        </tr>
        <tr>
  			<td><label for="txtClave">Contraseña:</label></td>
  			<td style="position: relative;">
    		<input type="password" id="txtClave" name="txtClave" required title="Ingrese su contraseña." />
  		</td>
		</tr>
       <tr>
          <td colspan="2" style="text-align: center;">
            <input type="submit" value="Enviar" />
            <input type="reset" value="Resetear" />
          </td>
        </tr>
      </table>
    </form>
  </section>
</div>
</body>
</html>
