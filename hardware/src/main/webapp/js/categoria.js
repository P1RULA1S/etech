document.addEventListener('DOMContentLoaded', function() {
    // Manejar clic en botones de agregar al carrito
    document.querySelectorAll('.boton-agregar').forEach(boton => {
        boton.addEventListener('click', function(e) {
            e.preventDefault();
            const productId = this.getAttribute('data-product-id');
            console.log('Agregar producto ID:', productId);
            window.location.href = 'agregarCarrito.jsp?id=' + productId;
        });
    });
});