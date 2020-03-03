package com.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/LoginOrLogout")
public class LoginOrLogout extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public LoginOrLogout() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		TeunoDTO dto = (TeunoDTO)session.getAttribute("userObj");
		if (dto == null) {
			System.out.println("로그인");
			String userID = request.getParameter("userID");
			String userPW = request.getParameter("userPW");
			TeunoDAO dao = new TeunoDAO();
			dto = dao.selectUser(userID, userPW);
			session.setAttribute("userObj", dto);
			dao.disConnect();
		} else {
			System.out.println("로그아웃" + dto.getUserName());
			session.removeAttribute("userObj");
		}
		response.sendRedirect("main");
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
