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
	
	<script>
$(document).ready(function () {
    // 드롭다운 클릭 열기
    $('.dropbtn_click').on('click', function (e) {
        e.stopPropagation();
        const dropdown = $(this).closest('.dropdown');
        $('.dropdown-content').not(dropdown.find('.dropdown-content')).removeClass('show');
        dropdown.find('.dropdown-content').toggleClass('show');
    });

    // 항목 클릭 시 텍스트 설정
    $('.dropdown .category').on('click', function () {
        const value = $(this).text();
        const dropdown = $(this).closest('.dropdown');
        dropdown.find('.dropbtn_content').text(value).css('color', '#252525');
        dropdown.find('.dropdown-content').removeClass('show');
    });

    // 외부 클릭 시 닫기
    $(window).on('click', function () {
        $('.dropdown-content').removeClass('show');
    });

    // 로그인/로그아웃 로직 (기존과 동일)
    function loginClickHandler() {
        alert('로그인창');
        $('#login-btn').text('로그아웃');
        $('#signup-btn').text('마이페이지');

        $('#login-btn').off('click').on('click', logoutClickHandler);
        $('#signup-btn').off('click').on('click', function () {
            alert('마이페이지');
        });
    }

    function logoutClickHandler() {
        alert('로그아웃');
        $('#login-btn').text('로그인');
        $('#signup-btn').text('회원가입');

        $('#login-btn').off('click').on('click', loginClickHandler);
        $('#signup-btn').off('click').on('click', function () {
            alert('회원가입');
        });
    }

    $('#login-btn').on('click', loginClickHandler);
    $('#signup-btn').on('click', function () {
        alert('회원가입');
    });
    
    // JSP에서 contextPath 변수 선언
    const contextPath = '${pageContext.request.contextPath}';

    // =================================================================
    // ▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼ 핵심 수정 사항 ▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
    // =================================================================
    // 검색 버튼 클릭 이벤트
    $('#search-btn').on('click', function () {
        // 1. 필터 값 가져오기
        const dealTypeText = $('#deal-type-dropdown .dropbtn_content').text().trim();
        const productType = $('#product-type-dropdown .dropbtn_content').text().trim();
        const keyword = $('#search-input').val().trim();

        // 2. 거래 유형에 따라 기본 URL 설정
        let baseUrl = '';
        switch (dealTypeText) {
            case '대여':
                baseUrl = contextPath + '/rent/list';
                break;
            case '교환':
                baseUrl = contextPath + '/exchange/list';
                break;
            case '나눔':
                baseUrl = contextPath + '/share/list';
                break;
            case '경매':
                baseUrl = contextPath + '/auction/list';
                break;
            case '커뮤니티':
                baseUrl = contextPath + '/community/list/all';
                break;
            case '거래유형': // 기본값일 경우
            case '전체':     // '전체'를 선택했을 경우
                alert('검색할 거래 유형을 먼저 선택해주세요.');
                return; // 함수 종료
            default:
                alert('유효하지 않은 거래 유형입니다.');
                return;
        }

        // 3. URL 파라미터 만들기
        const params = new URLSearchParams();
        if (productType && productType !== '상품유형') {
            params.append('productType', productType);
        }
        if (keyword) {
            params.append('keyword', keyword);
        }

        // 4. 최종 URL로 이동
        const queryString = params.toString();
        if (queryString) {
            window.location.href = baseUrl + '?' + queryString;
        } else {
            window.location.href = baseUrl;
        }
    });
    // =================================================================
    // ▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲ 핵심 수정 사항 ▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲
    // =================================================================

    // 카드 클릭 이벤트 (기존과 동일)
    $('.card').click(function () {
        const title = $(this).find('.card-title').text().trim();

        let targetUrl = '';
        switch(title) {
            case '대여':
                targetUrl = contextPath + '/board/rental/list';
                break;
            case '교환':
                targetUrl = contextPath + '/board/exchange/list';
                break;
            case '나눔':
                targetUrl = contextPath + '/board/share/list';
                break;
            case '경매':
                targetUrl = contextPath + '/board/auction/list';
                break;
            case '커뮤니티':
                targetUrl = contextPath + '/community/list/all';
                break;
            default:
                alert('해당 페이지가 없습니다.');
                return;
        }
        window.location.href = targetUrl;
    });
});
</script>

	
>>>>>>> main

</body>
</html>
