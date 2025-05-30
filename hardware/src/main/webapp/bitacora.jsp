<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true"%>
<%@ page import="java.sql.*, com.productos.datos.conexion, java.text.SimpleDateFormat, java.util.Date" %>
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
    <title>Bitácora - E-TECH</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome para iconos -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <!-- Fuentes personalizadas -->
    <link href="https://fonts.cdnfonts.com/css/ethnocentric" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Bungee&family=Press+Start+2P&family=Quantico:ital,wght@0,400;0,700;1,400;1,700&display=swap" rel="stylesheet">
    <!-- Estilo general (para nav, header, footer) -->
    <link href="css/estilo1.1.css" rel="stylesheet" type="text/css">
    <!-- Estilo específico para la bitácora -->
    <link href="css/estilo_bitacora.css" rel="stylesheet" type="text/css">
</head>
<body>
    <%
    // Obtener información de sesión
    String usuario = (String) session.getAttribute("usuario");
    
    // Obtener fecha y hora actual
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
    String fechaHora = sdf.format(new Date());
    %>
    
    <main>
        <div class="user-bar">
            <span><i class="fas fa-user-circle"></i> <%= usuario %> (Administrador)</span>
            <span><i class="fas fa-clock"></i> <%= fechaHora %></span>
        </div>
        
        <header>
            <h1>E-TECH</h1>
            <h2 id="destacado">Tecnología a tu alcance</h2>
            <h4 id="favorito">Construimos poder, Jugamos sin límites</h4>
        </header>
       
        <nav>
            <a href="index.jsp"><i class="fas fa-home"></i> Menú</a>
            <a href="registro2.jsp"><i class="fas fa-user-plus"></i> Crear Usuarios</a>
            <a href="gestionUsuarios.jsp"><i class="fas fa-cogs"></i> Administrar</a>
            <a href="bitacora.jsp" class="active"><i class="fas fa-book"></i> Bitácora</a>
            <a href="cerrarSesion.jsp"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a>
        </nav>
        
        <div class="agrupar">
            <section>
                <h3>Bitácora del Sistema</h3>
                <p>Registro de actividades realizadas en el sistema.</p>
                
                <!-- Botón de refrescar -->
                <div class="mb-3">
                    <button class="btn-refresh" onclick="location.reload()">
                        <img src="iconos/actualizar.png" alt="Refrescar"> Refrescar
                    </button>
                </div>
                
                <!-- Tabla de registros -->
                <div class="table-container">
                    <div class="table-responsive">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Tabla</th>
                                    <th>Operación</th>
                                    <th>Valor Anterior</th>
                                    <th>Valor Nuevo</th>
                                    <th>Fecha</th>
                                    <th>Usuario</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                conexion con = new conexion();
                                PreparedStatement ps = null;
                                ResultSet rs = null;
                                try {
                                    String sql = "SELECT id_aud, tabla_aud, operacion_aud, valoranterior_aud, valornuevo_aud, fecha_aud, usuario_aud " +
                                                "FROM auditoria.tb_auditoria " +
                                                "ORDER BY fecha_aud DESC, id_aud DESC";
                                    ps = con.getConnection().prepareStatement(sql);
                                    rs = ps.executeQuery();
                                    
                                    while (rs.next()) {
                                        int idAud = rs.getInt("id_aud");
                                        String tablaAud = rs.getString("tabla_aud");
                                        String operacionAud = rs.getString("operacion_aud");
                                        String valorAnteriorAud = rs.getString("valoranterior_aud");
                                        String valorNuevoAud = rs.getString("valornuevo_aud");
                                        Date fechaAud = rs.getDate("fecha_aud");
                                        String usuarioAud = rs.getString("usuario_aud");
                                %>
                                <tr>
                                    <td><%= idAud %></td>
                                    <td><%= tablaAud != null ? tablaAud : "N/A" %></td>
                                    <td>
                                        <%
                                        if ("I".equals(operacionAud)) {
                                            out.print("<span class='badge bg-success'>INSERT</span>");
                                        } else if ("U".equals(operacionAud)) {
                                            out.print("<span class='badge bg-warning'>UPDATE</span>");
                                        } else if ("D".equals(operacionAud)) {
                                            out.print("<span class='badge bg-danger'>DELETE</span>");
                                        } else {
                                            out.print("N/A");
                                        }
                                        %>
                                    </td>
                                    <td><%= valorAnteriorAud != null ? valorAnteriorAud : "N/A" %></td>
                                    <td><%= valorNuevoAud != null ? valorNuevoAud : "N/A" %></td>
                                    <td><%= fechaAud != null ? new SimpleDateFormat("dd/MM/yyyy").format(fechaAud) : "N/A" %></td>
                                    <td><%= usuarioAud != null ? usuarioAud : "N/A" %></td>
                                </tr>
                                <%
                                    }
                                } catch (SQLException e) {
                                    out.println("<tr><td colspan='7' class='text-danger'>Error al cargar los registros: " + e.getMessage() + "</td></tr>");
                                } finally {
                                    conexion.closeResources(rs, ps);
                                    con.close();
                                }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </section>
        </div>
        
        <footer>
            <ul>
                <li>
                    <a href="https://www.facebook.com/share/15zHexzLbU/" target="_blank" rel="noopener noreferrer">
                        <img src="iconos/facebook.png" alt="Facebook" width="30" height="30"> 
                        <span>Facebook</span>
                    </a>
                </li>
                <li>
                    <a href="https://www.instagram.com/elvis.g.03?igsh=MXd6MzMzdTJqb2l6bw==" target="_blank" rel="noopener noreferrer">
                        <img src="iconos/instagram.png" alt="Instagram" width="30" height="30"> 
                        <span>Instagram</span>
                    </a>
                </li>
                <li>
                    <a href="https://x.com/tech_e51533" target="_blank" rel="noopener noreferrer">
                        <img src="iconos/gorjeo.png" alt="Twitter" width="30" height="30"> 
                        <span>Twitter</span>
                    </a>
                </li>
            </ul>
        </footer>
    </main>
</body>
</html>