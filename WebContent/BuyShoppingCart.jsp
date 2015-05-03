
<%@ page import="java.util.*,java.sql.*" %>
<%@ include file="Home.jsp" %>
<% 
	Connection conn = null;
	ResultSet rs = null;
	
	List<String> products = new ArrayList<String>();
	List<Integer> quantities = new ArrayList<Integer>();
	List<Double> prices = new ArrayList<Double>();
	
	if (session.getAttribute("products") != null){
		products = (ArrayList<String>) session.getAttribute("products");
	}
	if (session.getAttribute("quantities") != null){
		quantities = (ArrayList<Integer>) session.getAttribute("quantities");
	}
	if (session.getAttribute("prices") != null){
		prices = (ArrayList<Double>) session.getAttribute("prices");
	}
	//test code
// 	products.add("Ring");
// 	products.add("Watch");
// 	quantities.add(9000);
// 	quantities.add(420);
// 	prices.add(3.50);
// 	prices.add(.55);
	
	try {
    // Registering Postgresql JDBC driver with the DriverManager
	Class.forName("org.postgresql.Driver");
	// Open a connection to the database using DriverManager
    conn = DriverManager.getConnection(
                "jdbc:postgresql://localhost/cse135?" +
                "user=postgres&password=postgres");
	
    // Create the statement
	Statement statement = conn.createStatement();
    // Use the created statement to SELECT
	
	//display products, amount, price, amount*price, total price at end
%>
<%-- -------- Retrieval code -------- --%>
<% String action = request.getParameter("action"); %>
<%-- -------- Buy Button Code ------- --%>
<%
	if (action != null && action.equals("buy")) {

        // Begin transaction
        conn.setAutoCommit(false);
		String card = request.getParameter("creditcardnumber");
        session.setAttribute("creditcard", card);
        System.out.println("card number stored in session: " + card);
        response.sendRedirect("Confirmation.jsp");
	}
%>

<html>
<head>
<title>Buy Shopping Cart</title>
</head>
<body>
	<%-- shopping cart table --%>
<table border=1>
	<tr>
	<td>Item</td>
	<td>Quantity</td>
	<td>Unit Price</td>
	<td>Item Total</td>
	</tr>
	<%
		String i_product = "";
		int i_quantity = 0;
		double i_price = 0.00;
		double i_bulkprice = 0.00;
		double i_totalprice = 0.00;
		if (products != null) {
			for (int i = 0; i < products.size(); i++) {
				i_product = products.get(i);
				i_quantity = quantities.get(i);
				i_price = prices.get(i);
				i_bulkprice = i_quantity * i_price;
				i_totalprice+=i_bulkprice;
	%>
			<tr>
				<td><%=i_product%></td>
				<td><%=i_quantity%></td>
				<td><%=String.format( "%.2f", i_price)%></td>
				<td><%=String.format( "%.2f", i_bulkprice)%></td>
			</tr>
			<%
			}
			} else { 
				%><tr><th>Empty</th></tr><%
			}
			%>
</table>
<p>
Total: $ <%=String.format( "%.2f",i_totalprice )%>
</p>
<p>Credit Card Number</p>
<form action="BuyShoppingCart.jsp" method="POST">
<input type="hidden" name="action" value="buy"/>
<input value="1234" name="creditcardnumber" size="20" />
<%-- Button --%>
<input type="submit" value="Purchase"/>
</form>

</body>
</html>

<% 
} catch(SQLException e) {
	throw new RuntimeException(e);
}
%>