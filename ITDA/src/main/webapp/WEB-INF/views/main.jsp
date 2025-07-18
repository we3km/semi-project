<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- JSTL c태그를 사용하기 위한 태그 라이브러리 (c:url 등 사용 시 필요) --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%-- 모바일 뷰 --%>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>IT다</title>
<link
	href="https://fonts.googleapis.com/css2?family=SUIT:wght@400;600;700&display=swap"
	rel="stylesheet">

<%-- mainPage CSS 파일 --%>
<link href="${pageContext.request.contextPath}/resources/css/mainPage.css"
	rel="stylesheet">

<%-- jQuery --%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
	<div class="container">
		<div class="top-buttons">
			<button class="btn" id="login-btn">로그인</button>
			<button class="btn" id="signup-btn">회원가입</button>
		</div>

		<div class="headline">IT다</div>
		<div class="subtitle">세상을 바꾸는 거래와 소통의 플랫폼</div>

		<div class="search-filter-wrapper">
			<div class="filters">
				<!-- 거래유형 드롭다운 -->
				<div class="dropdown" id="deal-type-dropdown">
					<button class="dropbtn">
						<span class="dropbtn_content">거래유형</span> <span
							class="dropbtn_click" aria-hidden="true"> <svg
								class="dropdown-icon" xmlns="http://www.w3.org/2000/svg"
								width="16" height="16" viewBox="0 0 24 24">
                <path fill="#5a5a5a" d="M7 10l5 5 5-5z" />
              </svg>
						</span>
					</button>
					<div class="dropdown-content">
						<div class="category">전체</div>
						<div class="category">대여</div>
						<div class="category">교환</div>
						<div class="category">나눔</div>
						<div class="category">경매</div>
						<div class="category">커뮤니티</div>
					</div>
				</div>

				<!-- 상품유형 드롭다운 -->
				<div class="dropdown" id="product-type-dropdown">
					<button class="dropbtn">
						<span class="dropbtn_content">상품유형</span> <span
							class="dropbtn_click" aria-hidden="true"> <svg
								class="dropdown-icon" xmlns="http://www.w3.org/2000/svg"
								width="16" height="16" viewBox="0 0 24 24">
                <path fill="#5a5a5a" d="M7 10l5 5 5-5z" />
              </svg>
						</span>
					</button>
					<div class="dropdown-content">
						<div class="category">전체</div>
						<div class="category">의류</div>
						<div class="category">전자기기</div>
						<div class="category">생활가전</div>
						<div class="category">가구</div>
						<div class="category">도서</div>
						<div class="category">뷰티</div>
						<div class="category">식품</div>
						<div class="category">스포츠</div>
					</div>
				</div>
			</div>

			<!-- 검색창 -->
			<div class="search-bar">
				<input type="text" placeholder="무엇을 찾으시나요?" id="search-input" /> <img
					src="${pageContext.request.contextPath}/resources/images/search.png" alt="search icon" id="search-btn"
					style="cursor: pointer;" />
			</div>
		</div>


		<div class="cards">
			<div class="card">
				<div class="card-title">대여</div>
				<div class="card-link">게시판 바로가기 &gt;</div>
			</div>
			<div class="card">
				<div class="card-title">교환</div>
				<div class="card-link">게시판 바로가기 &gt;</div>
			</div>
			<div class="card">
				<div class="card-title">나눔</div>
				<div class="card-link">게시판 바로가기 &gt;</div>
			</div>
			<div class="card">
				<div class="card-title">경매</div>
				<div class="card-link">게시판 바로가기 &gt;</div>
			</div>
			<div class="card community">
				<div class="card-title">커뮤니티</div>
				<div class="card-link">게시판 바로가기 &gt;</div>
			</div>
		</div>
	</div>
	
	<%-- mainPage JavaScript 파일 불러오기--%>
	<script src="${pageContext.request.contextPath}/resources/js/mainPage.js"></script>
	

</body>
</html>