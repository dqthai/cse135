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
					<select>
						<option value="AL">Alabama</option>
						<option value="AK">Alaska</option>
						<option value="AZ">Arizona</option>
						<option value="AR">Arkansas</option>
						<option value="CA">California</option>
						<option value="CO">Colorado</option>
						<option value="CT">Connecticut</option>
						<option value="DE">Delaware</option>
						<option value="DC">District Of Columbia</option>
						<option value="FL">Florida</option>
						<option value="GA">Georgia</option>
						<option value="HI">Hawaii</option>
						<option value="ID">Idaho</option>
						<option value="IL">Illinois</option>
						<option value="IN">Indiana</option>
						<option value="IA">Iowa</option>
						<option value="KS">Kansas</option>
						<option value="KY">Kentucky</option>
						<option value="LA">Louisiana</option>
						<option value="ME">Maine</option>
						<option value="MD">Maryland</option>
						<option value="MA">Massachusetts</option>
						<option value="MI">Michigan</option>
						<option value="MN">Minnesota</option>
						<option value="MS">Mississippi</option>
						<option value="MO">Missouri</option>
						<option value="MT">Montana</option>
						<option value="NE">Nebraska</option>
						<option value="NV">Nevada</option>
						<option value="NH">New Hampshire</option>
						<option value="NJ">New Jersey</option>
						<option value="NM">New Mexico</option>
						<option value="NY">New York</option>
						<option value="NC">North Carolina</option>
						<option value="ND">North Dakota</option>
						<option value="OH">Ohio</option>
						<option value="OK">Oklahoma</option>
						<option value="OR">Oregon</option>
						<option value="PA">Pennsylvania</option>
						<option value="RI">Rhode Island</option>
						<option value="SC">South Carolina</option>
						<option value="SD">South Dakota</option>
						<option value="TN">Tennessee</option>
						<option value="TX">Texas</option>
						<option value="UT">Utah</option>
						<option value="VT">Vermont</option>
						<option value="VA">Virginia</option>
						<option value="WA">Washington</option>
						<option value="WV">West Virginia</option>
						<option value="WI">Wisconsin</option>
						<option value="WY">Wyoming</option>
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