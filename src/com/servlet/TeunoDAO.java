package com.servlet;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class TeunoDAO {
	
	private Connection conn;
	private PreparedStatement psmt;
	private ResultSet rslt;
	
	public TeunoDAO() {
		String dbURL = "jdbc:mysql://localhost:3306/teuno_market?serverTimezone=UTC";
		String dbID = "Teuno";
		String dbPassword = "dogbook7!";
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn= DriverManager.getConnection(dbURL,dbID,dbPassword);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public void disConnect() {
		try {
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public boolean checkUserExistence(String userID) {
		String SQL = "select EXISTS (select * from user where user_name=?) as success";
		try {
			psmt = conn.prepareStatement(SQL);
			psmt.setString(1, userID);
			rslt = psmt.executeQuery();
			rslt.first();
			if(rslt.getInt("success") != 0) {
				return false;
			}
		} catch (SQLException e) {
			System.out.println("체크 에러");
			e.printStackTrace();
		}
		try {
			psmt.close();
			rslt.close();
		} catch(SQLException e) {
			e.printStackTrace();
		}
		return true;
	}
	
	public boolean checkUser(String userID, String userPW) {
		String SQL = "select EXISTS (select * from user where user_name=? and user_password=aes_encrypt(?, SHA2(?, 512))) as success";
		try {
			psmt = conn.prepareStatement(SQL);
			psmt.setString(1, userID);
			psmt.setString(2, userPW);
			psmt.setString(3, userPW);
			rslt = psmt.executeQuery();
			rslt.first();
			if(rslt.getInt("success") != 0) {
				return false;
			}
		} catch (SQLException e) {
			System.out.println("체크 에러");
			e.printStackTrace();
		}
		try {
			psmt.close();
			rslt.close();
		} catch(SQLException e) {
			e.printStackTrace();
		}
		return true;
	}
	
	public boolean signUp(String userID, String userPW, String userEmail) {
		if (!checkUserExistence(userID) ) {
			System.out.println("유저존재");
			return false;
		}
		String SQL = "INSERT INTO user VALUES(?, aes_encrypt(?, SHA2(?, 512)), ?)";
		try {
			psmt = conn.prepareStatement(SQL);
			psmt.setString(1, userID);
			psmt.setString(2, userPW);
			psmt.setString(3, userPW);
			psmt.setString(4, userEmail);
			psmt.execute();
		} catch(SQLException e) {
			e.printStackTrace();
			return false;
		}
		try {
			psmt.close();
		} catch(SQLException e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}
	
	public UserDTO signIn(String userID, String userPW) {
		if (checkUser(userID, userPW) ) {
			System.out.println("불합당유저");
			return null;
		}
		String SQL = "SELECT user_name, user_email FROM user WHERE user_name=? AND user_password=aes_encrypt(?, SHA2(?, 512))";
		UserDTO dto = new UserDTO();
		try {
			psmt = conn.prepareStatement(SQL);
			psmt.setString(1, userID);
			psmt.setString(2, userPW);
			psmt.setString(3, userPW);
			rslt = psmt.executeQuery();
			if(rslt.next()) {
				dto.setUserName(rslt.getString(1));
				dto.setUserEmail(rslt.getString(2));
			}
		} catch (SQLException e) {
			System.out.println("셀렉트 에러");
			e.printStackTrace();
		}
		try {
			rslt.close();
			psmt.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return dto;
	}
	
	public ArrayList<UserDTO> selectAll(){
		ArrayList<UserDTO> list = null;
		String SQL = "SELECT user_name, user_email FROM user";
		try {
			list = new ArrayList<UserDTO>();
			psmt = conn.prepareStatement(SQL);
			rslt = psmt.executeQuery();
			while(rslt.next()) {
				UserDTO dto = new UserDTO();
				dto.setUserName(rslt.getString(1));
				dto.setUserEmail(rslt.getString(2));
				list.add(dto);
			}
		} catch (SQLException e) {
			System.out.println("셀렉트올 에러");
			e.printStackTrace();
		}
		try {
			rslt.close();
			psmt.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public boolean deleteUser(String userName, String userEmail) {
		String SQL = "DELETE FROM user WHERE user_name=? AND user_email=?";
		try {
			psmt = conn.prepareStatement(SQL);
			psmt.setString(1, userName);
			psmt.setString(2, userEmail);
			if(!psmt.execute()) return false;
		} catch (SQLException e) {
			System.out.println("딜리트 에러");
			e.printStackTrace();
		}
		try {
			psmt.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return true;
	}
	
	public boolean insertProduct(String product_name, String product_desc, String product_picture, String upload_date) {
		String SQL = "INSERT INTO product(product_name, product_desc, picture_src, upload_date) VALUES(?, ?, ?, ?)";
		try {
			psmt = conn.prepareStatement(SQL);
			psmt.setString(1, product_name);
			psmt.setString(2, product_desc);
			psmt.setString(3, product_picture);
			psmt.setString(4, upload_date);
			if(!psmt.execute()) {
				return false;
			}
		} catch (SQLException e) {
			System.out.println("상품 입력 에러");
			e.printStackTrace();
		}
		try {
			psmt.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return true;
	}
	
	public ProductDTO selectProduct(String product_id) {
		ProductDTO dto = null;
		String SQL = "SELECT product_name, product_desc, picture_src, upload_date FROM product WHERE product_id=?";
		try {
			int pId = Integer.parseInt(product_id);
			psmt = conn.prepareStatement(SQL);
			psmt.setInt(1, pId);
			rslt = psmt.executeQuery();
			while(rslt.next()) {
				dto = new ProductDTO();
				dto.setPruduct_name(rslt.getString(1));
				dto.setProduct_desc(rslt.getString(2));
				dto.setProduct_picture(rslt.getString(3));
				dto.setUpload_date(rslt.getString(4));
			}
		} catch (SQLException e) {
			System.out.println("상품 셀렉트 에러");
			e.printStackTrace();
		}
		try {
			rslt.close();
			psmt.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return dto;
	}
	
	public ArrayList<ProductDTO> selectProductAll(){
		ArrayList<ProductDTO> list = null;
		String SQL = "SELECT * FROM product";
		try {
			list = new ArrayList<ProductDTO>();
			psmt = conn.prepareStatement(SQL);
			rslt = psmt.executeQuery();
			while(rslt.next()) {
				ProductDTO dto = new ProductDTO();
				dto.setProduct_id(rslt.getInt(1));
				dto.setPruduct_name(rslt.getString(2));
				dto.setProduct_desc(rslt.getString(3));
				dto.setProduct_picture(rslt.getString(4));
				dto.setUpload_date(rslt.getString(5));
				list.add(dto);
			}
		} catch (SQLException e) {
			System.out.println("상품 셀렉트올 에러");
			e.printStackTrace();
		}
		try {
			rslt.close();
			psmt.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public boolean deleteProduct(int product_id) {
		String SQL = "DELETE FROM product WHERE product_id=?";
		try {
			psmt = conn.prepareStatement(SQL);
			psmt.setInt(1, product_id);
			if(!psmt.execute()) return false;
		} catch (SQLException e) {
			System.out.println("상품 딜리트 에러");
			e.printStackTrace();
		}
		try {
			psmt.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return true;
	}
	
}
