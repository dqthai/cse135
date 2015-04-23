package model;

import java.math.BigDecimal;

public class Product {
	private int id;
	private String name;
	private String sku;
	private BigDecimal price;
	private String category;

	public Product(int id, String name, String sku, BigDecimal price, String category) {
		this.id = id;
		this.name = name;
		this.sku = sku;
		this.price = price;
		this.category = category;
	}
	
	public int getId(){
		return this.id;
	}
	
	public String getName() {
		return this.name;
	}

	public String getSKU() {
		return this.sku;
	}

	public BigDecimal getPrice() {
		return this.price;
	}

	public String getCategory() {
		return this.category;
	}
	
	public void setId(int id){
		this.id = id;
	}
	
	public void setName(String name) {
		this.name = name;
	}

	public void setSKU(String sku) {
		this.sku = sku;
	}

	public void setPrice(BigDecimal price) {
		this.price = price;
	}

	public void setCategory(String category) {
		this.category = category;
	}
}
