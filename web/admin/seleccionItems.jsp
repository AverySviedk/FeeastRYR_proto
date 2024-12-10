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
        <table style="text-align: center">
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
                
                String sql = "SELECT idItem, nombreItem AS Nombre, ancho AS Ancho, " + 
                                    "alto AS Alto, largo AS Largo, precio AS Precio, " + 
                                    "cantidadDisponible AS Disponible, cantidadTotal AS Total, " + 
                                    "idTipo AS Tipo FROM item"; //"SELECT * FROM item";
                statement = connection.prepareStatement(sql);
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
                        <th style="text-align: right"><%= columnName %></th>
              <%   }
                }else{%>
                    <th>No tienes items registrados.</th>
              <%}%>
            </tr>
        </thead>
        <tbody> <!-- Aquí se agregarán las filas dinámicamente -->
            <%  while (resultSet.next()) {
                    String idItem = resultSet.getObject(1).toString();%>
                    <tr>
                    <%  for (int i = 2; i <= columnCount; i++) { %>
                          <td align="center"><%= (resultSet.getObject(i) != null) ? resultSet.getObject(i).toString() : " - " %></td>
                    <%  } %>
                        <td>
                            <input type="button" value="Borrar" 
                                   onclick="window.location.href='<%=request.getContextPath()%>/statusChanger?modo=delItem&idItem=<%=idItem%>'">
                        </td>
                        <td>
                            <input type="button" value="Cambiar cantidades" name="showConfAm<%=idItem%>" 
                                   onclick="writeIte(<%=idItem%>);">
                        </td>
                        <td>
                            <input style="width: 150px;" type="number" name="dispo<%=idItem%>" value="<%=resultSet.getObject("Disponible")%>" 
                                   placeholed="disponible" min="0" hidden/>
                            <input style="width: 150px;" type="number" name="total<%=idItem%>" value="<%=resultSet.getObject("Total")%>" 
                                   placeholed="total" min="0" hidden/>
                        </td>
                        <td>
                            <input type="button" value="Aceptar!" name="submitDat<%=idItem%>" 
                                   onclick="doModifyTem(<%=idItem%>);" hidden/>
                        </td>
                    </tr>                    
            <%  } //FIN WHILE
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (resultSet != null) try { resultSet.close(); } catch (SQLException ignore) {}
                if (statement != null) try { statement.close(); } catch (SQLException ignore) {}
                if (connection != null) try { connection.close(); } catch (SQLException ignore) {}
            } %>
        </tbody>
        </table>     
        
        

        <script>
            function doModifyTem(idTem){
                let dispo = document.getElementsByName('dispo' + idTem)[0].value;
                let total = document.getElementsByName('total' + idTem)[0].value;

                console.log(dispo);
                console.log(total);
                if (dispo === "" || total === ""){
                    console.log("N inválidos");
                    return;
                }
                
                window.location.href = "<%=request.getContextPath()%>/statusChanger?"
                                            + "modo=updItem" 
                                            + "&idItem=" + idTem
                                            + "&dispoItem=" + dispo
                                            + "&totalItem=" + total;
                                    
                //console.log(u);
            }

            function writeIte(idItem){
                let buttonUpDat = document.getElementsByName('submitDat' + idItem)[0];
                let buttonMorph = document.getElementsByName('showConfAm' + idItem)[0];
                let itemDisp = document.getElementsByName('dispo' + idItem)[0];
                let itemTotl = document.getElementsByName('total' + idItem)[0];
                
                buttonUpDat.hidden = !buttonUpDat.hidden;
                itemDisp.hidden = !itemDisp.hidden;
                itemTotl.hidden = !itemTotl.hidden;
                
                if (buttonMorph.value === "Cambiar cantidades"){
                    buttonMorph.value = "Cancelar";
                }else{
                    buttonMorph.value = "Cambiar cantidades";
                }
            }
        </script>

        
        
        
        <br><br><br>
        <input type="button" value="Volver" onclick="window.location.href='<%=request.getContextPath()%>/admin/rentasAdmin.jsp'">
    </body>
</html>
