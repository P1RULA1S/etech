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
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());
        
        // Permitir acceso a recursos estáticos
        if (path.startsWith("/css/") || path.startsWith("/js/") || path.startsWith("/imagenes/")) {
            chain.doFilter(request, response);
            return;
        }
        
        // Permitir acceso a rutas públicas
        if (path.equals("/registro.jsp") || path.equals("/validarRegistroCliente.jsp") || 
            path.equals("/exito.jsp") || path.equals("/login.jsp")) {
            chain.doFilter(request, response);
            return;
        }
        
        // Proteger páginas administrativas
        if (path.startsWith("/admin.jsp") || path.startsWith("/registro2.jsp")) {
            if (session == null || session.getAttribute("usuario") == null) {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp");
                return;
            }
            String perfil = (String) session.getAttribute("perfil");
            if (!"Administrador".equalsIgnoreCase(perfil)) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso denegado");
                return;
            }
        }
        
        // Permitir acceso a todas las demás páginas
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}