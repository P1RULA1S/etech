document.addEventListener('DOMContentLoaded', function() {
    const numeroTarjetaInput = document.getElementById('numeroTarjeta');
    const cardTypeSpan = document.getElementById('cardType');
    const fechaExpiracionInput = document.getElementById('fechaExpiracion');

    // Detección del tipo de tarjeta
    numeroTarjetaInput.addEventListener('input', function() {
        const numero = this.value.replace(/\D/g, '');
        let tipo = '';

        if (numero.startsWith('4')) {
            tipo = 'Visa';
        } else if (numero.match(/^5[1-5]/)) {
            tipo = 'Mastercard';
        } else if (numero.match(/^3[47]/)) {
            tipo = 'American Express';
        } else if (numero.match(/^6(?:011|5)/)) {
            tipo = 'Discover';
        } else {
            tipo = '';
        }

        cardTypeSpan.textContent = tipo ? `(${tipo})` : '';
    });

    // Formato de fecha de expiración (MM/AAAA)
    fechaExpiracionInput.addEventListener('input', function(e) {
        let value = this.value.replace(/\D/g, '');
        if (value.length > 2) {
            value = value.slice(0, 2) + '/' + value.slice(2, 6);
        }
        if (value.length > 7) {
            value = value.slice(0, 7);
        }
        this.value = value;
    });

    // Validación básica en el cliente (opcional, ya que el servidor lo manejará)
    document.getElementById('paymentForm').addEventListener('submit', function(e) {
        const numeroTarjeta = document.getElementById('numeroTarjeta').value.replace(/\D/g, '');
        const fechaExpiracion = document.getElementById('fechaExpiracion').value;
        const cvv = document.getElementById('cvv').value;

        if (!/^\d{16}$/.test(numeroTarjeta)) {
            e.preventDefault();
            alert('El número de tarjeta debe tener 16 dígitos');
            return;
        }

        if (!/^\d{2}\/\d{4}$/.test(fechaExpiracion)) {
            e.preventDefault();
            alert('La fecha de expiración debe tener el formato MM/AAAA');
            return;
        }

        if (cvv === "000") {
            e.preventDefault();
            alert('El CVV no puede ser 000');
            return;
        }
    });
});