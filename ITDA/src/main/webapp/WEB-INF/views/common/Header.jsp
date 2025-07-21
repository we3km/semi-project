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
                <img src="/semi/img/search.png" alt="search icon" />
            </div>
        </div>
        <!-- 유저 인사 + 알림 -->
        <div class="login_effect">
            <!-- 회원 이름 바뀌기-->
            <div class="user"><strong>홍길동</strong>님 반갑습니다!</div>
            <div id ="icons">
                <img src="/semi/img/message.png" alt="message icon" id="message-icon" />
                <img src="/semi/img/alam.png" alt="alarm icon"  id="alarm-icon"/>
            </div>
        </div>
    </div>
    <script>
        $(document).ready(function () {


            // 로고
            $('.logo').click(function(){
                alert(`메인페이지로 이동`);
            })


            // 카테고리
            // 카테고리 클릭 시 active
            $('.category-line .category').click(function () {
                $('.category-line .category').removeClass('active');
                $(this).addClass('active');
                const category = $(this).text();
                alert(`${category}`);
            });


            // 로그인-로그아웃 버튼 
            // 로그인 상태 토글
            $('#loginBtn').click(function () {
                $('.unlogin').hide();
                $('.login').show();
            });
            $('#logoutBtn').click(function () {
                $('.login').hide();
                $('.unlogin').show();
            });
            // 초기화 - 무조건 로그인된 상태 숨기기
            $('.login').hide();      // 로그인된 사용자용 버튼 숨김
            $('.unlogin').show();    // 비로그인용 버튼 보이기
            $('.login_effect').hide();  // 유저 인사+알림창 숨기기
            // 로그인 클릭 시
            $('#loginBtn').click(function () {
                //로그인 페이지로 이동
                alert(`로그인창`);

                $('.unlogin').hide();
                $('.login').css('display', 'flex');
                $('.login_effect').show();
            });
            // 로그아웃 클릭 시
            $('#logoutBtn').click(function () {
                //로그아웃으로 바껴랏
                alert(`로그아웃 하였습니다`);

                $('.login').hide();
                $('.login_effect').hide();
                $('.unlogin').css('display', 'flex');
            });
            //회원가입
            $('#joinMembership').click(function(){
                alert(`회원가입 페이지 이동~`);
            });
            //마이페이지
            $('#myPage').click(function(){
                alert(`마이페이지 이동~`);
            });
            //고객센터
            $('#customerService').click(function(){
                alert(`고객센터 페이지 이동~`);
            })


            // 검색창
            // 검색 드롭다운 열기/닫기
            $('.search-category').click(function () {
                $(this).siblings('.search-dropdown').toggle();
            });
            // 카테고리 선택 시 텍스트만 변경 (svg 유지)
            $('.search-dropdown div').click(function () {
                const selectedText = $(this).text();
                $('.search-category div:first-child').text(selectedText);
                $('.search-dropdown').hide();
            });
            // 외부 클릭 시 드롭다운 닫기
            $(document).click(function (e) {
                if (!$(e.target).closest('.search').length) {
                    $('.search-dropdown').hide();
                }
            });
            // 검색 아이콘 클릭
            $('.search img').click(function () {
                const query = $('.search-bar input').val(); //입력된 검색어
                const category = $('.search-category div:first-child').text().trim(); // 선택된 카테고리

                if(query === ""){
                    alert(`검색어를 입력하세요`);
                }else{
                    alert(`카테고리: ${category}\n검색어: ${query}`);
                }
            });
            

            //로그인 상태창
            //채팅버튼
            $('#message-icon').click(function(){
            alert(`채팅 페이지로 이동~`);
            });
            //알람버튼
            $('#alarm-icon').click(function(){
            alert(`채팅 페이지로 이동~`);
            });

           

        });


    </script>
	
	

</body>
</html>