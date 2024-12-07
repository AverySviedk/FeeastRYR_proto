<%-- 
    Document   : seleccionItems
    Created on : 7 dic. 2024, 05:26:41
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
        <title>Items registrados</title>
        <%String userId = String.valueOf(session.getAttribute("userId"));
        if (!userId.equals("1")){
            response.sendRedirect(request.getContextPath() + "/notFound.jsp");
        }%>
    </head>
    <body>
        <h1>Articulos Disponibles</h1>
        <table>
        <thead>
            <tr>
        <%
            Connection connection = null;
            PreparedStatement statement = null;
            ResultSet resultSet = null;
            try {
                Connectorizer connect = new Connectorizer();
                connection = connect.conectar();
               
                out.println("<p>" + userId + "</p>");
                
                String sql = "SELECT * FROM item";
                statement = connection.prepareStatement(sql);
                resultSet = statement.executeQuery();
                
                if (resultSet.isBeforeFirst()) {
                    out.println("<p>Se encontraron datos</p>");
                } else {
                    out.println("<p>No se encontraron datos</p>");
                }
                
                out.println("<p>Consulta ejecutada: " + sql + "</p>");
               

                
                // Obtener nombres de columnas
                ResultSetMetaData metaData = resultSet.getMetaData();
                int columnCount = metaData.getColumnCount();
                
                out.println("<p>cuenta: " + resultSet.getRow() + "</p>");

                for (int i = 1; i <= columnCount; i++) {
                    String columnName = metaData.getColumnLabel(i);%>
                    <th><%= columnName %></th>
             <% } %>
            </tr>
        </thead>
        <tbody> <!-- Aquí se agregarán las filas dinámicamente -->
            <%  while (resultSet.next()) {
                    String idItem = resultSet.getObject(1).toString();%>
                    <tr>
                    <%  for (int i = 1; i <= columnCount; i++) { %>
                            <td><%= (resultSet.getObject(i) != null) ? resultSet.getObject(i).toString() : " - " %></td>
                    <%  } %>
                        <td>
                            <input type="button" value="Borrar" 
                                   onclick="window.location.href='<%=request.getContextPath()%>/statusChanger?modo=delItem&idItem=<%=idItem%>'">
                        </td>
                    </tr>
            <%  }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (resultSet != null) try { resultSet.close(); } catch (SQLException ignore) {}
                if (statement != null) try { statement.close(); } catch (SQLException ignore) {}
                if (connection != null) try { connection.close(); } catch (SQLException ignore) {}
            } %>
        </tbody>
        </table>        
        <br><br><br>
        <input type="button" value="Volver" onclick="window.location.href='<%=request.getContextPath()%>/admin/seleccionItems.jsp'">
    </body>
</html>
