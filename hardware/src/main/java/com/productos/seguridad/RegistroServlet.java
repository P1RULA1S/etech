package com.productos.seguridad;

import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/RegistroServlet")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024) // Límite de 5MB para archivos
public class RegistroServlet extends HttpServlet {

    private static final Map<String, String> PROVINCIAS = new HashMap<>();
    static {
        PROVINCIAS.put("01", "Azuay");
        PROVINCIAS.put("02", "Bolívar");
        PROVINCIAS.put("03", "Cañar");
        PROVINCIAS.put("04", "Carchi");
        PROVINCIAS.put("05", "Cotopaxi");
        PROVINCIAS.put("06", "Chimborazo");
        PROVINCIAS.put("07", "El Oro");
        PROVINCIAS.put("08", "Esmeraldas");
        PROVINCIAS.put("09", "Guayas");
        PROVINCIAS.put("10", "Imbabura");
        PROVINCIAS.put("11", "Loja");
        PROVINCIAS.put("12", "Los Ríos");
        PROVINCIAS.put("13", "Manabí");
        PROVINCIAS.put("14", "Morona Santiago");
        PROVINCIAS.put("15", "Napo");
        PROVINCIAS.put("16", "Pastaza");
        PROVINCIAS.put("17", "Pichincha");
        PROVINCIAS.put("18", "Tungurahua");
        PROVINCIAS.put("19", "Zamora Chinchipe");
        PROVINCIAS.put("20", "Galápagos");
        PROVINCIAS.put("21", "Sucumbíos");
        PROVINCIAS.put("22", "Orellana");
        PROVINCIAS.put("23", "Santo Domingo de los Tsáchilas");
        PROVINCIAS.put("24", "Santa Elena");
        PROVINCIAS.put("30", "Exterior");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        // Obtener parámetros del formulario
        String nombre = request.getParameter("txtNombre");
        String cedula = request.getParameter("txtCedula");
        String correo = request.getParameter("txtCorreo");
        String estadoCivil = request.getParameter("cmbECivil");
        String residencia = request.getParameter("rdResidencia");
        String clave = request.getParameter("txtClave");
        String repetirClave = request.getParameter("txtRepetirClave");
        String fechaNacimiento = request.getParameter("fecha");
        String colorFavorito = request.getParameter("colorFavorito");

        // Validaciones
        if (nombre == null || nombre.trim().isEmpty()) {
            request.setAttribute("error", "El nombre es obligatorio.");
            request.getRequestDispatcher("/registro.jsp").forward(request, response);
            return;
        }

        String provincia = "Desconocida";
        if (cedula == null || !cedula.matches("\\d{10}")) {
            request.setAttribute("error", "La cédula debe tener 10 dígitos numéricos.");
            request.getRequestDispatcher("/registro.jsp").forward(request, response);
            return;
        } else {
            String codigoProvincia = cedula.substring(0, 2);
            provincia = PROVINCIAS.getOrDefault(codigoProvincia, "Desconocida");
        }

        if (correo == null || !correo.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
            request.setAttribute("error", "El correo electrónico no es válido.");
            request.getRequestDispatcher("/registro.jsp").forward(request, response);
            return;
        }

        if (clave == null || clave.length() < 8) {
            request.setAttribute("error", "La contraseña debe tener al menos 8 caracteres.");
            request.getRequestDispatcher("/registro.jsp").forward(request, response);
            return;
        }
        if (!clave.equals(repetirClave)) {
            request.setAttribute("error", "Las contraseñas no coinciden.");
            request.getRequestDispatcher("/registro.jsp").forward(request, response);
            return;
        }

        Part fileCV = request.getPart("fileCV");
        if (fileCV == null || fileCV.getSize() == 0 || !fileCV.getContentType().equals("application/pdf")) {
            request.setAttribute("error", "Debe cargar un archivo PDF válido para el CV.");
            request.getRequestDispatcher("/registro.jsp").forward(request, response);
            return;
        }

        Part fileFoto = request.getPart("fileFoto");
        if (fileFoto != null && fileFoto.getSize() > 0) {
            String contentType = fileFoto.getContentType();
            if (!contentType.equals("image/jpeg") && !contentType.equals("image/png")) {
                request.setAttribute("error", "La imagen debe ser en formato JPG o PNG.");
                request.getRequestDispatcher("/registro.jsp").forward(request, response);
                return;
            }
        }

        // Registrar usuario
        usuarios usuario = new usuarios();
        try {
            if (usuario.existeUsuario(correo)) {
                request.setAttribute("error", "El correo ya está registrado.");
                request.getRequestDispatcher("/registro.jsp").forward(request, response);
                return;
            }

            int idEst = mapEstadoCivil(estadoCivil);
            int idRes = mapResidencia(residencia);

            boolean registrado = usuario.ingresarUsuario(
                3, // Perfil Cliente
                idEst,
                idRes,
                cedula,
                nombre,
                correo,
                clave
            );

            if (registrado) {
                // Invalidar sesión previa (si existe)
                HttpSession oldSession = request.getSession(false);
                if (oldSession != null) {
                    oldSession.invalidate();
                }

                // Preparar datos para respuesta.jsp
                request.setAttribute("nombre", nombre);
                request.setAttribute("cedula", cedula);
                request.setAttribute("correo", correo);
                request.setAttribute("estadoCivil", estadoCivil != null ? estadoCivil : "");
                request.setAttribute("residencia", residencia != null ? residencia : "");
                request.setAttribute("fechaNacimiento", fechaNacimiento != null ? fechaNacimiento : "");
                request.setAttribute("colorFavorito", colorFavorito != null ? colorFavorito : "#000000");
                request.setAttribute("clave", clave);
                request.setAttribute("provincia", provincia);
                request.setAttribute("mensaje", "Registro exitoso. Ahora puede iniciar sesión.");

                request.getRequestDispatcher("/respuesta.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "No se pudo completar el registro.");
                request.getRequestDispatcher("/registro.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error en el servidor: " + e.getMessage());
            request.getRequestDispatcher("/registro.jsp").forward(request, response);
        }
    }

    private int mapEstadoCivil(String estadoCivil) {
        if (estadoCivil == null) return 1;
        switch (estadoCivil) {
            case "Casado": return 1;
            case "Soltero": return 2;
            case "Divorciado": return 3;
            case "Viudo": return 4;
            default: return 1;
        }
    }

    private int mapResidencia(String residencia) {
        if (residencia == null) return 1;
        switch (residencia) {
            case "Sur": return 1;
            case "Norte": return 2;
            case "Centro": return 3;
            default: return 1;
        }
    }
}