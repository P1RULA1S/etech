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
    <link href="https://fonts.googleapis.com/css2?family=Bungee&family=Press+Start+2P&family=Quantico:ital,wght@0,400;0,700;1,400;1,700&display=swap" rel="stylesheet">
    <link href="css/estilo1.1.css" rel="stylesheet" type="text/css">
    <link href="css/estilo_actualizar.css" rel="stylesheet" type="text/css">
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

    String nombre = "";
    int categoriaId = 0;
    int cantidad = 0;
    double precio = 0.0;
    
    try (ResultSet rs = producto.obtenerProductoPorId(id)) {
        if (rs != null && rs.next()) {
            nombre = rs.getString("nombre_pr");
            categoriaId = rs.getInt("id_cat");
            cantidad = rs.getInt("cantidad_pr");
            precio = rs.getDouble("precio_pr");
        } else {
            mensaje = "Producto no encontrado.";
        }
    } catch (SQLException e) {
        mensaje = "Error al cargar el producto: " + e.getMessage();
    }
%>

<main>
    <header>
        <h1>E-TECH</h1>
        <h2 id="destacado">Actualizar Producto</h2>
    </header>

    <nav>
        <a href="GestionProductos.jsp" class="btn-regresar"><i class="fas fa-arrow-left"></i> Regresar</a>
        <a href="cerrarSesion.jsp" class="btn-cerrar-sesion"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a>
    </nav>

    <div class="contenedor-formulario">
        <section class="formulario-actualizar">
            <% if (!mensaje.isEmpty()) { %>
                <div class="mensaje <%= mensaje.toLowerCase().contains("error") ? "error" : "exito" %>">
                    <i class="fas <%= mensaje.toLowerCase().contains("error") ? "fa-exclamation-circle" : "fa-check-circle" %>"></i>
                    <%= mensaje %>
                </div>
            <% } %>
            
            <form action="ProductoServlet" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="<%= id %>">
                
                <div class="campo-actualizar">
                    <label>Nombre:</label>
                    <input type="text" name="nombre" value="<%= nombre %>" required>
                </div>
                
                <div class="campo-actualizar">
                    <label>Categoría:</label>
                    <%= categoriasCombo.replace("value='"+categoriaId+"'", "value='"+categoriaId+"' selected") %>
                </div>
                
                <div class="campo-actualizar">
                    <label>Cantidad:</label>
                    <input type="number" name="cantidad" value="<%= cantidad %>" required>
                </div>
                
                <div class="campo-actualizar">
                    <label>Precio:</label>
                    <input type="number" step="0.01" name="precio" value="<%= precio %>" required>
                </div>
                
                <div class="campo-actualizar campo-archivo">
                    <label>Imagen:</label>
                    <div class="contenedor-archivo">
                        <input type="file" name="foto" accept="image/*" id="input-archivo">
                        <label for="input-archivo" class="etiqueta-archivo">
                            <i class="fas fa-cloud-upload-alt"></i>
                            <span class="texto-archivo">Seleccionar archivo</span>
                        </label>
                        <span class="nota-archivo">Dejar en blanco para mantener la imagen actual</span>
                    </div>
                </div>
                
                <div class="botones-accion">
                    <button type="submit" class="btn-actualizar">
                        <i class="fas fa-save"></i> Actualizar
                    </button>
                    <a href="GestionProductos.jsp" class="btn-cancelar">
                        <i class="fas fa-times"></i> Cancelar
                    </a>
                </div>
            </form>
        </section>
    </div>

    <footer>
        <ul class="redes-sociales">
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

<script>
    // Mostrar nombre de archivo seleccionado
    document.getElementById('input-archivo').addEventListener('change', function(e) {
        const fileName = e.target.files[0] ? e.target.files[0].name : 'No se ha seleccionado ningún archivo';
        document.querySelector('.texto-archivo').textContent = fileName;
    });
</script>
</body>
</html>