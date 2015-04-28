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
	<%@page import=java.sql.* %>
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
		pstmt.setString(1, request.getParameter("name"));
		int rowcount = pstmt.executeUpdate();
		if (rowcount > 0)
		{
			// TODO: Login success
		}
		else
		{
			// TODO: No login found
		}
	}
	%>
	
	<%
	}
	%>
	<h1>Login</h1>
	<table>
		<tr>
			<form action="Login.jsp" method="post">
			<input type="hidden" name="action" value="login">
			<td>Name:</td>
			<td><input name="name" value="" size="10"></td>
			<td><button type="submit">Login</button></td>
			</form>
		</tr>
	</table>
</body>
</html>