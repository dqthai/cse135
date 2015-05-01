<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Sign Up</title>
</head>
<body>
	<%-- -------- Include menu HTML code -------- --%>
            
    <%-- -------- Open Connection Code -------- --%>
    <%@ page import="java.sql.*" %>
    <%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
    	 
    	// Registering Postgresql JDBC driver with the DriverManager
        Class.forName("org.postgresql.Driver");

        // Open a connection to the database using DriverManager
        conn = DriverManager.getConnection(
            "jdbc:postgresql://localhost/cse135?" +
            "user=postgres&password=postgres");
        
    %>
   
    
    <%-- -------- INSERT Code -------- --%>
    <%
    String action = request.getParameter("action");
    if (action != null && action.equals("signup"))
    {
    	conn.setAutoCommit(false);
    	pstmt = conn.prepareStatement(
    			"INSERT INTO users (u_name, u_role, u_age, u_state)" +
    	                           "VALUES (?, ?, ?, ?)");
    	pstmt.setString(1, request.getParameter("name"));
    	pstmt.setString(2, request.getParameter("role"));
    	pstmt.setInt   (3, Integer.parseInt(request.getParameter("age")));
    	pstmt.setString(4, request.getParameter("state"));
    	
    	int rowcount = pstmt.executeUpdate();
    	conn.commit();
    	conn.setAutoCommit(true);

    }
    %>

	<h1>Signup</h1>
	<form action="Signup.jsp" method="post">
		<table>
			<input type="hidden" name="action" value="signup" />
			<tr>
				<td>Name:</td>
				<td><input name="name" value="" size="10"></td>
			</tr>
			<tr>
				<td>Role:</td>
				<td><input type="radio" name="role" value="O">Owner
				<input type="radio" name="role" value="C">Customer</td>
			</tr>
			<tr>
				<td>Age:</td>
				<td><input name="age" value="" size="10"></td>
			</tr>
			
			<tr>
				<td>State:</td>
				<td>
					<select name="state">
						<option value="CA">CA</option>
						<option value="NV">NV</option>
						<option value="WA">WA</option>
					</select>
				</td>
			</tr>    
					
		</table>
		<%-- Button --%>
    	<input type="submit" value="Sign Up">
	</form>
	
	<%-- -------- Close Connection Code -------- --%>

	<%
    }
    catch (SQLException e) {
    	// TODO: Signup Failure
    	System.out.println("SQLException caught");
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