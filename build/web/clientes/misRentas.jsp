<%-- 
    Document   : misRentas
    Created on : 6 dic. 2024, 20:08:22
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
        if (userId.equals("null")){
            response.sendRedirect(request.getContextPath() + "/notFound.jsp");
        }%>
    </head>
    <body>
        <h1>Mis Rentas</h1>
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
                
                ServletContext context = request.getServletContext();
                context.log( "User ID: " + userId );
                
                String sql = "SELECT idRenta, fecha AS Fecha, hora AS Hora, precio AS Precio, estado AS Estado, " +
                                    "CASE WHEN fecha > CURRENT_DATE() " +
                                         "OR (fecha = CURRENT_DATE() AND hora < '9:00:00') THEN 'cancelable' " +
                                         "ELSE 'expirada' " +
                                    "END AS cancelabilidad FROM renta r  " + 
                                "WHERE (estado = 'Pendiente' or estado = 'Aceptado') AND r.idCliente = ? " +  
                                "ORDER BY r.estado ASC, Fecha ASC, Hora ASC";
                
                statement = connection.prepareStatement(sql);
                statement.setString(1, userId);
                resultSet = statement.executeQuery();
                boolean barelyResult = resultSet.next();
                resultSet = statement.executeQuery();
                
                context.log("Consulta ejecutada: " + sql + "");                
                if (resultSet.isBeforeFirst()) {
                    context.log("Se encontraron datos");
                } else {
                    context.log("No se encontraron datos");
                }
                
                // Obtener nombres de columnas
                ResultSetMetaData metaData = resultSet.getMetaData();
                int columnCount = metaData.getColumnCount(); 
                
                if (barelyResult){
                    for (int i = 2; i <= columnCount; i++) {
                        String columnName = metaData.getColumnLabel(i);%>
                        <th><%= columnName %></th>
              <%    }
                }else{%>
                    <th>No tienes rentas pendientes.</th>
              <%}%>
            </tr>
        </thead>
        <tbody> <!-- Aquí se agregarán las filas dinámicamente -->
            <%  while (resultSet.next()) {
                    String idRenta = resultSet.getObject(1).toString();
                    String cancelailidad = resultSet.getObject(columnCount).toString();%>
                    <tr>
                    <%  for (int i = 2; i <= columnCount - 1; i++) { %>
                            <td><%= (resultSet.getObject(i) != null) ? resultSet.getObject(i).toString() : " - " %></td>
                    <%  } %>
                        <td>
                            <a href="<%=request.getContextPath()%>/admin/detallesRenta.jsp?idRenta=<%=idRenta%>">Ver Detalles</a>
                        </td>
                      <%if (cancelailidad.equals("cancelable")){%>
                        <td>
                            <input type="button" value="Cancelar" 
                                   onclick="window.location.href='<%=request.getContextPath()%>/statusChanger?modo=delRenta&idRenta=<%=idRenta%>&idUsr=<%=userId%>'">
                        </td>
                      <%}%>
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
        <input type="button" value="Nueva Renta" onclick="window.location.href='<%=request.getContextPath()%>/clientes/iniciarPedido.jsp'">
        <br><br><br>
        <input type="button" value="Ver Historial" onclick="window.location.href='<%=request.getContextPath()%>/clientes/miHistorial.jsp'">
        <br><br><br>
        <input type="button" value="SignOut" onclick="window.location.href='<%=request.getContextPath()%>/statusChanger?modo=signOut'">
    </body>
</html>
