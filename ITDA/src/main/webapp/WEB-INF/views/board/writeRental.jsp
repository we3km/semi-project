<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<section class="price-date-category">
		<div class="price-area">
			<label>대여 가격</label> <input type="text"> 원 <label>보증금</label>
			<input type="text"> 원
		</div>

		<div class="date-area">
			<label>대여 기간</label>
			<div class="dates">
				<input type="date" value="2025-07-01"> 부터 <input type="date"
					value="2025-07-07"> 까지
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
</body>
</html>