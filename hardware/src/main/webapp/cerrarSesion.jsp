<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true"%>
<%
// Invalidar la sesión actual
session.invalidate();
// Redirigir al index
response.sendRedirect("index.jsp");
%>