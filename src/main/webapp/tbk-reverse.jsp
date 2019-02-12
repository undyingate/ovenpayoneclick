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
	
     if (action.equalsIgnoreCase("OneClickReverseTransaction")) {
          
    	    String username = ""; 
            String buyOrder = ""; 
            Boolean result = false;
            String token = ""; 
            
            Long buyOrderLong;
            BigDecimal amount = BigDecimal.valueOf(24300);
            Random rn = new Random();                        
            String urlNextStep = request.getRequestURL().toString()+"?action=OneClickRemoveUser";

                    
            try{
            	username = request.getParameter("usuario"); 
                token = request.getParameter("TBK_TOKEN");   
                buyOrder = request.getParameter("buyOrder");   
                buyOrderLong = Long.parseLong(buyOrder);
                tbkUser = request.getParameter("TBK_USER");  
                                
                %>
                <script>
                console.log("<%=buyOrder%>");
                </script>
                <%
                
                result = webpay.getOneClickTransaction().reverseTransaction(buyOrderLong);
                
                System.out.println("Result Authorize " + result);            
                
                %>
                
                
            <h2>Reverse Transaction</h2>
          
            <div style="background-color:lightgrey;">
                    <h3>result</h3>
                    <%                                        
                     out.print("[response] = "+result);                                        
                    %> 
             <script>          	 
             console.log('respuesta = <%=result%> ');
             </script>
                                                        
            </div>
                    <%if(!result){%>                     
            <p><samp>Operacion RECHAZADA por webpay </samp></p>
                    <%}else{%> 
            <p><samp>Operacion ACEPTADA por webpay </samp></p>
                    <% }%>         
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
                