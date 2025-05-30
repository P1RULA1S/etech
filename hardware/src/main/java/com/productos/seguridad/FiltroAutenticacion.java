package com.productos.seguridad;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class FiltroAutenticacion implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Inicialización del filtro (si es necesario)
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());
        System.out.println("Ruta solicitada: " + path);

        // Lista de rutas públicas que no requieren autenticación
        String[] publicPaths = {
        	    "/index.jsp",
        	    "/productos.jsp",
        	    "/categoria.jsp",
        	    "/reporteCategoria.jsp",
        	    "/login.jsp",
        	    "/validarLogin1.jsp",
        	    "/registro.jsp",
        	    "/validarRegistroCliente.jsp",
        	    "/exito.jsp",
        	    "/respuesta.jsp", // Agregado para permitir acceso sin autenticación
        	    "/RegistroServlet"
        	};

        // Lista de prefijos de rutas públicas (recursos estáticos)
        String[] publicPathPrefixes = {
            "/css/",
            "/js/",
            "/imagenes/",
            "/img/",
            "/images/",
            "/resources/",
            "/iconos/",
            "/ProductoServlet"
        };

        // Verificar si la ruta es pública
        boolean isPublic = false;
        for (String publicPath : publicPaths) {
            if (path.equals(publicPath)) {
                isPublic = true;
                break;
            }
        }

        if (!isPublic) {
            for (String prefix : publicPathPrefixes) {
                if (path.startsWith(prefix)) {
                    isPublic = true;
                    break;
                }
            }
        }

        // Si es una ruta pública, permitir acceso sin autenticación
        if (isPublic) {
            chain.doFilter(request, response);
            return;
        }

        // Verificar la sesión para rutas protegidas
        HttpSession session = httpRequest.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp?error=sesionRequerida");
            return;
        }

        // Verificar estado del usuario y permisos
        String correoUsuario = (String) session.getAttribute("email");
        String perfil = (String) session.getAttribute("perfil");
        Integer estadoActivo = (Integer) session.getAttribute("estadoActivo");

        // Verificar si el usuario está bloqueado (excepto administrador específico)
        if (estadoActivo != null && estadoActivo == 0) {
            if (!"steve.r@marvel.com".equals(correoUsuario) || !"Administrador".equalsIgnoreCase(perfil)) {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp?error=usuarioBloqueado");
                return;
            }
        }

        // Proteger rutas administrativas
        if (path.startsWith("/admin") || path.startsWith("/registro2") || path.startsWith("/gestionUsuarios")) {
            if (!"Administrador".equalsIgnoreCase(perfil)) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso denegado: se requiere rol de Administrador");
                return;
            }
        }

        // Continuar con la cadena de filtros si todo está correcto
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Liberar recursos si es necesario
    }
}