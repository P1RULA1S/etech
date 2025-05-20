<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.productos.datos.conexion, java.sql.*, java.text.SimpleDateFormat, java.util.Date, com.productos.seguridad.usuarios" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Procesando Registro</title>
</head>
<body>
    <%
        conexion con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String mensaje = "";

        try {
            request.setCharacterEncoding("UTF-8");
            con = new conexion();
            if (con.getConnection() == null) {
                throw new SQLException("No se pudo conectar a la base de datos. Verifique las credenciales o la configuración del servidor.");
            }

            String nombre = request.getParameter("txtNombre");
            String cedula = request.getParameter("txtCedula");
            String correo = request.getParameter("txtCorreo");
            String estadoCivil = request.getParameter("cmbECivil");
            String perfil = request.getParameter("cmbPerfil");
            String fechaNacimiento = request.getParameter("fecha");

            StringBuilder errores = new StringBuilder();
            if (nombre == null || nombre.trim().isEmpty()) errores.append("El nombre es obligatorio. ");
            if (cedula == null || !cedula.matches("[0-9]{10}")) errores.append("La cédula debe tener 10 dígitos. ");
            if (correo == null || !correo.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) errores.append("El correo es inválido. ");
            if (estadoCivil == null || estadoCivil.trim().isEmpty()) errores.append("El estado civil es obligatorio. ");
            if (perfil == null || perfil.trim().isEmpty()) errores.append("El perfil es obligatorio. ");
            if (fechaNacimiento == null || fechaNacimiento.trim().isEmpty()) errores.append("La fecha de nacimiento es obligatoria. ");
            if (errores.length() > 0) throw new IllegalArgumentException(errores.toString());

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date fechaNac = sdf.parse(fechaNacimiento);
            Date hoy = new Date();
            long diff = hoy.getTime() - fechaNac.getTime();
            long años = diff / (1000L * 60 * 60 * 24 * 365);
            if (años < 18) {
                mensaje = "El usuario debe ser mayor de 18 años.";
                request.setAttribute("error", mensaje);
                request.getRequestDispatcher("registro2.jsp").forward(request, response);
                return;
            }

            String checkSql = "SELECT COUNT(*) FROM tb_usuario WHERE cedula_us = ? OR correo_us = ?";
            ps = con.getConnection().prepareStatement(checkSql);
            ps.setString(1, cedula);
            ps.setString(2, correo);
            rs = ps.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                mensaje = "La cédula o el correo ya están registrados.";
                request.setAttribute("error", mensaje);
                request.getRequestDispatcher("registro2.jsp").forward(request, response);
                return;
            }
            rs.close();
            ps.close();

            usuarios usuario = new usuarios();
            boolean registrado = usuario.ingresarUsuario(Integer.parseInt(perfil), Integer.parseInt(estadoCivil), cedula, nombre, correo);
            if (registrado) {
                request.setAttribute("mensaje", "Usuario registrado exitosamente.");
                request.getRequestDispatcher("exito.jsp").forward(request, response);
            } else {
                mensaje = "Error al registrar el usuario. Posibles causas: perfil o estado civil inválidos, o error en la base de datos.";
                request.setAttribute("error", mensaje);
                request.getRequestDispatcher("registro2.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            mensaje = "Error de base de datos: " + e.getMessage();
            request.setAttribute("error", mensaje);
            request.getRequestDispatcher("registro2.jsp").forward(request, response);
        } catch (Exception e) {
            mensaje = "Error: " + e.getMessage();
            request.setAttribute("error", mensaje);
            request.getRequestDispatcher("registro2.jsp").forward(request, response);
        } finally {
            try {
                conexion.closeResources(rs, ps);
                if (con != null) con.close();
            } catch (Exception e) {
                mensaje = "Error al cerrar recursos: " + e.getMessage();
                request.setAttribute("error", mensaje);
                request.getRequestDispatcher("registro2.jsp").forward(request, response);
            }
        }
    %>
</body>
</html>