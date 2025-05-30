package com.productos.controlador;

import com.productos.negocio.Producto;
import com.productos.datos.conexion;
import com.productos.negocio.Categoria;
import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.sql.*;

@WebServlet("/ProductoServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
    maxFileSize = 1024 * 1024 * 10,      // 10 MB
    maxRequestSize = 1024 * 1024 * 100   // 100 MB
)
public class ProductoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        Producto producto = new Producto();
        Categoria categoria = new Categoria();

        try {
            if ("viewImage".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Connection conn = new conexion().getConnection();
                String sql = "SELECT foto_pr FROM tb_productos WHERE id_pr = ?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, id);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    byte[] imageData = rs.getBytes("foto_pr");
                    if (imageData != null) {
                        response.setContentType("image/jpeg"); // Ajusta según el tipo de imagen
                        response.getOutputStream().write(imageData);
                    } else {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Imagen no encontrada");
                    }
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Producto no encontrado");
                }
                rs.close();
                ps.close();
                conn.close();
                return;
            } else if ("delete".equals(action)) {
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
                ResultSet rs = producto.obtenerProductoPorId(id);
                if (rs.next()) {
                    request.setAttribute("producto", rs);
                    request.setAttribute("categorias", categoria.mostrarCategoria());
                    request.getRequestDispatcher("actualizarProducto.jsp").forward(request, response);
                } else {
                    String mensaje = URLEncoder.encode("Producto no encontrado", "UTF-8");
                    response.sendRedirect("GestionProductos.jsp?mensaje=" + mensaje);
                }
            } else if ("categoria".equals(action)) {
                int categoriaId = Integer.parseInt(request.getParameter("cat"));
                String productosHtml = producto.buscarProductoCategoria(categoriaId);
                request.setAttribute("productosCategoria", productosHtml);
                request.getRequestDispatcher("reporteCategoria.jsp").forward(request, response);
            } else {
                request.setAttribute("productosTabla", producto.consultarTodo());
                request.getRequestDispatcher("GestionProductos.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            String mensaje = URLEncoder.encode("Error: ID inválido", "UTF-8");
            response.sendRedirect("GestionProductos.jsp?mensaje=" + mensaje);
        } catch (SQLException e) {
            String mensaje = URLEncoder.encode("Error en la base de datos: " + e.getMessage(), "UTF-8");
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
                int categoriaId = request.getParameter("cmbCategoria") != null ? Integer.parseInt(request.getParameter("cmbCategoria")) : 0;
                int stock = Integer.parseInt(request.getParameter("cantidad"));
                double precio = Double.parseDouble(request.getParameter("precio"));
                byte[] imagen = null;
                Part filePart = request.getPart("foto");
                if (filePart != null && filePart.getSize() > 0) {
                    try (InputStream inputStream = filePart.getInputStream()) {
                        imagen = inputStream.readAllBytes();
                    }
                }

                if (producto.agregarProducto(nombre, categoriaId, stock, precio, imagen)) {
                    String mensaje = URLEncoder.encode("Producto agregado con éxito", "UTF-8");
                    response.sendRedirect("ProductoServlet?mensaje=" + mensaje + "&refresh=true");
                } else {
                    String mensaje = URLEncoder.encode("Error al agregar el producto", "UTF-8");
                    response.sendRedirect("GestionProductos.jsp?mensaje=" + mensaje);
                }
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String nombre = request.getParameter("nombre");
                int categoriaId = request.getParameter("cmbCategoria") != null ? Integer.parseInt(request.getParameter("cmbCategoria")) : 0;
                int stock = Integer.parseInt(request.getParameter("cantidad"));
                double precio = Double.parseDouble(request.getParameter("precio"));
                byte[] imagen = null;
                Part filePart = request.getPart("foto");
                if (filePart != null && filePart.getSize() > 0) {
                    try (InputStream inputStream = filePart.getInputStream()) {
                        imagen = inputStream.readAllBytes();
                    }
                } else {
                    // Mantener la imagen actual si no se sube una nueva
                    Connection conn = new conexion().getConnection();
                    String sql = "SELECT foto_pr FROM tb_productos WHERE id_pr = ?";
                    PreparedStatement ps = conn.prepareStatement(sql);
                    ps.setInt(1, id);
                    ResultSet rs = ps.executeQuery();
                    if (rs.next()) {
                        imagen = rs.getBytes("foto_pr");
                    }
                    rs.close();
                    ps.close();
                    conn.close();
                }

                if (producto.actualizarProducto(id, nombre, categoriaId, stock, precio, imagen)) {
                    String mensaje = URLEncoder.encode("Actualizado con éxito", "UTF-8");
                    response.sendRedirect("ProductoServlet?mensaje=" + mensaje + "&refresh=true");
                } else {
                    String mensaje = URLEncoder.encode("Error al actualizar el producto", "UTF-8");
                    response.sendRedirect("actualizarProducto.jsp?mensaje=" + mensaje + "&id=" + id);
                }
            } else if ("buscarCategoria".equals(action)) {
                int categoriaId = Integer.parseInt(request.getParameter("cmbCategoria"));
                response.sendRedirect("ProductoServlet?action=categoria&cat=" + categoriaId);
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