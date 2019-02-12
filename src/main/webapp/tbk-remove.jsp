<%@page import="com.transbank.webpayserver.webservices.OneClickPayOutput"%>
<%@page import="com.transbank.webpayserver.webservices.OneClickFinishInscriptionOutput"%>
<%@page import="com.transbank.webpayserver.webservices.OneClickInscriptionOutput"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="java.util.Random"%>
<%@page import="cl.transbank.webpay.configuration.Configuration"%>
<%@page import="java.util.ListIterator"%>
<%@page import="java.lang.reflect.Field"%>
<%@page import="java.util.ArrayList"%>
<%@page import="cl.transbank.webpay.Webpay"%>
<%@page import="cl.transbank.webpay.security.SoapSignature"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <style>
        table, th, td {
		  border: 1px solid black;
		}
        </style>
    </head>
    <h1>Cancelar Transaccion OneClick </h1>
    
       <%

     String action = request.getParameter("action");  
      
        
     /* La configuracion se debe cambiar por la entregada al comercio y seteada en el punto mas arriba*/
     Webpay webpay = new Webpay(Configuration.forTestingWebpayOneClickNormal());
              
      
     String tbkUser = "";   
	
     if (action.equalsIgnoreCase("OneClickRemoveUser")) {
          
            Boolean result;
  			String username = "";
            try{
                username = request.getParameter("USERNAME");   
                tbkUser = request.getParameter("TBK_USER");                
                result = webpay.getOneClickTransaction().removeUser(tbkUser, username);  
            %>
                
                
            <h2>Usuario eliminado (tarjeta)</h2>

            <div style="background-color:lightyellow;">
                   
          	 <script>
          	 console.log('usuario = <%=username%> ');        
             console.log('tbkUser = <%=tbkUser%> ');    
             console.log('respuesta = <%=result%> ');
             </script>
             
                           
            </div>       
                    <%if(!result){%>                     
            <p><samp>Operacion RECHAZADA por webpay </samp></p>
                    <%}else{%> 
            <p><samp>Operacion ACEPTADA por webpay </samp></p>
                    <% }%>            
          <br>
            <br>
            <a href=".">&laquo; volver a index</a>
            
          <%   
            }catch(Exception e){
                System.out.println("ERROR: " + e);
               %>
               <p><samp>Error: <%out.print(e.toString().replace("<", ""));%></samp></p><br>
               <a href=".">&laquo; volver a index</a>
               <%
            }  
        }
               
   %>
                