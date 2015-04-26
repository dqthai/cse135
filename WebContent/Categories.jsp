<%@page import="java.util.*, java.sql.*"%>
<%-- Prepare Connection Code --%>
<%
	Connection conn = null;
	PreparedStatement pstmt = null;
    ResultSet rs = null;
    String errortext = "";
    ResultSet re = null;
    try {
        // Registering Postgresql JDBC driver with the DriverManager
    	Class.forName("org.postgresql.Driver");
		// Open a connection to the database using DriverManager
        conn = DriverManager.getConnection(
                    "jdbc:postgresql://localhost/cse135?" +
                    "user=postgres&password=postgres");
%>
<%-- -------- Retrieval code -------- --%>
<% String action = request.getParameter("action"); %>



<%-- -------- INSERT Code -------- --%>
<%       
    // Check if an insertion is requested
    if (action != null && action.equals("insert")) {
        // Begin transaction
        
        // Create the prepared statement and use it to
        // INSERT categories INTO the students table.
		pstmt = conn.prepareStatement("SELECT 1 FROM categories " + 
					"WHERE name = ?");
		pstmt.setString(1, request.getParameter("name"));
		re = pstmt.executeQuery();
		if(request.getParameter("name") == null || request.getParameter("name").isEmpty()){
			//print an error
			errortext = "INSERT FAILED: NAME FIELD EMPTY";
		}
		else if(re.next()){
			
			errortext = "INSERT FAILED: NAME ALREADY EXISTS";
		}
		else{
			conn.setAutoCommit(false);
	        pstmt = conn.prepareStatement(
	        		"INSERT INTO categories (name, description) VALUES (?, ?)");
        	pstmt.setString(1, request.getParameter("name"));
        	pstmt.setString(2, request.getParameter("description"));
        	int rowCount = pstmt.executeUpdate();
            // Commit transaction
            conn.commit();
            conn.setAutoCommit(true);
		}
        
    }
%>
<%-- -------- UPDATE Code -------- --%>
<%
	// Check if an update is requested
	if (action != null && action.equals("update")) {
		
	pstmt = conn.prepareStatement("SELECT 1 FROM categories " + 
				"WHERE name = ?");
	pstmt.setString(1, request.getParameter("name"));
	re = pstmt.executeQuery();
		if(request.getParameter("name") == null || request.getParameter("name").isEmpty()){
			//print an error
			errortext = "UPDATE FAILED: NAME FIELD EMPTY";
		}
		else if(re.next()){
		errortext = "UPDATE FAILED: NAME ALREADY EXISTS";
		}
		else{
        // Begin transaction
		conn.setAutoCommit(false);
		// Create the prepared statement and use it to
        // UPDATE student values in the Students table.
        pstmt = conn.prepareStatement(
          		"UPDATE categories SET name = ?, "
                + "description = ? WHERE id = ?");
		pstmt.setString(1, request.getParameter("name"));
        pstmt.setString(2, request.getParameter("description"));
        pstmt.setInt(3, Integer.parseInt(request.getParameter("id")));
        int rowCount = pstmt.executeUpdate();
        // Commit transaction
        conn.commit();
        conn.setAutoCommit(true);
		}
	}
%>

<%-- -------- DELETE Code -------- --%>
<%
    // Check if a delete is requested
	if (action != null && action.equals("delete")) {

        // Begin transaction
        conn.setAutoCommit(false);
        // Create the prepared statement and use it to
        // DELETE categories FROM the table.
        pstmt = conn.prepareStatement("DELETE FROM categories WHERE id = ?");
        pstmt.setInt(1, Integer.parseInt(request.getParameter("id")));
        int rowCount = pstmt.executeUpdate();
        // Commit transaction
        conn.commit();
        conn.setAutoCommit(true);
	}
%>
<%-- -------- Result Set Code ---- --%>
<%
    // Create the statement
	Statement statement = conn.createStatement();

    // Use the created statement to SELECT
    rs = statement.executeQuery("SELECT * FROM categories");
%>


<html>

<body>
<table>
	<tr>
		<td valign="top">
			<%-- -------- Include menu HTML code -------- --%> 
			<%@include file="Header.jsp"%>
		</td>
		<td>
			<tr>
				<th>Categories</th>
				<th><font color="red"><%=errortext%></font></th>
			</tr>
			<!-- Add an HTML table header row to format the results -->
			<table border="1">
			<tr>
				<th>ID</th>
				<th>Name</th>
				<th>Description</th>
			</tr>

			<tr>
				<form action="Categories.jsp" method="POST">
					<input type="hidden" name="action" value="insert" />
					<th>&nbsp;</th>
					<th><input value="" name="name" size="10" /></th>
					<th><input value="" name="description" size="15" /></th>
					<th><input type="submit" value="insert" /></th>
				</form>
			</tr>
				<%-- -------- Iteration Code -------- --%>
				<% // Iterate over the ResultSet
                	while (rs.next()) {
            	%>

            <tr>
                <form action="Categories.jsp" method="POST">
                    <input type="hidden" name="action" value="update"/>
                    <input type="hidden" name="id" value="<%=rs.getInt("id")%>"/>

                	<%-- Get the id --%>
                	<td>
                    <%=rs.getInt("id")%>
                	</td>
                	<%-- Get the name --%>
                	<td>
                    <input value="<%=rs.getString("name")%>" name="name" size="15"/>
                	</td>

                	<%-- Get the description --%>
                	<td>
                    <input value="<%=rs.getString("description")%>" name="description" size="15"/>
                	</td>
                	<td> <input type="submit" value="Update"> </td>
                </form>

				<form action="Categories.jsp" method="POST">
                    <input type="hidden" name="action" value="delete"/>
                    <input type="hidden" value="<%=rs.getInt("id")%>" name="id"/>
                    <%-- Button --%>
                	<td><input type="submit" value="Delete"/></td>
                </form>
                <% } %>
                
			</table>
		</td>
	</tr>
</table>
</body>
</html>

<%
	// Close the ResultSet
	rs.close();
	// Close the Statement
	statement.close();
 	// Close the Connection
    conn.close();
    } catch (SQLException e) {

                // Wrap the SQL exception in a runtime exception to propagate
                // it upwards
                throw new RuntimeException(e);
    } 
    finally {
    	// Release resources in a finally block in reverse-order of
   	 	// their creation
		if (rs != null) {
        	try { rs.close();
        	} catch (SQLException e) { } // Ignore
            	rs = null;
            }
    	
            if (pstmt != null) {
            	try {
                	pstmt.close();
                } catch (SQLException e) { } // Ignore
                pstmt = null;
                }
            
          	if (conn != null) {
               	try { conn.close();
                } catch (SQLException e) { } // Ignore
                conn = null;
                }
  	}
%>