/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlets;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.sql.*;
import javax.servlet.ServletContext;
import sourcer.Connectorizer;

/**
 *
 * @author Inspiron 7380
 */
public class clientManager extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet clientManager</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet clientManager at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
    

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //processRequest(request, response);
        String modo = request.getParameter("modo");
                
        if (modo.equals("logIn")){
            logIn(request, response);
        }else if (modo.equals("signIn")){
            signIn(request, response);
        }
    }
    
    private boolean existingName(ServletContext context, String username){
        Connection connection = null;

        try {
            Connectorizer connect = new Connectorizer();
            connection = connect.conectar();

            String sql = "SELECT CASE WHEN (SELECT count(*) FROM cliente WHERE username = ?) > 0 " +
                                "THEN 'true' ELSE 'false' END AS existe"; 
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, username);
            ResultSet resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                return Boolean.parseBoolean(resultSet.getObject(1).toString()) ; 
            }
        } catch(SQLException sqlex){
            new Connectorizer().logSQLException(context, sqlex);
        } catch (Exception e) {
            new Connectorizer().logException(context, e);
        } finally {
            if (connection != null) {
                try {
                    connection.close(); // Cerrar la conexión
                } catch (SQLException ex) {
                    new Connectorizer().logException(context, ex);
                }
            }
        }
        return true;
    }
    
    private void signIn(HttpServletRequest request, HttpServletResponse response){
        ServletContext context = request.getServletContext();
        String nombre = request.getParameter("nombre");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String curp = request.getParameter("curp");
        String password = request.getParameter("password");
        
        boolean nameExists = existingName(context, username);
        if (nameExists){
            try {
                response.sendRedirect("login.html?side=Sign&found=" + String.valueOf(nameExists)); 
            }catch (Exception e){
                new Connectorizer().logException(context, e);
            }finally {
                return;
            }
        }
        
        HttpSession session = request.getSession();
        Connection connection = null;
        
        try {
            Connectorizer connect = new Connectorizer();
            connection = connect.conectar();

            String sql = "insert into cliente (username, nombreCliente, CURP, correo, password) " +
                                "values (?, ?, ?, ?, ?);"; //"SELECT * FROM cliente WHERE correo = ? AND password = ?";
            
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, username);
            statement.setString(2, nombre);
            statement.setString(3, curp);
            statement.setString(4, email);
            statement.setString(5, password);
            int istCount = statement.executeUpdate();

            if (istCount > 0) {
                session.setAttribute("username", username);
                session.setAttribute("password", password);
                
                logIn(request, response);
            } else {
                response.sendRedirect("failedProccess?severity=done&msj=Registro%20de%20datos%20sin%20efecto"); // Redirigir a error
            }
        } catch(SQLException sqlex){
            new Connectorizer().logSQLException(context, sqlex);
        } catch (Exception e) {
            new Connectorizer().logException(context, e);
        } finally {
            if (connection != null) {
                try {
                    connection.close(); // Cerrar la conexión
                } catch (SQLException ex) {
                    new Connectorizer().logException(context, ex);
                }
            }
        }
    }

    private void logIn(HttpServletRequest request, HttpServletResponse response){
        ServletContext context = request.getServletContext();
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        HttpSession session = request.getSession();
        Connection connection = null;

        try {
            Connectorizer connect = new Connectorizer();
            connection = connect.conectar();

            String sql = "SELECT idCliente FROM cliente WHERE username = ? AND password = ?"; //"SELECT * FROM cliente WHERE correo = ? AND password = ?";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, username);
            statement.setString(2, password);
            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                String idClient = String.valueOf(resultSet.getObject(1));
                session.setAttribute("userId", idClient);
                session.setAttribute("username", username);
                session.setAttribute("password", password);
                                
                // Verificar si el usuario es admin
                if (idClient.equals("1")) {
                    response.sendRedirect("admin/rentasAdmin.jsp"); // Redirigir a admin
                } else {
                    response.sendRedirect("clientes/misRentas.jsp"); // Redirigir a usuario normal
                }
            } else {
                response.sendRedirect("login.html?side=Log&found=" + String.valueOf(existingName(context, username))); 
            }
        } catch(SQLException sqlex){
            new Connectorizer().logSQLException(context, sqlex);
        } catch (Exception e) {
            new Connectorizer().logException(context, e);
        } finally {
            if (connection != null) {
                try {
                    connection.close(); // Cerrar la conexión
                } catch (SQLException ex) {
                    new Connectorizer().logException(context, ex);
                }
            }
        }
    }
    
    
    
    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
