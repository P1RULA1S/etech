<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true"%>
<%@ page import="java.text.SimpleDateFormat, java.util.Date, com.productos.negocio.Producto, com.productos.negocio.Categoria, java.net.URLDecoder" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>E-TECH - Gestión de Productos</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.cdnfonts.com/css/ethnocentric" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Bungee&family=Press+Start+2P&family=Quantico:ital,wght@0,400;0,700;1,400;1,700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/estilo1.1.css" rel="stylesheet" type="text/css">

</head>
<body>
<%
    String usuario = (String) session.getAttribute("usuario");
    String perfil = (String) session.getAttribute("perfil");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
    String fechaHora = sdf.format(new Date());
    String mensaje = request.getParameter("mensaje") != null ? java.net.URLDecoder.decode(request.getParameter("mensaje"), "UTF-8") : "";
    Producto producto = new Producto();
    Categoria categoria = new Categoria();
    String categoriasCombo = categoria.mostrarCategoria();
    
    String productosTabla = producto.consultarTodo();
    if (request.getAttribute("productosTabla") != null) {
        productosTabla = (String) request.getAttribute("productosTabla");
    }
%>

<main>
    <div class="user-bar">
        <span><i class="fas fa-user-circle"></i> <%= usuario != null ? usuario : "No logeado" %>
            (<%= perfil != null ? perfil : "Sin rol" %>)</span>
        <span><i class="fas fa-clock"></i> <%= fechaHora %></span>
    </div>

    <header>
        <h1>E-TECH</h1>
        <h2 id="destacado">Gestión de Productos</h2>
    </header>

    <nav>
       <a href="index_vendedor.jsp"><i class="fas fa-home"></i> Menú</a>
        <a href="GestionProductos.jsp"><i class="fas fa-cog"></i> GestionProductos</a>
        <a href="cambioClave.jsp"><i class="fas fa-cog"></i> Cambiar Contraseña</a>
        <a href="cerrarSesion.jsp"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a>
    </nav>

    <div class="agrupar d-flex justify-content-center align-items-center min-vh-100 p-3">
        <section class="w-100">
            <h3>Administrar Productos</h3>
            <% if (!mensaje.isEmpty()) { %>
                <div class="alert <%= mensaje.toLowerCase().contains("éxito") ? "alert-success" : "alert-info" %>">
                    <%= mensaje %>
                </div>
            <% } %>
            <form action="ProductoServlet" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="add">
                <div class="mb-3">
                    <label for="nombre" class="form-label">Nombre</label>
                    <input type="text" class="form-control" id="nombre" name="nombre" required>
                </div>
                <div class="mb-3">
                    <label for="categoria" class="form-label">Categoría</label>
                    <%= categoriasCombo %>
                </div>
                <div class="mb-3">
                    <label for="cantidad" class="form-label">Cantidad</label>
                    <input type="number" class="form-control" id="cantidad" name="cantidad" required>
                </div>
                <div class="mb-3">
                    <label for="precio" class="form-label">Precio</label>
                    <input type="number" step="0.01" class="form-control" id="precio" name="precio" required>
                </div>
                <div class="mb-3">
                    <label for="foto" class="form-label">Foto</label>
                    <input type="file" class="form-control" id="foto" name="foto" accept="image/*">
                </div>
                <button type="submit" class="btn btn-primary">Enviar</button>
                <button type="button" class="btn btn-danger" onclick="this.form.reset();">Borrar</button>
            </form>

            <h3 class="mt-5">Lista de Productos</h3>
            <details>
                <summary>Ver Lista de Productos</summary>
                <div class="table-responsive mt-3">
                    <table class="table table-hover table-bordered border-primary">
                        <thead class="table-dark">
                            <tr>
                                <th>ID</th>
                                <th>Producto</th>
                                <th>Categoría</th>
                                <th>Precio</th>
                                <th>Stock</th>
                                <th>Actualizar</th>
                                <th>Eliminar</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%= productosTabla %>
                        </tbody>
                    </table>
                </div>
            </details>
        </section>
    </div>

    <footer>
        <ul>
<li>
    <a href="https://www.facebook.com/share/15zHexzLbU/" target="_blank" rel="noopener noreferrer" aria-label="Visitar nuestra página en Facebook">
        <img src="iconos/facebook.png" alt="Facebook" width="30" height="30"> 
        <span>Facebook</span>
    </a>
</li>
<li>
    <a href="https://www.instagram.com/elvis.g.03?igsh=MXd6MzMzdTJqb2l6bw==" target="_blank" rel="noopener noreferrer" aria-label="Visitar nuestro perfil en Instagram">
        <img src="iconos/instagram.png" alt="Instagram" width="30" height="30"> 
        <span>Instagram</span>
    </a>
</li>
<li>
    <a href="https://x.com/tech_e51533" target="_blank" rel="noopener noreferrer" aria-label="Visitar nuestro perfil en Twitter">
        <img src="iconos/gorjeo.png" alt="Twitter" width="30" height="30"> 
        <span>Twitter</span>
    </a>
</li>
        </ul>
    </footer>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>