<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="com.productos.negocio.*"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta http-equiv="Cache-Control" content="public, max-age=31536000">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1"> <!-- Viewport para responsive -->
    <title>Todos los Productos - E-TECH</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Tus estilos y fuentes existentes -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.cdnfonts.com/css/ethnocentric" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Bungee&family=Press+Start+2P&display=swap" rel="stylesheet">   
    <link href="css/estilo1.1.css" rel="stylesheet" type="text/css">
    <link href="css/estilo_productos.css" rel="stylesheet" type="text/css">
</head>
<body>
    <main>
        <header>
            <h1>E-TECH</h1>
            <h2 id="destacado">Tecnología a tu alcance</h2>
            <h4 id="favorito">Construimos poder, Jugamos sin límites</h4>
        </header>
        
        <nav>
            <a href="index.jsp"><i class="fas fa-home"></i> Menú</a>
            <a href="productos.jsp" class="active"><i class="fas fa-list"></i> Productos</a>
            <a href="categoria.jsp"><i class="fas fa-search"></i> Buscar</a>
            <a href="login.jsp"><i class="fas fa-user"></i> Login</a>
        </nav>
        
        <div class="agrupar">
            <section class="productos-section">
                <h3 class="section-title">Todos nuestros productos</h3>
                
                <%
                Producto producto = new Producto();
                out.print(producto.consultarTodoEnTarjetas());
                %>
                
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
    
    <!-- Bootstrap JS (al final del body para mejor rendimiento) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Tu script actualizado -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Verificar si el usuario está autenticado
            const isAuthenticated = <%= session.getAttribute("usuario") != null %>;

            // Función para manejar favoritos
            document.querySelectorAll('.favorite-icon').forEach(icon => {
                icon.addEventListener('click', function() {
                    if (!isAuthenticated) {
                        alert('Debes iniciar sesión para guardar tus favoritos.');
                       
                        return;
                    }
                    this.classList.toggle('far');
                    this.classList.toggle('fas');
                    this.classList.toggle('active');
                    
                    const productId = this.closest('.product-card').dataset.productId;
                    console.log('Producto favorito:', productId);
                    // Aquí podrías agregar lógica para guardar el favorito en la base de datos si lo deseas
                });
            });
            
            // Manejar clic en "ADD TO CART"
            document.querySelectorAll('.add-to-cart-btn').forEach(btn => {
                btn.addEventListener('click', function(e) {
                    e.preventDefault();
                    if (!isAuthenticated) {
                        alert('Debes iniciar sesión para realizar compras.');
                       
                        return;
                    }
                    const productId = this.closest('.product-card').dataset.productId;
                    window.location.href = 'agregarCarrito.jsp?id=' + productId;
                });
            });
        });
    </script>
</body>
</html>