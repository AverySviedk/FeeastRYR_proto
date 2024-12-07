<%-- 
    Document   : notFound
    Created on : 5 dic. 2024, 00:14:22
    Author     : Inspiron 7380
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <%
            //HttpSession sesion = request.getSession(false);
            String email = "", password = "";
            try{
                email = session.getAttribute("username").toString();
                password = session.getAttribute("password").toString();
            }catch(Exception e){
                
            }
        %>
    </head>
    <body>
        <h1>
            Usuario no encontrado
        </h1><br>
        <h3>
            Email: <%=email%><br>
            Password: <%=password%><br>
        </h3>        
    </body>
</html>
