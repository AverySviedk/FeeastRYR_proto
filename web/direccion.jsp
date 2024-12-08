<%@ page import="java.util.ArrayList"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="sourcer.Connectorizer" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page pageEncoding="utf-8" contentType="text/html" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Continuar</title>
        <link rel="stylesheet" href="stilloo.css">
    </head>
    <body>
        <%
            boolean isPost = request.getMethod().equals("POST");
            String username = (session != null) ? (String) session.getAttribute("username") : null;
            String error = "";
            if (username == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            String pagRetorno = (String) request.getAttribute("pagAnt");
            System.out.println(pagRetorno);
            if (isPost) {
                String pagAnt = request.getParameter("pagAnt");

                if ("agregar_direccion".equals(pagAnt)) {
                    pagRetorno = "seleccionar_fecha";
                }else{
                    if("seleccionar_fecha".equals(pagAnt)){
                        pagRetorno = "seleccionar_fecha";
                    }
                    
                    String idCliente = session.getAttribute("userId").toString();
                    String direccion = request.getParameter("direccion");
                    String ciudad = request.getParameter("ciudad");
                    String estado = request.getParameter("estado");
                    String codigoPostal = request.getParameter("codigo_postal");
                    
                    if (!direccion.isEmpty()) {
                        if (direccion.length() > 512) {
                            error = "La direccion solo puede tener menos de 512 caracteres";
                        }
                    } else {
                        error = "Llene todos los campos";
                    }

                    if (!ciudad.isEmpty()) {
                        if (ciudad.length() > 200) {
                            error = "La ciudad solo puede tener menos de 200 caracteres";
                        }
                    } else {
                        error = "Llene todos los campos";
                    }

                    if (!estado.isEmpty()) {
                        if (estado.length() > 100) {
                            error = "El estado solo puede tener menos de 100 caracteres";
                        }
                    } else {
                        error = "Llene todos los campos";
                    }

                    if (!codigoPostal.isEmpty()) {
                        if (codigoPostal.length() != 5) {
                            error = "El codigo postal solo puede tener 5 caracteres";
                        }
                    } else {
                        error = "Llene todos los campos";
                    }

                    if (error.isEmpty()) {
                        Connectorizer connect = new Connectorizer();
                        Connection connection = connect.conectar();
                        try {
                            PreparedStatement statement;

                            statement = connection.prepareStatement("INSERT INTO `Direccion` (direccion, ciudad, estado, codigoPostal, idCliente) VALUES (?, ?, ?, ?, ?)");
                            statement.setString(1, direccion);
                            statement.setString(2, ciudad);
                            statement.setString(3, estado);
                            statement.setString(4, codigoPostal);
                            statement.setString(5, idCliente);
                            statement.executeUpdate();
                            System.out.println("Direccion registrada");

                            if ("seleccionar_fecha".equals(pagAnt)) {
                                request.setAttribute("pagAnt", "direccion");
                                RequestDispatcher dispatcher = request.getRequestDispatcher("seleccionar_fecha.jsp");
                                dispatcher.forward(request, response);
                            } else {
                                response.sendRedirect("bienvenida.jsp");
                            }
                        } catch (SQLException e) {
                            e.printStackTrace();
                            error = "Error interno del servidor";
                        }
                    }
                }
            }
        %>
        <div class="loading show">
            <div class="spin"></div>
        </div>


        <script>
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
                <p1>Introduce la dirección del envío</p1>
            </header>
        </div>
        <form action="direccion.jsp" method="POST">
            <%
                if (!error.isEmpty()) {
                    out.print("<p>" + error + "</p>");
                }
                if (pagRetorno != null) {
                    out.print("<input type=\"hidden\" id=\"pagAnt\" name=\"pagAnt\" value=\"" + pagRetorno + "\">");
                }

            %>
            <label for="direccion">Dirección:</label>

            <input type="text" id="direccion" name="direccion" required>

            <label for="ciudad">Ciudad:</label>

            <input type="text" id="ciudad" name="ciudad" required>

            <label for="estado">Estado:</label>

            <input type="text" id="estado" name="estado" required>

            <label for="codigo_postal">Código Postal:</label>

            <input type="text" id="codigo_postal" name="codigo_postal" required>

            <div class="boton-enviar">    
                <button type="submit">Enviar</button>
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
        </footer>
    </body>
</html>
