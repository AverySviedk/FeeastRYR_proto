/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;
import sourcer.Connectorizer;
/**
 *
 * @author Inspiron 7380
 */

//@WebServlet("/statusChanger")
public class statusChanger extends HttpServlet {

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
            out.println("<title>Servlet statusChanger</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet statusChanger at " + request.getContextPath() + "</h1>");
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
            throws ServletException, IOException {//processRequest(request, response);
        String modo = request.getParameter("modo");
        
        if (modo.equals("updEstado")){       //CAMBIA ESTADO DE RENTA
            updateEstado(request, response);
        }else if (modo.equals("updComt")){   //ENVIA UN COMENTARIO
            updateComent(request, response);
        }else if (modo.equals("delRenta")){  //ELIMINA UNA RENTA
            deleteRenta(request, response);
        }else if (modo.equals("instItemType")){ //INSERTA NUEVO TIPO ITEM
            insertTipoItem(request, response);
        }else if (modo.equals("delItem")){   //ELIMINA UN ITEM
            deleteItem(request, response);
        }else if (modo.equals("setCompen")){ //DEFINE UNA COMPENSACION
            setCompensacion(request, response);
        }else if (modo.equals("signOut")){   //ELIMINA LA SECION
            signOut(request, response);
        }
    }
    
    private void setCompensacion(HttpServletRequest request, HttpServletResponse response){
        ServletContext context = request.getServletContext();
        Connection connection = null;
        String idRenta = request.getParameter("idRenta");
        String cantComp = request.getParameter("cantComp");

        try {
            Connectorizer connect = new Connectorizer();
            connection = connect.conectar();

            //String sql = "SELECT * FROM cliente WHERE correo = ? AND password = ?";
            String sql = "UPDATE renta SET compensacion = ? WHERE idRenta = ?";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, Integer.parseInt(cantComp));  // Asignar el valor deseado para "compensacion"
            statement.setInt(2, Integer.parseInt(idRenta));  // Asignar el idRenta (en este caso, 1)
            int rowsUpdated = statement.executeUpdate();
            
            response.sendRedirect(request.getContextPath() + "/admin/rentasAdmin.jsp");
            
        } catch (Exception e) {
            new Connectorizer().logException(context, e);
        } finally {
            if (connection != null) {
                try {
                    connection.close(); // Cerrar la conexión
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
    }
    
    private void signOut(HttpServletRequest request, HttpServletResponse response){
        ServletContext context = request.getServletContext();
        HttpSession session = request.getSession(false);
        session.invalidate();
        try{
            response.sendRedirect(request.getContextPath() + "/index.html");
        }catch(Exception e) {
            new Connectorizer().logException(context, e);
        }
    }
    
    private void deleteItem(HttpServletRequest request, HttpServletResponse response){
        ServletContext context = request.getServletContext();
        Connection connection = null;
        String idItem = request.getParameter("idItem");
        
        try {
            Connectorizer connect = new Connectorizer();
            connection = connect.conectar();

            String sql = "DELETE FROM item WHERE idItem = ?"; 
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, Integer.parseInt(idItem));
            int rowsUpdated = statement.executeUpdate();
            
            response.sendRedirect(request.getContextPath() + "/admin/seleccionItems.jsp");
        } catch (Exception e) {
            new Connectorizer().logException(context, e);
        } finally {
            if (connection != null) {
                try {
                    connection.close(); // Cerrar la conexión
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
    }
    
    private void insertTipoItem(HttpServletRequest request, HttpServletResponse response){
        ServletContext context = request.getServletContext();
        Connection connection = null;
        String nombreTipo = request.getParameter("nombreTipo");

        try {
            Connectorizer connect = new Connectorizer();
            connection = connect.conectar();

            String sql = "INSERT INTO tipoitem (nombre) VALUES ( ? )"; 
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, nombreTipo);
            int rowsUpdated = statement.executeUpdate();
            
            //insertItem(request, response);
            response.sendRedirect(request.getContextPath() + "/admin/registroItem.jsp");
        } catch (Exception e) {
            new Connectorizer().logException(context, e);
        } finally {
            if (connection != null) {
                try {
                    connection.close(); // Cerrar la conexión
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
    }
    
    private void deleteRenta(HttpServletRequest request, HttpServletResponse response){
        ServletContext context = request.getServletContext();
        Connection connection = null;
        String idRenta = request.getParameter("idRenta");
        String idClient = request.getParameter("idUsr");
        
        try {
            Connectorizer connect = new Connectorizer();
            connection = connect.conectar();

            String sql = "DELETE FROM renta WHERE idRenta = ? " +
                                "AND idRenta IN (SELECT idRenta FROM (  " +
                                                    "SELECT idRenta  FROM renta  " +
                                                    "WHERE (Estado = 'Pendiente' OR Estado = 'Aceptado')  " +
                                                    "AND idCliente = ? AND idRenta = ?  " +
                                                    ") AS subquery  " +
                                                ")"; // and hora < time('9:00:00')
						//or ( fecha = current_date() and time('9:00:00') > current_time())
            
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, Integer.parseInt(idRenta));  // Asignar el idRenta (en este caso, 1)
            statement.setString(2, idClient);
            statement.setInt(3, Integer.parseInt(idRenta));
            int rowsUpdated = statement.executeUpdate();
            
            response.sendRedirect(request.getContextPath() + "/clientes/misRentas.jsp");
        } catch (Exception e) {
            new Connectorizer().logException(context, e);
        } finally {
            if (connection != null) {
                try {
                    connection.close(); // Cerrar la conexión
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
    }
    
    private void updateEstado(HttpServletRequest request, HttpServletResponse response){
        ServletContext context = request.getServletContext();
        Connection connection = null;
        String idRenta = request.getParameter("idRenta");
        String cambio = request.getParameter("cambio");

        try {
            Connectorizer connect = new Connectorizer();
            connection = connect.conectar();

            //String sql = "SELECT * FROM cliente WHERE correo = ? AND password = ?";
            String sql = "UPDATE renta SET estado = ? WHERE idRenta = ?";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, cambio);  // Asignar el valor deseado para "estado"
            statement.setInt(2, Integer.parseInt(idRenta));  // Asignar el idRenta (en este caso, 1)
            int rowsUpdated = statement.executeUpdate();
            
            if (cambio.equals("Rechazado")){
                response.sendRedirect(request.getContextPath() + "/admin/historialAdmin.jsp?idRenta=" + idRenta);
            }else{
                response.sendRedirect(request.getContextPath() + "/admin/rentasAdmin.jsp");
            }
        } catch (Exception e) {
            new Connectorizer().logException(context, e);
        } finally {
            if (connection != null) {
                try {
                    connection.close(); // Cerrar la conexión
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
    }
    
    private void updateComent(HttpServletRequest request, HttpServletResponse response){
        ServletContext context = request.getServletContext();
        Connection connection = null;
        String idRenta = request.getParameter("idRenta");
        String comentario = request.getParameter("comentario");
        
        try {
            Connectorizer connect = new Connectorizer();
            connection = connect.conectar();

            //String sql = "SELECT * FROM cliente WHERE correo = ? AND password = ?";
            String sql = "UPDATE renta SET comentario = ? WHERE idRenta = ?";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, comentario);  // Asignar el valor deseado para "estado"
            statement.setInt(2, Integer.parseInt(idRenta));  // Asignar el idRenta (en este caso, 1)
            int rowsUpdated = statement.executeUpdate();
            
            response.sendRedirect(request.getContextPath() + "/admin/historialAdmin.jsp");
        } catch (Exception e) {
            new Connectorizer().logException(context, e);
        } finally {
            if (connection != null) {
                try {
                    connection.close(); // Cerrar la conexión
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
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
        if (modo.equals("instItem")){ // INSERTA NUEVO ITEM
            insertItem(request, response);
        }
    }
    
    private void insertItem(HttpServletRequest request, HttpServletResponse response){
        System.out.println("ENTRAMOS");
        String dimenItem = request.getParameter("dimenItem");
        boolean dimenOrNot = Boolean.parseBoolean(dimenItem);
        
        String nombreItem = request.getParameter("nombreItem");
        String ancho = request.getParameter("ancho");
        String alto = request.getParameter("alto");
        String largo = request.getParameter("largo");
        String precio = request.getParameter("precio");
        String cantidadDisponible = request.getParameter("cantidadDisponible");
        String cantidadTotal = request.getParameter("cantidadTotal");
        String idTipo = request.getParameter("idTipo");
        
        Connection connection = null;
        int rowsUpdated = 0;
        try {
            Connectorizer connect = new Connectorizer();
            connection = connect.conectar();
            if (dimenOrNot){
                System.out.println("COMPLEX");
                String sql = "INSERT INTO item (nombreItem, ancho, alto, largo, precio, cantidadDisponible, cantidadTotal, idTipo) " +
                                    "VALUES ( ?, ?, ?, ?, ?, ?, ?, ? )"; 
                PreparedStatement statement = connection.prepareStatement(sql);
                statement.setString(1, nombreItem);
                statement.setFloat(2, Float.parseFloat(ancho));
                statement.setFloat(3, Float.parseFloat(alto));
                statement.setFloat(4, Float.parseFloat(largo));
                statement.setBigDecimal(5, new BigDecimal(precio));
                statement.setInt(6, Integer.parseInt(cantidadDisponible));
                statement.setInt(7, Integer.parseInt(cantidadTotal));
                statement.setInt(8, Integer.parseInt(idTipo));
                rowsUpdated = statement.executeUpdate();
            }else{
                System.out.println("SIMPLE");
                String sql = "INSERT INTO item (nombreItem, precio, cantidadDisponible, cantidadTotal, idTipo) " +
                                    "VALUES ( ?, ?, ?, ?, ? )"; 
                PreparedStatement statement = connection.prepareStatement(sql);
                statement.setString(1, nombreItem);
                statement.setBigDecimal(2, new BigDecimal(precio));
                statement.setInt(3, Integer.parseInt(cantidadDisponible));
                statement.setInt(4, Integer.parseInt(cantidadTotal));
                statement.setInt(5, Integer.parseInt(idTipo));
                rowsUpdated = statement.executeUpdate();
            }
            if (rowsUpdated > 0){
                response.sendRedirect(request.getContextPath() + "/admin/rentasAdmin.jsp");
            }else{
                System.out.println( nombreItem + ancho + alto + largo + precio + cantidadDisponible + cantidadTotal + idTipo);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (connection != null) {
                try {
                    connection.close(); // Cerrar la conexión
                } catch (SQLException ex) {
                    ex.printStackTrace();
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
