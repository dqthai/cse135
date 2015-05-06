<%@page import="java.sql.*" import="java.util.List"
	import="java.util.ArrayList"%>
<%@ include file="Home.jsp"%>
<%
if(request.getHeader("referer") == null ||
	!request.getHeader("referer").equals("http://localhost:8080/cse135/Browse.jsp"))
{
	System.out.println(request.getHeader("referer"));
	%>
	<p>Invalid referrer</p>
	<% 
} else
{
	Connection conn = null;
	ResultSet rs = null;
	List<String> products = new ArrayList<String>();
	if (session.getAttribute("products") != null)
		products = (ArrayList<String>) session.getAttribute("products");
	List<Integer> quantities = new ArrayList<Integer>();
	if (session.getAttribute("quantities") != null)
		quantities = (ArrayList<Integer>) session.getAttribute("quantities");
	List<Double> prices = new ArrayList<Double>();
	if (session.getAttribute("prices") != null)
		prices = (ArrayList<Double>) session.getAttribute("prices");
	List<Integer> p_ids = new ArrayList<Integer>();
	if (session.getAttribute("p_ids") != null)
		p_ids = (ArrayList<Integer>) session.getAttribute("p_ids");
	
	try {
		Class.forName("org.postgresql.Driver");
		conn = DriverManager
				.getConnection("jdbc:postgresql://localhost/cse135?"
						+ "user=postgres&password=postgres");

		Statement statement = conn.createStatement();

		String p_name = request.getParameter("products_order");
		double price = 0.0;
		int p_id = -1;
		rs = statement.executeQuery("Select * from products where p_name='" + p_name + "'");
		if (rs.next()) {
			price = rs.getDouble("price");
			p_id = rs.getInt("id");
		}
		rs.close();
%>

<div>
	<h1>Product Order</h1>
	<div>
		<h2>Add to orders</h2>
		<form action="Browse.jsp" method="POST">
			<label>Add Item: <%=p_id%>: <%=p_name%></label><br> 
			<label>Price: <%=price%></label><br> 
			<input type="hidden" value="<%=p_id%>" name="p_id" /> 
			<input type="hidden" value="<%=price%>" name="price" />
			<input type="hidden" value="<%=p_name%>" name="p_name" /> 
			<label>Quantity</label>
			<input type="number" value="" name="quantity" /><br> 
			<input type="hidden" name="action" value="add" /> 
			<input type="submit" value="Add to cart" />
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
				System.out.println(prices);
				if (products != null) {
						for (int i = 0; i < products.size(); i++) {
							String product = products.get(i);
							int quantity = quantities.get(i);
							double cost = prices.get(i);
			%>
			<tr>
				<td><%=product%></td>
				<td><%=cost%></td>
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
}
%>
