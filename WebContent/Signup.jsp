<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Sign Up</title>
</head>
<body>
	<table>
		<form action="Signup.jsp" method="post">
			<input type="hidden" name="action" value="signup">
			<tr>
				<td>Name:</td>
				<td><input name="name" value="" size="30"></td>
			</tr>
			<tr>
				<td>Role:</td>
				<td><input type="radio" name="role" value="Owner">Owner</td>
				<td><input type="radio" name="role" value="Customer">Customer</td>
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
		</form>
	</table>

            <%-- -------- Include menu HTML code -------- --%>
            
            <%-- -------- Open Connection Code -------- --%>
            <%@ page import="java.sql.*" %>
            <%
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            
            try {


            %>
            <%-- TODO: ADD JDBC CONNECTION ABOVE IN TRY BLOCK --%>
            
            <%-- -------- INSERT Code -------- --%>
            <%
            String action = request.getParameter("action");
            if (action != null && action.equals("signup"))
            {
            	conn.setAutoCommit(false);
            	pstmt = conn.prepareStatement("");
            }
            %>
            
            <%-- -------- UPDATE Code -------- --%>
            
            <%-- -------- DELETE Code -------- --%>
            

            <%-- -------- SELECT Statement Code -------- --%>
            

            <%-- -------- Iteration Code -------- --%>
            

                <%-- Get the data --%>
                
                <%-- Button --%>
                


            <%-- -------- Close Connection Code -------- --%>

			<%
            }
            catch (SQLException e) {
            	
            }
            %>
</body>
</html>