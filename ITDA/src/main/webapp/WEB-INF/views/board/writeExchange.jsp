<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div class="wrapper">
		<header class="header">
			<jsp:include page="/WEB-INF/views/common/Header.jsp" />
		</header>
	</div>
	
	<section class="price-date-category">
		<div class="price-area">
			원하는 상품 <label>1순위</label> <input type="text"> <label>2순위</label>
			<input type="text">
		</div>

		<div class="category-area">
			<label>상품 카테고리</label>
			<div class="category-list">
				<span class="main-category">전자기기</span> &gt; <span
					class="sub-category">사진</span> &gt; <span class="detail-category">카메라</span>
			</div>
		</div>
	</section>
</body>
</html>