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
        <link rel="stylesheet" href="stilloo.css">
    </head>
    <body>
        <%
            request.setAttribute("pagAnt", "seleccionar_fecha");
            RequestDispatcher dispatcher = request.getRequestDispatcher("direccion.jsp");
            String pagAnt = (String) request.getAttribute("pagAnt");
            ArrayList<Direccion> direcciones = new ArrayList();
            boolean isPost = request.getMethod().equals("POST");
            String username = (session != null) ? (String) session.getAttribute("username") : null;
            String error = "";
            if (username == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            Connectorizer connect = new Connectorizer();
            Connection connection = connect.conectar();
            try {
                
                PreparedStatement statement;

                statement = connection.prepareStatement("SELECT `idDireccion`, `direccion` from `Direccion` WHERE idCliente = ?");
                statement.setString(1, session.getAttribute("userId").toString());
                ResultSet rs = statement.executeQuery();
                while(rs.next()){
                    direcciones.add(new Direccion(rs.getString("idDireccion"), rs.getString("direccion")));
                }
                if(direcciones.isEmpty()){
                    dispatcher.forward(request, response);
                }
            } catch (SQLException e) {
                e.printStackTrace();
                error = "Error interno del servidor";
            }

        %>
        <div class="loading show">
            <div class="spin"></div>
        </div>


        <script>
            
            function redirigirConFormulario() {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = "http://localhost:8080/RyR/direccion.jsp";

                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = "pagAnt";
                input.value = "agregar_direccion";
                form.appendChild(input);

                document.body.appendChild(form);
                form.submit();
            }
            
            var Loading = (loadingDelayHidden = 0) => {
                let loading = null;
                const myLoadingDelayHidden = loadingDelayHidden;
                let imgs = [];
                let lenImgs = 0;
                let counterImgsLoading = 0;

                function incrementCounterImgs() {
                    counterImgsLoading += 1;
                    if (counterImgsLoading === lenImgs) {
                        hideLoading();
                    }
                }

                function hideLoading() {
                    if (loading !== null) {
                        loading.classList.remove('show');
                        setTimeout(() => {
                            loading.remove();
                        }, myLoadingDelayHidden);
                    }
                }

                function init() {
                    document.addEventListener('DOMContentLoaded', function () {
                        loading = document.querySelector('.loading');
                        imgs = Array.from(document.images);
                        lenImgs = imgs.length;

                        if (lenImgs === 0) {
                            hideLoading();
                        } else {
                            imgs.forEach(function (img) {
                                if (img.complete) {
                                    incrementCounterImgs(); // Contar imágenes que ya están cargadas
                                } else {
                                    img.addEventListener('load', incrementCounterImgs, false);
                                    img.addEventListener('error', incrementCounterImgs, false); // Manejar errores
                                }
                            });
                        }
                    });
                }

                return {'init': init};
            };

            function validarFecha() {
                let fechaSelect = document.getElementById("fechaPedido");
                let textoFecha = fechaSelect.value;
                let fechaActual = new Date();
                let fechaComparacion = new Date(textoFecha);
                let diaActual = fechaActual.getDate();
                let diaComparacion = fechaComparacion.getUTCDate();
                let mesActual = fechaActual.getMonth();
                let mesComparacion = fechaComparacion.getMonth();
                let anoActual = fechaActual.getFullYear();
                let anoComparacion = fechaComparacion.getFullYear();

                if (anoComparacion < anoActual) {
                    document.getElementById("botonEnviar").disabled = true;
                } else if (mesComparacion < mesActual) {
                    document.getElementById("botonEnviar").disabled = true;
                } else if (diaComparacion <= diaActual) {
                    document.getElementById("botonEnviar").disabled = true;
                } else {
                    document.getElementById("botonEnviar").disabled = false;
                }
            }

            Loading(1000).init();
        </script>
        <div class="container">
            <header class="hero">
                <nav class="nav">
                    <a href="#" class="nav__logo-link">
                        <img src="imgs/RyR.png" alt="Logo" class="logo">
                    </a>
                    <ul class="nav__list">
                        <li class="nav__item"><a href="bienvenida.jsp" class="nav__link">INICIO</a></li>
                        <li class="nav__item"><a href="#" class="nav__link">PEDIDOS</a></li>
                        <li class="nav__item"><a href="#" class="nav__link">DEVOLUCIONES</a></li>
                        <li class="nav__item"><a href="#" class="nav__link">CONTACTO</a></li>
                    </ul>
                    <a href="#" class="nav__icon"><img src="./imgs/icon-user.png" alt="User"></a>
                </nav>

                <h25>Para continuar, <strong><%= username%></strong>!</h25>
                <br>
                <p1>Introduce la fecha del envío</p1>
            </header>
        </div>
        <form action="rentas.jsp" method="POST">
            <%
                if (!error.isEmpty()) {
                    out.print("<p>" + error + "</p>");
                }
            %>
            <label for="direccion">Selecciona tu dirección</label>

            <%
                String select = "<select id=\"direccion\" name=\"direccion\" >";
                for(Direccion e : direcciones){
                    select += "<option value=\"" + e.getId() + "\">" + e.getDireccion() + "</option>";
                }
                select += "</select>";
                out.print(select);
            %>
            
            

            <label for="fechaPedido">Selecciona la fecha del evento</label>
            <input type="date" name="fechaPedido" id="fechaPedido" onchange="validarFecha()" required>
            <button type="button" id="botonAgregarDireccion" onclick="redirigirConFormulario()">Agregar direccion</button>
            <div class="boton-enviar">    
                <button type="submit" id="botonEnviar">Enviar</button>
            </div>
        </form>
        <br><!-- comment -->
        <br>
        <footer class="footer">
            <section class="footer__content">
                <div class="footer__main">
                    <a href="#" class="footer__logo-link">
                        <img src="imgs/RyR.svg" class="footer__logo">
                    </a>

                    <nav class="footer__links">
                        <a href="#" class="footer__link">Sobre Nosotros</a>
                        <a href="#" class="footer__link">Servicios</a>

                        <a class="footer__link_media">Nuestras Redes Sociales</a>
                    </nav>

                    <article class="footer__contact">
                        <h4 class="footer__copy">Contactanos:</h4>

                        <p class="footer__info">
                            Email: <a href="mailto:info@centrofiestas.com">ryr75125@gmail.com</a><br>

                        <p class="footer__info">
                            Telefono: 5513131414

                        <p class="footer__info">
                            Dirección: Agrupamiento J # 40, Narciso Bassols, 07980 Ciudad de México, CDMX

                        </p>
                    </article>

                    <form class="footer__newsletter">
                        <input type="email" placeholder="Email" class="footer__email">
                        <input type="submit" value="Suscribete " class="footer__submit">
                    </form>
                    <nav class="footer__social">

                        <a href="#" class="footer__social-links">
                            <img src="imgs/facebook.svg" class="footer__media">
                        </a>
                        <a href="#" class="footer__social-links">
                            <img src="imgs/twitter.svg" class="footer__media">
                        </a>
                    </nav>
                </div>
                <div class="footer__copyright">
                    <p class="footer__copyright-text">&copy; FEEAST - Derechos reservados.</p>
                </div>
            </section>
            <script>
                const select = document.getElementById('direccion');
                select.selectedIndex = select.options.length - 1;
            </script>
        </footer>
    </body>
</html>
