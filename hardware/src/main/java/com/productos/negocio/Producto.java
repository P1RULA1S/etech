package com.productos.negocio;

import com.productos.datos.conexion;
import java.sql.*;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;

public class Producto {

    // Método para comprimir imágenes
    private byte[] compressImage(byte[] imageData) {
        if (imageData == null || imageData.length == 0) {
            return null;
        }

        try {
            // Leer la imagen desde los bytes
            ByteArrayInputStream bais = new ByteArrayInputStream(imageData);
            BufferedImage originalImage = ImageIO.read(bais);

            // Redimensionar la imagen a 800x600 píxeles (o menos si es más pequeña)
            int targetWidth = Math.min(originalImage.getWidth(), 800);
            int targetHeight = Math.min(originalImage.getHeight(), 600);
            BufferedImage resizedImage = new BufferedImage(targetWidth, targetHeight, BufferedImage.TYPE_INT_RGB);
            resizedImage.getGraphics().drawImage(originalImage.getScaledInstance(targetWidth, targetHeight, java.awt.Image.SCALE_SMOOTH), 0, 0, null);

            // Comprimir la imagen con calidad reducida
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            ImageIO.write(resizedImage, "jpg", baos);
            return baos.toByteArray();
        } catch (Exception e) {
            e.printStackTrace();
            return imageData; // Si hay un error, devolver la imagen original
        }
    }

    public String consultarTodo1() {
        String sql = "SELECT p.id_pr, p.nombre_pr, c.descripcion_cat, p.cantidad_pr, p.precio_pr, p.foto_pr " +
                    "FROM tb_productos p JOIN tb_categoria c ON p.id_cat = c.id_cat WHERE p.cantidad_pr > 0 ORDER BY p.id_pr";
        conexion con = new conexion();
        StringBuilder html = new StringBuilder();
        
        html.append("<div class='products-grid'>");
        
        try (ResultSet rs = con.Consulta(sql)) {
            int rowCount = 0;
            while (rs != null && rs.next()) {
                rowCount++;
                // Convertir la imagen a Base64 para mostrarla directamente
                String imagenHtml = rs.getBytes("foto_pr") != null ?
                    "<img src='data:image/jpeg;base64," + java.util.Base64.getEncoder().encodeToString(rs.getBytes("foto_pr")) + 
                    "' alt='" + rs.getString("nombre_pr") + "'>" :
                    "<i class='fas fa-image fa-3x text-muted'></i>";
                
                String stockText = rs.getInt("cantidad_pr") + " disponibles";
                String stockClass = "stock-info";
                String addToCartBtn = "<button class='add-to-cart-btn'>ADD TO CART</button>";
                
                html.append("<div class='product-card' data-product-id='").append(rs.getInt("id_pr")).append("'>")
                   .append("<div class='card-img-container'>")
                   .append(imagenHtml)
                   .append("<span class='category-label'>").append(rs.getString("descripcion_cat")).append("</span>")
                   .append("<i class='fas fa-heart favorite-icon'></i>")
                   .append("</div>")
                   .append("<div class='price-review-container'>")
                   .append("<span class='price-badge'>").append(String.format("%.2f", rs.getDouble("precio_pr"))).append("$</span>")
                   .append("<a href='#' class='reviews-link'>REVIEWS</a>")
                   .append("</div>")
                   .append("<div class='product-info'>")
                   .append("<div class='product-title'>").append(rs.getString("nombre_pr")).append("</div>")
                   .append("<div class='").append(stockClass).append("'>").append(stockText).append("</div>")
                   .append(addToCartBtn)
                   .append("</div>")
                   .append("</div>");
            }
            System.out.println("Productos encontrados en consultarTodo1: " + rowCount);
            if (rowCount == 0) {
                html.append("<div class='col-12 text-center py-5'><i class='fas fa-box-open fa-3x mb-3'></i><p>No hay productos disponibles</p></div>");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return "<div class='alert alert-danger'>Error al cargar productos: " + e.getMessage() + "</div>";
        } finally {
            con.close();
        }
        
        html.append("</div>");
        
        return html.toString();
    }
    
    public String consultarTodo() {
        String sql = "SELECT p.id_pr, p.nombre_pr, c.descripcion_cat, p.cantidad_pr, p.precio_pr, p.foto_pr " +
                    "FROM tb_productos p JOIN tb_categoria c ON p.id_cat = c.id_cat ORDER BY p.id_pr";
        conexion con = new conexion();
        StringBuilder tabla = new StringBuilder();
        
        try (ResultSet rs = con.Consulta(sql)) {
            while (rs != null && rs.next()) {
                String imagen = "";
                if (rs.getBytes("foto_pr") != null) {
                    imagen = "<img src='data:image/jpeg;base64," + java.util.Base64.getEncoder().encodeToString(rs.getBytes("foto_pr")) + 
                             "' width='50' class='img-thumbnail'>";
                } else {
                    imagen = "<i class='fas fa-image text-muted'></i>";
                }
                
                tabla.append("<tr>")
                     .append("<td>").append(rs.getInt("id_pr")).append("</td>")
                     .append("<td>").append(rs.getString("nombre_pr")).append("<br>").append(imagen).append("</td>")
                     .append("<td>").append(rs.getString("descripcion_cat")).append("</td>")
                     .append("<td>$").append(String.format("%,.2f", rs.getDouble("precio_pr"))).append("</td>")
                     .append("<td>").append(rs.getInt("cantidad_pr")).append("</td>")
                     .append("<td><a href='actualizarProducto.jsp?id=").append(rs.getInt("id_pr")).append("' class='btn btn-warning btn-sm'><i class='fas fa-edit'></i></a></td>")
                     .append("<td><a href='eliminarProducto.jsp?id=").append(rs.getInt("id_pr")).append("' class='btn btn-danger btn-sm' onclick='return confirm(\"¿Eliminar este producto?\");'><i class='fas fa-trash'></i></a></td>")
                     .append("</tr>");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            con.close();
        }
        
        return tabla.toString();
    }
    
    public String buscarProductoCategoria(int cat) {
        String sql = "SELECT p.id_pr, p.nombre_pr, c.descripcion_cat, p.cantidad_pr, p.precio_pr, p.foto_pr " +
                     "FROM tb_productos p JOIN tb_categoria c ON p.id_cat = c.id_cat WHERE p.id_cat = ?";
        conexion con = new conexion();
        StringBuilder html = new StringBuilder();
        
        try (PreparedStatement pst = con.getConnection().prepareStatement(sql)) {
            pst.setInt(1, cat);
            try (ResultSet rs = pst.executeQuery()) {
                while (rs != null && rs.next()) {
                    String imagenHtml = rs.getBytes("foto_pr") != null ?
                        "<img src='data:image/jpeg;base64," + java.util.Base64.getEncoder().encodeToString(rs.getBytes("foto_pr")) + 
                        "' alt='" + rs.getString("nombre_pr") + "'>" :
                        "<i class='fas fa-image fa-3x text-muted'></i>";

                    html.append("<div class='producto-card' data-product-id='").append(rs.getInt("id_pr")).append("'>")
                        .append("<div class='producto-imagen'>").append(imagenHtml).append("</div>")
                        .append("<div class='producto-precio'>$").append(String.format("%.2f", rs.getDouble("precio_pr"))).append("</div>")
                        .append("<div class='producto-nombre'>").append(rs.getString("nombre_pr")).append("</div>")
                        .append("<div class='producto-stock'>").append(rs.getInt("cantidad_pr")).append(" disponibles</div>")
                        .append("<button class='btn-agregar'>ADD TO CART</button>")
                        .append("</div>");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return "<div class='mensaje-vacio'><i class='fas fa-exclamation-circle'></i> Error al cargar productos</div>";
        } finally {
            con.close();
        }
        
        if (html.length() == 0) {
            return "<div class='mensaje-vacio'><i class='fas fa-exclamation-circle'></i> No hay productos en esta categoría</div>";
        }
        
        return html.toString();
    }

    public boolean agregarProducto(String nombre, int categoria, int cantidad, double precio, byte[] imagen) {
        String sql = "INSERT INTO tb_productos (nombre_pr, id_cat, cantidad_pr, precio_pr, foto_pr) VALUES (?, ?, ?, ?, ?)";
        conexion con = new conexion();
        try (PreparedStatement pst = con.getConnection().prepareStatement(sql)) {
            pst.setString(1, nombre);
            pst.setInt(2, categoria);
            pst.setInt(3, cantidad);
            pst.setDouble(4, precio);
            pst.setBytes(5, compressImage(imagen)); // Comprimir imagen antes de guardar
            return pst.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            con.close();
        }
    }

    public boolean actualizarProducto(int id, String nombre, int categoria, int cantidad, double precio, byte[] imagen) {
        String sql = "UPDATE tb_productos SET nombre_pr=?, id_cat=?, cantidad_pr=?, precio_pr=?, foto_pr=? WHERE id_pr=?";
        conexion con = new conexion();
        try (PreparedStatement pst = con.getConnection().prepareStatement(sql)) {
            pst.setString(1, nombre);
            pst.setInt(2, categoria);
            pst.setInt(3, cantidad);
            pst.setDouble(4, precio);
            if (imagen != null && imagen.length > 0) {
                pst.setBytes(5, compressImage(imagen)); // Comprimir si se proporciona una nueva imagen
            } else {
                // Mantener la imagen existente si no se subió una nueva
                ResultSet rs = obtenerProductoPorId(id);
                if (rs != null && rs.next()) {
                    pst.setBytes(5, rs.getBytes("foto_pr"));
                } else {
                    pst.setBytes(5, null);
                }
            }
            pst.setInt(6, id);
            return pst.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            con.close();
        }
    }

    public boolean eliminarProducto(int id) {
        String sql = "DELETE FROM tb_productos WHERE id_pr=?";
        conexion con = new conexion();
        try (PreparedStatement pst = con.getConnection().prepareStatement(sql)) {
            pst.setInt(1, id);
            return pst.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            con.close();
        }
    }

    public ResultSet obtenerProductoPorId(int id) throws SQLException {
        String sql = "SELECT * FROM tb_productos WHERE id_pr=?";
        conexion con = new conexion();
        PreparedStatement pst = con.getConnection().prepareStatement(sql);
        pst.setInt(1, id);
        return pst.executeQuery();
    }
    
    public String consultarTodoEnTarjetas() {
        String sql = "SELECT p.id_pr, p.nombre_pr, c.descripcion_cat, p.cantidad_pr, p.precio_pr, p.foto_pr " +
                    "FROM tb_productos p JOIN tb_categoria c ON p.id_cat = c.id_cat WHERE p.cantidad_pr > 0 ORDER BY p.id_pr";
        conexion con = new conexion();
        StringBuilder html = new StringBuilder();
        
        html.append("<div class='row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-4'>");
        
        try (ResultSet rs = con.Consulta(sql)) {
            int rowCount = 0;
            while (rs != null && rs.next()) {
                rowCount++;
                String imagenHtml = rs.getBytes("foto_pr") != null ?
                    "<img src='data:image/jpeg;base64," + java.util.Base64.getEncoder().encodeToString(rs.getBytes("foto_pr")) + 
                    "' style='max-height:140px; width:auto;' alt='" + rs.getString("nombre_pr") + "'>" :
                    "<i class='fas fa-image fa-3x text-muted' style='max-height:140px;'></i>";

                html.append("<div class='col'>")
                    .append("<div class='product-card' data-product-id='").append(rs.getInt("id_pr")).append("'>")
                    .append("<div class='card-img-container'>")
                    .append(imagenHtml)
                    .append("<span class='category-label'>").append(rs.getString("descripcion_cat")).append("</span>")
                    .append("<i class='far fa-heart favorite-icon'></i>")
                    .append("</div>")
                    .append("<div class='product-info'>")
                    .append("<div class='product-price'>$").append(String.format("%.2f", rs.getDouble("precio_pr"))).append("</div>")
                    .append("<div class='product-title'>").append(rs.getString("nombre_pr")).append("</div>")
                    .append("<div class='stock-info'>").append(rs.getInt("cantidad_pr")).append(" disponibles</div>")
                    .append("<button class='add-to-cart-btn'>ADD TO CART</button>")
                    .append("</div>")
                    .append("</div>")
                    .append("</div>");
            }
            System.out.println("Productos encontrados en consultarTodoEnTarjetas: " + rowCount);
            if (rowCount == 0) {
                html.append("<div class='col-12 text-center py-5'><i class='fas fa-box-open fa-3x mb-3'></i><p>No hay productos disponibles</p></div>");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return "<div class='alert alert-danger'>Error al cargar productos: " + e.getMessage() + "</div>";
        } finally {
            con.close();
        }
        
        html.append("</div>");
        return html.toString();
    }
    
    public String consultarTodoEnTarjetasPorCategoria(int categoriaId) {
        String sql = "SELECT p.id_pr, p.nombre_pr, c.descripcion_cat, p.cantidad_pr, p.precio_pr, p.foto_pr " +
                    "FROM tb_productos p JOIN tb_categoria c ON p.id_cat = c.id_cat " +
                    "WHERE p.id_cat = ? AND p.cantidad_pr > 0 ORDER BY p.id_pr";
        conexion con = new conexion();
        StringBuilder html = new StringBuilder();
        
        html.append("<div class='row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-4'>");
        
        try (PreparedStatement pst = con.getConnection().prepareStatement(sql)) {
            pst.setInt(1, categoriaId);
            try (ResultSet rs = pst.executeQuery()) {
                int rowCount = 0;
                while (rs != null && rs.next()) {
                    rowCount++;
                    String imagenHtml = rs.getBytes("foto_pr") != null ?
                        "<img src='data:image/jpeg;base64," + java.util.Base64.getEncoder().encodeToString(rs.getBytes("foto_pr")) + 
                        "' style='max-height:140px; width:auto;' alt='" + rs.getString("nombre_pr") + "'>" :
                        "<i class='fas fa-image fa-3x text-muted' style='max-height:140px;'></i>";

                    html.append("<div class='col'>")
                       .append("<div class='product-card' data-product-id='").append(rs.getInt("id_pr")).append("'>")
                       .append("<div class='card-img-container'>")
                       .append(imagenHtml)
                       .append("<span class='category-label'>").append(rs.getString("descripcion_cat")).append("</span>")
                       .append("<i class='far fa-heart favorite-icon'></i>")
                       .append("</div>")
                       .append("<div class='product-info'>")
                       .append("<div class='product-price'>$").append(String.format("%.2f", rs.getDouble("precio_pr"))).append("</div>")
                       .append("<div class='product-title'>").append(rs.getString("nombre_pr")).append("</div>")
                       .append("<div class='stock-info'>").append(rs.getInt("cantidad_pr")).append(" disponibles</div>")
                       .append("<button class='add-to-cart-btn'>ADD TO CART</button>")
                       .append("</div>")
                       .append("</div>")
                       .append("</div>");
                }
                System.out.println("Productos encontrados en consultarTodoEnTarjetasPorCategoria (cat " + categoriaId + "): " + rowCount);
                if (rowCount == 0) {
                    html.append("<div class='col-12 text-center py-5'><i class='fas fa-box-open fa-3x mb-3'></i><p>No hay productos disponibles en esta categoría</p></div>");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return "<div class='col-12'><div class='alert alert-danger'>Error al cargar productos: " + e.getMessage() + "</div></div>";
        } finally {
            con.close();
        }
        
        html.append("</div>");
        return html.toString();
    }

    public int contarProductos() {
        String sql = "SELECT COUNT(*) AS total FROM tb_productos WHERE cantidad_pr > 0";
        conexion con = new conexion();
        try (ResultSet rs = con.Consulta(sql)) {
            return rs.next() ? rs.getInt("total") : 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        } finally {
            con.close();
        }
    }
}