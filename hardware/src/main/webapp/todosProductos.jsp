<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.productos.negocio.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Todos los Productos</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 1000px;
            margin: 0 auto;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            text-align: center;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }
        th {
            background-color: #4CAF50;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        .nav {
            margin-bottom: 20px;
            text-align: center;
        }
        .nav a {
            display: inline-block;
            margin: 0 10px;
            padding: 8px 16px;
            background: #4CAF50;
            color: white;
            text-decoration: none;
            border-radius: 4px;
        }
        .nav a:hover {
            background: #45a049;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Todos los Productos</h1>
        
        <div class="nav">
            <a href="categoria.jsp">Buscar por Categoría</a>
            <a href="todosProductos.jsp">Ver Todos los Productos</a>
        </div>
        
        <%
        Producto producto = new Producto();
        out.print(producto.consultarTodo());
        %>
    </div>
</body>
</html>