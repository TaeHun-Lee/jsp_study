package com.servlet;

public class ProductDTO {
	private int product_id;
	private String pruduct_name;
	private String product_desc;
	private String product_picture;
	private String upload_date;
	
	public int getProduct_id() {
		return product_id;
	}
	public void setProduct_id(int product_id) {
		this.product_id = product_id;
	}
	public String getPruduct_name() {
		return pruduct_name;
	}
	public void setPruduct_name(String pruduct_name) {
		this.pruduct_name = pruduct_name;
	}
	public String getProduct_desc() {
		return product_desc;
	}
	public void setProduct_desc(String product_desc) {
		this.product_desc = product_desc;
	}
	public String getProduct_picture() {
		return product_picture;
	}
	public void setProduct_picture(String product_picture) {
		this.product_picture = product_picture;
	}
	public String getUpload_date() {
		return upload_date;
	}
	public void setUpload_date(String upload_date) {
		this.upload_date = upload_date;
	}
}
