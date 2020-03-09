package com.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

@WebServlet("*.do")
public class TeunoController extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private String url;
    private TeunoDAO dao;
    private UserDTO dto;
    private HttpSession session;
    
    public TeunoController() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		url = request.getRequestURI().split("/TeunoMarket/")[1];
		session = request.getSession();
		System.out.println(url);
		if(url.compareTo("LoginOrLogout.do") == 0) {
			System.out.println("로그인올로그아웃");
			dto = (UserDTO)session.getAttribute("userObj");
			if (dto == null) {
				dao = new TeunoDAO();
				String userID = request.getParameter("userID");
				String userPW = request.getParameter("userPW");
				dto = dao.signIn(userID, userPW);
				if (dto == null) {
					session.setAttribute("msg", "SignInError");
				}
				else {
					session.removeAttribute("msg");
					session.setAttribute("userObj", dto);
				}
				dao.disConnect();
			} else {
				session.removeAttribute("userObj");
			}
		}
		else if (url.compareTo("SignUp.do") == 0) {
			System.out.println("사인업");
			dao = new TeunoDAO();
			dto = new UserDTO();
			String userID = request.getParameter("userID");
			String userPW = request.getParameter("userPW");
			String userEmail = request.getParameter("userEmail");
			if (dao.signUp(userID, userPW, userEmail)) {
				dto.setUserName(userID);
				dto.setUserEmail(userEmail);
				session.removeAttribute("msg");
				session.setAttribute("userObj", dto);
			}
			else {
				session.setAttribute("msg", "SignUpError");
			}
			dao.disConnect();
		}
		else if (url.compareTo("adminUpload.do") == 0) {
			System.out.println("상품 업로드");
			String saveDir = getServletContext().getRealPath("upload");
			System.out.println(saveDir);
			int maxSize = 10 * 1024 * 1024;
			
			MultipartRequest multi = new MultipartRequest(request, saveDir, maxSize, "UTF-8", new DefaultFileRenamePolicy());
			String product_name = multi.getParameter("productName");
			String product_desc = multi.getParameter("productDesc");
			String product_picture = multi.getOriginalFileName("picture");
			String upload_date = multi.getParameter("uploadDate");
			System.out.println("사진 이름 : " + product_picture);
			dao = new TeunoDAO();
			if(!dao.insertProduct(product_name, product_desc, product_picture, upload_date)) {
				session.setAttribute("AdminMsg", "ProductInsertError");
			}
			dao.disConnect();
			
		}
		else if (url.compareTo("deleteUser.do") == 0) {
			dao = new TeunoDAO();
			String userName = request.getParameter("userName");
			String userEmail = request.getParameter("userEmail");
			if(!dao.deleteUser(userName, userEmail)) {
				session.setAttribute("AdminMsg", "DeleteError");
			}
			dao.disConnect();
		}
		response.sendRedirect("main");
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
