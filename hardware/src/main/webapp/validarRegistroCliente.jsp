<%@page import="com.productos.seguridad.usuarios"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.util.List"%>
<%@page import="java.io.File"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Configuración para manejo de archivos
    String rutaArchivos = getServletContext().getRealPath("/") + "tmp";
    File directorioArchivos = new File(rutaArchivos);
    if (!directorioArchivos.exists()) {
        directorioArchivos.mkdirs();
    }

    // Verificar si la solicitud contiene contenido multipart
    boolean isMultipart = ServletFileUpload.isMultipartContent(request);
    
    if (isMultipart) {
        // Configurar el factory para manejo de archivos
        DiskFileItemFactory factory = new DiskFileItemFactory();
        factory.setSizeThreshold(1024);
        factory.setRepository(directorioArchivos);
        
        // Crear el manejador de carga
        ServletFileUpload upload = new ServletFileUpload(factory);
        
        try {
            // Parsear la solicitud
            List<FileItem> items = upload.parseRequest(request);
            
            // Variables para almacenar los datos del formulario
            String cedula = null;
            String nombre = null;
            String correo = null;
            String clave = null;
            String repetirClave = null;
            String imagen = null;
            
            // Procesar cada campo del formulario
            for (FileItem item : items) {
                if (item.isFormField()) {
                    // Procesar campos normales del formulario
                    String fieldName = item.getFieldName();
                    String fieldValue = item.getString("UTF-8");
                    
                    if ("txtCedula".equals(fieldName)) {
                        cedula = fieldValue;
                    } else if ("txtNombre".equals(fieldName)) {
                        nombre = fieldValue;
                    } else if ("txtCorreo".equals(fieldName)) {
                        correo = fieldValue;
                    } else if ("txtClave".equals(fieldName)) {
                        clave = fieldValue;
                    } else if ("txtRepetirClave".equals(fieldName)) {
                        repetirClave = fieldValue;
                    }
                } else {
                    // Procesar archivo subido
                    String fileName = item.getName();
                    if (fileName != null && !fileName.isEmpty()) {
                        fileName = new File(fileName).getName();
                        File uploadedFile = new File(directorioArchivos, fileName);
                        item.write(uploadedFile);
                        imagen = fileName;
                    }
                }
            }
            
            // Validar los datos
            usuarios user = new usuarios();
            
            if (!user.coincidirClaves(clave, repetirClave)) {
                response.sendRedirect("registro.jsp?error=Las contraseñas no coinciden");
                return;
            }
            
            if (user.existeUsuario(correo)) {
                response.sendRedirect("registro.jsp?error=El correo ya está registrado");
                return;
            }
            
            // Registrar al usuario (perfil 3 = Cliente)
            boolean registroExitoso = user.ingresarUsuario(3, 1, 1, cedula, nombre, correo, clave);
            
            if (registroExitoso) {
                response.sendRedirect("index.jsp?registro=exitoso");
            } else {
                response.sendRedirect("registro.jsp?error=Error en el registro");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("registro.jsp?error=Error al procesar el formulario: " + e.getMessage());
        }
    } else {
        response.sendRedirect("registro.jsp?error=Formulario no válido");
    }
%>