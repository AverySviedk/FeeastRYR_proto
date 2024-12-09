<%-- 
    Document   : login
    Created on : 8 dic. 2024, 15:23:41
    Author     : Inspiron 7380
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
    <!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Login Page</title>
        <link rel="stylesheet" href="style.css">
      <%String side = String.valueOf(request.getParameter("side"));
        String errMsj = String.valueOf(request.getParameter("errMsj"));
        side = (side.equals("null")) ? "" : side;
        errMsj = (errMsj.equals("null")) ? "" : errMsj;%>
    </head>
    <body>
        <div class="container">
            <div class="container-form">
                <form class="sign-in" action="/admonFeeast/clientManager?modo=logIn" method="POST">
                    <h2>Iniciar Sesión</h2>
                    <div class="social-networks">
                        <ion-icon name="logo-google"></ion-icon>
                    </div>
                    <span>Use su nombre de usuario y contraseña</span>
                    <div class="container-input">
                        <ion-icon name="person-outline"></ion-icon>
                        <input type="text" name="username" placeholder="Nombre de usuario" required>
                    </div>
                    <div class="container-input">
                        <ion-icon name="lock-closed-outline"></ion-icon>
                        <input type="password" name="password" placeholder="Contraseña" required>
                    </div>
                    <a href="#">¿Olvidaste tu contraseña?</a>
                    <div name="logMsjErr" hidden>
                        <p name="logMsjContent" hidden></p>
                    </div>
                    <button class="button" type="submit">INICIAR SESIÓN</button>
                </form>
            </div>

             <script>
                let logMsjErr = document.getElementsByName('logMsjErr')[0];
                let logMsjContent = document.getElementsByName('logMsjContent')[0];
                if ("<%=side%>" === "Log"){
                    console.log("<%=side%>" + "<%=errMsj%>");
                    logMsjErr.hidden = false;
                    logMsjContent.hidden = false;
                    logMsjContent.textContent = "<%=errMsj%>";
                    logMsjContent.style.color = "red";
                }
            </script>

            <div class="container-form">
                <form class="sign-up" name="signForm" action="/admonFeeast/clientManager?modo=signIn" method="POST">
                    <h2>Registrarse</h2>
                    <div class="social-networks">
                        <ion-icon name="logo-google"></ion-icon>
                    </div>
                    <span>Use su correo electrónico para registrarse</span>
                    <div class="container-input">
                        <ion-icon name="person-outline"></ion-icon>
                        <input type="text" name="nombre" placeholder="Nombre" required>
                    </div>
                    <div class="container-input">
                        <ion-icon name="person-outline"></ion-icon>
                        <input type="text" name="username" placeholder="Usuario" required>
                    </div>
                    <div class="container-input">
                        <ion-icon name="mail-outline"></ion-icon>
                        <input type="email" name="email" placeholder="Email" required>
                    </div>
                    <div class="container-input">
                        <ion-icon name="person-outline"></ion-icon>
                        <input type="text" name="curp" placeholder="CURP" required>
                    </div>
                    <div class="container-input">
                        <ion-icon name="lock-closed-outline"></ion-icon>
                        <input type="password" name="password" placeholder="Password" required>
                    </div>
                    <div name="signErr" hidden>
                        <p name="signContent" hidden></p>
                    </div>
                    <button class="button">REGISTRARSE</button>
                </form>
            </div>

            <script>
                let signErr = document.getElementsByName('signErr')[0];
                let signContent = document.getElementsByName('signContent')[0];
                if ("<%=side%>" === "Sign"){
                    console.log("<%=side%>" + "<%=errMsj%>");
                    logMsjErr.hidden = false;
                    logMsjContent.hidden = false;
                    logMsjContent.textContent = <%=errMsj%>;
                    logMsjContent.style.color = "red";
                }
            </script>

            <div class="container-welcome">
                <div class="welcome-sign-up welcome">
                    <h3>¡Bienvenido!</h3>
                    <p>Ingrese sus datos personales para usar todas las funciones del sitio</p>
                    <button class="button" id="btn-sign-up">Registrarse</button>
                </div>
                <div class="welcome-sign-in welcome">
                    <h3>¡Hola!</h3>
                    <p>Regístrese con sus datos personales para usar todas las funciones del sitio</p>
                    <button class="button" id="btn-sign-in">Iniciar Sesión</button>
                </div>
            </div>
        </div>
        <script>
            const logUser = document.getElementsByName('username')[0];
            logUser.addEventListener('invalid', (event) => {
                event.target.setCustomValidity('Ingresa tu nombre.');
            });
            logUser.addEventListener('input', (event) => {
                event.target.setCustomValidity('');
            });
            const logPwrd = document.getElementsByName('password')[0];
            logPwrd.addEventListener('invalid', (event) => {
                event.target.setCustomValidity('Ingresa tu contraseña');
            });
            logPwrd.addEventListener('input', (event) => {
                event.target.setCustomValidity('');
            });
            const singNombre = document.getElementsByName('nombre')[0];
            singNombre.addEventListener('invalid', (event) => {
                event.target.setCustomValidity('Dinos tu nombre.');
            });
            singNombre.addEventListener('input', (event) => {
                event.target.setCustomValidity('');
            });
            const signUser = document.getElementsByName('username')[1];
            signUser.addEventListener('invalid', (event) => {
                event.target.setCustomValidity('Dinos tu apodo.');
            });
            signUser.addEventListener('input', (event) => {
                event.target.setCustomValidity('');
            });
            const signEmail = document.getElementsByName('email')[0];
            signEmail.addEventListener('invalid', (event) => {
                event.target.setCustomValidity('Formato de mail no reconocido.');
            });
            signEmail.addEventListener('input', (event) => {
                event.target.setCustomValidity('');
            });
            const signCurp = document.getElementsByName('curp')[0];
            const signPwrd = document.getElementsByName('password')[1];
            const signForm = document.getElementsByName('signForm')[0];
            signForm.addEventListener('submit', (event) => {
                if (!/^[A-Z0-9]{18}$/.test(signCurp.value)){
                    event.preventDefault();
                }
                if (signPwrd.value.length < 8){
                    event.preventDefault();
                }
            });
        </script>

        <script src="script.js"></script>
        <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
        <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
    </body>
</html>

