package com.productos.negocio;

   import com.productos.datos.conexion;
   import java.sql.*;

   public class Categoria {

       public String mostrarCategoria() {
           String sql = "SELECT * FROM tb_categoria ORDER BY id_cat";
           conexion con = new conexion();
           StringBuilder combo = new StringBuilder();
           combo.append("<select name='cmbCategoria' class='form-select' required>")
                .append("<option value='' selected disabled>Seleccione categoría</option>");
           
           try (ResultSet rs = con.Consulta(sql)) {
               int count = 0;
               while (rs != null && rs.next()) {
                   count++;
                   combo.append("<option value='").append(rs.getInt("id_cat")).append("'>")
                        .append(rs.getString("descripcion_cat")).append("</option>");
               }
               System.out.println("Categorías encontradas en mostrarCategoria: " + count);
               if (count == 0) {
                   combo.append("<option value='' disabled>No hay categorías disponibles</option>");
               }
           } catch (SQLException e) {
               System.err.println("Error al consultar categorías: " + e.getMessage());
               e.printStackTrace();
               combo.append("<option value='' disabled>Error al cargar categorías</option>");
           } finally {
               con.close();
           }
           
           combo.append("</select>");
           return combo.toString();
       }

       public String obtenerNombreCategoria(int id) {
           String sql = "SELECT descripcion_cat FROM tb_categoria WHERE id_cat=?";
           conexion con = new conexion();
           try (PreparedStatement pst = con.getConnection().prepareStatement(sql)) {
               pst.setInt(1, id);
               try (ResultSet rs = pst.executeQuery()) {
                   return rs != null && rs.next() ? rs.getString("descripcion_cat") : "Desconocido";
               }
           } catch (SQLException e) {
               System.err.println("Error al obtener nombre de categoría: " + e.getMessage());
               e.printStackTrace();
               return "Error";
           } finally {
               con.close();
           }
       }
   }