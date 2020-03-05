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
//	private ArrayList<TeunoDTO> list;
	
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
				System.out.println("존재 여부 : " + rslt.getInt("success"));
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
		String SQL = "select EXISTS (select * from user where user_name=? and user_password=?) as success";
		try {
			psmt = conn.prepareStatement(SQL);
			psmt.setString(1, userID);
			psmt.setString(2, userPW);
			rslt = psmt.executeQuery();
			rslt.first();
			if(rslt.getInt("success") != 0) {
				System.out.println("존재 여부 : " + rslt.getInt("success"));
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
		String SQL = "INSERT INTO user VALUES(?, ?, ?)";
		try {
			psmt = conn.prepareStatement(SQL);
			psmt.setString(1, userID);
			psmt.setString(2, userPW);
			psmt.setString(3, userEmail);
			psmt.execute();
		} catch(SQLException e) {
			e.printStackTrace();
		}
		try {
			psmt.close();
		} catch(SQLException e) {
			e.printStackTrace();
		}
		return true;
	}
	
	public TeunoDTO signIn(String userID, String userPW) {
		if (checkUser(userID, userPW) ) {
			System.out.println("불합당유저");
			return null;
		}
		String SQL = "SELECT user_name, user_email FROM user WHERE user_name=? AND user_password=?";
		TeunoDTO dto = new TeunoDTO();
		try {
			psmt = conn.prepareStatement(SQL);
			psmt.setString(1, userID);
			psmt.setString(2, userPW);
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
}
