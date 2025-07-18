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
<title>Header</title>
<link
	href="https://fonts.googleapis.com/css2?family=SUIT:wght@400;600;700&display=swap"
	rel="stylesheet">

<%-- Header CSS 파일 --%>
<link href="${pageContext.request.contextPath}/resources/css/Header.css"
	rel="stylesheet">

<%-- jQuery --%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<div class="container">
        <!-- 좌측 로고 -->
        <div class="logo">IT다</div>
        <!-- 카테고리 -->
        <div class="category-line">
            <div class="category">대여</div>
            <div class="category">경매</div>
            <div class="category">교환</div>
            <div class="category">나눔</div>
            <div class="category">커뮤니티</div>
        </div>
        <!-- 로그인 / 로그아웃 버튼 -->
        <div class="top-buttons">
            <div class="unlogin">
                <div class="btn" id="loginBtn">로그인</div>
                <div class="btn" id="joinMembership">회원가입</div>
            </div>
            <div class="login">
                <div class="btn" id="myPage">마이페이지</div>
                <div class="btn" id="logoutBtn">로그아웃</div>
                <div class="btn" id="customerService">고객센터</div>
            </div>
        </div>
        <!-- 검색 -->
        <div class="search">
            <div style="position: relative;">
                <button class="search-category">
                    <div>전체</div>
                    <svg class="dropdown-icon" xmlns="http://www.w3.org/2000/svg" width="16" height="16"
                        viewBox="0 0 24 24">
                        <path fill="#5A5A5A" d="M7 10l5 5 5-5z" />
                    </svg>
                </button>
                <div class="search-dropdown">
                    <div>전체</div>
                    <div>대여</div>
                    <div>경매</div>
                    <div>교환</div>
                    <div>나눔</div>
                    <div>커뮤니티</div>
                </div>
            </div>
            <div class="search-bar">
                <input type="text" placeholder="무엇을 찾으시나요?" />
                <img src="${pageContext.request.contextPath}/resources/images/search.png" alt="search icon" />
            </div>
        </div>
        <!-- 유저 인사 + 알림 -->
        <div class="login_effect">
            <!-- 회원 이름 바뀌기-->
            <div class="user"><strong>홍길동</strong>님 반갑습니다!</div>
            <div id ="icons">
                <img src="${pageContext.request.contextPath}/resources/images/message.png" alt="message icon" id="message-icon" />
                <img src="${pageContext.request.contextPath}/resources/images/alam.png" alt="alarm icon"  id="alarm-icon"/>
            </div>
        </div>
    </div>
    
    <%-- Header JavaScript 파일 불러오기--%>
	<script src="${pageContext.request.contextPath}/resources/js/Header.js"></script>

</body>
</html>