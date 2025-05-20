<%@ page language="java" contentType="text/html; charset=UTF-8" 
    pageEncoding="UTF-8" session="true"%>
<%@ page import="com.productos.seguridad.usuarios, java.net.URLEncoder" %>

<% 
// 1. Obtener parámetros
String correo = request.getParameter("usuario");
String clave = request.getParameter("clave");

// 2. Validar parámetros no vacíos
if (correo == null || clave == null || correo.trim().isEmpty() || clave.trim().isEmpty()) {
    String mensajeError = URLEncoder.encode("Debe ingresar correo y contraseña", "UTF-8");
    response.sendRedirect("login.jsp?error=" + mensajeError);
    return;
}

// 3. Verificar credenciales
usuarios usuario = new usuarios();
boolean autenticado = usuario.verificarUsuario(correo.trim(), clave.trim());

// 4. Procesar resultado
if (autenticado) {
    // Configurar sesión
    HttpSession sesion = request.getSession();
    sesion.setAttribute("usuario", usuario.getNombre());
    sesion.setAttribute("perfil", usuario.getPerfil());
    sesion.setAttribute("email", usuario.getEmail());
    sesion.setAttribute("idPerfil", usuario.getIdPerfil());
    
    // Redirección según perfil
    if (usuario.esAdministrador()) {
        response.sendRedirect("admin.jsp");
    } else if (usuario.esVendedor()) {
        response.sendRedirect("index_vendedor.jsp");
    } else if (usuario.esCliente()) {
        response.sendRedirect("index_cliente.jsp");
    } else {
        // En caso de un perfil no reconocido
        String mensajeError = URLEncoder.encode("Perfil no válido", "UTF-8");
        response.sendRedirect("login.jsp?error=" + mensajeError);
    }
} else {
    String mensajeError = URLEncoder.encode("Correo o contraseña incorrectos", "UTF-8");
    response.sendRedirect("login.jsp?error=" + mensajeError);
}
%>