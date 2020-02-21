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
	private ArrayList<TeunoDTO> list;
	
	public TeunoDAO() {
		String dbURL = "jdbc:mysql://localhost:3306/teuno_market?serverTimezone=UTC";
		String dbID = "Teuno";
		String dbPassword = "dogbook7!";
		list = new ArrayList<TeunoDTO>();
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn= DriverManager.getConnection(dbURL,dbID,dbPassword);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public ArrayList<TeunoDTO> selectUser() {
		String SQL= "SELECT * FROM user";
		try {
			psmt = conn.prepareStatement(SQL);
			rslt = psmt.executeQuery();
			while (rslt.next()) {
				TeunoDTO dto = new TeunoDTO();
				dto.setUserName(rslt.getString(1));
				dto.setUserPassword(rslt.getString(2));
				dto.setUserEmail(rslt.getString(3));
				list.add(dto);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}
}
