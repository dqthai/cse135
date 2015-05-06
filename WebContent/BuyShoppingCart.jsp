
<%@ page import="java.util.*,java.sql.*"%>
<%@ include file="Home.jsp"%>
<% 
if (session.getAttribute("login_status") != null &&
	!session.getAttribute("login_status").equals("success"))
{
//initialize jsp objects
	Connection conn = null;
	ResultSet rs = null;
	PreparedStatement pstmt = null;
//initialize temporary variables
int user_id = 0;
String user = "";
String summary = "";
	
//create products, quantities, prices lists
	List<Integer> p_ids = new ArrayList<Integer>();
	List<Integer> quantities = new ArrayList<Integer>();
	List<Double> prices = new ArrayList<Double>();
//get attributes from session
	if (session.getAttribute("p_ids") != null){
		p_ids = (ArrayList<Integer>) session.getAttribute("p_ids");
	}
	if (session.getAttribute("quantities") != null){
		quantities = (ArrayList<Integer>) session.getAttribute("quantities");
	}
	if (session.getAttribute("prices") != null){
		prices = (ArrayList<Double>) session.getAttribute("prices");
	}
	if (session.getAttribute("u_name") != null){
		user = (String)session.getAttribute("u_name");
	}

	
	try {
	Class.forName("org.postgresql.Driver"); // Registering Postgresql JDBC driver with the DriverManager
    conn = DriverManager.getConnection(	// Open a connection to the database using DriverManager
                "jdbc:postgresql://localhost/cse135?" +
                "user=postgres&password=postgres");
	
    
	Statement statement = conn.createStatement(); // Create the statement
    // Use the created statement to SELECT
	
	//display products, amount, price, amount*price, total price at end
%>
<%-- -------- Retrieval code -------- --%>
<% String action = request.getParameter("action"); %>

<%-- Get user id--%>
<%
System.out.println("entering query 1");
pstmt = conn.prepareStatement("SELECT * FROM users " + "WHERE u_name = ?");
pstmt.setString(1, user);
rs = pstmt.executeQuery();
if(rs.next()){
	user_id = rs.getInt("u_id");
}
System.out.println("query 1 success: " + user_id);
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
		int i_pid = 0;
		String i_product = "";
		int i_quantity = 0; //i_ prefix means iteration
		double i_price = 0.00;
		double i_quantityprice = 0.00;
		double i_totalprice = 0.00;
		if (p_ids != null) {
			for (int i = 0; i < p_ids.size(); i++) {
				//get the name of the product from its id
				i_pid = p_ids.get(i);
				pstmt = conn.prepareStatement("SELECT * FROM products " 
					+ "WHERE id = ?");
				pstmt.setInt(1, i_pid);
				rs = pstmt.executeQuery();
				if(rs.next()){
					i_product = rs.getString("p_name");
				}
				i_quantity = quantities.get(i);
				i_price = prices.get(i);
				i_quantityprice = i_quantity * i_price;
				i_totalprice+=i_quantityprice;
	%>
		<tr>
			<td><%=i_pid%></td>
			<td><%=i_product%></td>
			<td><%=i_quantity%></td>
			<td><%=String.format( "%.2f", i_price)%></td>
			<td><%=String.format( "%.2f", i_quantityprice)%></td>
		</tr>
		<%
			}
			} else { 
				%><tr>
			<th>Empty</th>
		</tr>
		<%
			}
			%>
	</table>
	<p>
		Total: $
		<%=String.format( "%.2f",i_totalprice )%>
	</p>
	<p>Credit Card Number</p>
	<form action="BuyShoppingCart.jsp" method="POST">
		<input type="hidden" name="action" value="buy" /> <input value=""
			name="creditcardnumber" size="20" />
		<%-- Button --%>
		<input type="submit" value="Purchase" />
	</form>

</body>
</html>
<%-- -------- Buy Button Code ------- --%>
<%


	if (action != null && action.equals("buy")) {
		String card = request.getParameter("creditcardnumber");
		if(p_ids.isEmpty()){
			System.out.println("empty");
		}
		else if(card.isEmpty() || card == null){
			System.out.println("nocard");
		}
		else{
        // Begin transaction
        conn.setAutoCommit(false);
        session.setAttribute("creditcard", card);
        System.out.println("card number stored in session: " + card);
        pstmt = conn.prepareStatement("INSERT INTO purchases(u_id,price,summary)"+ 
        		" VALUES(?, ?, ?)");
        pstmt.setInt(1, user_id);
        for(int i = 0; i < p_ids.size(); i++){
        	i_pid = p_ids.get(i);
        	i_quantity = quantities.get(i);
        	i_price = prices.get(i);
        	summary += "[" + i_pid + ";" + i_quantity + ";" + i_price + "]" ;
        }
        pstmt.setDouble(2, i_totalprice);
        pstmt.setString(3, summary);
        pstmt.executeUpdate();
        conn.commit();
        conn.setAutoCommit(true);
        response.sendRedirect("Confirmation.jsp");
		}
	}
} catch(SQLException e) {
	throw new RuntimeException(e);
}
}
%>