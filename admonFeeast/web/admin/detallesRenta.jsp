<%-- 
    Document   : detallesRenta
    Created on : 5 dic. 2024, 08:14:05
    Author     : Inspiron 7380
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@page import="sourcer.Connectorizer" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
      <%String userId = String.valueOf(session.getAttribute("userId"));
        if (!userId.equals("1")){
            response.sendRedirect(request.getContextPath() + "/notFound.jsp");
        }%>
        
        <%
            String idRenta = request.getParameter("idRenta");
            Connection connection = null;
            PreparedStatement statement = null;
            ResultSet resultSet = null;
            try {
                Connectorizer connect = new Connectorizer();
                connection = connect.conectar();

                //String sql = "SELECT * FROM cliente WHERE correo = ? AND password = ?";
                String sql = "SELECT i.idItem, i.nombreItem, ti.Nombre, rri.cantItem " +
                                    "FROM relrentaitem rri INNER JOIN item i INNER JOIN tipoItem ti " +
                                    "WHERE rri.idItem = i.idItem AND i.idTipo = ti.idTipoItem " +
                                    "AND rri.idRenta = ? " +
                                    "ORDER BY cantItem DESC";                
                statement = connection.prepareStatement(sql);
                statement.setInt(1, Integer.parseInt(idRenta));  // Asignar el idRenta (en este caso, 1)
                resultSet = statement.executeQuery();


                //AHORA QUE TIENES EL RESULT SWET SE DEBEN MOSTRAR LOS RESULTADOS
                //DE LOS DETALLES D ELOS PRODUCTOS
                
                
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (resultSet != null) try { resultSet.close(); } catch (SQLException ignore) {}
                if (statement != null) try { statement.close(); } catch (SQLException ignore) {}
                if (connection != null) try { connection.close(); } catch (SQLException ignore) {}
            }
        %>
    </head>
    <body>
        <h1>Hello World!</h1>
    </body>
</html>
