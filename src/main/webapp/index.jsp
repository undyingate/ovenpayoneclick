 <h2>Ingreso de usuario y tarjeta</h2>   

<table border="0" style="width:70%">
    <form action="tbk-oneclick.jsp" method="post">
    	usuario:<br>
    	<input type="text" name="usuario"><br>
    	email:<br>
    	<input type="text" name="email"><br>
	    <input type="submit" value="Webpay OneClick" />
	</form>   
  </tr>
</table>

<hr />

     <h2>Cancelar la transaccion</h2>                     
     <br><form action="tbk-reverse.jsp?action=OneClickReverseTransaction" method="post">
     	   Orden de compra:<br>
           <input type="text" name="buyOrder"><br>
           TBK_USER Key:<br>
           <input type="text" name="TBK_USER"><br>
           usuario:<br>
           <input type="text" name="usuario"><br>
           <input type="submit" value="Reverse Transaction">
     </form>
     
 <hr />
 
           <h2>Remover cuenta del usuario</h2>            
          <br><form action="tbk-remove.jsp?action=OneClickRemoveUser" method="post">
          		TBK_USER Key:<br>
                <input type="text" name="TBK_USER"><br>
                 usuario:<br>
                <input type="text" name="USERNAME"><br>
                <input type="submit" value="Remover usuario ">
          </form>