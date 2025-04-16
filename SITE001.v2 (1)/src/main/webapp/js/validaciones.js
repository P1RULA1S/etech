function validarPDF() {
  const archivo = document.getElementById("hojaVida").files[0];
  if (archivo) {
    const tamanoMB = archivo.size / (1024 * 1024);
    if (tamanoMB > 5) {
      alert("El archivo supera los 5MB. Por favor, seleccione uno más pequeño.");
      document.getElementById("hojaVida").value = "";
    }
  }
}

function calcularEdad() {
  const fecha = document.getElementById("fecha").value;
  const edadSpan = document.getElementById("edad");

  if (fecha) {
    const hoy = new Date();
    const nacimiento = new Date(fecha + "-01");
    let edad = hoy.getFullYear() - nacimiento.getFullYear();
    const mes = hoy.getMonth() - nacimiento.getMonth();

    if (mes < 0 || (mes === 0 && hoy.getDate() < nacimiento.getDate())) {
      edad--;
    }

    edadSpan.textContent = "Edad actual: " + edad + " años";
  } else {
    edadSpan.textContent = "";
  }
}

function detectarProvincia() {
  const cedula = document.getElementById("txtCedula").value;
  const provinciaSpan = document.getElementById("provincia");

  const provincias = {
    "01": "Azuay", "02": "Bolívar", "03": "Cañar", "04": "Carchi", "05": "Cotopaxi",
    "06": "Chimborazo", "07": "El Oro", "08": "Esmeraldas", "09": "Guayas", "10": "Imbabura",
    "11": "Loja", "12": "Los Ríos", "13": "Manabí", "14": "Morona Santiago", "15": "Napo",
    "16": "Pastaza", "17": "Pichincha", "18": "Tungurahua", "19": "Zamora Chinchipe",
    "20": "Galápagos", "21": "Sucumbíos", "22": "Orellana", "23": "Santo Domingo de los Tsáchilas",
    "24": "Santa Elena", "30": "Exterior"
  };

  if (cedula.length >= 2) {
    const codigo = cedula.substring(0, 2);
    const provincia = provincias[codigo] || "Código no válido";
    provinciaSpan.textContent = "Provincia: " + provincia;
  } else {
    provinciaSpan.textContent = "";
  }
}
function mostrarOcultarClave() {
  const inputClave = document.getElementById("txtClave");
  const toggleIcon = document.getElementById("toggleClave");

  if (inputClave.type === "password") {
    inputClave.type = "text";
    toggleIcon.textContent = "🙈"; // Cambia a ícono de ocultar
  } else {
    inputClave.type = "password";
    toggleIcon.textContent = "👁️"; // Cambia a ícono de mostrar
  }
}


