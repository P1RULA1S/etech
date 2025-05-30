<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true"%>
<%@ page import="com.productos.seguridad.usuarios, java.sql.*, com.productos.datos.conexion" %>
<%
// Verificar que el usuario sea administrador
String perfil = (String) session.getAttribute("perfil");
if (perfil == null || !perfil.equalsIgnoreCase("Administrador")) {
    response.sendRedirect("index.jsp");
    return;
}

// Obtener el ID del usuario a editar
String id = request.getParameter("id");
if (id == null || id.trim().isEmpty()) {
    response.sendRedirect("gestionUsuarios.jsp?error=ID no proporcionado");
    return;
}

Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;
usuarios u = new usuarios();
String nombre = "", cedula = "", correo = "";

try {
    conn = new conexion().getConnection();
    if (conn == null) {
        throw new SQLException("No se pudo conectar a la base de datos.");
    }
    String sql = "SELECT nombre_us, cedula_us, correo_us FROM tb_usuario WHERE id_us = ?";
    ps = conn.prepareStatement(sql);
    ps.setInt(1, Integer.parseInt(id));
    rs = ps.executeQuery();

    if (rs.next()) {
        nombre = rs.getString("nombre_us");
        cedula = rs.getString("cedula_us");
        correo = rs.getString("correo_us");
    } else {
        response.sendRedirect("gestionUsuarios.jsp?error=Usuario no encontrado");
        return;
    }
} catch (SQLException e) {
    out.println("<p class='text-danger'>Error al consultar usuario: " + e.getMessage() + "</p>");
    return;
} finally {
    conexion.closeResources(rs, ps);
    if (conn != null) {
        try {
            conn.close();
        } catch (SQLException e) {
            out.println("<p class='text-danger'>Error al cerrar la conexión: " + e.getMessage() + "</p>");
        }
    }
}
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Editar Usuario - E-TECH</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h2>Editar Usuario</h2>
        <form action="gestionUsuarios.jsp" method="post">
            <input type="hidden" name="action" value="editar">
            <input type="hidden" name="id" value="<%= id %>">
            <div class="mb-3">
                <label for="nombre" class="form-label">Nombre</label>
                <input type="text" class="form-control" id="nombre" name="nombre" value="<%= nombre != null ? nombre : "" %>" required>
            </div>
            <div class="mb-3">
                <label for="cedula" class="form-label">Cédula</label>
                <input type="text" class="form-control" id="cedula" name="cedula" value="<%= cedula != null ? cedula : "" %>" required>
            </div>
            <div class="mb-3">
                <label for="correo" class="form-label">Correo</label>
                <input type="email" class="form-control" id="correo" name="correo" value="<%= correo != null ? correo : "" %>" required>
            </div>
            <button type="submit" class="btn btn-primary">Actualizar</button>
            <a href="gestionUsuarios.jsp" class="btn btn-secondary">Cancelar</a>
        </form>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>