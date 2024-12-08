/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package sourcer;
import java.sql.*;
import javax.servlet.ServletContext;
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
    
    public void logException(ServletContext context, Exception e) {
        context.log("-!- Traza de excepcion: . . . " + e.getMessage());

        for (StackTraceElement element : e.getStackTrace()) {
            context.log(": - " + element.getLineNumber() +  
                         " | " + element.getFileName()   + 
                         " | " + element.getMethodName() + 
                         " | " + element.getClassName()  + 
                         "  --  - -   -");
        }
        context.log("-!- Excepcion: " + e.getMessage() + "  ----  ---  --  --  -    -    -     -");
    }

    public void logSQLException(ServletContext context, SQLException sqlEx) {
        context.log("-!- Traza de excepcion SQL: . . . " + sqlEx.getMessage());

        for (StackTraceElement element : sqlEx.getStackTrace()) {
            context.log(": - " + element.getLineNumber() +
                        " | " + element.getFileName() +
                        " | " + element.getMethodName() +
                        " | " + element.getClassName() + 
                        "  --  - -   -");
        }

        // Manejar excepciones anidadas en la cadena de SQLExceptions
        SQLException nextException = sqlEx.getNextException();
        while (nextException != null) {
            context.log("-- Sub SQLException: " + nextException.getMessage() + 
                        " -- Codigo -- " + nextException.getErrorCode() + 
                        " -- Estado: --" + nextException.getSQLState() + "  ---  - -   -   -" );
            nextException = nextException.getNextException();
        }
        
        context.log("-!- SQLException: " + sqlEx.getMessage() + 
                    " -- Codigo -- " + sqlEx.getErrorCode() + 
                    " -- Estado: --" + sqlEx.getSQLState() + "  ----  ---  --  --  -    -    -     -");
        
    }

    
}
