<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- JSTL c태그를 사용하기 위한 태그 라이브러리 (c:url 등 사용 시 필요) --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>

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
<link
	href="${pageContext.request.contextPath}/resources/css/mainPage.css"
	rel="stylesheet">

<%-- jQuery --%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
	<div class="container">
		<%-- <div class="top-buttons">
			<div class="unlogin">
				<div class="btn" id="loginBtn">로그인</div>
				<div class="btn" id="joinMembership">회원가입</div>
			</div>
			<div class="login">
				<div class="btn" id="myPage">마이페이지</div>
				<div class="btn" id="logoutBtn">로그아웃</div>
			</div>
		</div>
		<c:choose>
			<c:when test="${not empty sessionScope.loginUser}">
				<script>
					$('.unlogin').hide();
					$('.login').show();
				</script>
			</c:when>
			<c:otherwise>
				<script>
					$('.login').hide();
					$('.unlogin').show();
				</script>
			</c:otherwise>
		</c:choose> --%>

		<div class="top-buttons">
			<%--Spring Security 태그를 사용하여 로그인하지 않았을 때만 이 div를 렌더링--%>
			<sec:authorize access="isAnonymous()">
				<div class="unlogin">
					<div class="btn" id="loginBtn">로그인</div>
					<div class="btn" id="joinMembership">회원가입</div>
				</div>
			</sec:authorize>

			<%--로그인했을 때만 이 div를 렌더링--%>
			<sec:authorize access="isAuthenticated()">
				<div class="login">
					<div class="btn" id="myChatRoom">나의 채팅방</div>
					<div class="btn" id="myPage">마이페이지</div>
					<div class="btn" id="logoutBtn">로그아웃</div>
				</div>
			</sec:authorize>
		</div>

		<!-- 채팅방 리스트 이동 -->
		<script>
		document.getElementById("myChatRoom").addEventListener("click", function() {
		    location.href = "${contextpath}/itda/chat/chatRoomList";
		});
		</script>
		
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

					<!-- 목록 -->
					<div class="dropdown-content">
						<c:forEach var="entry" items="${mainCategoryType}">
							<div class="category" data-id="${entry.value.categoryId}"
								data-gubun="${entry.value.categoryGubun}"
								data-name="${entry.value.category}">
								${entry.value.category}</div>
						</c:forEach>
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

					<div class="dropdown-content"></div>
				</div>
			</div>

			<!-- 검색창 -->
			<div class="search-bar">
				<input type="text" placeholder="무엇을 찾으시나요?" id="search-input" /> <img
					src="${pageContext.request.contextPath}/resources/images/search.png"
					alt="search icon" id="search-btn" style="cursor: pointer;" />
				<%-- <input type="text" placeholder="무엇을 찾으시나요?" id="search-input" /> <img
					src="${pageContext.request.contextPath}/resources/images/search.png" alt="search icon" id="search-btn"
					style="cursor: pointer;" /> --%>
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
	    // JSP에서 contextPath 변수 선언
	    const contextPath = '${pageContext.request.contextPath}';
	    
	    // controller에서 받은 데이터 변환
	    const subCategoryData={
	    		//board 카테고리목록
	    		board : [
	    			<c:forEach var="entry" items="${productCategories}">
	                	{ id: "${entry.categoryId}", name: "${entry.value.category}" },
	            	</c:forEach>
	    		],
	    		//community 카테고리 목록
	    		community : [
	    			<c:forEach var="entry" items="${communityTypes}">
	                	{ id: "${entry.key}", name: "${entry.value.communityName}" },
	            	</c:forEach>
	    		]
	    };
	    
	    let selectedCategoryId = null;
	    let selectedCategoryGubun = null;
	    let selectedProcuctTypeId = null;
	
	    // 드롭다운 화살표 클릭 시 목록 열기
	    $('.dropbtn_click').on('click', function (e) {
	        e.stopPropagation();
	        const dropdown = $(this).closest('.dropdown');
	        // 현재 드롭다운을 제외한 다른 모든 드롭다운은 닫기
	        $('.dropdown-content').not(dropdown.find('.dropdown-content')).removeClass('show');
	        // 현재 드롭다운 목록 보이기/숨기기
	        dropdown.find('.dropdown-content').toggleClass('show');
	    });
	    $(window).on('click', () => $('.dropdown-content').removeClass('show'));
	    
	 //  '거래유형' 드롭다운 클릭 이벤트 분리
	    $('#deal-type-dropdown').on('click', '.category', function () {
	        const dropdown = $(this).closest('.dropdown');
	        const name = $(this).data('name');
	        
	        // 선택된 거래유형의 ID와 Gubun 저장
	        selectedCategoryId = $(this).data('id');
	        selectedCategoryGubun = $(this).data('gubun');

	        // 거래유형 버튼의 제목을 선택한 항목으로 변경
	        dropdown.find('.dropbtn_content').text(name).css('color', '#252525');
	        dropdown.find('.dropdown-content').removeClass('show');

	        // --- 상품유형 드롭다운을 동적으로 변경하는 로직 ---
	        const $productDropdown = $('#product-type-dropdown .dropdown-content');
	        const $productBtnText = $('#product-type-dropdown .dropbtn_content');

	        $productDropdown.empty(); // 기존 목록 비우기
	        $productBtnText.text('상품유형'); // 버튼 텍스트 초기화
	        selectedProductTypeId = null; // 이전에 선택했던 상품유형 값 초기화

	        let dataToPopulate = [];
	        const id = Number(selectedCategoryId);

	        if (id >= 6 && id <= 9) { // 대여, 교환 등
	            dataToPopulate = subCategoryData.board;
	        } else if (id === 10) { // 커뮤니티
	            dataToPopulate = subCategoryData.community;
	        }

	        // 새 목록 생성 및 추가
	        dataToPopulate.forEach(item => {
	            const categoryDiv = $('<div></div>')
	                .addClass('category')
	                .attr('data-id', item.id)
	                .attr('data-name', item.name)
	                .text(item.name);
	            $productDropdown.append(categoryDiv);
	        });
	    });

	    //  '상품유형' 드롭다운 클릭 이벤트 (동적으로 생성되므로 이벤트 위임 방식 사용)
	    $('#product-type-dropdown').on('click', '.category', function() {
	        selectedProductTypeId = $(this).data('id'); // 선택한 상품유형 ID 저장
	        const name = $(this).data('name');
	        $(this).closest('.dropdown').find('.dropbtn_content').text(name).css('color', '#252525');
	        $(this).closest('.dropdown').find('.dropdown-content').removeClass('show');
	    });


	    //  검색 버튼 클릭 시 상품유형 파라미터 추가
	    $('#search-btn').on('click', function () {
	        if (!selectedCategoryId) {
	            alert("거래유형을 선택해주세요.");
	            return;
	        }
	        
	        const keyword = $("#search-input").val().trim();
	        const params = new URLSearchParams();

	        if(keyword) {
	            params.append('keyword', keyword);
	        }
	        // 선택된 상품유형 ID가 있으면 'category' 파라미터로 추가
	        if(selectedProductTypeId) {
	            params.append('category', selectedProductTypeId);
	        }

	        let url = "";
	        const id = Number(selectedCategoryId);

	        if (id >= 6 && id <= 9) {
	            url = contextPath + "/board/" + selectedCategoryGubun + "/list";
	        } else if (id === 10) {
	            url = contextPath + "/community/list/all";
	        } else {
	            alert("잘못된 카테고리입니다.");
	            return;
	        }
	        
	        const queryString = params.toString();
	        location.href = url + (queryString ? '?' + queryString : '');
	    });
	    
	    // --- 나머지 이벤트 핸들러 (기존과 동일) ---
	    function postToUrl(url) {
		    const form = document.createElement('form');
		    form.method = 'POST';
		    form.action = url;
		    document.body.appendChild(form);
		    form.submit();
		}
	    $('#loginBtn').click(() => location.href = contextPath + '/user/login');
	    $('#logoutBtn').click(() => postToUrl(contextPath + '/user/logout'));
	    $('#joinMembership').click(() => location.href = contextPath + '/user/join/terms');
	    $('#myPage').click(() => location.href = contextPath + '/user/mypage');
	    $('.card').click(function () {
	        const title = $(this).find('.card-title').text().trim();
	        let targetUrl = '';
	        switch(title) {
	            case '대여': targetUrl = contextPath + '/board/rental/list'; break;
	            case '교환': targetUrl = contextPath + '/board/exchange/list'; break;
	            case '나눔': targetUrl = contextPath + '/board/share/list'; break;
	            case '경매': targetUrl = contextPath + '/board/auction/list'; break;
	            case '커뮤니티': targetUrl = contextPath + '/community/list/all'; break;
	            default: alert('해당 페이지가 없습니다.'); return;
	        }
	        window.location.href = targetUrl;
	    });
	
	  
	});
	</script>

</body>
</html>
