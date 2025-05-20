package com.productos.controlador;

import com.productos.negocio.Producto;
import java.io.IOException;
import java.net.URLEncoder;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ProductoServlet")
public class ProductoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        Producto producto = new Producto();

        try {
            if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                if (producto.eliminarProducto(id)) {
                    String mensaje = URLEncoder.encode("Producto eliminado con éxito", "UTF-8");
                    response.sendRedirect("GestionProductos.jsp?mensaje=" + mensaje + "&refresh=true");
                } else {
                    String mensaje = URLEncoder.encode("Error al eliminar el producto", "UTF-8");
                    response.sendRedirect("GestionProductos.jsp?mensaje=" + mensaje);
                }
            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                request.setAttribute("id", id);
                request.getRequestDispatcher("actualizarProducto.jsp").forward(request, response);
            } else {
                request.setAttribute("productosTabla", producto.consultarTodo());
                request.getRequestDispatcher("GestionProductos.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            String mensaje = URLEncoder.encode("Error: ID inválido", "UTF-8");
            response.sendRedirect("GestionProductos.jsp?mensaje=" + mensaje);
        } catch (Exception e) {
            String mensaje = URLEncoder.encode("Error inesperado: " + e.getMessage(), "UTF-8");
            response.sendRedirect("GestionProductos.jsp?mensaje=" + mensaje);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        Producto producto = new Producto();

        try {
            if ("add".equals(action)) {
                String nombre = request.getParameter("nombre");
                int categoriaId = Integer.parseInt(request.getParameter("cmbCategoria"));
                int cantidad = Integer.parseInt(request.getParameter("cantidad"));
                double precio = Double.parseDouble(request.getParameter("precio"));

                if (producto.agregarProducto(nombre, categoriaId, cantidad, precio)) {
                    String mensaje = URLEncoder.encode("Producto agregado con éxito", "UTF-8");
                    response.sendRedirect("ProductoServlet?mensaje=" + mensaje + "&refresh=true");
                } else {
                    String mensaje = URLEncoder.encode("Error al agregar el producto", "UTF-8");
                    response.sendRedirect("GestionProductos.jsp?mensaje=" + mensaje);
                }
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String nombre = request.getParameter("nombre");
                int categoriaId = Integer.parseInt(request.getParameter("cmbCategoria"));
                int cantidad = Integer.parseInt(request.getParameter("cantidad"));
                double precio = Double.parseDouble(request.getParameter("precio"));

                if (producto.actualizarProducto(id, nombre, categoriaId, cantidad, precio)) {
                    String mensaje = URLEncoder.encode("Actualizado con éxito", "UTF-8");
                    response.sendRedirect("ProductoServlet?mensaje=" + mensaje + "&refresh=true");
                } else {
                    response.sendRedirect("actualizarProducto.jsp?mensaje=Error+al+actualizar+el+producto&id=" + id);
                }
            }
        } catch (NumberFormatException e) {
            String redirectUrl = "GestionProductos.jsp?mensaje=" + URLEncoder.encode("Error: Datos inválidos", "UTF-8");
            if ("update".equals(action)) {
                redirectUrl = "actualizarProducto.jsp?mensaje=" + URLEncoder.encode("Error: Datos inválidos", "UTF-8") + "&id=" + request.getParameter("id");
            }
            response.sendRedirect(redirectUrl);
        } catch (Exception e) {
            String redirectUrl = "GestionProductos.jsp?mensaje=" + URLEncoder.encode("Error inesperado: " + e.getMessage(), "UTF-8");
            if ("update".equals(action)) {
                redirectUrl = "actualizarProducto.jsp?mensaje=" + URLEncoder.encode("Error inesperado: " + e.getMessage(), "UTF-8") + "&id=" + request.getParameter("id");
            }
            response.sendRedirect(redirectUrl);
        }
    }
}