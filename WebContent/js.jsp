<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="com.servlet.UserDTO" %>
<%@ page import="com.servlet.ProductDTO" %>
<%@ page import="com.servlet.TeunoDAO" %>
<%@ page import="java.net.URLDecoder" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JS</title>
</head>
<body>
	<%!
		TeunoDAO dao;
		String userName;
		String userEmail;
		String msg;
	%>
	<%
		dao = new TeunoDAO();
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
			var cards = $('.card');
			cards.hover(function(){
				$(this).removeClass("shadow");
				$(this).addClass("shadow-lg");
			}, function(){
				$(this).removeClass("shadow-lg");
				$(this).addClass("shadow");
			});
			var putInCart = $('.putInCart');
			putInCart.click(function(){
				var pId = $(this).data("product-id");
				console.log(pId);
				var f = $('<form action="putInCart.do" method="POST">' +
					'<input type="hidden" name="pId" value="' + pId +'">' +
				'</form>');
				$(document.body).append(f);
				f.submit();
			});
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
				var fContainer = $('<div class="form-container col-sm-6"></div>');
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
					main.html(fContainer);
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
					main.html(fContainer);
				<% } else { %>
					var cartList = [];
					<% 
						Cookie[] cookies = request.getCookies();
						if (cookies != null) {
							for (Cookie c : cookies) {
								String tmp = URLDecoder.decode(c.getValue(), "UTF-8");
								String name = URLDecoder.decode(c.getName(), "UTF-8");
								if (name.equals("productId")){
									ProductDTO pdto = dao.selectProduct(tmp);
									if(pdto != null) {
										String tName = pdto.getPruduct_name();
										String tDesc = pdto.getProduct_desc();
										String tSrc = pdto.getProduct_picture();
										%> 
											cartList.push({product_name : '<%= tName %>', product_desc : '<%= tDesc %>',
												picture_src : '<%= tSrc %>'});
										<%
									}
								}
							}
						}
					%>
					var cartBoard = $('<div class="card-deck row cartBoard"></div>');
					var boardTitle = $('<div class="col-sm-12">장바구니</div>');
					cartBoard.append(boardTitle);
					for (var p in cartList){
						var col = $('<div class="col-sm-3"></div>');
						var tCard = $('<div class="card shadow"></div>');
						var tImg = $('<img class="card-img-top"/>');
						var tCbody = $('<div class="card-body"></div>');
						var cTitle = $('<h5 class="card-title"></h5>');
						var cText = $('<p class="card-text"></p>');
						cTitle.text(cartList[p].product_name);
						cText.text(cartList[p].product_desc);
						tCbody.append(cTitle);
						tCbody.append(cText);
						tImg.attr('src', 'upload/' + cartList[p].picture_src);
						tCard.append(tImg);
						tCard.append(tCbody);
						col.append(tCard);
						cartBoard.append(col);
					}
					var acc = $('<h3>User ID : <%= userName %> </h3>' +
							'<h3>User Email : <%= userEmail %> </h3>' +						
							'<form action="LoginOrLogout.do" method="POST">' +
							  '<button type="submit" class="btn btn-primary">로그아웃</button>'+
							'</form>');
					fContainer.append(acc);
					main.empty();
					main.append(fContainer);
					main.append(cartBoard);
				<% } %>
			});
		});
	</script>
</body>
</html>