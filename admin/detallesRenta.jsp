<%-- 
    Document   : detallesRenta
    Created on : 5 dic. 2024, 08:14:05
    Author     : Inspiron 7380
--%>

<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@page import="sourcer.Connectorizer" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>


    </head>
    <body>
        <%String userId = String.valueOf(session.getAttribute("userId"));
            if (!userId.equals("1")) {
                response.sendRedirect(request.getContextPath() + "/notFound.jsp");
            }

            String idRenta = request.getParameter("idRenta");
            Connection connection = null;

            ResultSet itemsElegidos1 = null;
            Statement statement = null;
            try {

                Connectorizer connect = new Connectorizer();
                connection = connect.conectar();

                statement = connection.createStatement();;

                String strQry = "select item_renta.idItem, item.idTipo from item inner join item_renta where cantidadDisponible>0  and item_renta.idItem=item.idItem and idRenta='" + idRenta + "';";

                itemsElegidos1 = statement.executeQuery(strQry);

                strQry = "select idTipoItem from tipoItem";
                ResultSet tiposItem = null;
                Statement statement2;
                statement2 = connection.createStatement();
                tiposItem = statement2.executeQuery(strQry);

                ArrayList<String> itemsParticipantes = new ArrayList<>();
                ArrayList<String> tiposItemExistentes = new ArrayList<>();
                while (tiposItem.next()) {
                    String tipoItem = tiposItem.getString(1);
                    tiposItemExistentes.add(tipoItem);
                }
                while (itemsElegidos1.next()) {
                    String tipoItemElegido = itemsElegidos1.getString(2);
                    for (String tipoItem : tiposItemExistentes) {
                        if (tipoItemElegido.equals(tipoItem)) {

                            String itemPosible = tipoItem;
                            boolean existe = false;
                            for (String yaRegistrado : itemsParticipantes) {
                                if (yaRegistrado.equals(itemPosible)) {
                                    existe = true;
                                }

                            }
                            if (existe == false) {
                                itemsParticipantes.add(itemPosible);
                            }

                        }
                    }

                }

                for (String idTipoItem : itemsParticipantes) {

                    ResultSet resultadosItemsRentados = null;
                    strQry = "SELECT nombreItem, cantItem, item.precio, alto, ancho, largo FROM item inner join item_renta WHERE cantidadDisponible>0 AND item_renta.idItem=item.idItem AND item.idTipo=+" + idTipoItem + " AND idRenta=" + idRenta + ";";
                    statement = connection.createStatement();
                    resultadosItemsRentados = statement.executeQuery(strQry);

        %>
        <h2><%=idTipoItem%></h2>
        <table>
            <tr>
                <th>Nombre del <%=idTipoItem%></th>
                <th>Cantidad</th>
                <th>Precio </th>
                <th>Alto</th>
                <th>Ancho</th>
                <th>Largo</th>

            </tr>
            <%
                while (resultadosItemsRentados.next()) {
            %>
            <tr>
                <th><%=resultadosItemsRentados.getString(1)%></th>
                <th><%=resultadosItemsRentados.getString(2)%></th>
                <th><%=resultadosItemsRentados.getString(3)%></th>
                <th><%=resultadosItemsRentados.getString(4)%></th>
                <th><%=resultadosItemsRentados.getString(5)%></th>
                <th><%=resultadosItemsRentados.getString(6)%></th>

            </tr>

            <%

            %></table> <%                }
            %>

        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (itemsElegidos1 != null) try {
                    itemsElegidos1.close();
                } catch (SQLException ignore) {
                    ignore.printStackTrace();
                }
                if (statement != null) try {

                    statement.close();
                } catch (SQLException ignore) {
                    ignore.printStackTrace();
                }
                if (connection != null) try {
                    connection.close();
                } catch (SQLException ignore) {
                    ignore.printStackTrace();

                }
            }
        %>


    </body>
</html>
