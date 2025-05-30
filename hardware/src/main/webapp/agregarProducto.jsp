<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.productos.negocio.Producto, java.io.*, java.util.*" %>
<%
    String mensaje = "";
    try {
        String nombre = request.getParameter("nombre");
        int categoria = Integer.parseInt(request.getParameter("cmbCategoria"));
        int cantidad = Integer.parseInt(request.getParameter("cantidad"));
        double precio = Double.parseDouble(request.getParameter("precio"));

        byte[] imagen = null;
        Part filePart = request.getPart("foto");
        if (filePart != null && filePart.getSize() > 0) {
            try (InputStream fileContent = filePart.getInputStream()) {
                ByteArrayOutputStream buffer = new ByteArrayOutputStream();
                int nRead;
                byte[] data = new byte[1024];
                while ((nRead = fileContent.read(data, 0, data.length)) != -1) {
                    buffer.write(data, 0, nRead);
                }
                imagen = buffer.toByteArray();
            }
        }

        Producto producto = new Producto();
        if (producto.agregarProducto(nombre, categoria, cantidad, precio, imagen)) {
            mensaje = "Producto agregado con éxito";
        } else {
            mensaje = "Error al agregar el producto";
        }
    } catch (Exception e) {
        mensaje = "Error al agregar el producto: " + e.getMessage();
    }
    response.sendRedirect("GestionProductos.jsp?mensaje=" + java.net.URLEncoder.encode(mensaje, "UTF-8"));
%>