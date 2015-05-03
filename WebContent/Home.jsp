<!-- Watch out for the different types of parameters: 
	requests/forms and sessions -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Home</title>
</head>
<body>
	<!-- TODO: Show certain links based on role -->
	<%
	String u_name = null;
	if (session.getAttribute("u_name") == null ||
		session.getAttribute("login_status") == null ||
		!session.getAttribute("login_status").equals("success"))
	{
		%>
		<p>No user logged in</p>
		
		<% 
	}
	
	else {
	
		u_name = new String((String)session.getAttribute("u_name"));
		/* Possible gratuitous check
		if (session.getAttribute("login_status") != null &&
			session.getAttribute("login_status").equals("success"))
		*/
		{
		
			
			String u_role = new String((String)session.getAttribute("u_role"));
			System.out.println("session user is " + 
								u_name + " with role as " + u_role);
			%>
			<p>Hello, <%=u_name %></p>
			
			<!-- Customer pages -->
			<li><a href="BuyShoppingCart.jsp">Shopping Cart</a></li>
			<li><a href="Browse.jsp">Product Browsing</a></li>
			<%
			if (u_role.equals("owner"))
			{
				%>
				<li><a href="Categories.jsp">Categories</a></li>
				<li><a href="Product.jsp">Products</a></li>
				<%
			}
			
		}	
	}

	%>

</body>
</html>