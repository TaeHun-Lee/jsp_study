<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="com.servlet.UserDTO" %>
<%@ page import="com.servlet.ProductDTO" %>
<%@ page import="com.servlet.TeunoDAO" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Teuno Market</title>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
<link rel="stylesheet" type="text/css" href="<%= getServletContext().getContextPath() %>/css-js/main.css">
<link rel="shortcut icon" href="<%= getServletContext().getContextPath() %>/img/favicon.png" type="image/x-icon" />
<link rel="icon" href="<%= getServletContext().getContextPath() %>/img/favicon.png" type="image/x-icon" />
<style>
	.main {
		text-align: center;
	}
	.form-container {
		margin: 0 auto;
		transition: all .5s ease-in-out;
	  	padding: 1.5em;
	  	border-radius: 1em;
	  	box-shadow: 0px 0px 1em #ddd;
	}
	label { color: #d9534f ; }
	button { 
	    background: #008CBA;
	    margin: .5em;
	}
	button:hover {
		background: darken(#008CBA, 5%);
	}
</style>
</head>
<body>
	<div class="container-fluid">
	<%!
		TeunoDAO dao;
		String userName;
		String userEmail;
		String msg;
	%>
	<%
		dao = new TeunoDAO();
		ArrayList<ProductDTO> pList = dao.selectProductAll();
		UserDTO dto = (UserDTO)session.getAttribute("userObj");
		msg = (String)session.getAttribute("msg");
		if (dto != null) {
			userName = dto.getUserName();
			userEmail = dto.getUserEmail();
		}
		else {
			userName = null;
			userEmail = null;
		}
	%>
	  <nav class="nav nav-pills nav-justified justify-content-center align-items-center">
	  	<a class="nav-item nav-link" href="#">About</a>
	  	<a class="nav-item nav-link" href="#">Product</a>
	    <a class="nav-item nav-link" href="#"><img src="<%= getServletContext().getContextPath() %>/img/logo.png" height="125" width="125"></a>
	    <a class="nav-item nav-link" href="#">Contact</a>
	    <a class="nav-item nav-link" href="#">My Page</a>
	  </nav>
	  <div class="main row">
	  	<div class="card-deck row">
	  		<% for(int i=0; i<pList.size(); i++) { %>
	  		<div class="col-sm-3">
			  <div class="card">
			    <img src="upload/<%= pList.get(i).getProduct_picture() %>" class="card-img-top" alt="상품 사진">
			    <div class="card-body">
			      <h5 class="card-title"><%= pList.get(i).getPruduct_name() %></h5>
			      <p class="card-text"><%= pList.get(i).getProduct_desc() %></p>
			      <p class="card-text"><small class="text-muted"><%= pList.get(i).getUpload_date() %></small></p>
			    </div>
			  </div>
			</div>
			<% } %>
		</div>
	  </div>
	</div>
	<script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
	<script>
		$(document).ready(function(){
			var navList = $(".nav-link");
			var main = $(".main");
			var main_bu = main.children();
			var about = navList[0];
			var product = navList[1];
			var icon = navList[2];
			var contact = navList[3];
			var myPage = navList[4];
			<% if (msg != null) { %>
				switch("<%= msg %>"){
				case "SignInError":
					alert("로그인 실패");
					<% session.removeAttribute("msg"); %>
					break;
				case "SignUpError":
					alert("회원가입 실패");
					<% session.removeAttribute("msg"); %>
					break;
				}
			<% } %>
			$(about).click(function(e){
				e.preventDefault();
				main.html("<h1>This is About Page</h1>");
			});
			$(product).click(function(e){
				e.preventDefault();
				main.html("<h1>This is Product Page</h1>");
			});
			$(icon).click(function(e){
				e.preventDefault();
				main.html(main_bu);
			});
			$(contact).click(function(e){
				e.preventDefault();
				main.html("<h1>This is Contact Page</h1>");
			});
			$(myPage).click(function(e){
				e.preventDefault();
				var fContainer = $('<div class="form-container col-6"></div>');
				<% if (dto == null) { %>
				
					var formEl = $('<form method="POST"></form>');
					var formGroupEl = $('<div class="form-group"></div>');
					
					var signUp = $('<button />', {
						'class' : 'btn btn-primary',
						text : '회원가입',
						click : function(e){
							e.preventDefault();
							
							formGroupEl.empty();
							formEl.empty();
							fContainer.empty();
							createFormGroupEl(formGroupEl, 'ID', 'text', 'userID');
							createFormGroupEl(formGroupEl, 'Password', 'password', 'userPW');
							createFormGroupEl(formGroupEl, 'Email', 'email', 'userEmail');
							createFormEl(formEl, formGroupEl, 'SignUp.do', '회원가입');
							fContainer.append(formEl);
							main.html(fContainer);
						}
					});
					
					function createFormGroupEl(formGroupEl, labelName, inputType, inputName) {
						var labelEl = $('<label>' + labelName + '</label>');
						var inputEl = $('<input class="form-control" aria-required="true" aria-invalid="true" required>');
						inputEl.attr('type', inputType).attr('name', inputName);
						labelEl.appendTo(formGroupEl);
						inputEl.appendTo(formGroupEl);
					};
					function createFormEl(formEl, formGroupEl, action, buttonText) {
						formEl.attr('action', action);
						var button = $('<button type="submit" class="btn btn-primary">' + buttonText + '</button>');
						formGroupEl.appendTo(formEl);
						button.appendTo(formEl);
					};
				
					createFormGroupEl(formGroupEl, 'ID', 'text', 'userID');
					createFormGroupEl(formGroupEl, 'Password', 'password', 'userPW');
					createFormEl(formEl, formGroupEl, 'LoginOrLogout.do', '로그인');
					
					fContainer.append(formEl);
					fContainer.append(signUp);
				
				<% } else if(userName.compareTo("admin") == 0 && userEmail.compareTo("admin@admin.com") == 0) { %>
					<%! ArrayList<UserDTO> list; %>
					<% list = dao.selectAll(); %>
					var board = $('<h1>관리자 영역</h1>'+
					'<div class="table-responsive">'+
					'<table class="table">'+
					  '<thead class="thead-dark">'+
					    '<tr>'+
					      '<th scope="col"></th>'+
					      '<th scope="col">User Name</th>'+
					      '<th scope="col">User Email</th>'+
					      '<th scope="col">Action</th>'+
					    '</tr>'+
					  '</thead>'+
					  '<tbody>'+
					  	<% for(int i=0; i<list.size(); i++) { %>
					    '<tr>'+
					      '<th scope="row"><%= i+1 %></th>'+
					      '<td><%= list.get(i).getUserName() %></td>'+
					      '<td><%= list.get(i).getUserEmail()%></td>'+
					      '<td><form action="deleteUser.do" method="POST">'+
					      '<input type="hidden" name="userName" value="<%= list.get(i).getUserName() %>">'+
					      '<input type="hidden" name="userEmail" value="<%= list.get(i).getUserEmail()%>">'+
					      '<button type="submit" class="btn btn-primary">유저 삭제</button></form></td>'+
					    '</tr>'+
					    <% } %>
					  '</tbody>'+
					'</table>'+
					'</div>');
					var uploadButton = $('<button />', {
						'class' : 'btn btn-primary',
						text : '상품 업로드',
						click : function(e){
							e.preventDefault();
							var adminForm = $('<form action="adminUpload.do" method="POST" enctype="Multipart/form-data">' +
									'<label>상품명</label>' +
									'<input class="form-control" aria-required="true" aria-invalid="true" type="text" name="productName" required>' +
									'<label>사진</label>' +
									'<input class="form-control" aria-required="true" aria-invalid="true" type="file" name="picture" required>' +
									'<label>상품 설명</label>' +
									'<input class="form-control" aria-required="true" aria-invalid="true" type="text" name="productDesc" required>' +
									'<input type="hidden" name="uploadDate" id="uploadDate" value="' + new Date().toLocaleString() + '">' +
									'<button type="submit" class="btn btn-primary">업로드</button>'+
								'</form>');
							this.remove();
							fContainer.append(adminForm);
						}
					});
					var logOut = $('<form action="LoginOrLogout.do" method="POST">' +
							  '<button type="submit" class="btn btn-primary">로그아웃</button>'+
								'</form>');
					fContainer.append(board);
					fContainer.append(uploadButton);
					fContainer.append(logOut);
					
				<% } else { %>
					var acc = $('<h1>User ID : <%= userName %> </h1>' +
							'<h1>User Email : <%= userEmail %> </h1>' +
							'<form action="LoginOrLogout.do" method="POST">' +
							  '<button type="submit" class="btn btn-primary">로그아웃</button>'+
							'</form>');
					fContainer.append(acc);
				<% } %>
				main.html(fContainer);
			});
		});
	</script>
</body>
</html>