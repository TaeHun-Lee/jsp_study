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
<title>Teuno Market</title>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
<link rel="stylesheet" type="text/css" href="<%= getServletContext().getContextPath() %>/css-js/main.css">
<link rel="shortcut icon" href="<%= getServletContext().getContextPath() %>/img/favicon.png" type="image/x-icon" />
<link rel="icon" href="<%= getServletContext().getContextPath() %>/img/favicon.png" type="image/x-icon" />
</head>
<body>
	<div class="container-fluid">
	<%!
		TeunoDAO dao;
	%>
	<%
		dao = new TeunoDAO();
		ArrayList<ProductDTO> pList = dao.selectProductAll();
		UserDTO dto = (UserDTO)session.getAttribute("userObj");
	%>
	  <nav class="nav nav-pills nav-justified justify-content-center align-items-center">
	  	<a class="nav-item nav-link" href="#">About</a>
	  	<a class="nav-item nav-link" href="#">Product</a>
	    <a class="nav-item nav-link" href="#"><img src="<%= getServletContext().getContextPath() %>/img/logo.png" height="125" width="125"></a>
	    <a class="nav-item nav-link" href="#">Contact</a>
	    <a class="nav-item nav-link" href="#">My Page</a>
	  </nav>
	  <div class="main">
	  	<div class="card-deck row">
	  		<% for(int i=0; i<pList.size(); i++) { %>
	  		<div class="col-sm-3">
			  <div class="card shadow" data-toggle="modal" data-target="#productCard<%= i %>">
			    <img src="upload/<%= pList.get(i).getProduct_picture() %>" class="card-img-top" alt="상품 사진">
			    <div class="card-body">
			      <h5 class="card-title"><%= pList.get(i).getPruduct_name() %></h5>
			      <p class="card-text"><%= pList.get(i).getProduct_desc() %></p>
			      <p class="card-text"><small class="text-muted"><%= pList.get(i).getUpload_date() %></small></p>
			    </div>
			  </div>
			</div>
			<div class="modal fade" id="productCard<%= i %>" tabindex="-1" role="dialog" aria-labelledby="productCardTitle" aria-hidden="true">
			  <div class="modal-dialog modal-dialog-scrollable modal-dialog-centered" role="document">
			    <div class="modal-content">
			      <div class="modal-header">
			        <h5 class="modal-title" id="productCardTitle"><%= pList.get(i).getPruduct_name() %></h5>
			      </div>
			      <div class="modal-body">
			      	<img src="upload/<%= pList.get(i).getProduct_picture() %>" class="card-img-top" alt="상품 사진">
			        <p class="card-text"><%= pList.get(i).getProduct_desc() %></p>
			        <small class="text-muted"><%= pList.get(i).getUpload_date() %></small>
			      </div>
			      <div class="modal-footer">
			      	<% if (dto != null) { %>
			      	<button type="button" class="btn btn-primary putInCart"
			      		data-product-id="<%= pList.get(i).getProduct_id() %>"
			      	>장바구니 담기</button>
			      	<% } %>
			        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
			      </div>
			    </div>
			  </div>
			</div>
			<% } %>
		</div>
	  </div>
	</div>
	<jsp:include page="js.jsp"></jsp:include>
</body>
</html>