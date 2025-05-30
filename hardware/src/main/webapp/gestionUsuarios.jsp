<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true"%>
<%@ page import="com.productos.seguridad.usuarios, java.sql.*, java.util.ArrayList, java.util.List, java.text.SimpleDateFormat, java.util.Date, com.productos.datos.conexion" %>
<%
// Verificar que el usuario sea administrador
String perfil = (String) session.getAttribute("perfil");
if (perfil == null || !perfil.equalsIgnoreCase("Administrador")) {
    response.sendRedirect("index.jsp");
    return;
}
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gestión de Usuarios - E-TECH</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .user-bar { background-color: #f8f9fa; padding: 10px; margin-bottom: 20px; }
        .table-container { margin-top: 20px; }
        .success-message { color: green; font-weight: bold; }
    </style>
</head>
<body>
    <%
    String usuario = (String) session.getAttribute("usuario");
    String fechaHora = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new Date());
    String mensaje = request.getParameter("mensaje");
    %>

    <div class="user-bar">
        <span><i class="fas fa-user-circle"></i> <%= usuario != null ? usuario : "Invitado" %> (Administrador)</span>
        <span><i class="fas fa-clock"></i> <%= fechaHora %></span>
        <a href="admin.jsp"><i class="fas fa-arrow-left"></i> Volver al Panel</a>
    </div>

    <div class="container table-container">
        <h2>Gestión de Usuarios</h2>
        <% if (mensaje != null) { %>
            <% if (mensaje.equals("bloqueoExitoso")) { %>
                <p class="success-message">Usuario bloqueado con éxito.</p>
            <% } else if (mensaje.equals("desbloqueoExitoso")) { %>
                <p class="success-message">Usuario desbloqueado con éxito.</p>
            <% } else if (mensaje.equals("edicionExitosa")) { %>
                <p class="success-message">Usuario editado con éxito.</p>
            <% } %>
        <% } %>

        <%
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<usuarios> usuariosList = new ArrayList<>();

        try {
            conn = new conexion().getConnection();
            if (conn == null) {
                throw new SQLException("No se pudo conectar a la base de datos.");
            }
            String sql = "SELECT id_us, nombre_us, cedula_us, correo_us, estado_activo FROM tb_usuario";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                usuarios u = new usuarios();
                u.setIdUsuario(rs.getInt("id_us"));
                u.setNombre(rs.getString("nombre_us"));
                u.setCedula(rs.getString("cedula_us"));
                u.setEmail(rs.getString("correo_us"));
                u.setEstadoActivo(rs.getInt("estado_activo"));
                usuariosList.add(u);
            }
        } catch (SQLException e) {
            out.println("<p class='text-danger'>Error al consultar usuarios: " + e.getMessage() + "</p>");
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

        <table class="table table-success table-striped-columns">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nombre</th>
                    <th>Cédula</th>
                    <th>Correo</th>
                    <th>Estado</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody>
                <% for (usuarios u : usuariosList) { %>
                    <tr>
                        <td><%= u.getIdUsuario() %></td>
                        <td><%= u.getNombre() != null ? u.getNombre() : "N/A" %></td>
                        <td><%= u.getCedula() != null ? u.getCedula() : "N/A" %></td>
                        <td><%= u.getEmail() != null ? u.getEmail() : "N/A" %></td>
                        <td><%= u.getEstadoActivo() == 1 ? "Activo" : "Bloqueado" %></td>
                        <td>
                            <a href="editarUsuario.jsp?id=<%= u.getIdUsuario() %>" class="btn btn-warning btn-sm"><i class="fas fa-edit"></i> Editar</a>
                            <% if (u.getEstadoActivo() == 1) { %>
                                <button class="btn btn-danger btn-sm" onclick="confirmarBloqueo(<%= u.getIdUsuario() %>)"><i class="fas fa-lock"></i> Bloquear</button>
                            <% } else { %>
                                <button class="btn btn-success btn-sm" onclick="confirmarDesbloqueo(<%= u.getIdUsuario() %>)"><i class="fas fa-unlock"></i> Desbloquear</button>
                            <% } %>
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function confirmarBloqueo(id) {
            if (confirm('¿Seguro que desea bloquear este usuario?')) {
                fetch('gestionUsuarios.jsp?action=bloquear&id=' + id, {
                    method: 'POST'
                })
                .then(response => response.text())
                .then(data => {
                    if (data.includes("bloqueoExitoso")) {
                        alert("Usuario bloqueado con éxito.");
                        location.reload();
                    } else {
                        alert("Error al bloquear el usuario.");
                    }
                })
                .catch(error => console.error('Error:', error));
            }
        }

        function confirmarDesbloqueo(id) {
            if (confirm('¿Seguro que desea desbloquear este usuario?')) {
                fetch('gestionUsuarios.jsp?action=desbloquear&id=' + id, {
                    method: 'POST'
                })
                .then(response => response.text())
                .then(data => {
                    if (data.includes("desbloqueoExitoso")) {
                        alert("Usuario desbloqueado con éxito.");
                        location.reload();
                    } else {
                        alert("Error al desbloquear el usuario.");
                    }
                })
                .catch(error => console.error('Error:', error));
            }
        }

        // Manejar las acciones en el servidor
        <% if ("bloquear".equals(request.getParameter("action"))) {
            int id = Integer.parseInt(request.getParameter("id"));
            usuarios u = new usuarios();
            if (u.bloquearUsuario(id)) {
                response.sendRedirect("gestionUsuarios.jsp?mensaje=bloqueoExitoso");
            } else {
                out.println("alert('Error al bloquear el usuario.');");
            }
        } else if ("desbloquear".equals(request.getParameter("action"))) {
            int id = Integer.parseInt(request.getParameter("id"));
            usuarios u = new usuarios();
            if (u.desbloquearUsuario(id)) {
                response.sendRedirect("gestionUsuarios.jsp?mensaje=desbloqueoExitoso");
            } else {
                out.println("alert('Error al desbloquear el usuario.');");
            }
        } else if ("editar".equals(request.getParameter("action"))) {
            int id = Integer.parseInt(request.getParameter("id"));
            String nombre = request.getParameter("nombre");
            String cedula = request.getParameter("cedula");
            String correo = request.getParameter("correo");

            usuarios u = new usuarios();
            if (u.actualizarUsuario(id, nombre, cedula, correo)) {
                response.sendRedirect("gestionUsuarios.jsp?mensaje=edicionExitosa");
            } else {
                response.sendRedirect("gestionUsuarios.jsp?error=Error al editar el usuario");
            }
        } %>
    </script>
</body>
</html>