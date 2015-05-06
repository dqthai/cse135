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
    String redirect = null;
    
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
    	if (request.getParameter("name") == null
				|| request.getParameter("role") == null
				|| request.getParameter("age") == null
				|| request.getParameter("state") == null
    			|| request.getParameter("name").equals("")
				|| request.getParameter("role").equals("")
				|| request.getParameter("age").equals("")
				|| request.getParameter("state").equals("")) 
    	{
    		%>
    		<p>You have failed to sign up.
    		Invalid input</p>
    		<%
    	} else {
    		
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
    	
    	// Redirect to signup success page
    	redirect = "SignUpSuccess.html";
    	response.sendRedirect(redirect);
    	}
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
						<option value="AL">AL</option>
						<option value="AK">AK</option>
						<option value="AS">AS</option>
						<option value="AZ">AZ</option>
						<option value="AR">AR</option>
						<option value="CA">CA</option>
						<option value="CO">CO</option>
						<option value="CT">CT</option>
						<option value="DE">DE</option>
						<option value="DC">DC</option>
						<option value="FL">FL</option>
						<option value="GA">GA</option>
						<option value="GU">GU</option>
						<option value="HI">HI</option>
						<option value="ID">ID</option>
						<option value="IL">IL</option>
						<option value="IN">IN</option>
						<option value="IA">IA</option>
						<option value="KS">KS</option>
						<option value="KY">KY</option>
						<option value="LA">LA</option>
						<option value="ME">ME</option>
						<option value="MH">MH</option>
						<option value="MD">MD</option>
						<option value="MA">MA</option>
						<option value="MI">MI</option>
						<option value="MN">MN</option>
						<option value="MS">MS</option>
						<option value="MO">MO</option>
						<option value="MT">MT</option>
						<option value="NE">NE</option>
						<option value="NV">NV</option>
						<option value="NH">NH</option>
						<option value="NJ">NJ</option>
						<option value="NM">NM</option>
						<option value="NY">NY</option>
						<option value="NC">NC</option>
						<option value="OH">OH</option>
						<option value="OK">OK</option>
						<option value="OR">OR</option>
						<option value="PA">PA</option>
						<option value="RI">RI</option>
						<option value="SC">SC</option>
						<option value="SD">SD</option>
						<option value="TN">TN</option>
						<option value="TX">TX</option>
						<option value="UT">UT</option>
						<option value="VT">VT</option>
						<option value="VA">VA</option>
						<option value="WA">WA</option>
						<option value="WV">WV</option>
						<option value="WI">WI</option>
						<option value="WY">WY</option>
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
    	redirect = "SignupFailure.html";
    	response.sendRedirect(redirect);
    }
    catch (NumberFormatException e){
    	System.out.println("NumberFormatException caught");
    	%>
    	<p>You have failed to sign up.
    	Age: not a number</p>
    	<% 
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