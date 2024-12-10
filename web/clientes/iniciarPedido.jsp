<%-- 
    Document   : iniciarPedido
    Created on : 8 dic. 2024, 08:21:46
    Author     : Inspiron 7380
--%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="sourcer.Connectorizer" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page pageEncoding="utf-8" contentType="text/html" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="sourcer.Direccion" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Continuar</title>
      <%String userId = String.valueOf(session.getAttribute("userId"));
        if (userId.equals("null")){
            response.sendRedirect(request.getContextPath() + "/notFound.jsp");
        }%>
    </head>
    <body>
        <h1>Indica Dirección y Fecha</h1> 
          <%
            Connection connection = null;
            PreparedStatement statement = null;
            ResultSet resultSet = null;
            try {
                Connectorizer connect = new Connectorizer();
                connection = connect.conectar();
                
                ServletContext context = request.getServletContext();
                context.log( "User ID: " + userId );

                String sql = "SELECT dc.idDireccion, CONCAT(direccion, ', ', ciudad, ', ', d.estado, '  C.P:', codigoPostal) AS Direccion " +
                                        "FROM direccion d INNER JOIN dir_cliente dc ON d.idDireccion = dc.idDireccion " +
                                        "                INNER JOIN Cliente c ON dc.idCliente = c.idCliente " +
                                        "WHERE dc.idCliente = ? ";
                statement = connection.prepareStatement(sql);
                statement.setString(1, userId);
                //ResultSet rs = statement.executeQuery();
                resultSet = statement.executeQuery();
        %>
        <form action="<%=request.getContextPath()%>/clientes/realizarRenta.jsp" method="POST" name="formDirDate">
            <label for="opcionesDireccion">Selecciona tu dirección</label>
            <select name="opcionesDireccion" onchange="writeDir()">
                <option value="" selected>Selecciona una direccion</option>
              <%while(resultSet.next()){%>
                    <option name="optDir" value="<%=resultSet.getObject(1).toString()%>"><%=resultSet.getObject(2).toString()%></option>
              <%}%>
                <option value="nuevaDireccion">Nueva Direccion</option>
            </select><br>
            <input type="text" name="direccion" placeholder="Dirección:" maxlength="250" hidden>
            <input type="text" name="ciudad" placeholder="Ciudad:" maxlength="120" hidden>
            <input type="text" name="estado" placeholder="Estado:" maxlength="20" hidden>
            <input type="number" name="codigoPostal" placeholder="Código Postal:" hidden>
            
            <input type="button" name="newDirec" value="Nueva Dirección" onclick="instCustomDir()" hidden>

            <script>  //INST CUSTOM DIR
                let dirSelected = document.getElementsByName('opcionesDireccion')[0];
                let dirDirecx = document.getElementsByName('direccion')[0];
                let dirCiudad = document.getElementsByName('ciudad')[0];
                let dirEstado = document.getElementsByName('estado')[0];
                let dirPostal = document.getElementsByName('codigoPostal')[0];
                
                let buttonCustomDirec = document.getElementsByName('newDirec')[0];
                function writeDir(){
                    if (dirSelected.value === "nuevaDireccion"){
                        buttonCustomDirec.hidden = false;
                        buttonCustomDirec.disabled = false;
                        dirDirecx.hidden = false;
                        dirCiudad.hidden = false;
                        dirEstado.hidden = false;
                        dirPostal.hidden = false;
                        dirDirecx.required = true;
                        dirCiudad.required = true;
                        dirEstado.required = true;
                        dirPostal.required = true;
                    }else if (buttonCustomDirec.hidden === false){
                        buttonCustomDirec.hidden = true;
                        buttonCustomDirec.disabled = true;
                        dirDirecx.value = "";
                        dirCiudad.value = "";
                        dirEstado.value = "";
                        dirPostal.value = "";
                        dirDirecx.hidden = true;
                        dirCiudad.hidden = true;
                        dirEstado.hidden = true;
                        dirPostal.hidden = true;
                        dirDirecx.required = false;
                        dirCiudad.required = false;
                        dirEstado.required = false;
                        dirPostal.required = false;
                    }
                }

                function instCustomDir(){
                    buttonCustomDirec.value = "Nueva Dirección";
                    let optDir = document.getElementsByName('optDir');
                    let isAlready = dirDirecx.value + ", " +  dirCiudad.value + ", " + dirEstado.value + "  C.P:" + dirPostal.value;
                    console.log(isAlready);
                    
                    ///let buttonNewItem = document.getElementsByName('newItem')[0];
                    
                    //console.log("estás dentro  > w<");
                    let coinciDir = false;
                    for (let ops of optDir){
                        if (ops.textContent === isAlready){
                            coinciDir = true;
                            console.log("Done uwU" + ops.textContent);
                        }
                        console.log("Salto U. U");
                        console.log(ops.textContent);
                        console.log(isAlready);
                    }
                    console.log(isAlready);
                    if (!/^[0-9]{5}$/.test(dirPostal.value)){
                        dirPostal.placeholder = " CP Inválido ";
                        dirPostal.value = "";
                        console.log (dirPostal.value);
                        console.log (!/^[0-9]{5}$/.test(dirPostal.value));
                        buttonCustomDirec.value = "Mal CP- Reintentar";
                        return;
                    }
                    if (dirEstado === "" || dirCiudad === "" || dirDirecx === "" || dirPostal){
                        buttonCustomDirec.value = "Falta Info- Reintentar";
                        return;
                    }
                    if (!coinciDir){ //(false){ //
                        console.log("Envviando formulario :3");
                        window.location.href = "<%=request.getContextPath()%>/statusChanger?" +  
                                                "modo=instCustDir" + 
                                                "&direccion=" + dirDirecx.value + 
                                                "&ciudad=" + dirCiudad.value + 
                                                "&estado=" + dirEstado.value + 
                                                "&cp=" + dirPostal.value;
                    }else{
                        dirDirecx.value = "";
                        dirCiudad.value = "";
                        dirEstado.value = "";
                        dirPostal.value = "";
                        dirDirecx.placeholder = " -!- Direccion ya registrada";
                        dirCiudad.placeholder = " Direccion";
                        dirEstado.placeholder = " ya";
                        dirPostal.placeholder = " registrada";
                        buttonCustomDirec.value = "Reintentar";
                        return;
                    }
                }
            </script>
            
            <br>
            <label for="fechaPedido">Selecciona la fecha del evento</label>
            <input type="datetime-local" name="fechaPedido" id="fechaPedido" onchange="validarFecha()" required>
            
            <div class="boton-enviar">    
                <button type="submit" name="submitDirDate" id="botonEnviar">Enviar</button>
            </div>
            
            <script>
                function validarFecha (){
                    let gotFecha = document.getElementById("fechaPedido");
                    let curDate = new Date();
                    let compDate = new Date(gotFecha.value);

                    let selectDate = document.getElementsByName("submitDirDate")[0];

                    // Compara directamente las fechas
                    if (compDate <= curDate) {
                        selectDate.disabled = true; // Fecha anterior o igual al día de hoy
                    } else {
                        selectDate.disabled = false; // Fecha válida (posterior a hoy)
                    }
                }
            </script>
            
        </form>
        <script>
            const cdPost = document.getElementsByName('codigoPostal')[0];
            const dirDateForm = document.getElementsByName('formDirDate')[0];

            dirDateForm.addEventListener('submit', (event) => {
                if (cdPost.hidden === false && /^[0-9]{5}$/.test(cdPost.value)){
                    event.preventDefault();
                    console.log("Entraste > w<");
                }else{
                    console.log("Nopi unu");
                }
            });
        </script>
          <%} catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (resultSet != null) try { resultSet.close(); } catch (SQLException ignore) {}
                if (statement != null) try { statement.close(); } catch (SQLException ignore) {}
                if (connection != null) try { connection.close(); } catch (SQLException ignore) {}
            } %>    
    </body>
</html>

