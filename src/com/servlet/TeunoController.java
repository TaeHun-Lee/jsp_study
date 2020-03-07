package com.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("*.do")
public class TeunoController extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private String url;
    private TeunoDAO dao;
    private TeunoDTO dto;
    private HttpSession session;
    
    public TeunoController() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		url = request.getRequestURI().split("/TeunoMarket/")[1];
		session = request.getSession();
		System.out.println(url);
		if(url.compareTo("LoginOrLogout.do") == 0) {
			System.out.println("�α��ο÷α׾ƿ�");
			dto = (TeunoDTO)session.getAttribute("userObj");
			if (dto == null) {
				dao = new TeunoDAO();
				String userID = request.getParameter("userID");
				String userPW = request.getParameter("userPW");
				dto = dao.signIn(userID, userPW);
				session.setAttribute("userObj", dto);
				dao.disConnect();
			} else {
				session.removeAttribute("userObj");
			}
		}
		else if (url == "SignUp.do") {
			System.out.println("���ξ�");
			dao = new TeunoDAO();
			dto = new TeunoDTO();
			String userID = request.getParameter("userID");
			String userPW = request.getParameter("userPW");
			String userEmail = request.getParameter("userEmail");
			dao.signUp(userID, userPW, userEmail);
			dto.setUserName(userID);
			dto.setUserEmail(userEmail);
			session.setAttribute("userObj", dto);
			response.sendRedirect("main");
			dao.disConnect();
		}
		response.sendRedirect("main");
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
