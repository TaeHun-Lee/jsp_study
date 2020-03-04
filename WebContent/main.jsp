<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="com.servlet.TeunoDTO" %>
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
		max-width: 25em;
		transition: all .5s ease-in-out;
		background: white;
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
		String userName;
		String userEmail;
	%>
	<% 
		TeunoDTO dto = (TeunoDTO)session.getAttribute("userObj");
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
	  <div class="main form-container off-canvas">
	  	<h1><%= userName %></h1>
	  	
	  </div>
	</div>
	<script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
	<script>
		$(document).ready(function(){
			var navList = $(".nav-link");
			var main = $(".main");
			var about = navList[0];
			var product = navList[1];
			var icon = navList[2];
			var contact = navList[3];
			var myPage = navList[4];
			$(about).click(function(e){
				e.preventDefault();
				main.html("<h1>This is About Page</h1>");
			});
			$(product).click(function(e){
				e.preventDefault();
				main.html("<h1>This is Product Page</h1>");
			});
			$(contact).click(function(e){
				e.preventDefault();
				main.html("<h1>This is Contact Page</h1>");
			});
			$(myPage).click(function(e){
				e.preventDefault();
				<% if (dto == null) { %>
					var formEl = $('<form method="POST"></form>');
					var formGroupEl = $('<div class="form-group"></div>');
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
					var fClone = formEl.clone();
					var fgClone = formGroupEl.clone();
					createFormGroupEl(fgClone, 'ID', 'text', 'userID');
					createFormGroupEl(fgClone, 'Password', 'password', 'userPW');
					createFormEl(fClone, fgClone, 'LoginOrLogout', '로그인');
					main.html(fClone);
					var signUp = $('<button />', {
						'class' : 'btn btn-primary',
						text : '회원가입',
						click : function(e){
							e.preventDefault();
							fClone = formEl.clone();
							fgClone = formGroupEl.clone();
							createFormGroupEl(fgClone, 'ID', 'text', 'userID');
							createFormGroupEl(fgClone, 'Password', 'password', 'userPW');
							createFormGroupEl(fgClone, 'Email', 'email', 'userEmail');
							createFormEl(fClone, fgClone, 'SignUp', '회원가입');
							main.html(fClone);
						}
					});
					main.append(signUp);
				<% } else { %>
					main.html('<h1>User ID : <%= userName %> </h1>' +
							'<h1>User Email : <%= userEmail %> </h1>' +
							'<form action="LoginOrLogout" method="POST">' +
							  '<button type="submit" class="btn btn-primary">로그아웃</button>'+
							'</form>');
				<% } %>
			});
		});
	</script>
</body>
</html>