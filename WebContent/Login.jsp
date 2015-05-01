<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Login</title>
</head>
<body>
	<!-- Open database connection -->
	<%@page import="java.sql.*" %>
	<%
	
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	try {
		Class.forName("org.postgresql.Driver");
		
		conn = DriverManager.getConnection(
				"jdbc:postgresql://localhost/cse135?" +
	            "user=postgres&password=postgres");
	%>
	
	<%------ Query Code -------%>
	<%
	String action = request.getParameter("action");
	if(action != null && action.equals("login"))
	{
		conn.setAutoCommit(false);
		pstmt = conn.prepareStatement(
				"SELECT * FROM users WHERE u_name = ?");
		// u_name starts out as the user login form input
		String u_name = new String(request.getParameter("name"));
		// Set session's name to u_name
		session.setAttribute("u_name", u_name);
		System.out.println(session.getAttribute("u_name"));
		// u_role starts out as customer by default
		String u_role = null;
		pstmt.setString(1, u_name);
		rs = pstmt.executeQuery();
		System.out.println("Query 1 executed");
		int row_count = 0;
		while(rs.next())
		{
			row_count++;
			System.out.println(rs.getString("u_name"));
			System.out.println(rs.getString("u_role"));
			u_role = rs.getString("u_role");
            System.out.println("Rows queried: " + row_count);
		}
		if (row_count > 0)
		{
			System.out.println("Login success");
			session.setAttribute("login_status", "success");
			if(u_role.equals("C"))
			{
				session.setAttribute("u_role", "customer");
			}
			// Set session's role to customer
			else if(u_role.equals("O"))
			{
				session.setAttribute("u_role", "owner");
				System.out.println("Set session role to " +
					session.getAttribute("u_role"));
			}
			else
			{
				System.out.println("Role found: " + u_role);
				throw new SQLException();
			}
			// Close connections
			rs.close(); rs = null; pstmt.close(); pstmt = null; conn.close(); conn = null;
			// New location to be redirected
			String redirect = "Home.jsp";
			response.sendRedirect(redirect);
		}
		else
		{
			System.out.println("Login Failure");
			// Set the session's loginerror to true
			session.setAttribute("login_status", "failure");
			// TODO: Include alert that login failed
			
			// Close connections
			rs.close(); rs = null; pstmt.close(); pstmt = null; conn.close(); conn = null;
			// New location to be redirected
			String redirect = "Login.jsp";
			response.sendRedirect(redirect);
		}
	}
	%>
	
	<h1>Login</h1>
	<%
	if (session.getAttribute("login_status") != null &&
		session.getAttribute("login_status").equals("failure"))
	{
		%>
		<p>The provided name <%= session.getAttribute("u_name") %> is not found </p>
		<%
	}
	%>
	<table>
		<tr>
			<form action="Login.jsp" method="post">
			<input type="hidden" name="action" value="login" />
			<td>Name:</td>
			<td><input name="name" value="" size="10" /></td>
			<td><button type="submit">Login</button></td>
			</form>
		</tr>
	</table>
	
	<%
	}
	catch (SQLException e)
	{
		// TODO: What happens here?
		System.out.println("SQLException caught");
		e.printStackTrace();
	}
	finally {
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
</body>
</html>