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

                String sql = "SELECT idRenta, nombreCliente AS Cliente, " + 
                             "CONCAT(direccion, ', ', ciudad, ', ', d.estado, '  C.P:', codigoPostal) AS Direccion, " + 
                             "fecha AS Fecha, hora AS Hora, precio AS Precio, " + 
			     "compensacion AS Compensacion, r.estado AS Estado " + 
                             "FROM renta r INNER JOIN cliente c ON r.idCliente = c.idCliente " + 
                             "INNER JOIN direccion d ON d.idDireccion = r.idDireccion " + 
                             "WHERE r.estado = 'Pendiente' or r.estado = 'Aceptado' " + 
                             "ORDER BY r.estado ASC, fecha ASC, hora ASC";
                
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
            <%  while (resultSet.next()) { 
                    String idRenta = resultSet.getObject(1).toString();%>
                    <tr>
                    <%  for (int i = 2; i <= columnCount; i++) { %>
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
                            <input type="button" value="Compenzar" name="compen<%=idRenta%>" onclick="showCompText()"> 
                            <input type="number" name="cantComp<%=idRenta%>" size="6" maxlength="6" hidden>
                            <input type="button" value="Dar $" name="submitComp<%=idRenta%>" onclick="submitCompCant()" hidden>
                            <script>
                                function showCompText(){
                                    let compen = document.getElementsByName("compen<%=idRenta%>")[0];
                                    let cantComp = document.getElementsByName("cantComp<%=idRenta%>")[0];
                                    let submitComp = document.getElementsByName("submitComp<%=idRenta%>")[0];
                                    submitComp.hidden = !submitComp.hidden;
                                    cantComp.hidden = !cantComp.hidden;
                                    if (cantComp.hidden){
                                        cantComp.value = "";
                                        compen.value = "Compenzar";
                                    }else{
                                        compen.value = "Ocultar";
                                    }
                                }
                                function submitCompCant(){
                                    let cantComp = document.getElementsByName("cantComp<%=idRenta%>")[0];
                                    if(cantComp.value != "") {
                                        window.location.href = "<%=request.getContextPath()%>/statusChanger?modo=setCompen&idRenta=<%=idRenta%>&cantComp=" + cantComp.value;
                                    }
                                }
                                
                            </script>
                            
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
