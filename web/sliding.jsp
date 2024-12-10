<%-- 
    Document   : sliding
    Created on : 9 dic. 2024, 22:59:23
    Author     : Inspiron 7380
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <% String prevPage = request.getParameter("prevPage"); 
           String id = String.valueOf(session.getAttribute("userId").toString());%>
    </head> 
    <body>
        <h1><div class="icon">😿</div>Oops, algo salió mal</h1>
        <p>No pudimos completar tu solicitud. Inténtalo nuevamente más tarde o vuelve al inicio.</p>
        <br><br>
        <% if (prevPage != null) { %>
        <a href="<%=prevPage %>">Volver a la página anterior</a><br>
        <% }
           if (id == "null"){
                response.sendRedirect(request.getContextPath() + "/notFound.jsp");
           } else if (id == "1") {%>
            <a href="<%=request.getContextPath() + "/admin/rentasAdmin.jsp" %>">Volver al inicio</a>
        <% } else{%>
            <a href="<%=request.getContextPath() + "/clientes/misRentas.jsp"%>">Volver al inicio</a>
        <% }%>
    </body>
</html>
