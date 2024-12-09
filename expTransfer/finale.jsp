<%-- 
    Document   : finale
    Created on : 3 nov. 2024, 00:29:16
    Author     : Inspiron 7380
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
        HttpSession storedSession = request.getSession();
        
        String direccion, mesas, sillas, vasos;
        direccion = (String) storedSession.getAttribute("direccion");
        mesas     = (String) storedSession.getAttribute("mesas");
        sillas    = (String) storedSession.getAttribute("sillas");
        vasos     = (String) storedSession.getAttribute("vasos");
        %>
        <h1>Pedido realizado con éxito</h1>
        <b>Direccion: </b><%=direccion%><br>
        <b>Mesas: </b><%=mesas%><br>
        <b>Sillas: </b><%=sillas%><br>
        <b>Vasos: </b><%=vasos%><br>
    </body>
</html>
