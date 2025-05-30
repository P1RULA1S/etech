<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true"%>
<%@ page import="java.text.SimpleDateFormat, java.util.Date, com.productos.datos.conexion, java.sql.*, java.net.URLEncoder" %>
<%
String perfil = (String) session.getAttribute("perfil");
if (perfil == null || !perfil.equalsIgnoreCase("Cliente")) {
    response.sendRedirect("index.jsp");
    return;
}
String usuario = (String) session.getAttribute("usuario");
Integer idUsuario = (Integer) session.getAttribute("idUsuario");

if (idUsuario == null) {
    String email = (String) session.getAttribute("email");
    if (email != null) {
        conexion con = new conexion();
        try {
            String sql = "SELECT id_us FROM tb_usuario WHERE correo_us = ?";
            PreparedStatement ps = con.getConnection().prepareStatement(sql);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                idUsuario = rs.getInt("id_us");
                session.setAttribute("idUsuario", idUsuario);
            }
            rs.close();
            ps.close();
        } catch (SQLException e) {
            response.sendRedirect("login.jsp?error=" + URLEncoder.encode("Error al recuperar sesión: " + e.getMessage(), "UTF-8"));
            return;
        } finally {
            con.close();
        }
    }
}

if (idUsuario == null) {
    response.sendRedirect("login.jsp?error=" + URLEncoder.encode("Sesión inválida, inicie sesión nuevamente", "UTF-8"));
    return;
}

SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
String fechaHora = sdf.format(new Date());

conexion con = new conexion();
StringBuilder favoritosHTML = new StringBuilder();
int contadorFavoritos = 0;

try {
    String sql = "SELECT f.id_fav, p.id_pr, p.nombre_pr, p.precio_pr, p.foto_pr, p.cantidad_pr " +
                 "FROM tb_favoritos f JOIN tb_productos p ON f.id_pr = p.id_pr " +
                 "WHERE f.id_us = ?";
    PreparedStatement ps = con.getConnection().prepareStatement(sql);
    ps.setInt(1, idUsuario);
    ResultSet rs = ps.executeQuery();

    while (rs.next()) {
        contadorFavoritos++;
        int idFav = rs.getInt("id_fav");
        int idPr = rs.getInt("id_pr");
        String nombrePr = rs.getString("nombre_pr");
        double precioPr = rs.getDouble("precio_pr");
        int stockDisponible = rs.getInt("cantidad_pr");

        String imagenHtml = rs.getBytes("foto_pr") != null ?
            "<img src='ProductoServlet?action=viewImage&id=" + idPr + "' width='50' class='img-fluid'>" :
            "<i class='fas fa-image text-muted'></i>";

        favoritosHTML.append("<li class='list-group-item d-flex justify-content-between align-items-center'>")
                     .append("<div class='d-flex align-items-center'>")
                     .append("<div class='me-3'>").append(imagenHtml).append("</div>")
                     .append("<div class='me-3'>").append(nombrePr).append("</div>")
                     .append("<div class='me-3 text-nowrap'>$").append(String.format("%.2f", precioPr)).append("</div>")
                     .append("</div>")
                     .append("<div class='d-flex align-items-center'>")
                     .append("<form action='agregarCarrito.jsp' method='post' class='d-inline me-3' onsubmit='return agregarAlCarrito(this)'>")
                     .append("<input type='hidden' name='id' value='").append(idPr).append("'>")
                     .append("<input type='number' name='cantidad' value='1' min='1' max='").append(stockDisponible).append("' ")
                     .append("class='form-control form-control-sm d-inline-block' style='width: 70px;'>")
                     .append("<button type='submit' class='btn btn-primary btn-sm ms-2'>")
                     .append("<i class='fas fa-cart-plus'></i> Añadir")
                     .append("</button>")
                     .append("<small class='text-white ms-2'>Disponibles: ").append(stockDisponible).append("</small>")
                     .append("</form>")
                     .append("<button onclick='removeFromFavorites(").append(idFav).append(")' class='btn btn-danger btn-sm'>")
                     .append("<i class='fas fa-trash'></i>")
                     .append("</button>")
                     .append("</div>")
                     .append("</li>");
    }
    rs.close();
    ps.close();
} catch (SQLException e) {
    e.printStackTrace();
    favoritosHTML.append("<li class='list-group-item text-center'>Error al cargar los favoritos: ").append(e.getMessage()).append("</li>");
} finally {
    con.close();
}
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>E-TECH - Favoritos</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.cdnfonts.com/css/ethnocentric" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Bungee&family=Press+Start+2P&family=Quantico:ital,wght@0,400;0,700;1,400;1,700&display=swap" rel="stylesheet">
    <link href="css/estilo1.1.css" rel="stylesheet" type="text/css">
    <link href="css/estilo_fav.css" rel="stylesheet" type="text/css">
    <style>
        .text-white {
            color: white !important;
        }
    </style>
    <script>
        function removeFromFavorites(idFav) {
            if (confirm("¿Estás seguro de que quieres eliminar este producto de tus favoritos?")) {
                fetch('eliminarFavorito.jsp?idFav=' + idFav, {
                    method: 'POST'
                })
                .then(response => response.text())
                .then(data => {
                    if (data.trim() === "success") {
                        location.reload();
                    } else {
                        alert("Error al eliminar el producto de favoritos: " + data);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert("Error al eliminar el producto de favoritos.");
                });
            }
        }

        function agregarAlCarrito(form) {
            // Puedes agregar validación adicional aquí si es necesario
            return true; // Permite que el formulario se envíe
        }
    </script>
</head>
<body>
<main>
    <div class="user-bar">
        <span><i class="fas fa-user-circle"></i> <%= usuario %> (Cliente)</span>
        <span><i class="fas fa-clock"></i> <%= fechaHora %></span>
    </div>

    <header>
        <h1>E-TECH</h1>
        <h2 id="destacado">Mis Favoritos</h2>
    </header>

    <nav>
        <a href="index_cliente.jsp"><i class="fas fa-home"></i> Menú</a>
        <a href="producto_cliente.jsp"><i class="fas fa-list"></i> Productos</a>
        <a href="categoria_cliente.jsp"><i class="fas fa-search"></i> Categorías</a>
        <a href="carrito.jsp"><i class="fas fa-shopping-cart"></i> Carrito</a>  
        <a href="favoritos.jsp" class="active"><i class="fas fa-heart"></i> Favoritos 
            <span class="badge"><%= contadorFavoritos %></span>
        </a>
        <a href="misCompras.jsp"><i class="fas fa-shopping-bag"></i> Mis Compras</a>
        <a href="cerrarSesion.jsp"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a>
    </nav>
    
    <div class="agrupar">
        <section class="favorites-container">
            <ul class="list-group">
                <% if (contadorFavoritos == 0) { %>
                    <li class="list-group-item text-center">No tienes productos favoritos.</li>
                <% } else { %>
                    <%= favoritosHTML.toString() %>
                <% } %>
            </ul>
            <a href="producto_cliente.jsp" class="btn btn-secondary mt-3">Seguir Comprando</a>
        </section>
    </div>

    <footer>
        <ul>
            <li><a href="https://www.facebook.com/share/15zHexzLbU/" target="_blank"><img src="iconos/facebook.png" width="30"> Facebook</a></li>
            <li><a href="https://www.instagram.com/elvis.g.03" target="_blank"><img src="iconos/instagram.png" width="30"> Instagram</a></li>
            <li><a href="https://x.com/tech_e51533" target="_blank"><img src="iconos/gorjeo.png" width="30"> Twitter</a></li>
        </ul>
    </footer>
</main>
</body>
</html>