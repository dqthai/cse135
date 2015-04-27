<%@page import="java.sql.*" import="java.util.List"
	import="java.util.ArrayList"%>
<%@ include file="Header.jsp"%>
<%
	Connection conn = null;
	ResultSet rs = null;
	List<String> products = new ArrayList<String>();
	if (session.getAttribute("products") != null)
		products = (ArrayList<String>) session.getAttribute("products");
	List<Integer> quantities = new ArrayList<Integer>();
	if (session.getAttribute("quantities") != null)
		quantities = (ArrayList<Integer>) session
				.getAttribute("quantities");
	List<Integer> prices = new ArrayList<Integer>();
	if (session.getAttribute("prices") != null)
		prices = (ArrayList<Integer>) session.getAttribute("prices");

	try {
		Class.forName("org.postgresql.Driver");
		conn = DriverManager
				.getConnection("jdbc:postgresql://localhost/cse135?"
						+ "user=postgres&password=postgres");

		Statement statement = conn.createStatement();

		String p_name = request.getParameter("products_order");
		int price = 0;
		rs = statement
				.executeQuery("Select * from products where p_name='"
						+ p_name + "'");
		if (rs.next())
			price = rs.getInt("price");
		rs.close();
%>

<div>
	<h1>Product Order</h1>
	<div>
		<h2>Add to orders</h2>
		<form action="Browse.jsp" method="POST">
			<label>Add Item: <%=p_name%></label><br> <label>Price: <%=price%></label><br>
			<input type="hidden" value="<%=p_name%>" name="p_name" /> <input
				type="hidden" value="<%=price%>" name="price" /> <label>Quantity</label><input
				type="number" value="" name="quantity" /><br> <input
				type="hidden" name="action" value="add" /> <input type="submit"
				value="Add to cart" />
		</form>
	</div>

	<div id="order_list">
		<h2>Orders</h2>
		<table border="1" width="50%">
			<tr>
				<th>Name</th>
				<th>Price</th>
				<th>Quantity</th>
			</tr>
			<%
				if (products != null) {
						for (int i = 0; i < products.size(); i++) {
							String product = products.get(i);
							int quantity = quantities.get(i);
							int cost = prices.get(i);
			%>
			<tr>
				<td><%=product%></td>
				<td><%= cost%></td>
				<td><%=quantity%></td>
			</tr>
			<%
				}
					} else {
						out.println("No items added yet");
					}
			%>
		</table>
	</div>
</div>

<%
	statement.close();
		conn.close();
	} catch (SQLException e) {
		throw new RuntimeException(e);
	} finally {
		if (rs != null) {
			try {
				rs.close();
			} catch (SQLException e) {
			}
			rs = null;
		}
		if (conn != null) {
			try {
				conn.close();
			} catch (SQLException e) {
			} // Ignore
			conn = null;
		}
	}
%>
