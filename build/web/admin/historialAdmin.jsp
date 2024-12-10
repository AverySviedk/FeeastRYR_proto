<%-- 
    Document   : historialAdmin
    Created on : 5 dic. 2024, 07:17:32
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
        <h1>Historial Admin</h1>
        <table>
        <thead>
            <tr>
        <%
            String rentaPorJustificar = request.getParameter("idRenta");
            Connection connection = null;
            PreparedStatement statement = null;
            ResultSet resultSet = null;
            
            try {
                Connectorizer connect = new Connectorizer();
                connection = connect.conectar();

                String sql = "SELECT r.idRenta, " +
                             "       c.nombreCliente AS Cliente, " +
                             "       CONCAT(d.direccion, ', ', d.ciudad, ', ', d.estado, '  C.P:', d.codigoPostal) AS Direccion, " +
                             "       r.fecha AS Fecha, " +
                             "       r.hora AS Hora, " +
                             "       r.precio AS Precio, " +
                             "       r.compensacion AS Compensacion, " +
                             "       r.estado AS Estado, " +
                             "       r.comentario AS Comentario " +
                             "FROM renta r " +
                             "INNER JOIN cliente c ON r.idCliente = c.idCliente " +
                             "INNER JOIN dir_cliente dc ON r.idDireccion = dc.idDireccion " +
                             "INNER JOIN direccion d ON dc.idDireccion = d.idDireccion " +
                             "WHERE r.estado IN ('Terminado', 'Rechazado') " +
                             "ORDER BY r.estado ASC, r.fecha ASC, r.hora ASC; ";
                
                statement = connection.prepareStatement(sql);
                resultSet = statement.executeQuery();
                boolean barelyResult = resultSet.next();
                resultSet = statement.executeQuery();
                
                ServletContext context = request.getServletContext();
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
                    <th>No tienes rentas por cumplir.</th>
              <%}%>
            </tr>
        </thead>
        <tbody> <!-- Aquí se agregarán las filas dinámicamente -->
             <% while (resultSet.next()) { 
                  String idRenta = resultSet.getObject(1).toString();%>
                    <tr>
                     <% for (int i = 2; i <= columnCount; i++) { %>
                          <%String stringContent = (resultSet.getObject(i) != null) ? resultSet.getObject(i).toString() : " - ";
                            if (metaData.getColumnName(i).toString().equals("comentario") 
                                && stringContent.length() > 28) { %>
                               <td><%= stringContent.substring(0, 25) + "..." %></td>
                          <%} else {%>
                               <td style="max-width: 400px; height: 30px;" ><%= stringContent %></td>
                          <%}%>

                         <% if (metaData.getColumnName(i).toString().equals("comentario")
                                && resultSet.getObject(1).toString().equals(rentaPorJustificar)){%>
                            <td>
                                <textarea rows="2" cols="40" maxlength="80" name="comentario" placeholder="Justifica el rechazo"></textarea>
                                <br><input type="button" value="Enviar!" name="sendComment" 
                                       onclick="subirComentario()"/>
                                <a href="<%=request.getContextPath()%>/admin/detallesRenta.jsp?idRenta=<%=idRenta%>">Ver Detalles</a>
                            </td>
                            <script>
                                function subirComentario(){
                                    let comentario = document.getElementsByName('comentario')[0].value;
                                    window.location.href = "<%=request.getContextPath()%>/statusChanger?modo=updComt&idRenta=<%=rentaPorJustificar%>&comentario=" + comentario;
                                }
                            </script>
                         <% }%>
                     <% } %>
                        
                     <% if (!resultSet.getObject(1).toString().equals(rentaPorJustificar)){%>
                        <td>
                            <a href="<%=request.getContextPath()%>/admin/detallesRenta.jsp?idRenta=<%=idRenta%>">Ver Detalles</a>
                        </td>
                      <%}%>
                        <td><%=resultSet.getObject(1)%><%=rentaPorJustificar%></td>
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
        <input type="button" value="Volver A Rentas" onclick="window.location.href='<%=request.getContextPath()%>/admin/rentasAdmin.jsp'">
    </body>
</html>
