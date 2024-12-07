<%-- 
    Document   : rentasAdmin
    Created on : 4 dic. 2024, 23:19:17
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
    </head>
    <body>
        <h1>Admin_Page</h1>
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

                //String sql = "SELECT * FROM renta ORDER BY fechaHoraRenta ASC";
                //"SELECT * FROM renta WHERE estado = 'Pendiente' OR estado = 'Aceptado' ORDER BY fechaHoraRenta ASC";
                /*
                String sql = "SELECT idRenta, fecha, hora, precio, compensacion, estado "
                            + "FROM renta WHERE estado = 'Pendiente' or estado = 'Aceptado' "
                            + "ORDER BY fecha ASC, hora ASC";*/
                
                String sql = "SELECT idRenta, nombreCliente AS Cliente, fecha AS Fecha, " +
                             "hora AS Hora, precio AS Precio, compensacion AS Compensacion, estado AS Estado " +
                             "FROM renta r INNER JOIN cliente c  " +
                             "ON r.idCliente = c.idCliente " +
                             "WHERE Estado = 'Pendiente' or Estado = 'Aceptado' " +
                             "ORDER BY Fecha ASC, Hora ASC";
                
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
                    String idRenta = resultSet.getObject(1).toString();%>
                    <tr>
                    <%  for (int i = 1; i <= columnCount; i++) { %>
                            <td><%= (resultSet.getObject(i) != null) ? resultSet.getObject(i).toString() : " - " %></td>
                    <%  } %>
                        <td>
                            <a href="/detallesRenta.jsp?idRenta=<%=idRenta%>">Ver Detalles</a>
                        </td>
                        <td>
                    <%  if (resultSet.getObject(columnCount).equals("Pendiente")){%>
                            <input type="button" value="Aceptar" 
                                   onclick="window.location.href='<%=request.getContextPath()%>/statusChanger?modo=updEstado&idRenta=<%=idRenta%>&cambio=Aceptado'"> 
                            <input type="button" value="Rechazar" 
                                   onclick="window.location.href='<%=request.getContextPath()%>/statusChanger?modo=updEstado&idRenta=<%=idRenta%>&cambio=Rechazado'"> 
                          
                    <%  } else if (resultSet.getObject(columnCount).equals("Aceptado")){%>
                            <input type="button" value="Finalizar" 
                                   onclick="window.location.href='<%=request.getContextPath()%>/statusChanger?modo=updEstado&idRenta=<%=idRenta%>&cambio=Terminado'"> 
                            <input type="button" value="Cancelar" 
                                   onclick="window.location.href='<%=request.getContextPath()%>/statusChanger?modo=updEstado&idRenta=<%=idRenta%>&cambio=Pendiente'"> 
                    <%  } %>
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
        <input type="button" value="Ver Historial" onclick="window.location.href='<%=request.getContextPath()%>/admin/historialAdmin.jsp'">
        <br>
        <input type="button" value="Registrar un nuevo artículo" onclick="window.location.href='<%=request.getContextPath()%>/admin/registroItem.jsp'">
        <br>
        <input type="button" value="Ver artículos" onclick="window.location.href='<%=request.getContextPath()%>/admin/seleccionItems.jsp'">
        <br><br><br>
        <input type="button" value="SignOut" onclick="window.location.href='<%=request.getContextPath()%>/statusChanger?modo=signOut'">
    </body>
</html>
