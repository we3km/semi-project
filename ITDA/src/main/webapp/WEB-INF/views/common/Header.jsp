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
<title>Header</title>
<link
	href="https://fonts.googleapis.com/css2?family=SUIT:wght@400;600;700&display=swap"
	rel="stylesheet">
<%-- Header CSS 파일 --%>
<link href="${pageContext.request.contextPath}/resources/css/Header.css"
	rel="stylesheet">
<%-- jQuery --%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
</head>
<body>
	<sec:authorize access="hasRole('ROLE_ADMIN')">
		<input type="hidden" id="userRole" value="ROLE_ADMIN" />
	</sec:authorize>
	<sec:authorize access="hasRole('ROLE_USER')">
		<input type="hidden" id="userRole" value="ROLE_USER" />
	</sec:authorize>

	<div class="container_header">

		<!-- 좌측 로고 -->
		<div class="logo" style="cursor: pointer">IT다</div>

		<!-- 카테고리 -->
		<div class="category-line">
			<div class="category">대여</div>
			<div class="category">경매</div>
			<div class="category">나눔</div>
			<div class="category">커뮤니티</div>
		</div>
		<!-- 로그인 / 로그아웃 버튼 -->
		<div class="top-buttons">
			<sec:authorize access="isAnonymous()">
				<div class="unlogin">
					<div class="btn" id="loginBtn">로그인</div>
					<div class="btn" id="joinMembership">회원가입</div>
				</div>
			</sec:authorize>
			<sec:authorize access="isAuthenticated()">
				<div class="login">
					<div class="btn" id="myPage">마이페이지</div>
					<div class="btn" id="logoutBtn">로그아웃</div>
					<div class="btn" id="customerService">고객센터</div>
				</div>
			</sec:authorize>
		</div>

		<!-- 카테고리 -->
		<div class="category-line">
			<div class="category">대여</div>
			<div class="category">경매</div>
			<div class="category">나눔</div>
			<div class="category">커뮤니티</div>
		</div>

		<!-- 유저 인사 + 알림 -->
		<sec:authorize access="isAuthenticated()">
			<div class="login_effect">
				<!-- 회원 이름 바뀌기 -->
				<div class="user">
					<strong> <sec:authentication property="principal.nickName" />
					</strong>님 반갑습니다!
				</div>

				<div id="icons">
					<img
						src="${pageContext.request.contextPath}/resources/images/message.png"
						alt="message icon" id="message-icon" />

					<div class="alarm-wrapper">
						<img
							src="${pageContext.request.contextPath}/resources/images/alam.png"
							alt="alarm icon" id="alarm-icon" /> <span id="alarm-dot"
							class="alarm-dot"></span>

						<div id="alarm-dropdown" class="alarm-dropdown">
							<ul id="alarm-list" class="alarm-list"></ul>
						</div>
					</div>
				</div>
			</div>
		</sec:authorize>

	</div>

	<!-- 검색 필터 + 검색창 -->
	<div class="search-filter-wrapper">
		<div class="filters">
			<!-- 드롭다운 -->
			<div class="dropdown" id="deal-type-dropdown">
				<button class="dropbtn">
					<span class="dropbtn_content">게시판</span> <span
						class="dropbtn_click" aria-hidden="true"> <svg
							class="dropdown-icon" xmlns="http://www.w3.org/2000/svg"
							width="16" height="16" viewBox="0 0 24 24">
		                        <path fill="#5A5A5A" d="M7 10l5 5 5-5z" />
		                    </svg>
					</span>
				</button>
				<div class="dropdown-content">
					<c:forEach var="entry" items="${CategoryType}">
						<div class="category" data-id="${entry.value.categoryId}"
							data-gubun="${entry.value.categoryGubun}"
							data-name="${entry.value.category}">
							${entry.value.category}</div>
					</c:forEach>
				</div>
			</div>
		</div>
		<!-- 검색창 -->
		<div class="search-bar">
			<input type="text" placeholder="무엇을 찾으시나요?" id="search-input" /> <img
				src="${pageContext.request.contextPath}/resources/images/search.png"
				alt="search icon" id="search-btn" style="cursor: pointer;" />
		</div>
	</div>

	<script>
	let stompClient = null;
	const loginUserNum1 = "<sec:authentication property='principal.userNum' />";

	let alarmList = [];
	let unread = false;

	// 1. 웹소켓 연결
	function connectAlarmWebSocket(loginUserNum1) {
		const socket = new SockJS("${pageContext.request.contextPath}/stomp");
		stompClient = Stomp.over(socket);

		stompClient.connect({}, function () {
			stompClient.subscribe("/topic/alarm/" + loginUserNum1, function (message) {
				const alarm = JSON.parse(message.body); // 실시간 알림 파싱
				showAlarm(alarm);
			});
		});
	}

	// 2. 실시간 알림 표시
	function showAlarm(alarm) {
		if (!alarm || !alarm.content) {
			console.warn("❗ 실시간 알림 파싱 실패:", alarm);
			return;
		}

		const text = alarm.content.trim();
		const time = formatTimestamp(alarm.createdAt);
		const alarmId = alarm.alarmId || null;
		const chatRoomId = alarm.chatRoomId || null;
		const refId = alarm.refId || null;
		const refType = alarm.refType || null;

		alarmList.unshift({ text, time, alarmId, refId, refType, chatRoomId });
		console.log("📥 실시간 알림 추가:", text,"chatRoomId:", alarm.chatRoomId);

		document.getElementById('alarm-dot').style.display = 'block';
		unread = true;

		renderAlarmList();
	}

	// 3. 페이지 로드시 DB에서 알림 불러오기
	window.addEventListener("DOMContentLoaded", function () {
		connectAlarmWebSocket(loginUserNum1);

		fetch('${pageContext.request.contextPath}/alarm/list')
			.then(res => res.json())
			.then(data => {
				if (!Array.isArray(data)) return;

				alarmList = data.map(item => ({
					alarmId: item.alarmId,
					text: item.content,
					time: formatTimestamp(item.createdAt),
					refId:      item.refId       || null, 
			        refType:    item.refType     || null, 
					chatRoomId: item.chatRoomId || null 
					
				}));

				if (alarmList.length > 0) {
					document.getElementById('alarm-dot').style.display = 'block';
					unread = true;
				}

				renderAlarmList();
			})
			.catch(err => {
				console.error("🚨 알림 불러오기 실패:", err);
			});
	});

	// 4. 알림 목록 렌더링
	function renderAlarmList() {
		const ul = document.getElementById('alarm-list');
		if (!ul) return;

		ul.innerHTML = "";

		alarmList.forEach(({ text, time, alarmId, refId, refType, chatRoomId }) => {
			const li = document.createElement("li");

			const container = document.createElement("div");
			container.style.display = "flex";
			container.style.justifyContent = "space-between";
			container.style.alignItems = "center";
			container.style.padding = "8px";
			container.style.borderBottom = "1px solid #eee";
			container.style.cursor = "pointer";

			// 왼쪽 텍스트
			const textBox = document.createElement("div");
			const strong = document.createElement("strong");
			strong.innerHTML = text;

			const small = document.createElement("small");
			small.textContent = time;
			small.style.color = "#888";
			small.style.display = "block";
			small.style.marginTop = "4px";

			textBox.appendChild(strong);
			textBox.appendChild(small);

			// 삭제 버튼
			const deleteBtn = document.createElement("button");
			deleteBtn.textContent = "🗑️";
			deleteBtn.style.border = "none";
			deleteBtn.style.background = "transparent";
			deleteBtn.style.cursor = "pointer";
			deleteBtn.title = "삭제";
			deleteBtn.style.marginLeft = "3px";

			deleteBtn.addEventListener("click", function (e) {
				e.stopPropagation();
				deleteAlarm(alarmId);
			});

			container.appendChild(textBox);
			container.appendChild(deleteBtn);

			li.appendChild(container);

			// 클릭 시 처리
			li.addEventListener("click", function () {
	            if (alarmId != null) {
	               markAlarmAsRead(alarmId);
	            }
	
	            if (chatRoomId != null) {
	                // 채팅방으로 이동
	                sessionStorage.setItem('pendingOpenRoomId', chatRoomId);
	                location.href = "${pageContext.request.contextPath}/chat/chatRoomList";
	
	            } else if (refId != null && refType) {
	                // 커뮤니티 글로 이동
	                location.href = "${pageContext.request.contextPath}/community/detail/" + refType + "/" + refId;
	            }
	        });

			ul.appendChild(li);
		});
	}

	// 5. 알림 읽음 처리
	function markAlarmAsRead(alarmId) {
		fetch('${pageContext.request.contextPath}/alarm/read?alarmId=' + alarmId, {
			method: 'POST'
		}).then(res => {
			if (res.ok) {
				console.log("✅ 읽음 처리 완료 - ID:", alarmId);
			}
		});
	}

	// 6. 알림 삭제 처리
	function deleteAlarm(alarmId) {
		fetch('${pageContext.request.contextPath}/alarm/delete?alarmId=' + alarmId, {
			method: 'POST'
		}).then(res => {
			if (res.ok) {
				console.log("🗑️ 삭제 완료 - ID:", alarmId);
				alarmList = alarmList.filter(a => a.alarmId !== alarmId);
				renderAlarmList();
			} else {
				alert("❌ 알림 삭제 실패");
			}
		});
	}

	// 7. 시간 포맷
	function formatTimestamp(timestamp) {
		if (!timestamp) return "";
		const date = new Date(timestamp);
		return date.toLocaleTimeString();
	}

	// 8. 드롭다운 열고 닫기
	document.getElementById('alarm-icon').addEventListener('click', function () {
		const box = document.getElementById('alarm-dropdown');
		box.style.display = (box.style.display === 'none' || box.style.display === '') ? 'block' : 'none';

		if (unread) {
			document.getElementById('alarm-dot').style.display = 'none';
			unread = false;
		}
	});
</script>


	<script>
			$(document).ready(function() {
				const contextPath = "${pageContext.request.contextPath}";
				// 로그인-로그아웃 버튼
				// 로그인 상태 토글
				const currentPath = window.location.pathname; // 현재 페이지의 URL 경로를 가져옴
		
				$('.category-line .category').each(function() {
					const categoryName = $(this).text();
					let isMatched = false;
		
					// URL 경로에 각 카테고리별 키워드가 포함되어 있는지 확인
					if (categoryName === '대여' && currentPath.includes('/board/rental')) {
						isMatched = true;
					} else if (categoryName === '경매' && currentPath.includes('/board/auction')) {
						isMatched = true;
					} else if (categoryName === '나눔' && currentPath.includes('/board/share')) {
						isMatched = true;
					} else if (categoryName === '커뮤니티' && currentPath.includes('/community')) {
						isMatched = true;
					}
		
					// 일치하는 카테고리에 'active' 클래스 추가
					if (isMatched) {
						$(this).addClass('active');
					}
				});
				
				
				$('#loginBtn').click(function() {
					$('.unlogin').hide();
					$('.login').show();
				});
				$('#logoutBtn').click(function() {
					$('.login').hide();
					$('.unlogin').show();
				});
				// 로그인 클릭 시
				$('#loginBtn').click(function() {
					location.href = contextPath
							+ '/user/tempLogin';
					/* location.href = contextPath + '/user/login'; */
				});
				// 로그아웃 클릭 시
				$('#logoutBtn').click(function() {
					alert(`로그아웃 하였습니다`);
					location.href = contextPath	+ '/user/logout';
				});
				//회원가입 이동
				$('#joinMembership').click(function() {
					location.href = contextPath + '/user/join';
				});
				//마이페이지 이동
			    $('#myPage').click(function() {
			        const userRole = $('#userRole').val();
			        if (userRole === 'ROLE_ADMIN') {
			            location.href = contextPath + '/admin/mypage';
			        } else {
			            location.href = contextPath + '/user/mypage';
			        }
			    });
				//고객센터이동
				$('#customerService').click( function() {
							location.href = contextPath
									+ '/cs';
				})
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
				//로그인 상태창
				//채팅버튼
				$('#message-icon').click(function() {
					location.href = contextPath+"/chat/chatRoomList";
				});
			});
				
		</script>
	<sec:authorize access="isAuthenticated()">
	</sec:authorize>
</body>
</html>