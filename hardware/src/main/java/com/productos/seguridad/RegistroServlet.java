package com.productos.seguridad;

import com.productos.datos.conexion;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/RegistroServlet")
public class RegistroServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Establecer codificación UTF-8
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        // Obtener parámetros del formulario
        String nombre = request.getParameter("txtNombre");
        String cedula = request.getParameter("txtCedula");
        String correo = request.getParameter("txtCorreo");
        String estadoCivil = request.getParameter("cmbECivil");
        String residencia = request.getParameter("rdResidencia");
        String clave = request.getParameter("txtClave");
        String fechaNacimiento = request.getParameter("fecha");
        String colorFavorito = request.getParameter("colorFavorito");

        // Mapear valores del formulario a IDs de las tablas relacionadas
        int idEst = mapEstadoCivil(estadoCivil);
        int idRes = mapResidencia(residencia);
        int idPer = 3; // Perfil "Cliente" por defecto

        // Validaciones básicas del lado del servidor
        String errorMessage = null;
        if (nombre == null || nombre.trim().isEmpty()) {
            errorMessage = "El nombre es obligatorio.";
        } else if (cedula == null || !cedula.matches("\\d{10}")) {
            errorMessage = "La cédula debe tener 10 dígitos numéricos.";
        } else if (correo == null || !correo.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
            errorMessage = "El correo electrónico no es válido.";
        } else if (clave == null || clave.length() < 6) {
            errorMessage = "La contraseña debe tener al menos 6 caracteres.";
        } else if (idEst == -1) {
            errorMessage = "Estado civil no válido.";
        } else if (idRes == -1) {
            errorMessage = "Residencia no válida.";
        }

        if (errorMessage != null) {
            request.setAttribute("error", errorMessage);
            request.setAttribute("nombre", nombre);
            request.setAttribute("cedula", cedula);
            request.setAttribute("correo", correo);
            request.setAttribute("estadoCivil", estadoCivil);
            request.setAttribute("residencia", residencia);
            request.setAttribute("fechaNacimiento", fechaNacimiento);
            request.setAttribute("colorFavorito", colorFavorito);
            request.setAttribute("clave", clave != null ? "Contraseña recibida." : "No ingresada");
            request.getRequestDispatcher("/respuesta.jsp").forward(request, response);
            return;
        }

        // Registrar usuario usando la clase usuarios
        usuarios usuario = new usuarios();
        boolean registrado = usuario.ingresarUsuario(idPer, idEst, idRes, cedula, nombre, correo, clave);

        // Manejo del resultado
        if (registrado) {
            request.setAttribute("mensaje", "Usuario registrado exitosamente.");
        } else {
            request.setAttribute("error", "No se pudo registrar el usuario. Verifique que la cédula o correo no estén registrados.");
        }

        // Reenviar parámetros para mostrar en respuesta.jsp
        request.setAttribute("nombre", nombre);
        request.setAttribute("cedula", cedula);
        request.setAttribute("correo", correo);
        request.setAttribute("estadoCivil", estadoCivil);
        request.setAttribute("residencia", residencia);
        request.setAttribute("fechaNacimiento", fechaNacimiento);
        request.setAttribute("colorFavorito", colorFavorito);
        request.setAttribute("clave", clave != null ? "Contraseña recibida." : "No ingresada");

        request.getRequestDispatcher("/respuesta.jsp").forward(request, response);
    }

    // Mapear estado civil a ID
    private int mapEstadoCivil(String estadoCivil) {
        if (estadoCivil == null) return -1;
        switch (estadoCivil) {
            case "Casado": return 1;
            case "Soltero": return 2;
            case "Divorciado": return 3;
            case "Viudo": return 4;
            default: return -1;
        }
    }

    // Mapear residencia a ID
    private int mapResidencia(String residencia) {
        if (residencia == null) return -1;
        switch (residencia) {
            case "Sur": return 1;
            case "Norte": return 2;
            case "Centro": return 3;
            default: return -1;
        }
    }
}