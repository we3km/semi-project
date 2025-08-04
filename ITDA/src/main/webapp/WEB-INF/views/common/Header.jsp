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


	<div class="container_header">
		<!-- 좌측 로고 -->
		<div class="logo" style="cursor: pointer">IT다</div>
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
		<c:choose>
			<c:when test="${not empty sessionScope.loginUser}">
				<script>
					$('.unlogin').hide();
					$('.login').show();
					$('.login_effect').show();
				</script>
			</c:when>
			<c:otherwise>
				<script>
					$('.login').hide();
					$('.unlogin').show();
					$('.login_effect').hide();
				</script>
			</c:otherwise>
		</c:choose>

		<!-- 검색 필터 + 검색창 -->
		<div class="search-filter-wrapper">
		    <div class="filters">
		        <!-- 드롭다운 -->
		        <div class="dropdown" id="deal-type-dropdown">
		            <button class="dropbtn">
		                <span class="dropbtn_content">전체</span>
		                <span class="dropbtn_click" aria-hidden="true">
		                    <svg class="dropdown-icon" xmlns="http://www.w3.org/2000/svg"
		                         width="16" height="16" viewBox="0 0 24 24">
		                        <path fill="#5A5A5A" d="M7 10l5 5 5-5z" />
		                    </svg>
		                </span>
		            </button>
		            <div class="dropdown-content">
		                <c:forEach var="entry" items="${CategoryType}">
		                    <div class="category"
		                         data-id="${entry.value.categoryId}"
		                         data-gubun="${entry.value.categoryGubun}"
		                         data-name="${entry.value.category}">
		                        ${entry.value.category}
		                    </div>
		                </c:forEach>
		            </div>
		        </div>
		    </div>
		
		    <!-- 검색창 -->
		    <div class="search-bar">
		        <input type="text" placeholder="무엇을 찾으시나요?" id="search-input" />
		        <img src="${pageContext.request.contextPath}/resources/images/search.png"
		             alt="search icon" id="search-btn" style="cursor: pointer;" />
		    </div>
		</div>
		
		
		<!-- 유저 인사 + 알림 -->
		<div class="login_effect"
			style="<c:if test='${empty sessionScope.loginUser}'>display:none;</c:if>">
			<!-- 회원 이름 바뀌기-->
			<div class="user">
				<strong>${sessionScope.loginUser.userName}</strong>님 반갑습니다!
			</div>
			<div id="icons">
				<img
					src="${pageContext.request.contextPath}/resources/images/message.png"
					alt="message icon" id="message-icon" /> 
				<img
					src="${pageContext.request.contextPath}/resources/images/alam.png"
					alt="alarm icon" id="alarm-icon" />
			</div>
		</div>
		<script>
			$(document).ready(function() {
				const contextPath = "${pageContext.request.contextPath}";

				// 로고
				$('.logo').click(function() {
					location.href = contextPath;
				})

				// 카테고리
				// 카테고리 클릭 시 active
				$('.category-line .category').click(function() {
							$('.category-line .category').removeClass('active');
							$(this).addClass('active');
							const category = $(this).text();
							let targetUrl = '';
					        switch(category) {
					            case '대여': targetUrl = contextPath + '/board/rental/list'; break;
					            case '교환': targetUrl = contextPath + '/board/exchange/list'; break;
					            case '나눔': targetUrl = contextPath + '/board/share/list'; break;
					            case '경매': targetUrl = contextPath + '/board/auction/list'; break;
					            case '커뮤니티': targetUrl = contextPath + '/community/list/all'; break;
					            default: alert('해당 페이지가 없습니다.'); return;
					        }
					        window.location.href = targetUrl;
						});

				// 로그인-로그아웃 버튼 
				// 로그인 상태 토글
				$('#loginBtn').click(function() {
					$('.unlogin').hide();
					$('.login').show();
				});
				$('#logoutBtn').click(function() {
					$('.login').hide();
					$('.unlogin').show();
				});
				// 초기화 - 무조건 로그인된 상태 숨기기
				$('.login').hide(); // 로그인된 사용자용 버튼 숨김
				$('.unlogin').show(); // 비로그인용 버튼 보이기
				$('.login_effect').hide(); // 유저 인사+알림창 숨기기
				// 로그인 클릭 시
				$('#loginBtn').click(
						function() {
							//로그인 페이지로 이동
							alert(`로그인창`);
							location.href = contextPath
									+ '/user/login';
							location.href = contextPath + '/user/login'; 

							$('.unlogin').hide();
							$('.login').css('display', 'flex');
							$('.login_effect').show();
						});
				// 로그아웃 클릭 시
				$('#logoutBtn').click(
						function() {
							//로그아웃
							alert(`로그아웃 하였습니다`);
							const form = document.createElement('form');
						    form.method = 'POST';
						    form.action = contextPath + '/user/logout';

						    document.body.appendChild(form);
						    form.submit();
						    
							$('.login').hide();
							$('.login_effect').hide();
							$('.unlogin')
									.css('display', 'flex');
						});

				//회원가입 이동
				$('#joinMembership').click(function() {
					location.href = contextPath + '/user/join';
				});

				//마이페이지 이동
				$('#myPage').click(
						function() {
							location.href = contextPath
									+ '/user/mypage';
						});

				//고객센터이동
				$('#customerService').click(
						function() {
							location.href = contextPath
									+ '/cs';
						})

				// 검색창
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
			    
			 	// '거래유형' 드롭다운 클릭 이벤트 분리
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
			 	
			 	// 검색 버튼 클릭 시 상품유형 파라미터 추가
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
			        
			        
			        
				/* // 검색 드롭다운 열기/닫기
				$('.search-category').click(
						function() {
							$(this)
									.siblings(
											'.search-dropdown')
									.toggle();
						});
				// 카테고리 선택 시 텍스트만 변경 (svg 유지)
				$('.search-dropdown div')
						.click(
								function() {
									const selectedText = $(this)
											.text();
									$(
											'.search-category div:first-child')
											.text(selectedText);
									$('.search-dropdown')
											.hide();
								});
				// 외부 클릭 시 드롭다운 닫기
				$(document)
						.click(
								function(e) {
									if (!$(e.target).closest(
											'.search').length) {
										$('.search-dropdown')
												.hide();
									}
								});
				// 검색 아이콘 클릭
				$('.search img')
						.click(
								function() {
									const query = $(
											'.search-bar input')
											.val(); //입력된 검색어
									const category = $(
											'.search-category div:first-child')
											.text().trim(); // 선택된 카테고리

									if (query === "") {
										alert(`검색어를 입력하세요`);
									} else {
										alert(`카테고리: ${category}\n검색어: ${query}`);
									}
								}); */

				//로그인 상태창
				//채팅버튼
				$('#message-icon').click(function() {
					alert(`채팅 페이지로 이동~`);
				});
				//알람버튼
				$('#alarm-icon').click(function() {
					alert(`채팅 페이지로 이동~`);
				});

			});
		</script>
		</div>
</body>
</html>