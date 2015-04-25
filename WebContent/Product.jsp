
<%@ page import="java.sql.*" import="java.util.List"
	import="java.util.ArrayList"%>
<%
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	try {
		Class.forName("org.postgresql.Driver");
		conn = DriverManager
				.getConnection("jdbc:postgresql://localhost/cse135?"
						+ "user=postgres&password=postgres");
		String action = request.getParameter("action");
		if (action != null && action.equals("insert")) {
			System.out.println("insert");
			pstmt = conn
					.prepareStatement("INSERT INTO Products (p_name, sku, price, category) VALUES (?, ?, ?, ?)");
			pstmt.setString(1, request.getParameter("p_name"));
			pstmt.setString(2, request.getParameter("sku"));
			pstmt.setInt(3,
					Integer.parseInt(request.getParameter("price")));
			pstmt.setInt(4,
					Integer.parseInt(request.getParameter("category")));
			System.out.println("name: " + request.getParameter("p_name")
					+ " sku: " + request.getParameter("sku")
					+ " price: " + request.getParameter("price")
					+ " category: " + request.getParameter("category"));
			pstmt.executeUpdate();
		}

		if (action != null && action.equals("update")) {
			System.out.println("update");
			pstmt = conn
					.prepareStatement("UPDATE Products SET p_name = ?, sku = ?, price = ?, category = ? WHERE id = ?");
			pstmt.setString(1, request.getParameter("p_name"));
			pstmt.setString(2, request.getParameter("sku"));
			pstmt.setInt(3,
					Integer.parseInt(request.getParameter("price")));
			pstmt.setInt(4,
					Integer.parseInt(request.getParameter("category")));
			pstmt.setInt(5,
					Integer.parseInt(request.getParameter("id")));
			System.out.println("name: " + request.getParameter("name")
					+ " sku: " + request.getParameter("sku")
					+ " price: " + request.getParameter("price")
					+ " category: " + request.getParameter("category"));
			pstmt.executeUpdate();
		}

		if (action != null && action.equals("delete")) {
			pstmt = conn
					.prepareStatement("DELETE FROM Products WHERE id = ?");
			pstmt.setInt(1,
					Integer.parseInt(request.getParameter("id")));
			pstmt.executeUpdate();
		}

		Statement statement = conn.createStatement();
		rs = statement.executeQuery("SELECT name FROM Category");
%>

<div>
	<h1>Products</h1>
	<div id="categories">
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
			%>
		</ul>
	</div>
	<%
		rs = statement.executeQuery("SELECT * FROM Category");
			String cate = request.getParameter("categories");
	%>
	<div id="product_table">
		<h2>Product Table</h2>
		<div id="search">
			<form action="Product.jsp" method="post">
				<input type="text" name="search" value="" /> <input type="hidden"
					name=categories value="<%=cate%>" /> <input type="submit"
					value="Search" />
			</form>
		</div>
		<table>
			<tr>
				<th>ID</th>
				<th>Name</th>
				<th>SKU</th>
				<th>Price</th>
				<th>Category</th>
			</tr>
			<tr>
				<form action="Product.jsp" method="POST">
					<input type="hidden" name="action" value="insert" />
					<th>&nbsp;</th>
					<th><input type="text" value="" name="p_name" id="p_name"
						size="15" /></th>
					<th><input type="text" name="sku" id="sku" size="15" /></th>
					<th><input type="text" name="price" id="price" size="15" /></th>
					<th><select name="category" id="category">
							<%
								while (rs.next()) {
										String category = rs.getString("name");
										int id = rs.getInt("id");
							%>
							<option value="<%=id%>"><%=category%></option>
							<%
								}
									rs.close();
							%>
					</select></th>
					<th><input type="submit" value="Add" /></th>
				</form>
			</tr>
			<%
				List<String> categories = new ArrayList<String>();
					List<Integer> ids = new ArrayList<Integer>();
					rs = statement.executeQuery("SELECT * FROM Category");
					while (rs.next()) {
						categories.add(rs.getString("name"));
						ids.add(rs.getInt("id"));
					}
					rs.close();

					String cat = request.getParameter("categories");
					String search = request.getParameter("search");
					cat = (cat == null) ? null : cat.trim();
					search = (search == null) ? null : search.trim();
					System.out.println("cat: " + cat + " search: " + search);
					if (cat != null || search != null) {

						if (cat == null && search != null) {
							rs = statement
									.executeQuery("SELECT * FROM Products, Category WHERE Upper(p_name) LIKE upper('%"
											+ search
											+ "%') AND Category.id=Products.category GROUP BY Category.id, Products.id");
						} else if (cat.equals("allproducts") && search != null) {
							rs = statement
									.executeQuery("SELECT * FROM products, Category WHERE upper(p_name) LIKE upper('%"
											+ search
											+ "%') AND Products.category=Category.id GROUP BY Category.id, Products.id");
						} else if (cat.equals("allproducts") && search == null) {
							rs = statement
									.executeQuery("SELECT * FROM Products, Category WHERE Products.category=Category.id GROUP BY Category.id, Products.id");
						} else if (cat != null && search == null) {
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
											+ search
											+ "%') GROUP BY Category.id, Products.id");
						}
					} else {
						rs = statement
								.executeQuery("SELECT * FROM Products, Category WHERE Products.category=Category.id");
					}
					while (rs.next()) {
			%>
			<tr>
				<form action="Product.jsp" method="POST">
					<input type="hidden" name="action" value="update" /> <input
						type="hidden" name="id" value="<%=rs.getInt("id")%>" />
					<td><%=rs.getInt("id")%></td>
					<td><input value="<%=rs.getString("p_name")%>" name="p_name"
						size="15" /></td>
					<td><input value="<%=rs.getString("sku")%>" name="sku"
						size="15" /></td>
					<td><input value="<%=rs.getInt("price")%>" name="price"
						size="15" /></td>
					<td><select name="category">
							<%
								for (int i = 0; i < categories.size(); i++) {
											String category = categories.get(i);
											int id = ids.get(i);
							%>
							<option value="<%=id%>" <%if (id == rs.getInt("category")) {%>
								selected <%}%>>
								<%=category%>
							</option>
							<%
								}
							%>
					</select></td>
					<td><input type="submit" value="Update"></td>
				</form>
				<form action="Product.jsp" method="POST">
					<input type="hidden" name="action" value="delete" /> <input
						type="hidden" value="<%=rs.getInt("id")%>" name="id" />
					<td><input type="submit" value="Delete" /></td>
				</form>
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
		if (pstmt != null) {
			try {
				pstmt.close();
			} catch (SQLException e) {
			} // Ignore
			pstmt = null;
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
