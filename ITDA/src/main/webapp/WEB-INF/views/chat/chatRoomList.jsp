<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>ChattingRoomList</title>

<link
	href="${pageContext.request.contextPath
}/resources/css/globals.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/chat-style.css">

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>

<body>

<!-- chat.js 불러오기 -->
<script src="${contextPath}/resources/js/chat.js"></script>

	<!-- 왼쪽 채팅창 -->
	<div class="chat-wrapper">

		<!-- 살아있는 채팅창이 아무것도 없는 경우 -->
	<%-- 	<c:choose>
			<c:when test="${empty chatRoomList}">
				
			</c:when>
		</c:choose> --%>
		
		
		<div class="chatlist-container">
			<div class="chat-header1">
				<!-- 거래 유형 -->
				<span id="chatTypeLabel">전체 채팅방</span>
				<!-- '전체 채팅방' 디폴트 -->
				<!-- '+'버튼 누르면 채팅방 유형별 뜨도록 -->

				<!-- 채팅 유형 버튼 -->
				<button class="ellipse-button-chatRoomType" onclick="chatRoomType()">
					<b>채팅방 선택</b>
				</button>

				<div id="chatMenu" class="chat-menu hidden">
					<button class="chat-type" onclick="filterChatByType('전체 채팅방')">전체
						채팅방</button>
					<button class="chat-type" onclick="filterChatByType('교환')">교환</button>
					<button class="chat-type" onclick="filterChatByType('대여')">대여</button>
					<button class="chat-type" onclick="filterChatByType('경매')">경매</button>
					<button class="chat-type" onclick="filterChatByType('나눔')">나눔</button>
					<button class="chat-type" onclick="filterChatByType('오픈채팅방')">오픈채팅방</button>

				</div>
			</div>

			<!-- 채팅 리스트 -->
			<div class="chat-content1">

				<!-- 각 채팅방 예시 -->
				<!-- 예: 교환 유형 채팅방 -->
				<div class="list-chat" data-chat-type="교환"
					style="display: flex; align-items: center; justify-content: space-between; width: 100%;">

					<!-- 프로필 이미지 -->
					<!-- 프로필 버튼 누르면 유저 페이지로 이동 -->
					<button class="profile-button" onclick="goToUserPage('user123')">
						<img
							src="${pageContext.request.contextPath}/resources/images/chat/personEx.png"
							alt="프로필 이미지" width="50" height="50" style="border-radius: 20%;" />

					</button>
					<!-- 상대 닉네임, 맨 마지막에 했던 채팅 메세지 -->
					<div style="flex: 1; margin-left: 20px;">
						<div class="chatname">나는야 현이</div>
						<div class="last-message">저랑 이거 바꿀래요?</div>
					</div>
					<!-- 오른쪽: 햄버거 버튼 + 메뉴 -->
					<div style="position: relative;">
						<img
							src="${pageContext.request.contextPath}/resources/images/chat/hamburger-option.png"
							alt="채팅방 옵션" width="30" height="30"
							style="border-radius: 10%; cursor: pointer;"
							onclick="toggleActionMenu(this)" />
						<!-- 채팅 버튼 신고하기, 대화나가기 -->
						<div class="exit-report-menu hidden">
							<button class="exit-report-button" onclick="reportChat()">🚩
								신고하기</button>
							<button class="exit-report-button" onclick="leaveChat(this)">❌
								대화 나가기</button>
						</div>
					</div>
				</div>
				<!-- 각 채팅방  -->
				<div class="list-chat" data-chat-type="대여"
					style="display: flex; align-items: center; justify-content: space-between; width: 100%;">
					<button class="profile-button" onclick="goToUserPage('user123')">
						<img
							src="${pageContext.request.contextPath}/resources/images/chat/personEx.png"
							alt="프로필 이미지" width="50" height="50" style="border-radius: 20%;" />
					</button>
					<div style="flex: 1; margin-left: 20px;">
						<div class="chatname">김성겸</div>
						<div class="last-message">이거 대여 가능???</div>
					</div>
					<div style="position: relative;">
						<img
							src="${pageContext.request.contextPath}/resources/images/chat/hamburger-option.png"
							alt="옵션" width="30" height="30"
							style="border-radius: 10%; cursor: pointer;"
							onclick="toggleActionMenu(this)" />
						<div class="exit-report-menu hidden">
							<button class="exit-report-button" onclick="reportChat()">🚩
								신고하기</button>
							<button class="exit-report-button" onclick="leaveChat(this)">❌
								대화 나가기</button>
						</div>
					</div>
				</div>

				<div class="list-chat" data-chat-type="나눔"
					style="display: flex; align-items: center; justify-content: space-between; width: 100%;">
					<button class="profile-button" onclick="goToUserPage('user123')">
						<img
							src="${pageContext.request.contextPath}/resources/images/chat/personEx.png"
							alt="프로필 이미지" width="50" height="50" style="border-radius: 20%;" />
					</button>
					<div style="flex: 1; margin-left: 20px;">
						<div class="chatname">나눔왕 기석</div>
						<div class="last-message">이거 나눔 합니다</div>
					</div>
					<div style="position: relative;">
						<img
							src="${pageContext.request.contextPath}/resources/images/chat/hamburger-option.png"
							alt="옵션" width="30" height="30"
							style="border-radius: 10%; cursor: pointer;"
							onclick="toggleActionMenu(this)" />
						<div class="exit-report-menu hidden">
							<button class="exit-report-button" onclick="reportChat()">🚩
								신고하기</button>
							<button class="exit-report-button" onclick="leaveChat(this)">❌
								대화 나가기</button>
						</div>
					</div>
				</div>

				<div class="list-chat" data-chat-type="경매"
					style="display: flex; align-items: center; justify-content: space-between; width: 100%;">
					<button class="profile-button" onclick="goToUserPage('user123')">
						<img
							src="${pageContext.request.contextPath}/resources/images/chat/personEx.png"
							alt="프로필 이미지" width="50" height="50" style="border-radius: 20%;" />
					</button>
					<div style="flex: 1; margin-left: 20px;">
						<div class="chatname">경매하고 싶은 은비</div>
						<div class="last-message">경매가 5000원</div>
					</div>
					<div style="position: relative;">
						<img
							src="${pageContext.request.contextPath}/resources/images/chat/hamburger-option.png"
							alt="옵션" width="30" height="30"
							style="border-radius: 10%; cursor: pointer;"
							onclick="toggleActionMenu(this)" />
						<div class="exit-report-menu hidden">
							<button class="exit-report-button" onclick="reportChat()">🚩
								신고하기</button>
							<button class="exit-report-button" onclick="leaveChat(this)">❌
								대화 나가기</button>
						</div>
					</div>
				</div>

				<div class="list-chat" data-chat-type="오픈채팅방"
					style="display: flex; align-items: center; justify-content: space-between; width: 100%;">
					<button class="profile-button" onclick="goToUserPage('user123')">
						<img
							src="${pageContext.request.contextPath}/resources/images/chat/personEx.png"
							alt="프로필 이미지" width="50" height="50" style="border-radius: 20%;" />
					</button>
					<div style="flex: 1; margin-left: 20px;">
						<div class="chatname">강남 러닝크루 오픈 채팅방</div>
						<div class="last-message">오픈입니다~</div>
					</div>
					<div style="position: relative;">
						<img
							src="${pageContext.request.contextPath}/resources/images/chat/hamburger-option.png"
							alt="옵션" width="30" height="30"
							style="border-radius: 10%; cursor: pointer;"
							onclick="toggleActionMenu(this)" />
						<div class="exit-report-menu hidden">
							<button class="exit-report-button" onclick="reportChat()">🚩
								신고하기</button>
							<button class="exit-report-button" onclick="leaveChat(this)">❌
								대화 나가기</button>
						</div>
					</div>
				</div>
				<!-- 채팅방 나가기, 신고하기 -->
			</div>

			<div class="chat-footer1">
				<!-- <button class="ellipse-button" onclick="handleClick()"><b>+</b></button> -->
			</div>
		</div>



		<!-- 오른쪽 채팅창 -->
		<!--
      필요 로직
         - 오른쪽 채팅방에서 가장 마지막에 말한 메세지를 저장하여 왼쪽 채팅방에 뜰 수 있도록하자
    -->
		<div class="chatting-room">
			<div class="chat-header2">
				상대방 이름
				<!-- 클릭하면 판매자 or 구매자에 맞춰서 해당하는 기능 제공 창  -->
				<button class="ellipse-button" onclick="transactionService()">
					<b>+</b>
				</button>
				<div id="transMenu" class="trans-menu hidden">
					<!-- 누르면 각기에 해당하는 alert창 뜨게 하기 -->

					<button class="trans-option" trans-option-select="주소 요청"
						onclick="moveToTransOptionByType('주소 요청')">주소 요청</button>
					<button class="trans-option" trans-option-select="배송 정상 수령"
						onclick="moveToTransOptionByType('배송 정상 수령')">배송 정상 수령</button>
					<button class="trans-option" trans-option-select="상품 발송"
						onclick="moveToTransOptionByType('상품 발송')">상품 발송</button>
					<button class="trans-option" trans-option-select="거래 완료"
						onclick="moveToTransOptionByType('거래 완료')">거래 완료</button>
					<button class="trans-option" trans-option-select="안전 결제"
						onclick="moveToTransOptionByType('안전 결제')">안전 결제</button>
					<button class="trans-option" trans-option-select="사기 계좌 조회"
						onclick="moveToTransOptionByType('사기 계좌 조회')">사기 계좌 조회</button>
					<!-- 
            나눔, 교환
             - 구매자 기준 버튼 : 주소요청, 배송 정상 수령, 상품 발송, 거래 완료
             - 판매자 기준 버튼 : 주소요청, 배송 정상 수령, 상품 발송, 거래 완료

            대여, 경매
             - 구매자 기준 버튼 : 안전결제(아이엠포트), 배송정상수령, 사기 계좌 조회(경찰청), 거래완료
             - 판매자 기준 버튼 : 주소 요청, 상품 발송, 계좌 정보 전송

            오픈채팅방에는 해당 버튼 필요X
          -->
					<script>
            // 주소 요청, 배송 정상 수령 등 버튼 누르면 해당하는 alert창 및 채팅방 생성
            function moveToTransOptionByType(type) {
              const transMenuList = document.querySelectorAll(".trans-menu");
              transMenuList.forEach(trans => {
                const transOption = trans.getAttribute("trans-option-select");
                if (type === "주소 요청" || transOption === type) {
                  // 주소요청 alert창
                }
                if (type === "배송 정상 수령" || transOption === type) {
                  // 주소요청 alert창
                }
                if (type === "상품 발송" || transOption === type) {
                  // 주소요청 alert창
                }
                if (type === "거래 완료" || transOption === type) {
                  // 거래가 완료됐다는 채팅창 자동 생성
                }
                if (type === "사기 계좌 조회" || transOption === type) {
                  // 경찰청 계좌 조회 사이트로 바로 이동
                  window.open("https://www.police.go.kr/www/security/cyber/cyber04.jsp", "_blank");
                }
                if (type === "안전 결제" || transOption === type) {
                  // 아이엠 포트 이동
                }
              });
            }
          </script>
				</div>
			</div>

			<div class="chat-content2">

				<div class="chat-message" id="item-board">
					<!-- 아이템 소개부분 -->
					<!-- 상품 사진 누르면 상품 상세 조회사이트로 이동 -->
					<!-- 상품 상세 사이트에서 채팅방으로 직접 들어올테니 '거래 채팅방' 테이블통해 게시물 정보 추출해오자 -->
					<button class="item-button" onclick="goToUserPage('상품 상세 사이트 링크')">
						<img src="resources/image.png" alt="" width="150" height="150"
							style="border-radius: 20%;">
						<div class="item-description">
							<div class="item-title">
								<strong>상품명:</strong> 에어팟 프로
							</div>
							<!-- 게시글 제목 -->
							<div class="item-type">
								<strong>거래유형:</strong> 대여
							</div>
							<!-- 거래 유형 -->
							<div class="item-price">
								<strong>가격:</strong> 30,000원
							</div>
							<!-- 가격 -->
						</div>
					</button>
				</div>
				<div class="chat-message received">안녕하세요! 이건 상대방 메시지입니다.</div>

			</div>




			<div class="chat-footer2">
				<!-- 버튼 눌렀을 때 나올 메뉴 -->
				<!-- 실제 파일 업로드용 input (숨김 처리) -->
				<input type="file" id="imageInput" accept="image/*"
					style="display: none;" />
				<!-- 사용자가 누르게 될 버튼 -->
				<button class="ellipse-button" onclick="insertImg()">
					<b>+</b>
				</button>
				<input type="text" class="chat-input" placeholder="메시지를 입력하세요..." />
				<button class="send-button" onclick="sendMessage()">
					<b>전송</b>
				</button>

				<!-- =========================우측 채팅방 기능========================= -->
				<script>
          // 오른쪽 채팅창 헤더 +버튼 눌렀을 때 
          // 주소요청, 상품 발송 등 거래 유형에 맞게 보여줌

          function transactionService() {
            const menu = document.getElementById("transMenu");
            menu.classList.toggle("hidden");
          }

          // 메세지 보내기 (전송 버튼)
          function sendMessage() {
            const input = document.querySelector('.chat-input');
            const message = input.value.trim();

            if (message) {
              const chatContent = document.querySelector('.chat-content2');

              // 내가 보낸 메시지 div 생성
              const newMessage = document.createElement('div');
              newMessage.className = 'chat-message sent';
              newMessage.textContent = message;

              chatContent.appendChild(newMessage);
              chatContent.scrollTop = chatContent.scrollHeight;

              input.value = "";
            } else {
              alert("메시지를 입력해주세요.");
            }
          }

          // 오른쪽 채팅창 왼쪽 하단 이미지 첨부
          function insertImg() {
            document.getElementById('imageInput').click();
            // 숨겨진 input을 클릭
          }
        </script>

			</div>
		</div>
	</div>

</body>

</html>