<%-- 
    Document   : realizarRenta
    Created on : 26 nov. 2024, 07:42:50
    Author     : Usuario
--%>

<%@page import="sourcer.Connectorizer" %>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Realizar Renta</title>
        <script>
            function desplegarItems(idTipo, nombre) {
                var boton = document.getElementById(idTipo);
                var campo = document.getElementById("Campo" + idTipo);
                var items = document.getElementsByName(nombre);

                if (campo.style.display === "none") {
                    campo.style.display = "block";
                } else {
                    campo.style.display = "none";
                    for (var i = 0; i < items.length; i++) {
                        if (items[i].type === "checkbox") {
                            items[i].checked = false;
                        } else {
                            items[i].value = 0;
                        }
                    }
                }
            }
        </script>
    </head>
    <body>
        <main>
            <hgroup>
                <h1>Renta tus items</h1>
            </hgroup>

            <form name="elegirItems" enctype="multipart/form-data" 
                  action="<%=request.getContextPath()%>/clientes/insertarRenta.jsp" method="get">

                  <%// Recupera la fecha de pedido, primero de la request y luego de la session si no está presente
                    String fechaHora = request.getParameter("fechaPedido");
                    String opcionesDireccion = request.getParameter("opcionesDireccion");
                    if (fechaHora == null) {
                        fechaHora = session.getAttribute("fechaPedido").toString();
                    } else {
                        session.setAttribute("fechaPedido", fechaHora);
                    }%>
                
                <input type="hidden" name="fechaPedido" value="<%=fechaHora%>"/>
                <input type="hidden" name="idDireccion" value="<%=opcionesDireccion%>"/>

                  <%String[] fecha0hora1;
                    if (fechaHora == null) {
                        fecha0hora1 = session.getAttribute("fechaPedido").toString().split("T");
                    } else {
                        fecha0hora1 = fechaHora.split("T");
                    }

                    Connectorizer cnx = new Connectorizer();
                    Connection connection = null;
                    PreparedStatement stmt = null;
                    ResultSet rs = null;
                    try {
                        connection = cnx.conectar();
                        String usuarioID = session.getAttribute("userId").toString();

                        // Consultar si el usuario tiene una dirección registrada
                        String direccionQuery = "SELECT d.* FROM direccion d " + 
                                                "INNER JOIN dir_cliente dc ON d.idDireccion = dc.idDireccion " + 
                                                "WHERE dc.idCliente = ? ";
                        stmt = connection.prepareStatement(direccionQuery);
                        stmt.setInt(1, Integer.parseInt(usuarioID));
                        rs = stmt.executeQuery();

                        if (!rs.next()) {
                            response.sendRedirect("iniciarPedido.jsp");
                        } else {
                            // Consultar los tipos de items disponibles
                            String tiposItemsQuery = "SELECT * FROM tipoItem";
                            stmt = connection.prepareStatement(tiposItemsQuery);
                            ResultSet rsTipoItem = stmt.executeQuery();

                            while (rsTipoItem.next()) {
                                int idTipoItem = rsTipoItem.getInt(1);
                                String itemsQuery = "SELECT idItem, nombreItem, precio, cantidadDisponible " + 
                                                            "FROM item WHERE cantidadDisponible > 0 AND idTipo = ?";
                                stmt = connection.prepareStatement(itemsQuery);
                                stmt.setInt(1, idTipoItem);
                                ResultSet rsItemsDisp = stmt.executeQuery();%>

                                <label for="<%=rsTipoItem.getString(1)%>"><%=rsTipoItem.getString(2)%></label>
                                <input type="checkbox" name="tiposItem<%=rsTipoItem.getString(1)%>" 
                                       onchange="desplegarItems(<%=rsTipoItem.getString(1)%>, <%=rsTipoItem.getString(1)%>)"/> <br>

                                <fieldset id="Campo<%=rsTipoItem.getString(1)%>" style="display:none">
                                      
                                      <%while (rsItemsDisp.next()) {
                                            // Consultar la cantidad de items rentados para esa fecha
                                            String contarItemsQuery = "SELECT sum(cantItem) FROM item_renta " + 
                                                                            "INNER JOIN renta WHERE idItem = ? AND fecha = ?";
                                            stmt = connection.prepareStatement(contarItemsQuery);
                                            stmt.setInt(1, rsItemsDisp.getInt(1));
                                            stmt.setString(2, fecha0hora1[0]);
                                            ResultSet contarItems = stmt.executeQuery();

                                            boolean hayDisponibles = true;
                                            int rentablesEsteDia = rsItemsDisp.getInt(4);
                                            if (contarItems.next()) {
                                                int cantidadOcupados = contarItems.getInt(1);
                                                rentablesEsteDia -= cantidadOcupados;
                                                hayDisponibles = (rentablesEsteDia > 0);
                                            }

                                            if (hayDisponibles) {       //CHECKBOX BOTON O NO HAY
                                                String nombre = rsItemsDisp.getString(1);
                                                boolean unico = rentablesEsteDia <= 1;

                                                if (unico) {%>
                                                    <input type="checkbox" name="<%=nombre%>">
                                                    <label for="inflable1"><%=rsItemsDisp.getString(2)%></label> <br>
                                              <%} else {%>
                                                    <input type="number" min="0" max="<%=rentablesEsteDia%>" name="<%=nombre%>">
                                                    <label for="inflable1"><%=rsItemsDisp.getString(2)%></label> <br>
                                              <%}
                                            } else {%>
                                                <p>No hay <%=rsTipoItem.getString(2)%> disponibles</p>
                                          <%}
                                        }%>
                                </fieldset>

                                <table border="1" width="600">
                                    <tr bgcolor="skyBlue">
                                        <th>Id</th>
                                        <th>Tipo</th>
                                        <th>Opciones</th>
                                    </tr>
                                    <tr>
                                        <th><%=rsTipoItem.getString(1)%></th>
                                        <th><%=rsTipoItem.getString(2)%></th>
                                        <th>
                                            <a href="E.jsp?idPer=<%=idTipoItem%>">Editar</a> ||
                                            <a href="newjsp2.jsp?idPer=<%=idTipoItem%>">Eliminar</a>
                                        </th>
                                    </tr>    
                                </table>
                          <%} // Fin del while de resultadosTipoItem

                            rsTipoItem.close();
                            //cnx.close();
                        }
                    } catch (SQLException ex) {
                        out.print(ex.getMessage());
                    } finally {
                        try {
                            if (rs != null) rs.close();
                            if (stmt != null) stmt.close();
                            if (connection != null) connection.close();
                        } catch (SQLException e) {
                            out.print("Error al cerrar recursos: " + e.getMessage());
                        }
                    }
                %>

                <input type="submit" value="Confirmar Renta"/>
            </form>
        </main>
    </body>
</html>



