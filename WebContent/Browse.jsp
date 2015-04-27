<%@page import="java.sql.*" import="java.util.List"
	import="java.util.ArrayList"%>
<%@ include file="Header.jsp"%>
<%
	Connection conn = null;
	ResultSet rs = null;
	try {
		Class.forName("org.postgresql.Driver");
		conn = DriverManager
				.getConnection("jdbc:postgresql://localhost/cse135?"
						+ "user=postgres&password=postgres");

		Statement statement = conn.createStatement();
		
		String action = request.getParameter("action");

		if (action != null && action.equals("add")) {
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

			products.add(request.getParameter("p_name"));
			quantities.add(Integer.parseInt(request
					.getParameter("quantity")));
			prices.add(Integer.parseInt(request.getParameter("price")));
			session.setAttribute("products", products);
			session.setAttribute("quantities", quantities);
			session.setAttribute("prices", prices);
		}
		
		rs = statement.executeQuery("SELECT name FROM category");
%>
<div>
	<h1>Products Browsing</h1>
	<div id="categories" style="float: left;">
		<h2>Categories</h2>
		<ul>
			<li><a href="Product.jsp?categories=allproducts">All
					Products</a></li>
			<%
				while (rs.next()) {
						String category = rs.getString("name");
			%>
			<li><a href="Product.jsp?categories=<%=category%>"><%=category%></a></li>
			<%
				}
				rs.close();
			%>
		</ul>
	</div>
	
	<%
		String cat = request.getParameter("categories");
		String srch = request.getParameter("search");
		cat = (cat == null) ? "allproducts" : cat.trim();
		cat = (cat.equals("")) ? "allproducts" : cat.trim();
		srch = (srch == null) ? "" : srch.trim();
		System.out.println("cat: " + cat + " search: " + srch);
	%>
	
	<div id="product_table">
		<h2>Product Table</h2>
		<div id="search">
			<form action="Browse.jsp" method="post">
				<input type="text" name="search" value="<%=srch%>" /> <input
					type="hidden" name=categories value="<%=cat%>" /> <input
					type="submit" value="Search" />
			</form>
		</div>
		<table border="1" style="width:90%; float:right">
			<tr>
				<th>ID</th>
				<th>Name</th>
				<th>SKU</th>
				<th>Price</th>
				<th>Category</th>
			</tr>
			<%
				List<String> categories = new ArrayList<String>();
				List<Integer> ids = new ArrayList<Integer>();
				rs = statement.executeQuery("SELECT * FROM Category");
				while(rs.next()){
					categories.add(rs.getString("name"));
					ids.add(rs.getInt("id"));
				}
				rs.close();
				
				if (cat != null || srch != null) {

					if (cat == null && !srch.equals("")) {
						rs = statement
								.executeQuery("SELECT * FROM Products, Category WHERE Upper(p_name) LIKE upper('%"
										+ srch
										+ "%') AND Category.id=Products.category GROUP BY Category.id, Products.id");
					} else if (cat.equals("allproducts")
							&& !srch.equals("")) {
						rs = statement
								.executeQuery("SELECT * FROM products, Category WHERE upper(p_name) LIKE upper('%"
										+ srch
										+ "%') AND Products.category=Category.id GROUP BY Category.id, Products.id");
					} else if (cat.equals("allproducts")
							&& srch.equals("")) {
						rs = statement
								.executeQuery("SELECT * FROM Products, Category WHERE Products.category=Category.id GROUP BY Category.id, Products.id");
					} else if (cat != null && srch.equals("")) {
						rs = statement
								.executeQuery("SELECT * FROM Products, Category WHERE name='"
										+ cat
										+ "' AND Products.category=Category.id"
										+ " GROUP BY Category.id, Products.id");
					} else {
						rs = statement
								.executeQuery("SELECT * FROM Products, Category WHERE name='"
										+ cat
										+ "' AND Products.category=Category.id AND upper(p_name) LIKE upper('%"
										+ srch
										+ "%') GROUP BY Category.id, Products.id");
					}
				} else {
					rs = statement
							.executeQuery("SELECT * FROM Products, Category WHERE Products.category=Category.id");
				}
				while(rs.next()){
					String product_name = rs.getString("p_name");
			%>
			
			<tr>
			<td><%=rs.getInt("id")%></td>
			<td><a href="ProductOrder.jsp?products_order=<%= product_name%>"><%= product_name%></a></td>
			<td><%=rs.getString("sku")%></td>
			<td><%=rs.getInt("price")%></td>
			<td><%=rs.getString("name")%></td>
			</tr>
			<%
				}
				rs.close();
			%>
		</table>
	</div>
</div>
<%
		rs.close();
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