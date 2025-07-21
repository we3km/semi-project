<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- JSTL c태그를 사용하기 위한 태그 라이브러리 (c:url 등 사용 시 필요) --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<%-- 모바일 뷰 --%>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>communityWrite</title>
<link
	href="https://fonts.googleapis.com/css2?family=SUIT:wght@400;600;700&display=swap"
	rel="stylesheet">

<%-- communityWrite CSS 파일 --%>s
<link
	href="${pageContext.request.contextPath}/resources/css/communityWrite.css"
	rel="stylesheet">

<%-- jQuery --%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
	<div class="container">

		<!-- 상단 타이틀 / 위치 영역 -->
		<div class="top-title">
			<span class="community-title"><strong style="color: #7f8cff;">커뮤니티</strong>
				글쓰기</span> | <span class="location">활동지역 &gt; <span
				class="highlight">서울특별시 강남구</span> 📍
			</span>
		</div>
		<hr>

		<div class="form-container">
			<div class="top-buttons">
				<button class="btn-cancel" id="cancelBtn">작성 취소</button>
				<button class="btn-submit" id="submitBtn">작성 완료</button>
			</div>

			<div class="form-group">
				<label>카테고리 선택</label> <select id="category" class="select-category">
					<option value="">카테고리 선택</option>
					<option value="운동">운동</option>
					<option value="문화/예술">문화/예술</option>
					<option value="취미/오락">취미/오락</option>
					<option value="반려동물">반려동물</option>
					<option value="동네친구">동네친구</option>
					<option value="자기개발/스터디">자기개발/스터디</option>
					<option value="공포이야기">공포이야기</option>
				</select>
			</div>

			<div class="form-group">
				<label for="title">제목</label> <input type="text" id="title"
					placeholder="제목을 입력하세요">
			</div>

			<div class="form-group">
				<label for="tagInput">태그</label>
				<div id="tagArea">
					<div class="tag-wrap">
						<div id="tagList"></div>
						<input type="text" id="tagInput" placeholder="엔터키로 추가 가능">
					</div>
					<img src="/semi/img/search.png" class="search-icon" />
				</div>

			</div>

			<div class="form-group">
				<label for="content">게시글 상세 내용</label>
				<textarea id="content"
					placeholder="욕설, 비속어 사용은 자제해주세요. 내용은 1000자까지 입력이 가능합니다."></textarea>
			</div>

			<div class="form-group file-group">
				<label for="fileInput">첨부파일</label> <span id="fileName"
					style="margin-left: 10px; color: #666;"></span> <label
					for="fileInput" class="file-label">파일선택</label> <input type="file"
					id="fileInput">
			</div>
		</div>

	</div>

	<%-- communityWrite JavaScript 파일 불러오기--%>
	<script
		src="${pageContext.request.contextPath}/resources/js/communityWrite.js"></script>

</body>
</html>