<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true"%>
   <%@ page import="com.productos.negocio.Categoria, com.productos.negocio.Producto, com.productos.datos.conexion, java.sql.*" %>
   <%
   // Verificar sesión
   String perfil = (String) session.getAttribute("perfil");
   if (perfil == null || !perfil.equalsIgnoreCase("Cliente")) {
       response.sendRedirect("index.jsp");
       return;
   }

   // Contador de productos en el carrito
   int contadorCarrito = 0;
   Integer idUsuario = (Integer) session.getAttribute("idUsuario");
   if (idUsuario == null) {
       response.sendRedirect("login.jsp?error=Sesión inválida, inicie sesión nuevamente");
       return;
   }
   conexion con = new conexion();
   try {
       String sql = "SELECT COUNT(*) FROM tb_carrito WHERE id_us = ?";
       PreparedStatement ps = con.getConnection().prepareStatement(sql);
       ps.setInt(1, idUsuario);
       ResultSet rs = ps.executeQuery();
       if (rs.next()) {
           contadorCarrito = rs.getInt(1);
       }
       rs.close();
       ps.close();
   } catch (SQLException e) {
       e.printStackTrace();
   } finally {
       con.close();
   }

   // Manejar búsqueda por categoría
   String productosHtml = "";
   String categoriaSeleccionada = request.getParameter("cmbCategoria");
   if (categoriaSeleccionada != null && !categoriaSeleccionada.isEmpty()) {
       try {
           int categoriaId = Integer.parseInt(categoriaSeleccionada);
           Producto producto = new Producto();
           productosHtml = producto.consultarTodoEnTarjetasPorCategoria(categoriaId);
       } catch (NumberFormatException e) {
           productosHtml = "<div class='alert alert-danger'>Categoría inválida</div>";
       }
   }
   %>
   <!DOCTYPE html>
   <html lang="es">
   <head>
       <meta charset="UTF-8">
       <meta name="viewport" content="width=device-width, initial-scale=1">
       <title>Categorías - E-TECH</title>
       <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
       <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
       <link href="https://fonts.cdnfonts.com/css/ethnocentric" rel="stylesheet">
       <link rel="preconnect" href="https://fonts.googleapis.com">
       <link href="https://fonts.googleapis.com/css2?family=Bungee&family=Press+Start+2P&display=swap" rel="stylesheet">
       <link href="css/estilo1.1.css" rel="stylesheet" type="text/css">
       <link href="css/estilo_productos.css" rel="stylesheet" type="text/css">
   </head>
   <body>
   <main>
       <div class="user-bar">
           <span><i class="fas fa-user-circle"></i> <%= session.getAttribute("usuario") %> (Cliente)</span>
           <span><i class="fas fa-clock"></i> <%= new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new java.util.Date()) %></span>
       </div>

       <header>
           <h1>E-TECH</h1>
           <h2 id="destacado">Tecnología a tu alcance</h2>
           <h4 id="favorito">Construimos poder, Jugamos sin límites</h4>
       </header>

       <nav>
           <a href="index_cliente.jsp"><i class="fas fa-home"></i> Menú</a>
           <a href="producto_cliente.jsp"><i class="fas fa-list"></i> Productos</a>
           <a href="categoria_cliente.jsp" class="active"><i class="fas fa-search"></i> Categorías</a>
           <a href="carrito.jsp"><i class="fas fa-shopping-cart"></i> Carrito 
               <span class="badge"><%= contadorCarrito %></span>
           </a>
           <a href="misCompras.jsp"><i class="fas fa-shopping-bag"></i> Mis Compras</a>
           <a href="favoritos.jsp"><i class="fas fa-heart"></i> Favoritos</a>
           <a href="cerrarSesion.jsp"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a>
       </nav>

       <div class="agrupar">
           <section class="productos-section">
               <h3 class="section-title">Buscar por Categoría</h3>
               <form action="categoria_cliente.jsp" method="post">
                   <div class="mb-3">
                       <label for="cmbCategoria" class="form-label">Selecciona una categoría:</label>
                       <%= new Categoria().mostrarCategoria() %>
                   </div>
                   <button type="submit" class="btn btn-primary">Buscar</button>
               </form>

               <% if (!productosHtml.isEmpty()) { %>
               <h3 class="section-title mt-5">Productos Encontrados</h3>
               <%= productosHtml %>
               <% } %>
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
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Depuración: Verificar si las tarjetas se generaron
            const productCards = document.querySelectorAll('.product-card');
            console.log('Tarjetas de producto encontradas:', productCards.length);
            productCards.forEach(card => {
                const productId = card.getAttribute('data-product-id');
                console.log('Tarjeta encontrada con data-product-id:', productId);
                console.log('HTML de la tarjeta:', card.outerHTML);
            });

            // Manejar favoritos
            document.querySelectorAll('.favorite-icon').forEach(icon => {
                icon.addEventListener('click', function() {
                    const productCard = this.closest('.product-card');
                    const productId = productCard.getAttribute('data-product-id');
                    if (!productId) {
                        console.error('ID de producto no encontrado en la tarjeta:', productCard);
                        alert("Error: ID de producto no encontrado");
                        return;
                    }
                    fetch('gestionarFavoritos.jsp?action=toggle&id=' + productId, {
                        method: 'POST'
                    })
                    .then(response => response.text())
                    .then(data => {
                        if (data.trim() === "added") {
                            this.classList.remove('far');
                            this.classList.add('fas');
                            this.classList.add('active');
                        } else if (data.trim() === "removed") {
                            this.classList.remove('fas');
                            this.classList.add('far');
                            this.classList.remove('active');
                        } else {
                            alert("Error al gestionar favorito: " + data);
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert("Error al gestionar favorito.");
                    });
                });
            });

            // Manejar "ADD TO CART" con formulario
            document.querySelectorAll('.product-card .add-to-cart-btn').forEach(btn => {
                btn.addEventListener('click', function(e) {
                    e.preventDefault();
                    const productCard = this.closest('.product-card');
                    if (!productCard) {
                        console.error('No se encontró .product-card para el botón:', this);
                        alert("Error: No se encontró la tarjeta del producto");
                        return;
                    }
                    const productId = productCard.getAttribute('data-product-id');
                    if (!productId) {
                        console.error('ID de producto no encontrado en la tarjeta:', productCard);
                        alert("Error: ID de producto no encontrado");
                        return;
                    }
                    const form = document.createElement('form');
                    form.action = 'agregarCarrito.jsp';
                    form.method = 'post';
                    form.style.display = 'none';
                    const idInput = document.createElement('input');
                    idInput.type = 'hidden';
                    idInput.name = 'id';
                    idInput.value = productId;
                    const cantidadInput = document.createElement('input');
                    cantidadInput.type = 'hidden';
                    cantidadInput.name = 'cantidad';
                    cantidadInput.value = 1; // Cantidad fija por ahora
                    form.appendChild(idInput);
                    form.appendChild(cantidadInput);
                    document.body.appendChild(form);
                    form.submit();
                });
            });
        });
    </script>
   </body>
   </html>