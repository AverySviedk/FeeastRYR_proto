/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package sourcer;
import java.sql.*;
/**
 *
 * @author Inspiron 7380
 */
public class Connectorizer {
    Connection cnx = null;
    
    public Connection conectar (){
        try{
            Class.forName("com.mysql.cj.jdbc.Driver");
            cnx = DriverManager.getConnection("jdbc:mysql://localhost:3306/"
                + "feeast?autoReconnect=true&useSSL=false", 
                        "root", 
                        //"n0m3l0");
                        "Furr0_L0v3r_37");
        }catch(ClassNotFoundException | SQLException error){
            System.err.print(error.toString());
        }
        return cnx;
    }
}
