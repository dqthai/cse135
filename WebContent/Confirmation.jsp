<%@ page import="java.util.*,java.sql.*" %>

<%
	
	List<String> products = new ArrayList<String>();
	List<Integer> quantities = new ArrayList<Integer>();
	
	if (session.getAttribute("products") != null){
		products = (ArrayList<String>) session.getAttribute("products");
	}

	if (session.getAttribute("quantities") != null){
		quantities = (ArrayList<Integer>) session.getAttribute("quantities");
	}
	
	//---test code--------------------
// 	products.add("Diamond");		
// 	products.add("Orange");			
// 	quantities.add(9000);			
// 	quantities.add(420);			
	//---test code--------------------
	
	
	%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Payment Confirmation</title>
</head>
<body>
Purchase Confirmed Bitch
<table>
<tr>
<th>your stuff</th>
</tr>
	<%
		if (products != null) {
			for (int i = 0; i < products.size(); i++) {
				String product = products.get(i);
				int quantity = quantities.get(i);
	%>
			<tr>
				<td><%=product%></td>
				<td><%=quantity%></td>
			</tr>
			<%
			}
	        session.setAttribute("p_ids",null);
	        session.setAttribute("prices",null);
	        session.setAttribute("quantities",null);
	        session.setAttribute("products",null);
			} else { 
				out.println("empty");
			}
			
			%>

</table>
<a href="Browse.jsp">go back to browse</a>
</body>
</html>