<%-- 
    Document   : insertaRenta
    Created on : 9 dic. 2024, 01:44:42
    Author     : Inspiron 7380
<%@page import="conexion.Base"%>
--%>
<%@page import="java.util.ArrayList"%>
<%@page import="sourcer.Connectorizer"%>
<%@page import="java.sql.*"%>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>

<%@page import="java.util.ArrayList"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <%
            ServletContext context = request.getServletContext();
            String fechaHora = request.getParameter("fechaPedido");
            if (fechaHora == null) {
                context.log("No se recibió fechaPedido en el request, obteniéndola de la sesión.");
                fechaHora = session.getAttribute("fechaPedido").toString();
            } else {
                context.log("Se recibió fechaPedido desde el request: " + fechaHora);
                session.setAttribute("fechaPedido", fechaHora);
            }

        %>
    <input type="hidden" name="fechaPedido" value="<%=fechaHora%>"/>
    <%
        String[] fecha0hora1;
        if (fechaHora == null) {
            context.log("fechaPedido es null. Recuperándola desde la sesión.");
            fecha0hora1 = session.getAttribute("fechaPedido").toString().split("T");
        } else {
            context.log("Separando fecha y hora del parámetro fechaPedido: " + fechaHora);
            fecha0hora1 = fechaHora.split("T");
        }

        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;

        try {
            Connectorizer connect = new Connectorizer();
            context.log("Intentando conectar a la base de datos...");
            connection = connect.conectar();
            context.log("Conexión a la base de datos establecida.");

            String usuarioID = session.getAttribute("userId").toString();
            context.log("ID de usuario recuperado de la sesión: " + usuarioID);

            String strQry = "SELECT d.* FROM direccion d " + 
                                   "INNER JOIN dir_cliente dc ON d.idDireccion = dc.idDireccion " + 
                                   "WHERE dc.idCliente= ? ";
            statement = connection.prepareStatement(strQry);
            statement.setInt(1, Integer.parseInt(usuarioID));
            context.log("Ejecutando consulta para verificar dirección del usuario...");
            ResultSet tienedireccion = statement.executeQuery();

            if (!tienedireccion.next()) {
                context.log("El usuario no tiene dirección registrada. Redirigiendo a pedirDireccion.html.");
                response.sendRedirect(request.getContextPath() + "/clientes/iniciarPedido.jsp");
            } else {
                context.log("El usuario tiene una dirección registrada. Procesando la renta...");

                //String direccion = "1";
                String direccion = request.getParameter("idDireccion");
                context.log("tu direccion es : " + direccion);
                //strQry = "SELECT COUNT(*) FROM tipoItem;";
                strQry = "SELECT idTipoItem FROM tipoItem ORDER BY idTipoItem DESC;";
                statement = connection.prepareStatement(strQry);
                ResultSet cantidadTipoItem = statement.executeQuery();
                cantidadTipoItem.next();

                int cantidadTipoItemInt = cantidadTipoItem.getInt(1);
                context.log("Cantidad de tipos de ítems disponibles: " + cantidadTipoItemInt);

                strQry = "SELECT * FROM tipoItem ";
                statement = connection.prepareStatement(strQry);
                ResultSet resultadosTipoItem1 = statement.executeQuery();
                boolean[] itemSelected = new boolean[cantidadTipoItemInt];
                boolean todosApagados = true;

                int i = 0;
                context.log("Verificando selección de tipos de ítems...");
                while (resultadosTipoItem1.next()) {
                    String estaEncendido = request.getParameter("tiposItem" + resultadosTipoItem1.getString(1));
                    if (estaEncendido == null) {
                        context.log("Tipo Ítem " + resultadosTipoItem1.getString(1) + " no seleccionado.");
                        //itemSelected[i] = false;
                        itemSelected[Integer.parseInt(resultadosTipoItem1.getString(1)) - 1] = false;
                    } else {
                        context.log("Tipo Ítem " + resultadosTipoItem1.getString(1) + " seleccionado.");
                        //itemSelected[i] = true;
                        itemSelected[Integer.parseInt(resultadosTipoItem1.getString(1)) - 1] = true;
                        todosApagados = false;
                    }
                    i++;
                }
                resultadosTipoItem1.close();

                if (!todosApagados) {
                    context.log("Al menos un ítem fue seleccionado. Procesando la selección...");
                    int idTipoItem;
                    boolean itemsApagados = true;
                    ArrayList<String[]> ListaSeleccionado = new ArrayList<>();
                    int precio = 0;

                    strQry = "SELECT * FROM tipoItem;";
                    statement = connection.prepareStatement(strQry);
                    ResultSet resultadosTipoItem = statement.executeQuery();

                    while (resultadosTipoItem.next()) {
                        idTipoItem = Integer.parseInt(resultadosTipoItem.getString(1));
                        if (itemSelected[idTipoItem - 1]) {
                            context.log("Procesando ítems del tipo: " + idTipoItem);
                            strQry = "SELECT idItem, nombreItem, precio, cantidadDisponible FROM item WHERE cantidadDisponible > 0 AND idTipo = ?";
                            statement = connection.prepareStatement(strQry);
                            statement.setInt(1, idTipoItem);
                            ResultSet resultadosItemsDisp = statement.executeQuery();

                            while (resultadosItemsDisp.next()) {
                                context.log("Ítem disponible encontrado: ID " + resultadosItemsDisp.getString("idItem"));

                                // Realizar cálculos adicionales aquí...
                                int cantidadDeseada = Integer.parseInt(request.getParameter(resultadosItemsDisp.getString("idItem")));
                                if (cantidadDeseada > 0) {
                                    String[] itemSeleccionado = new String[2];
                                    itemSeleccionado[0] = resultadosItemsDisp.getString("idItem");
                                    itemSeleccionado[1] = String.valueOf(cantidadDeseada);
                                    ListaSeleccionado.add(itemSeleccionado);
                                    precio += resultadosItemsDisp.getInt("precio") * cantidadDeseada;
                                    itemsApagados = false;
                                }
                            }
                        }
                    }

                    if (!itemsApagados) {
                        context.log("Insertando nueva renta en la base de datos...");
                        strQry = "INSERT INTO renta (fecha, hora, precio, idDireccion, idCliente) VALUES (?, ?, ?, ?, ?)";
                        statement = connection.prepareStatement(strQry);
                        statement.setString(1, fecha0hora1[0]);
                        statement.setString(2, fecha0hora1[1]);
                        statement.setInt(3, precio);
                        statement.setString(4, direccion);
                        statement.setString(5, usuarioID);
                        statement.executeUpdate();
                        context.log("Renta insertada exitosamente.");
                        response.sendRedirect(request.getContextPath() + "/clientes/misRentas.jsp");
                    }
                } else {
                    context.log("Todos los ítems están apagados. Redirigiendo a iniciarPedido.jsp.");
                    response.sendRedirect(request.getContextPath() + "/clientes/iniciarPedido.jsp");
                }
            }
        } catch (SQLException sqlex){
            new Connectorizer().logSQLException(context, sqlex);
        }catch (Exception ex) {
            context.log("Ocurrió un error: " + ex.getMessage());
            new Connectorizer().logException(context, ex);
            out.println(ex.getMessage());
        } finally {
            if (connection != null) {
                try {
                    connection.close();
                    context.log("Conexión a la base de datos cerrada.");
                } catch (SQLException ex) {
                    context.log("Error al cerrar la conexión: " + ex.getMessage());
                }
            }
        }
        %>
</head>
<body>
    <div class="main">
        <div class="bloque">

            <h3>🗣 no la metiste bue</h3>
            <a href="index.html"><p>Ingresa aquí para insertar otro registro</p></a>                  
            <a href="newjsp.jsp"><p>Ingresa aquí para hacer una consulta</p></a>   

        </div>
    </div>

</body>
</html>
