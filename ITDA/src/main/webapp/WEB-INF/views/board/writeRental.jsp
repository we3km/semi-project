<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<form:form modelAttribute="board" action="${pageContext.request.contextPath}/board/write/${boardCategory}"  method="post">
	<section class="price-date-category">
		<div class="price-area">
			<label>대여 가격</label> <form:input path="boardRental.rentalFee" type="text"/> 원 
			<label>보증금</label>
			<form:input path="boardRental.deposit" type="text"/> 원
		</div>

		<div class="date-area">
			<label>대여 기간</label>
			<div class="dates">
				<form:input path="boardRental.rentalStartDate" type="date" value="2025-07-01"/> 부터 
				<form:input path="boardRental.rentalEndDate" type="date"
					value="2025-07-07"/> 까지
			</div>
		</div>

		<div class="category-area">
			<label>상품 카테고리</label>
			<div class="category-list">
				<span class="main-category">전자기기</span> &gt; <span
					class="sub-category">사진</span> &gt; <span class="detail-category">카메라</span>
			</div>
		</div>
	</section>
	</form:form>
</body>
</html>