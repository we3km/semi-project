<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<title>Insert title here</title>
<style>
body {
	font-family: 'Noto Sans KR', sans-serif;
	background: #fefefe;
	margin: 0;
	padding: 0;
}

.container {
	max-width: 1000px;
	margin: 30px auto;
	padding: 20px;
}

header {
	display: flex;
	align-items: center;
	justify-content: space-between;
	border-bottom: 1px solid #ccc;
	padding-bottom: 10px;
}

h1 {
	font-size: 28px;
}

.highlight {
	color: #6B63FF;
}

.region {
	font-size: 16px;
	color: #666;
}

.region-name {
	color: #6B63FF;
	font-weight: bold;
}

.buttons button {
	margin-left: 10px;
	padding: 8px 16px;
	border: none;
	border-radius: 20px;
	font-size: 14px;
	cursor: pointer;
}

.cancel {
	background-color: #eee;
}

.submit {
	background-color: #6B63FF;
	color: white;
}

main {
	display: flex;
	flex-wrap: wrap;
	gap: 20px;
	margin-top: 30px;
}

.image-upload {
	flex: 1;
	min-width: 280px;
}

.image-upload .main-image img {
	width: 100%;
	max-width: 200px;
	border-radius: 12px;
}

.thumbnail-list {
	display: flex;
	gap: 10px;
	margin-top: 10px;
}

.thumbnail-list img {
	width: 50px;
	height: 50px;
	border-radius: 8px;
	object-fit: cover;
}

.add-thumbnail {
	width: 50px;
	height: 50px;
	border: 2px dashed #ccc;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 24px;
	border-radius: 8px;
	cursor: pointer;
}

.info-input {
	flex: 2;
	display: flex;
	flex-direction: column;
	gap: 10px;
}

.title-input {
	font-size: 18px;
	padding: 10px;
	border-radius: 6px;
	border: 1px solid #ccc;
}

.tag-input {
	display: flex;
	align-items: center;
	gap: 10px;
}

.tag-input input {
	flex: 1;
	padding: 8px;
	border-radius: 6px;
	border: 1px solid #ccc;
}

.tag {
	background-color: #6B63FF;
	color: white;
	padding: 5px 10px;
	border-radius: 20px;
	font-size: 14px;
}

.description {
	height: 150px;
	padding: 10px;
	font-size: 14px;
	border-radius: 6px;
	border: 1px solid #ccc;
	resize: none;
}

.price-date-category {
	width: 100%;
	display: flex;
	gap: 20px;
	margin-top: 20px;
}

.price-area, .date-area, .category-area {
	flex: 1;
	display: flex;
	flex-direction: column;
	gap: 10px;
}

.price-area input, .date-area input {
	padding: 8px;
	border-radius: 6px;
	border: 1px solid #ccc;
}

.category-list {
	font-size: 14px;
	color: #6B63FF;
}

#board-category {
	width: 100px;
	background: #ADAAF8;
	border-radius: 20px;
	font-size: 14px;
	cursor: pointer;
}

img {
	width: 100px;
}
</style>

</head>

<body>
	<div class="container">
		<form:form modelAttribute="board"
			action="${pageContext.request.contextPath}/board/write/${boardCategory}"
			method="post" enctype="multipart/form-data">
			<header>
				<c:choose>
					<c:when test="${boardCategory eq 'rental'}">
						<h1>
							<span class="highlight">대여</span> 글쓰기
						</h1>
					</c:when>
					<c:when test="${boardCategory eq 'auction'}">
						<h1>
							<span class="highlight">경매</span> 글쓰기
						</h1>
					</c:when>
					<c:when test="${boardCategory eq 'exchange'}">
						<h1>
							<span class="highlight">교환</span> 글쓰기
						</h1>
					</c:when>
					<c:when test="${boardCategory eq 'share'}">
						<h1>
							<span class="highlight">나눔</span> 글쓰기
						</h1>
					</c:when>
				</c:choose>
				<select id="board-category" name="board-category">
					<option value="rental"
						${boardCategory == 'rental' ? 'selected' : ''}>대여</option>
					<option value="auction"
						${boardCategory == 'auction' ? 'selected' : ''}>경매</option>
					<option value="exchange"
						${boardCategory == 'exchange' ? 'selected' : ''}>교환</option>
					<option value="share" ${boardCategory == 'share' ? 'selected' : ''}>나눔</option>
				</select>

				<div class="region">
					거래지역 &gt; <span class="region-name">서울특별시 강남구 📍</span>
				</div>
				<div class="buttons">
					<button id="cancel-btn" class="cancel">작성 취소</button>
					<button id="submit-btn" type="submit">작성 완료</button>
				</div>
			</header>

			<main>
				<section class="image-upload">
					<p>상품 이미지(2/10)</p>
					<div class="main-image">
						<img class="preview">
					</div>

					<input type="file" id="upfile" class="form-control" name="upfile"
						multiple accept="image/*">

				</section>

				<section class="info-input">
					<form:input path="boardCommon.productName" type="text"
						placeholder="상품명" cssClass="title-input" />


					<div class="tag-input">
						<input type="text" id="tagInput" placeholder="태그 입력 후 Enter" />

						
						
						<span class="tag">#DSLR ✕</span>
					</div>
					<script>

					</script>


					<form:textarea path="boardCommon.productComment"
						placeholder="상품 설명" cssClass="description" />
				</section>


			</main>

			<c:choose>
				<c:when test="${boardCategory eq 'rental'}">
					<section class="price-date-category">
						<div class="price-area">
							<label>대여 가격</label>
							<form:input path="boardRental.rentalFee" type="text" />
							원 <label>보증금</label>
							<form:input path="boardRental.deposit" type="text" />
							원
						</div>

						<div class="date-area">
							<label>대여 기간</label>
							<div class="dates">
								<form:input path="boardRental.rentalStartDate" type="date" />
								부터
								<form:input path="boardRental.rentalEndDate" type="date" />
								까지
							</div>
						</div>

						<div class="category-area">
							<label>상품 카테고리</label>
							<div class="category-list">
								<span class="main-category">전자기기</span> &gt; <span
									class="sub-category">사진</span> &gt; <span
									class="detail-category">카메라</span>
							</div>
						</div>
					</section>
				</c:when>
				<c:when test="${boardCategory eq 'auction'}">
					<jsp:include page="/WEB-INF/views/board/writeAuction.jsp"></jsp:include>
				</c:when>
				<c:when test="${boardCategory eq 'exchange'}">
					<jsp:include page="/WEB-INF/views/board/writeExchange.jsp"></jsp:include>
				</c:when>
				<c:when test="${boardCategory eq 'share'}">
					<jsp:include page="/WEB-INF/views/board/writeShare.jsp"></jsp:include>
				</c:when>
			</c:choose>

		</form:form>
	</div>


	<script>
		$(function() {

			$("#board-category").on(
					"change",
					function() {
						const selectedCategory = this.value;
						var contextPath = "${pageContext.request.contextPath}";
						window.location.href = contextPath + "/board/write/"
								+ selectedCategory;

					})
		})
	</script>
</body>
</html>