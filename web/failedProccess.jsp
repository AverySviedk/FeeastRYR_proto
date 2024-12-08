<%-- 
    Document   : failedProccess
    Created on : 8 dic. 2024, 02:48:09
    Author     : Inspiron 7380
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
      <%String severity = request.getParameter("severity");
        String head = "";
        String msj = request.getParameter("msj");
        if (severity.equals("done")){
            head = "Ejecución completa";
        }        
      %>
    </head>
    <body>
        <h1><%=head%></h1>
        <h3><%=msj%></h3>
    </body>
</html>
