<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true"%>
<%@ page import="com.productos.seguridad.usuarios, java.net.URLEncoder" %>

<% 
// Depuración: Registrar inicio
System.out.println("validarLogin1.jsp: Iniciando procesamiento");

// 1. Invalidar sesión previa para evitar conflictos
HttpSession oldSession = request.getSession(false);
if (oldSession != null) {
    oldSession.invalidate();
    System.out.println("validarLogin1.jsp: Sesión previa invalidada");
}

// 2. Obtener parámetros
String correo = request.getParameter("usuario");
String clave = request.getParameter("clave");
System.out.println("validarLogin1.jsp: correo = " + correo + ", clave = " + clave);

// 3. Validar parámetros no vacíos
if (correo == null || clave == null || correo.trim().isEmpty() || clave.trim().isEmpty()) {
    System.out.println("validarLogin1.jsp: Parámetros vacíos");
    String mensajeError = URLEncoder.encode("Debe ingresar correo y contraseña", "UTF-8");
    response.sendRedirect("login.jsp?error=" + mensajeError);
    return;
}

// 4. Verificar credenciales
usuarios usuario = new usuarios();
boolean autenticado = usuario.verificarUsuario(correo.trim(), clave.trim());
System.out.println("validarLogin1.jsp: Autenticación = " + autenticado);

// 5. Procesar resultado
if (autenticado) {
    // Configurar nueva sesión
    session = request.getSession(true); // Forzar creación de sesión
    Integer idUsuario = usuario.getIdUsuario();
    System.out.println("validarLogin1.jsp: idUsuario obtenido = " + idUsuario);
    
    if (idUsuario == null || idUsuario == 0) {
        System.out.println("validarLogin1.jsp: idUsuario inválido");
        String mensajeError = URLEncoder.encode("Error interno: ID de usuario no válido", "UTF-8");
        response.sendRedirect("login.jsp?error=" + mensajeError);
        return;
    }

    session.setAttribute("idUsuario", idUsuario);
    session.setAttribute("usuario", usuario.getNombre());
    session.setAttribute("perfil", usuario.getPerfil());
    session.setAttribute("email", usuario.getEmail());
    session.setAttribute("idPerfil", usuario.getIdPerfil());
    session.setAttribute("estadoActivo", usuario.getEstadoActivo());
    System.out.println("validarLogin1.jsp: Sesión configurada - idUsuario = " + idUsuario + 
                       ", usuario = " + usuario.getNombre() + ", perfil = " + usuario.getPerfil());
    
    // Redirección según perfil
    if (usuario.esAdministrador()) {
        response.sendRedirect("admin.jsp");
    } else if (usuario.esVendedor()) {
        response.sendRedirect("index_vendedor.jsp");
    } else if (usuario.esCliente()) {
        response.sendRedirect("index_cliente.jsp");
    } else {
        System.out.println("validarLogin1.jsp: Perfil no válido");
        String mensajeError = URLEncoder.encode("Perfil no válido", "UTF-8");
        response.sendRedirect("login.jsp?error=" + mensajeError);
    }
} else {
    System.out.println("validarLogin1.jsp: Autenticación fallida");
    String mensajeError = URLEncoder.encode("Correo o contraseña incorrectos", "UTF-8");
    response.sendRedirect("login.jsp?error=" + mensajeError);
}
%>