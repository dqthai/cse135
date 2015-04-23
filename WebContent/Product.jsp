<% 
String name = null;//get the name
String category = null;//get the category
%>

<div>
	<div>
		<h1>Products</h1>
		<div>
			<h2>Categories</h2>
		</div>

		<form action="product" method="get">
			<h2>Search</h2>
			<label>Name</label>
			<input type="text" name="name" value="<%=name%>"></input><br>
			<input type="hidden" name="category" value="<%=category%>"></input>
			<input type="submit" value="Search">
		</form>

		<form action="product" method="post">
			<h2>Add New Product</h2>
			<label>Name</label><input type="text" name="name" id="name"></input><br>
			<label>SKU</label><input type="text" name="sku" id="sku"></input><br>
			<label>List price</label><input type="text" name="price" id="price"></input><br>
			<label>Category</label>
			<select name="category" id="category">
			
			</select><br>
			<input type="submit" onClick="productAction(null,'insert'); return false;" value="Add product">
		</form>
	</div>

	<div>
	</div>

</div>