<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true"%>
<%@ page import="java.sql.*, com.productos.negocio.Producto, com.productos.negocio.Categoria" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>E-TECH - Actualizar Producto</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.cdnfonts.com/css/ethnocentric" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Bungee&family=Press+Start+2P&family=Quantico:ital,wght@0,400;0,700;1,400;1,700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/estilo1.1.css" rel="stylesheet" type="text/css">
</head>
<body>
<%
    int id = 0;
    String mensaje = request.getParameter("mensaje") != null ? request.getParameter("mensaje") : "";
    try {
        id = Integer.parseInt(request.getParameter("id"));
    } catch (NumberFormatException e) {
        mensaje = "Error: ID de producto inválido.";
    }

    Producto producto = new Producto();
    Categoria categoria = new Categoria();
    String categoriasCombo = categoria.mostrarCategoria();

    // Obtener datos del producto
    String nombre = "";
    int categoriaId = 0;
    int cantidad = 0;
    double precio = 0.0;
    ResultSet rs = null;
    try {
        rs = producto.obtenerProductoPorId(id);
        if (rs.next()) {
            nombre = rs.getString("nombre_pr");
            categoriaId = rs.getInt("id_cat");
            cantidad = rs.getInt("cantidad_pr");
            precio = rs.getDouble("precio_pr");
        } else {
            mensaje = "Producto no encontrado.";
        }
    } catch (SQLException e) {
        mensaje = "Error al cargar el producto: " + e.getMessage();
    } finally {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                mensaje += " Error al cerrar ResultSet: " + e.getMessage();
            }
        }
    }
%>

<main>
    <header>
        <h1>E-TECH</h1>
        <h2 id="destacado">Actualizar Producto</h2>
    </header>

    <nav>
        <a href="GestionProductos.jsp"><i class="fas fa-cog"></i> GestionProductos</a>
        <a href="cerrarSesion.jsp"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a>
    </nav>

    <div class="agrupar">
        <section>
            <h3>Actualizar Producto</h3>
            <% if (!mensaje.isEmpty()) { %>
                <div class="alert alert-danger"><%= mensaje %></div>
            <% } %>
            <form action="ProductoServlet" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="<%= id %>">
                <div class="mb-3">
                    <label for="nombre" class="form-label">Nombre</label>
                    <input type="text" class="form-control" id="nombre" name="nombre" value="<%= nombre %>" required>
                </div>
                <div class="mb-3">
                    <label for="categoria" class="form-label">Categoría</label>
                    <%= categoriasCombo %>
                </div>
                <div class="mb-3">
                    <label for="cantidad" class="form-label">Cantidad</label>
                    <input type="number" class="form-control" id="cantidad" name="cantidad" value="<%= cantidad %>" required>
                </div>
                <div class="mb-3">
                    <label for="precio" class="form-label">Precio</label>
                    <input type="number" step="0.01" class="form-control" id="precio" name="precio" value="<%= precio %>" required>
                </div>
                <div class="mb-3">
                    <label for="foto" class="form-label">Foto</label>
                    <input type="file" class="form-control" id="foto" name="foto" accept="image/*">
                </div>
                <button type="submit" class="btn btn-primary">Actualizar</button>
                <button type="button" class="btn btn-danger" onclick="window.location.href='gestionProductos.jsp'">Cancelar</button>
            </form>
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