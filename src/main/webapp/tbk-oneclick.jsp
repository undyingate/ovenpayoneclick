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
    <h1>Transaccion OneClick</h1>
    
       <%
       /*Configuracion del comercio*/
       /*Configuration configuration = new Configuration();
       configuration.setCommerceCode((String)session.getAttribute("COMMERCE_CODE"));
       configuration.setPrivateKey((String)session.getAttribute("PRIVATE_KEY"));
       configuration.setPublicCert((String)session.getAttribute("PUBLIC_CERT"));
       configuration.setEnvironment("INTEGRACION");*/       
       
        String action = request.getParameter("action");  
        if(action == null)action="OneClickInitInscription";
        
        /* La configuracion se debe cambiar por la entregada al comercio y seteada en el punto mas arriba*/
        Webpay webpay = new Webpay(Configuration.forTestingWebpayOneClickNormal());
              
        String username = request.getParameter("usuario"); 
        String email = request.getParameter("email"); 
        String tbkUser = "";   
	
     	if (action.equalsIgnoreCase("OneClickInitInscription")) {
           
            OneClickInscriptionOutput result = new OneClickInscriptionOutput();
            String urlReturn = request.getRequestURL().toString()+"?action=OneClickFinishInscription";            
           
            /** Inscription */
            try{                                                       
                result = webpay.getOneClickTransaction().initInscription(username, email, urlReturn);               

            }catch(Exception e){
                System.out.println("ERROR: " + e);
               %>
               <p><samp>Error: <%out.print(e.toString().replace("<", ""));%></samp></p><br>
               <a href=".">&laquo; volver a index</a>
            <%}%>  
          
          	 <script>
          	 console.log('usuario = <%=username%> ');
             console.log('email = <%=email%>');
             console.log('Url = <%=result.getUrlWebpay()%> ');
             console.log('Token ws = <%=result.getToken()%>');
             </script>
             
             <%if(result.getToken()!=null){    %>
            	<h2>Inscripcion</h2>              
            
	            <p><spam>Sesion iniciada con exito en Webpay</spam></p>
	            
	            <br>
	            <form action='<%=result.getUrlWebpay()%>' method="post">
	            	<input type="hidden" name="TBK_TOKEN" value='<%=result.getToken()%>'>
	            	<input type="hidden" name="usuario" value='<%=username%>'>
	            	<input type="submit" value="Agregar tarjeta">
	            </form>
	            <br>                        
            <%}else{%>                    
            	<p><samp>Ocurrio un error en la operacion InitTransaction Webpay.</samp></p>                            
            <%} %>            
            <a href=".">&laquo; Salir</a>
          
        <%             
        } else if (action.equalsIgnoreCase("OneClickFinishInscription")) {
          
            OneClickFinishInscriptionOutput result = new OneClickFinishInscriptionOutput();           
            String token = "";
            int responseCode = 0;
            String urlNextStep = request.getRequestURL().toString()+"?action=OneClickAuthorize";         
            
            try{
                token = request.getParameter("TBK_TOKEN");                  
               
                /**
                (finishInscription) Permite finalizar el proceso de inscripción del tarjetahabiente en OneClick. 
                Retorna el identificador del usuario en OneClick, el cual será utilizado para realizar las transacciones de pago.
                */
                result = webpay.getOneClickTransaction().finishInscription(token); 
                %>
                                                
            <h2>Inscripcion Finalizada</h2>          
            <div style="background-color:lightgrey;">                    
                    <%
                    responseCode = result.getResponseCode();
                    if(responseCode==0){
                    	/** Se debe almacenar la informacion de la tarjeta y user generados por transbank*/
                    %>
                    <script>        
                        console.log("responseCode = <%=result.getResponseCode()%>");
                        console.log("authCode     = <%=result.getAuthCode()%>");
                        console.log("TBK_TOKEN    = <%=token%>");
                        console.log("tbkUser      = <%=result.getTbkUser()%>");
                        console.log("last4CardDigits = <%=result.getLast4CardDigits()%>");
                        console.log("CreditCardType  = <%=result.getCreditCardType().value()%>");
                    </script>
                    <%
                    }else{
                        out.print("[responseCode] = "+result.getResponseCode());
                    }                                        
                    %> 
                                                        
            </div>
            <%if(responseCode!=0){%>                     
            	<p><samp>Pago RECHAZADO por webpay </samp></p>
            <%}else{%> 
            	<p><samp>Pago validacion ACEPTADO por webpay (se deben guardar datos para mostrar voucher)</samp></p>
            	<table>
            		<tr>
            			<th>Tipo Tarjeta: <%=result.getCreditCardType().value()%></th>
            			<th>Numero: *********<%=result.getLast4CardDigits()%></th>
            		</tr>            		
            	</table>
            	
            	
            <% }%>  
            
                      
            <br><form action="<%=urlNextStep%>" method="post">
                <input type="hidden" name="TBK_TOKEN" value="<%=token%>">
                <input type="hidden" name="tbk_user" value="<%=result.getTbkUser()%>">                
                <input type="submit" value="Realizar pago">
            </form>
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
 
        } else if (action.equalsIgnoreCase("OneClickAuthorize")) {
          
        	int monto= 25300;        	        	
            OneClickPayOutput result = new OneClickPayOutput();
            String token = "";
            int responseCode = 0;
            BigDecimal amount = BigDecimal.valueOf(monto);        	
            Random rn = new Random();            
            Long buyOrder = Math.abs(rn.nextLong());     /** Orden de compra, debe sacarce de la transaccion en curso */     
        	
            String urlNextStep = request.getRequestURL().toString()+"?action=OneClickReverseTransaction";
        	
                    
            try{
                token = request.getParameter("TBK_TOKEN");   
                tbkUser = request.getParameter("tbk_user");  
                username = "prueba";
              
            	%>   
            	<script>
            	console.log("TBK_TOKEN = <%=token%>");
            	console.log("tbkUser = <%=tbkUser%>" );            	
            	</script>
            	<%
                /**
                	Una vez realizada la inscripción, el comercio puede usar el tbkUser recibido para realizar transacciones. Para eso debe usar el método authorize().
                	tbkuser debe ser guardado como identificador de la tarjeta a usar para las transacciones.
                */
                result = webpay.getOneClickTransaction().authorize(buyOrder, tbkUser, username, amount);
                                             
                %>
                
                
            <h2>Transaccion autorizada</h2>

            <div style="background-color:lightgrey;">
                    <script>                                                         
                     console.log("responseCode = <%=result.getResponseCode()%>");
                     console.log("authCode = <%=result.getAuthorizationCode()%>");
                     console.log("last4CardDigits = <%=result.getLast4CardDigits()%>"); 
                     console.log("creditCardType = <%=result.getCreditCardType().value()%>"); 
                     console.log("transactionId = <%=result.getTransactionId()%>");  
                     console.log("buyOrder = <%=buyOrder%>");
                    </script>                                    
            </div>
                    <%if(responseCode!=0){%>                     
            <p><samp>Pago RECHAZADO por webpay </samp></p>
                    <%}else{%> 
            <p><samp>Pago ACEPTADO por webpay </samp></p>
                    <% }%> 
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
                