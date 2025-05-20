/**
 * Validador de formularios para el registro de usuarios.
 * @namespace FormValidator
 */
const FormValidator = {
    /** Configuración de validaciones */
    config: {
        maxFileSizeMB: 5,
        minPasswordLength: 6,
        minAge: 18,
        cedulaLength: 10,
        provincias: {
            "01": "Azuay", "02": "Bolívar", "03": "Cañar", "04": "Carchi", "05": "Cotopaxi",
            "06": "Chimborazo", "07": "El Oro", "08": "Esmeraldas", "09": "Guayas", "10": "Imbabura",
            "11": "Loja", "12": "Los Ríos", "13": "Manabí", "14": "Morona Santiago", "15": "Napo",
            "16": "Pastaza", "17": "Pichincha", "18": "Tungurahua", "19": "Zamora Chinchipe",
            "20": "Galápagos", "21": "Sucumbíos", "22": "Orellana", "23": "Santo Domingo de los Tsáchilas",
            "24": "Santa Elena", "30": "Exterior"
        }
    },

    /**
     * Muestra un mensaje de error en el DOM.
     * @param {string} message - Mensaje de error.
     * @param {HTMLElement} container - Contenedor donde mostrar el error.
     */
    showError(message, container) {
        container.textContent = message;
        container.classList.add('error-message');
        container.style.display = 'block';
        setTimeout(() => {
            container.style.display = 'none';
            container.textContent = '';
        }, 5000);
    },

    /**
     * Valida el archivo PDF subido.
     * @param {HTMLInputElement} input - Input de tipo file.
     * @returns {boolean} - True si el archivo es válido, false si no.
     */
    validarPDF(input) {
        const errorContainer = document.getElementById('errorFileCV') || document.createElement('div');
        errorContainer.id = 'errorFileCV';
        input.parentNode.appendChild(errorContainer);

        try {
            const archivo = input.files[0];
            if (!archivo) {
                this.showError('Por favor, seleccione un archivo PDF.', errorContainer);
                return false;
            }

            const tamanoMB = archivo.size / (1024 * 1024);
            if (tamanoMB > this.config.maxFileSizeMB) {
                this.showError(`El archivo supera los ${this.config.maxFileSizeMB}MB. Seleccione uno más pequeño.`, errorContainer);
                input.value = '';
                return false;
            }

            if (archivo.type !== 'application/pdf') {
                this.showError('Solo se permiten archivos PDF.', errorContainer);
                input.value = '';
                return false;
            }

            errorContainer.style.display = 'none';
            return true;
        } catch (error) {
            this.showError('Error al validar el archivo.', errorContainer);
            console.error('Error en validarPDF:', error);
            return false;
        }
    },

    /**
     * Calcula y muestra la edad basada en la fecha de nacimiento.
     * @param {HTMLInputElement} input - Input de tipo date.
     * @returns {boolean} - True si la edad es válida (>= 18), false si no.
     */
    calcularEdad(input) {
        const edadSpan = document.getElementById('edad');
        const errorContainer = document.getElementById('errorFecha') || document.createElement('div');
        errorContainer.id = 'errorFecha';
        input.parentNode.appendChild(errorContainer);

        try {
            const fecha = input.value;
            if (!fecha) {
                edadSpan.textContent = '';
                this.showError('Seleccione una fecha de nacimiento.', errorContainer);
                return false;
            }

            const nacimiento = new Date(fecha);
            if (isNaN(nacimiento.getTime())) {
                edadSpan.textContent = '';
                this.showError('Fecha de nacimiento inválida.', errorContainer);
                return false;
            }

            const hoy = new Date();
            let edad = hoy.getFullYear() - nacimiento.getFullYear();
            const mes = hoy.getMonth() - nacimiento.getMonth();
            if (mes < 0 || (mes === 0 && hoy.getDate() < nacimiento.getDate())) {
                edad--;
            }

            if (edad < this.config.minAge) {
                edadSpan.textContent = '';
                this.showError(`Debe tener al menos ${this.config.minAge} años.`, errorContainer);
                return false;
            }

            edadSpan.textContent = `Edad actual: ${edad} años`;
            errorContainer.style.display = 'none';
            return true;
        } catch (error) {
            this.showError('Error al calcular la edad.', errorContainer);
            console.error('Error en calcularEdad:', error);
            return false;
        }
    },

    /**
     * Detecta la provincia basada en los primeros dos dígitos de la cédula.
     * @param {HTMLInputElement} input - Input de tipo text.
     * @returns {boolean} - True si la cédula es válida, false si no.
     */
    detectarProvincia(input) {
        const provinciaSpan = document.getElementById('provincia');
        const errorContainer = document.getElementById('errorCedula') || document.createElement('div');
        errorContainer.id = 'errorCedula';
        input.parentNode.appendChild(errorContainer);

        try {
            const cedula = input.value;
            if (cedula.length < 2) {
                provinciaSpan.textContent = '';
                this.showError('Ingrese al menos los dos primeros dígitos de la cédula.', errorContainer);
                return false;
            }

            if (cedula.length > this.config.cedulaLength) {
                this.showError(`La cédula no puede tener más de ${this.config.cedulaLength} dígitos.`, errorContainer);
                return false;
            }

            if (!/^\d+$/.test(cedula)) {
                this.showError('La cédula solo puede contener números.', errorContainer);
                return false;
            }

            const codigo = cedula.substring(0, 2);
            const provincia = this.config.provincias[codigo] || 'Código no válido';
            provinciaSpan.textContent = `Provincia: ${provincia}`;

            if (provincia === 'Código no válido') {
                this.showError('Código de provincia no válido.', errorContainer);
                return false;
            }

            errorContainer.style.display = 'none';
            return true;
        } catch (error) {
            this.showError('Error al detectar la provincia.', errorContainer);
            console.error('Error en detectarProvincia:', error);
            return false;
        }
    },

    /**
     * Alterna la visibilidad de un campo de contraseña.
     * @param {string} inputId - ID del input de contraseña.
     * @param {string} iconId - ID del ícono de toggle.
     */
    mostrarOcultarClave(inputId, iconId) {
        try {
            const input = document.getElementById(inputId);
            const icono = document.getElementById(iconId);
            if (!input || !icono) {
                throw new Error('Elemento no encontrado.');
            }

            if (input.type === 'password') {
                input.type = 'text';
                icono.classList.remove('fa-eye');
                icono.classList.add('fa-eye-slash');
            } else {
                input.type = 'password';
                icono.classList.remove('fa-eye-slash');
                icono.classList.add('fa-eye');
            }
        } catch (error) {
            console.error('Error en mostrarOcultarClave:', error);
        }
    },

    /**
     * Valida todo el formulario antes de enviarlo.
     * @returns {boolean} - True si el formulario es válido, false si no.
     */
    validarFormulario() {
        const fileCV = document.getElementById('fileCV');
        const fecha = document.getElementById('fecha');
        const cedula = document.getElementById('txtCedula');
        const errorContainer = document.getElementById('errorGeneral') || document.createElement('div');
        errorContainer.id = 'errorGeneral';
        document.querySelector('form').prepend(errorContainer);

        try {
            const isFileValid = this.validarPDF(fileCV);
            const isFechaValid = this.calcularEdad(fecha);
            const isCedulaValid = this.detectarProvincia(cedula);

            if (!isFileValid || !isFechaValid || !isCedulaValid) {
                this.showError('Por favor, corrija los errores en el formulario.', errorContainer);
                return false;
            }

            return true;
        } catch (error) {
            this.showError('Error al validar el formulario.', errorContainer);
            console.error('Error en validarFormulario:', error);
            return false;
        }
    },

    /**
     * Inicializa los eventos de validación.
     */
    init() {
        try {
            const fileCV = document.getElementById('fileCV');
            const fecha = document.getElementById('fecha');
            const cedula = document.getElementById('txtCedula');
            const form = document.querySelector('form');

            if (fileCV) {
                fileCV.addEventListener('change', () => this.validarPDF(fileCV));
            }
            if (fecha) {
                fecha.addEventListener('change', () => this.calcularEdad(fecha));
            }
            if (cedula) {
                cedula.addEventListener('input', () => this.detectarProvincia(cedula));
            }
            if (form) {
                form.addEventListener('submit', (e) => {
                    if (!this.validarFormulario()) {
                        e.preventDefault();
                    }
                });
            }
        } catch (error) {
            console.error('Error en init:', error);
        }
    }
};

// Inicializar validaciones al cargar el DOM
document.addEventListener('DOMContentLoaded', () => FormValidator.init());

/* Estilos para mensajes de error */
const style = document.createElement('style');
style.textContent = `
    .error-message {
        color: #e76f51;
        background-color: #ffe6e6;
        padding: 10px;
        border-radius: 5px;
        margin-top: 5px;
        font-size: 14px;
        display: block;
    }
`;
document.head.appendChild(style);