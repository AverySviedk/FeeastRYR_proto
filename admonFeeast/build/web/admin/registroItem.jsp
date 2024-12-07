<%-- 
    Document   : registroItem
    Created on : 7 dic. 2024, 02:49:14
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
        <h1>Nuevo Artículo</h1>
        
      <%
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        try {
            Connectorizer connect = new Connectorizer();
            connection = connect.conectar();

            out.println("<p>" + userId + "</p>");

            String sql = "SELECT * FROM tipoitem";
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();

            if (resultSet.isBeforeFirst()) {
                out.println("<p>Se encontraron datos</p>");
            } else {
                out.println("<p>No se encontraron datos</p>");
            }

            out.println("<p>Consulta ejecutada: " + sql + "</p>");

            out.println("<p>cuenta: " + resultSet.getRow() + "</p>");
      %>
      <form name="formItem" method="post" onsubmit="return preventType(event)" action="<%=request.getContextPath()%>/statusChanger?modo=instItem&dimenItem=false">
            <table>
                <thead>
                    <th colspan="2">Características</th>
                </thead>
                <tr>
                    <th><label for="TxtPwd">Tipo de artículo</label></th>
                    <th>
                        <select name="idTipo" onchange="writeType()">
                            <option value="" selected>Selecciona una tipo de item</option>
                          <%while (resultSet.next()) {%>
                          <option value="<%=String.valueOf(resultSet.getObject(1))%>"><%=resultSet.getObject(2).toString()%></option>
                          <%}%>
                            <option value="nuevoTipo">Nuevo Tipo</option>
                        </select><br>
                        <input type="text" name="nombreTipo" placeholder="Nombre de Tipo" hidden>
                        <input type="button" name="newItem" value="Subir" onclick="instType()" hidden>
                    </th>
                </tr>
                <tr>
                    <th><label for="nombreItem">Nombre del Artículo</label></th>
                    <th><input type="text" name="nombreItem" required></th>
                </tr>
                <tr>
                    <th><input type="button" name="showDim" value="Incluír dimensiones" onclick="showDimension()"> </th>
                </tr>
                <tr name="itemDim" hidden>
                    <th><label for="alto">Ancho</label></th>
                    <th><input type="number" name="ancho" ></th>
                </tr>
                <tr name="itemDim" hidden>
                    <th><label for="alto">Alto</label></th>
                    <th><input type="number" name="alto" ></th>
                </tr>
                <tr name="itemDim" hidden>
                    <th><label for="largo">Largo</label></th>
                    <th><input type="number" name="largo" ></th>
                </tr>
                    <script>
                        let showButtonDim = document.getElementsByName('showDim')[0];
                        let itemDimens = document.getElementsByName('itemDim');
                        let ancho = document.getElementsByName('ancho')[0];
                        let alto  = document.getElementsByName('alto')[0];
                        let largo = document.getElementsByName('largo')[0];
                        let itemForm = document.getElementsByName('formItem')[0];
                                                
                        function showDimension(){
                            if (showButtonDim.value === "Incluír dimensiones"){
                                for (let dimx of itemDimens){
                                    dimx.hidden = false;
                                    console.log("uwu");
                                }
                                ancho.required = true;
                                alto.required = true;
                                largo.required = true;
                                showButtonDim.value = "Ocultar dimensiones";
                                itemForm.action = "<%=request.getContextPath()%>/statusChanger?modo=instItem&dimenItem=true";
                            }else if (showButtonDim.value === "Ocultar dimensiones"){
                                for (let dimx of itemDimens){
                                    dimx.hidden = true;
                                }
                                ancho.value = alto.value = largo.value = null;
                                ancho.required = alto.required = largo.required = false;
                                showButtonDim.value = "Incluír dimensiones";
                                itemForm.action = "<%=request.getContextPath()%>/statusChanger?modo=instItem&dimenItem=false";
                            }
                        }
                    </script>
                <tr>
                    <th><label for="precio">Precio</label></th>
                    <th><input type="number" name="precio" required></th>
                </tr>
                <tr>
                    <th><label for="cantidadDisponible">Unidades disponibles </label></th>
                    <th><input type="number" name="cantidadDisponible" required></th>
                </tr>
                <tr>
                    <th><label for="cantidadTotal">Unidades totales</label></th>
                    <th><input type="number" name="cantidadTotal" required></th>
                </tr>
                <tfoot>
                    <tr>
                        <td>
                        <input type="submit" value="Registrar">
                        </td>
                    </tr>
                </tfoot>
            </table>
        </form>
        <script>
            let typeSelected = document.getElementsByName('idTipo')[0];
            let typeNameContent = document.getElementsByName('nombreTipo')[0];
            let buttonItemType = document.getElementsByName('newItem')[0];
            function writeType(){
                if (typeSelected.value === "nuevoTipo"){
                    buttonItemType.hidden = false;
                    typeNameContent.hidden = false;
                    typeNameContent.required = true;
                }else if (buttonItemType.hidden === false){
                    buttonItemType.hidden = true;
                    typeNameContent.value = "";
                    typeNameContent.hidden = true;
                    typeNameContent.required = false;
                }
            }
            function instType(){
                window.location.href = "<%=request.getContextPath()%>/statusChanger?modo=instItemType&nombreTipo=" + typeNameContent.value;                                    
            }
        </script>
        <script>
            function preventType(event){
               if (typeSelected.value === ""){
                   event.preventDefault();
                   return false;
               }else{
                   return true;
               }
           }
        </script>
      <%
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (resultSet != null) try { resultSet.close(); } catch (SQLException ignore) {}
            if (statement != null) try { statement.close(); } catch (SQLException ignore) {}
            if (connection != null) try { connection.close(); } catch (SQLException ignore) {}
        }
      %>
    </body>
</html>
