<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<head>
<%-- <%@ include file="/WEB-INF/views/common/Header.jsp" %> --%>
<!-- 헤더 연결은 나중에 하자 -->
<%@ include file="/WEB-INF/views/common/chatHeader.jsp"%>

<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>ChattingRoomList</title>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<link
	href="${pageCosntext.request.contextPath}/resources/css/globals.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/chat-style.css">

<!-- 모달 CSS 기술 -->
<link
	href="${pageContext.request.contextPath}/resources/css/report/reports.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/modal_css/shipping_Inform.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/modal_css/shipping_Address.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/modal_css/account_Input.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/modal_css/shipping_Address.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/modal_css/manner_Review.css">

<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<script
	src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>

<!-- 신고하기 -->
<script>
	//stompClient 연결 설정
	const userNum = '${loginUser.userNum}';
	const nickName = '${loginUser.nickName}';
	const imageUrl = '${loginUser.imageUrl}';
	const contextPath = '${contextPath}';	
</script>

<script type="text/javascript"
	src="${contextPath}/resources/js/stomp.js"></script>
<!-- 카카오 우편번호 API -->
<script
	src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</head>

<body data-usernum="${loginUser.userNum}">
	<script>
		// 시작전에 오른쪽 채팅방 clean
		document.addEventListener("DOMContentLoaded", function () {
			document.querySelectorAll(".chat-message-received, .chat-message-sent, .chat-system-message, .chat-content2 > img").forEach(element => {
				element.remove();
			});
		});

		// 로그인한 회원 번호
		const loginUserNum = (Number)(document.body.dataset.usernum);	
	</script>

	<div class="chat-wrapper">
		<!-- 왼쪽 채팅창 -->
		<div class="chatlist-container">
			<div class="chat-header1">
				<!-- 거래 유형 -->
				<span id="chatTypeLabel">전체 채팅방</span>
				<!-- '전체 채팅방' 디폴트 -->
				<!-- '+'버튼 누르면 채팅방 유형별 뜨도록 -->
				<button class="ellipse-button-chatRoomType" onclick="chatRoomType()">
					<b>채팅방 선택</b>
				</button>

				<script>
				// 게시물 정보 받아오기 & openChatRoom컨트롤러에 바로 보냄
					function selectBoardInfo(boardId) {			
					fetch("${contextPath}/chat/selectBoardInfo?boardId=" + boardId, {
				    	method: "GET"
				    	})
					      .then(response => {
					        if (!response.ok) throw new Error("게시물 정보 응답 실패");
					        return response.json(); // 컨트롤러에서 보낸 JSON 객체를 JS 객체로 파싱
					      })
					      .then(data => {
					    	  console.log("게시물 정보:", data);
					        
					        return fetch("${contextPath}/chat/openChatRoom" ,{
					        	method: "POST",
					        	headers: {
					                "Content-Type": "application/json"
					              },
					              body: JSON.stringify(data)
					        });
					      })
					      .then(response => {
					    	  if (!response.ok) throw new Error("채팅방 열기 실패");
					      })
					      .catch(err => console.error("오류 발생:", err));    
					  	}			
				</script>

				<div id="chatMenu" class="chat-menu hidden">
					<button class="chat-type" onclick="filterChatByType('전체 채팅방')">전체
						채팅방</button>
					<button class="chat-type" onclick="filterChatByType('교환')">교환</button>
					<button class="chat-type" onclick="filterChatByType('대여')">대여</button>
					<button class="chat-type" onclick="filterChatByType('경매')">경매</button>
					<button class="chat-type" onclick="filterChatByType('나눔')">나눔</button>
					<button class="chat-type" onclick="filterChatByType('오픈채팅방')">오픈채팅방</button>

					<script>
		            // 상단 텍스트 바꾸는 함수
		            function filterChatByType(type) {
		              const chatList = document.querySelectorAll(".list-chat");
		
		              chatList.forEach(chat => {
		                const chatType = chat.getAttribute("data-chat-type");
		                // 교환인지, 나눔인지, 경매인지 얻어옴
		
		                // '전체 채팅방'일 때는 모두 보이게
		                if (type === "전체 채팅방" || chatType === type) {
		                  chat.style.display = "flex";
		                } else {
		                  chat.style.display = "none";
		                }
		              });
		
		              // 상단 라벨 변경
		              const label = document.getElementById("chatTypeLabel");
		              if (label) label.textContent = type;
		
		              // 메뉴 닫기
		              const menu = document.getElementById("chatMenu");
		              if (menu) menu.classList.add("hidden");
		            }		       
		          </script>
				</div>
			</div>

			<script>
			// 채팅방 나가면 STATUS = 'N' 처리1 11
			function leaveChat(button) {
		        const confirmLeave = confirm("대화방에서 나가시겠습니까?");
		        if (confirmLeave) {
		        	 // 대화방 나가면 오른쪽 창 비워주자
		            document.querySelectorAll(".chat-message-received, .chat-message-sent, .chat-system-message, .chat-content2 > img").forEach(element => {
		                element.remove();
		            });
		            let listChat = button.closest(".list-chat");
		            if (listChat) {
		                const chatRoomId = listChat.getAttribute("data-chat-room-id");
		                fetch("${contextPath}/chat/exit/" + chatRoomId, {
		                    method: "POST",
		                    headers: {
		                        "Content-Type": "application/json"
		                    }
		                });
		                // UI 상에서 채팅방 제거
		                listChat.remove();
		                alert("대화방을 나갔습니다.");
		            }		           
		        }		        
		    }
			
			// 신고하기 
			function reportChat(){
				// 신고하기 모달창 열어주자.
				openModal("reportModal");	
			}
			
     		// 프로필 이미지 누르면 그 사람 소개페이지로 이동 (태형이 마이페이지)
			function goToUserPage() {
				window.location.href = "/itda/user/mypageOthers/" + window.opponentUserNum;
			}
			</script>

			<!-- 채팅방이 살아 있는 경우 -->
			<c:forEach var="chatRoom" items="${chatRoomList}">
				<c:choose>
					<c:when test="${chatRoom.status == 'Y'}">
						<!-- 채팅 리스트 -->
						<div class="chat-content1">
							<!-- 각각의 채팅방 속성 -->
							<div class="list-chat" data-chat-room-id="${chatRoom.chatRoomId}"
								data-chat-userNum="${chatRoom.userNum}"
								data-board-id="${chatRoom.boardId}"
								data-chat-type="${chatRoom.refName}"
								data-chat-nickname="${chatRoom.nickName}"
								data-chat-profile="${chatRoom.imageUrl}"
								data-open-chat-room-name="${chatRoom.openChatRoomName}"
								data-open-chat-count="${chatRoom.openChatCount}"
								data-open-chat-profile="${chatRoom.fileName}"
								style="display: flex; align-items: center; justify-content: space-between; width: 100%;">

								<script>
									// 왼쪽 채팅창 마지막 메세지 가져오기			
									(function () {							   
									    const chatRoomId = "${chatRoom.chatRoomId}";
									    fetch("${contextPath}/chat/bringLastMessage?chatRoomId=" + chatRoomId, {
									      method: "GET"
									    })
									    .then(res => {
									      if (!res.ok) throw new Error("메세지 못 받아옴");
									      return res.json(); 
									    })			    
									    .then(lastMessage => {
									      const targetDiv = document.getElementById("lastMessage-" + chatRoomId);		
									      // 사진인 경우 <사진>으로 출력
									      if (lastMessage.chatContent) {
									            const trimmedMessage = lastMessage.chatContent.length > 8 
								                ? lastMessage.chatContent.slice(0, 8) + "..."
								                : lastMessage.chatContent;
								            targetDiv.textContent = trimmedMessage;
								        } else if (lastMessage.chatImg) {
								        	targetDiv.textContent = "<사진>";
								        } else {
								        	targetDiv.textContent = "";
								        }
									    })
									    .catch(err => console.error("마지막 메시지 로드 실패:", err));
									})();

									if("${chatRoom.refName}"==="오픈채팅방") console.log("오픈 프로필", "${contextPath}/resources/images/chat/openchat/"+"${chatRoom.fileName}");										
									else console.log("${chatRoom.refName}", "개인 거래 프로필", "${chatRoom.imageUrl}");																					
							
									console.log("각 채팅방 번호 :", "${chatRoom.chatRoomId}");
								</script>

								<c:choose>
									<c:when test="${chatRoom.refName == '오픈채팅방'}">
										<img
											src="/itda/resources/images/chat/openchat/2025080412442662255.png"
											alt="오픈채팅방 프로필" width="50" height="50"
											style="border-radius: 20%;" />
									</c:when>

									<c:otherwise>
										<button class="profile-button" onclick="goToUserPage()">
											<!-- 프로필 이미지 및 오픈채팅방 대표 이미지 경로 할당 필요 -->
											<!-- 오픈 채팅방 대표 이미지 경로 직접 할당 -->
											<img id="profileImage-${chatRoom.chatRoomId}"
												src="${contextPath}${chatRoom.imageUrl}" alt="상대방 프로필 이미지"
												width="50" height="50" style="border-radius: 20%;" />
										</button>

										<script>			
										/* ===================================== 거래 채팅방 프로필 나타내기 ===================================== */
											if("${chatRoom.refName}" !== "오픈채팅방"){
												fetch("${contextPath}/chat/selectOpponentProfile?chatRoomId=${chatRoom.chatRoomId}", {
													method: "GET"
												})
													.then(response => {
														if (!response.ok) throw new Error("상대방 프로필 불러오기 실패ㅠㅠ");
														return response.json();
													})
													.then(data => {
														console.log("상대방 정보 :", data);
														const imgEl = document.getElementById("profileImage-${chatRoom.chatRoomId}");
														if (imgEl) {
															imgEl.src = "${contextPath}" + data.imageUrl;
															window.revieweeImg = "${contextPath}" + data.imageUrl;															
															imgEl.alt = data.nickName + "프로필 이미지";
															console.log("상대방 프로필 경로 :", window.revieweeImg);
														} else {
															console.log("상대방 프로필 없음!!");
														}
														
														const titleEl = document.getElementById("chatname-${chatRoom.chatRoomId}");
														if (titleEl) {
															window.revieweeNickName = data.nickName;
															console.log("상대방 닉네임 :", data.nickName);
															titleEl.textContent = data.nickName;															
														} else {
															console.log("상대방 닉네임 없음!!");
														}
														// 상대방 회원 번호 전역변수로 쓰자
														window.opponentUserNum = data.opponentUserNum;
														console.log("상대방 회원 번호 :", window.opponentUserNum);														
													}).catch(error => {
														console.error("에러 발생:", error);
													})
											}
										</script>
									</c:otherwise>
								</c:choose>


								<div style="flex: 1; margin-left: 20px;">
									<!-- 상대 닉네임 or 오픈채팅방 제목 -->
									<c:choose>
										<c:when test="${chatRoom.refNum == 5}">
											<!-- 오픈채팅방인 경우 오픈채팅방 제목 -->
											<div class="chatname">${chatRoom.openChatRoomName}
												<!-- 오픈 채팅방 인원 수 -->
												<span class="chatMemberCount"> 참여:
													${chatRoom.openChatCount} /30</span>
											</div>
											<div class="lastM" id="lastMessage-${chatRoom.chatRoomId}"></div>
										</c:when>

										<c:otherwise>
											<!-- 거래채팅방인 경우 거래채팅방 제목 -->
											<div class="chatname" id="chatname-${chatRoom.chatRoomId}">${chatRoom.nickName}</div>
											<div class="lastM" id="lastMessage-${chatRoom.chatRoomId}"></div>
										</c:otherwise>
									</c:choose>

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
										<button class="exit-report-button"
											onclick="openReportModal('OPENCHAT', ${chatRoom.chatRoomId}, ${chatRoom.userNum})">🚩
											신고하기</button>
										<button class="exit-report-button" onclick="leaveChat(this)">❌
											대화 나가기</button>
									</div>
								</div>
							</div>
						</div>
					</c:when>
				</c:choose>
			</c:forEach>
		</div>


		<!-- 오른쪽 채팅방 -->
		<div class="chatting-room">
			<div class="chat-header2">
				<span id="chat-header2-title">왼쪽 채팅방을 눌러 대화를 시작하세요.</span>
				<!-- 클릭하면 판매자 or 구매자에 맞춰서 해당하는 기능 제공 창  -->
				<button class="ellipse-button" onclick="transactionService()"
					id="transMenuIcon">
					<b>+</b>
				</button>
			</div>
			<div id="transMenu" class="trans-menu hidden">
				<button class="trans-option"
					onclick="moveToTransOptionByType('배송지 정보 입력')">배송지 정보 입력</button>
				<!-- <button class="trans-option"
					onclick="moveToTransOptionByType('배송 정상 수령')">배송 정상 수령</button> -->
				<button class="trans-option"
					onclick="moveToTransOptionByType('운송장 입력')">운송장 입력</button>
				<button class="trans-option"
					onclick="moveToTransOptionByType('계좌 정보 전송')">계좌 정보 전송</button>
				<button class="trans-option"
					onclick="moveToTransOptionByType('안전 결제')">안전 결제</button>
				<button class="trans-option"
					onclick="moveToTransOptionByType('사기 계좌 조회')">사기 계좌 조회</button>
				<button class="trans-option"
					onclick="moveToTransOptionByType('거래 완료')">거래 완료</button>
				<!-- 
	            나눔, 교환
	             - 구매자 기준 버튼 : 주소요청, 배송 정상 수령, 운송장 입력, 거래 완료
	             - 판매자 기준 버튼 : 주소요청, 배송 정상 수령, 운송장 입력, 거래 완료
	
	            대여, 경매
	             - 구매자 기준 버튼 : 안전결제(아이엠포트), 배송정상수령, 사기 계좌 조회(경찰청), 거래완료
	             - 판매자 기준 버튼 : 배송지 정보 입력, 운송장 입력, 계좌 정보 전송
	
	            오픈채팅방에는 해당 버튼 필요X
	          -->
			</div>

			<script>
			
			
				// 배송지 정보 입력, 배송 정상 수령 등 버튼 누르면 해당하는 alert창 및 채팅방 생성
				  function moveToTransOptionByType(type) {
				    switch (type) {
				      case "운송장 입력":
				        openModal('shipping_Inform_Input');
				        break;
				      case "배송지 정보 입력":
				    	openModal('shipping_Address_Modal');
				    	break;
				      /* case "배송 정상 수령":
				        alert("배송을 정상적으로 수령했습니다.");
				        break; */
				      case "계좌 정보 전송":
				    	openModal('account_Inform_Input');
					    break;
				      case "거래 완료":
				        alert("거래가 완료되었습니다. \n생성된 버튼을 눌러 상대방의 매너 점수를 평가해주세요.");
				        // 거래 완료되면 데이터 조작
				       	completeTransaction();
				        // 버튼 생성하고 모달 오픈
				        break;
				      case "사기 계좌 조회":
				    	alert("이동하는 페이지를 통해 사기 계좌 및 전화번호를 확인하세요.");
				        window.open("https://www.police.go.kr/www/security/cyber/cyber04.jsp", "_blank");
				        break;
				      case "안전 결제":
				        window.open("https://www.iamport.kr/", "_blank");
				        break;
				    }
				  }
				</script>

			<script>
			// 거래 완료 버튼 생성 및 모달 오픈
			function completeTransaction() {
				  const chatContent = document.querySelector('.chat-content2');

				  // 이미 버튼이 있다면 중복 생성 방지
				  if (chatContent.querySelector('.review-button')) return;

				  const messageWrapper = document.createElement('div');
				  messageWrapper.classList.add('message', 'system-message');
				  
				  messageWrapper.innerHTML = `
				    <button class="review-button" onclick="openModal('manner_Review')">
				     후기 작성하기
				    </button>
				  `;
				  // 채팅창에 추가
				  chatContent.appendChild(messageWrapper);
				  // 스크롤 하단으로 이동
				  chatContent.scrollTop = chatContent.scrollHeight;
				}
			</script>


			<!-- ======================= 각 모달 기술 ======================= -->
			<!-- 신고 모달 -->

			<!-- 매너 평가 모달 -->
			<div id="manner_Review" class="modal-overlay hidden">
				<div class="modal">
					<div class="close-button" onclick="closeModal('manner_Review')">×</div>
					<h2>매너 평가</h2>
					<p>
						거래가 정상적으로 완료되었습니다. <br> 상대방의 매너 점수를 평가해주세요!
					</p>
					<div class="user-info">
						<!-- 상대방 프로필 이미지 -->
						<!-- 경로 할당 필요! -->
						<div class="user-icon">
							<img id="reviewee-Img" src="" alt="프로필 이미지" width="50"
								height="50" style="border-radius: 20%;" />
						</div>
						<div class="username" id="revieweeName">상대방 닉네임</div>
					</div>
					<div class="slider-container">
						<div id="tempDisplay" class="temp-indicator" style="left: 36%">
							🔥 <span id="tempValue">36°C</span>
						</div>
						<input type="range" id="slider" min="0" max="100" value="36">
					</div>

					<div class="feedback">상대방에게 후기를 남겨주세요!</div>
					<textarea class="feedback-input" id="reviewText"
						placeholder="후기 내용을 입력하세요"></textarea>

					<div class="btns">
						<button class="btn cancel" onclick="closeModal('manner_Review')">취소</button>
						<button class="btn confirm" onclick="submitReview()">확인</button>
						<!-- 확인 버튼 누르면 온도, 후기 내용 얻어짐 -->
					</div>
				</div>
			</div>

			<script>						
		        const slider = document.getElementById("slider");
		        const tempDisplay = document.getElementById("tempDisplay");
		        const tempValue = document.getElementById("tempValue");
		
		        slider.addEventListener("input", function () {
		            const val = slider.value;
		            tempValue.textContent = `\${val}°C`;
				
		            const percent = (val - slider.min) / (slider.max - slider.min) * 100;
		            tempDisplay.style.left = `\${percent}%`; 
		
		            // 36.5 기준으로 아이콘 바뀜 
		            tempDisplay.innerHTML = (val >= 36.5 ? "🔥" : "❄️") + ` <span>\${val}°C</span>`;
		        });

		    </script>

			<script>
			// 매너 평가자, 매너 평가 당하는 사람 두명 지정해줘야 됨
		        function submitReview() {
		        let hasSubmitted = false; // 이미 제출되어 있지 않음
				closeModal('manner_Review');
				if (hasSubmitted) {
					alert("이미 후기를 제출하셨습니다.");
					return;
				}

				const reviewTextarea = document.getElementById('reviewText');
				const sliderValue = parseInt(document.getElementById("slider").value);
				const reviewText = document.getElementById("reviewText").value.trim();

				console.log("매너 온도: ", sliderValue);
				console.log("후기 내용: ", reviewText);
				console.log("후기 남길 게시물 ID: ", window.boardInfo.boardId);
				console.log("후기 받을 회원 번호 (게시물 주인): ", window.boardInfo.userNum);

				// POST 요청 보내기
				fetch("${contextPath}/chat/insertManner/", {
					method: 'POST',
					headers: {
						'Content-Type': 'application/json'
					},
					body: JSON.stringify({
						sliderValue: sliderValue,
						reviewText: reviewText,
						boardId: window.boardInfo.boardId,
						userNum: window.boardInfo.userNum
					})
				})
				.then(response => {
					if (response.ok) {
						alert("후기가 등록되었습니다!");
					    reviewTextarea.value = "";
					    
					    // 거래 완료 메세시 시스템메세지로 보냄
					    const message = "거래가 완료되었습니다.";
					    stompClient.send("/app/chat/sendMessage", {}, JSON.stringify({
					    	userNum: 0,
			                chatContent: message,
			                chatRoomId: window.chatRoomId			                
			            }));
					} else {
						alert("이미 후기가 등록되었습니다!");
					}				
				})
				.catch(error => {
					console.error("에러 발생:", error);
				});

				hasSubmitted = true;
			}
			</script>

			<!-- 운송장 정보 입력 모달 -->
			<div class="modal-overlay" id="shipping_Inform_Input">
				<div class="modal-container">
					<button class="close-button"
						onclick="closeModal('shipping_Inform_Input')">×</button>
					<div class="truck-icon">🚚</div>
					<div class="title">운송장 정보 입력</div>
					<!-- 택배사 및 운송장 번호 저장 -->
					<select id="deliveryCompany">
						<option value="">택배사 선택</option>
						<option value="CJ대한통운">CJ대한통운</option>
						<option value="한진택배">한진택배</option>
						<option value="로젠택배">로젠택배</option>
						<option value="우체국">우체국</option>
						<option value="롯데택배">롯데택배</option>
					</select> <input type="text" id="trackingNumber"
						placeholder="운송장 번호 - 없이 입력">
					<button class="submit-button" id="submitShippingInfo">다음</button>
				</div>
			</div>

			<!-- 배송지 정보 입력 모달 -->
			<div class="modal-overlay" id="shipping_Address_Modal">
				<div class="modal-container">
					<div class="modal-header">
						<span class="title-sub">IT다 배송지 정보 입력창</span>
						<button class="close-button"
							onclick="closeModal('shipping_Address_Modal')">×</button>
					</div>

					<div class="modal-body">
						<div class="icon-section">🚚</div>
						<h2 class="main-title">배송지 정보 입력</h2>
						<p class="sub-title">
							<!-- 상품 제목 -->
							<br>(주)잇다
						</p>
						<form class="address-form">
							<label>받으시는 분</label> <input type="text" class="input" id="name"
								placeholder="받으시는 분 성함" /> <label>주소</label>
							<div class="address-zip">
								<input type="text" class="input" id="zipcode" placeholder="우편번호" />
								<button type="button" class="zip-btn"
									onclick="execDaumPostcode()">우편번호 찾기</button>
							</div>
							<input type="text" class="input disabled" id="address"
								placeholder="주소" disabled /> <input type="text" class="input"
								id="detailAddress" placeholder="상세 배송지 정보 입력" /> <label>휴대폰
								번호</label> <input type="text" class="input" id="phone"
								placeholder="휴대폰 번호 - 없이 입력" />
						</form>

						<button class="next-button" id="nextButton">다음</button>
					</div>
				</div>
			</div>

			<!-- 내 계좌 정보 입력 모달 -->
			<div id="account_Inform_Input" class="modal-overlay">
				<div class="modal-box">
					<button class="close-button"
						onclick="closeModal('account_Inform_Input')">×</button>
					<div class="modal-header">IT다 결제창</div>

					<h2 class="modal-title">내 계좌 정보 입력</h2>
					<p class="item-desc" id="item-desc-title">
						상품명<br> ${productName}
						<!-- 전달된 상품명 동적 표현 -->
					</p>

					<input type="text" class="input-box"
						placeholder="상대방과 최종 합의된 가격을 기입해주세요." id="price" /> <select
						class="input-box" id="bank">
						<option disabled selected>은행선택</option>
						<option>신한은행</option>
						<option>국민은행</option>
						<option>카카오뱅크</option>
						<option>토스뱅크</option>
						<option>농협은행</option>
					</select> <input type="text" class="input-box" placeholder="계좌 입력"
						id="account" />
					<button class="submit-button" onclick="submitAccountInfo()">다음</button>
				</div>
			</div>



			<!-- ===================== 오른쪽 창 메세지 ===================== -->
			<div class="chat-content2">
				<!-- 바디 부분 -->
				<div class="chat-message" id="item-board">
					<button class="item-button" onclick="goToBoardPage()">
						<!-- 게시물 사진 -->
						<img id="product-img" src="" alt="상품 이미지" width="150" height="150"
							style="border-radius: 20%;">
						<div class="item-description">
							<span id="product-name"></span> <span id="transaction-type"></span>
							<span id="board-id"></span>
							<!-- 거래 유형에 맞게 추가 정보 보여주자 -->
							<div id="extra-info"></div>
						</div>
					</button>
				</div>
				<!-- 데베에 있던 메세지 끝어옴 -->
				<div class="chat-message-received">
					<!-- 받은 메시지 전체 감싸는 div -->
					<div class="chat-user-info">
						<!-- 프로필 이미지와 닉네임 영역 -->
						<img src="상대방프로필" alt="상대방 이미지" class="chat-profile-img"> <span
							class="chat-nickname"></span>
					</div>
					<div class="chat-text"></div>
					<!-- 실제 채팅 메시지 -->
					<div class="chat-time"></div>
					<!-- 보낸 시간 -->
				</div>
			</div>

			<div class="chat-footer2">
				<!-- 버튼 눌렀을 때 나올 메뉴 -->
				<!-- 실제 파일 업로드용 input (숨김 처리) -->
				<input type="file" id="imageInput" accept="image/*"
					style="display: none;" onchange="uploadImage(this)" />
				<!-- 사용자가 누르게 될 버튼 -->
				<button class="ellipse-button" onclick="insertImg()">
					<b>+</b>
				</button>
				<input type="text" class="chat-input" placeholder="메시지를 입력하세요..."
					onkeydown="handleKeyDown(event)" />
				<button class="send-button" onclick="sendMessage()">
					<b>전송</b>
				</button>

				<!-- =========================우측 채팅방 기능========================= -->
				<script>
                const transMenu = document.getElementById("transMenu");
                const transMenuIcon = document.getElementById('transMenuIcon');
                
				// 메뉴 토글
				transMenuIcon.addEventListener("click", function (event) {
					event.stopPropagation(); // 문서 클릭 이벤트 방지
					transMenu.classList.toggle("show");
				});

				transMenu.addEventListener("click", function(event) {
				  event.stopPropagation();
				});
                
				function handleKeyDown(event) {
					if (event.key === "Enter") {
						event.preventDefault(); // 폼 제출 막기 (폼이 있을 경우)
						sendMessage(); // 전송 함수 호출
					}
				}

                // 오른쪽 채팅창 헤더 +버튼 눌렀을 때 
                // 주소요청, 운송장 입력 등 거래 유형에 맞게 보여줌                
                function transactionService() {
                    transMenu.classList.toggle("hidden");
                }
                
                // 오른쪽 채팅창 왼쪽 하단 이미지 첨부
                function insertImg() {
                    document.getElementById('imageInput').click();
                    // 숨겨진 input을 클릭
                }
                
                // 이미지 선택시, 이미지 서버 저장, DB삽입하자
                function uploadImage(input) {
                    const file = input.files[0];
                    if (!file) return;
                    
                    console.log("사진 파일 : ", file);

                    // 실제 사진 파일, 채룸 아이디
                    const formData = new FormData();
                    formData.append('image', file);
                    formData.append('chatRoomId', window.chatRoomId); // 채팅방 id도 같이 전송

                    fetch("${contextPath}/chat/uploadImageMessage", {                    	
                        method: 'POST',
                        body: formData
                    })
                    .then(response => response.json())
                    .then(data => {                    	
                        if (data.success) {
                            stompClient.send("/topic/room/" + window.chatRoomId, {}, JSON.stringify(data.chatMessage));
                        } else {
                            alert('이미지 업로드 실패');
                        }
                    })
                    .catch(err => {
                        console.error(err);
                        alert('에러 발생');
                    });
                } 
                
                // 게시물 상제 조회에서 누르면 사이트로 이동
                function goToBoardPage(){               
                	let url = "";
                	if(window.chatRoomTypeOf === "대여"){
                		url = "/itda/board/detail/rental/" + window.chatBoardNum;
                	}else if(window.chatRoomTypeOf === "나눔"){
                		url = "/itda/board/detail/share/" + window.chatBoardNum;
                	}else if(window.chatRoomTypeOf === "경매"){
                		url = "/itda/board/detail/auction/" + window.chatBoardNum;
                	}					
					window.location.href = url;
				}
            </script>
			</div>
		</div>
	</div>

	<!-- ================= 왼쪽 채팅방 누르면 오른쪽에 해당 채팅 정보 출력 ================== -->
	<script>
	let currentSubscribe = null; //전역에서 구독 객체 추적, 선언해보자
	
    document.addEventListener("DOMContentLoaded", function () {
    	connect();
        const chatRooms = document.querySelectorAll(".list-chat");
	
        chatRooms.forEach(chat => {
            chat.addEventListener("click", function () {
            	// 기존 구독 취소
                if (currentSubscribe) {
                	console.log("다른 방 선택!! 기존에 있던 구독 연결 취소")
                	currentSubscribe.unsubscribe();
                	currentSubscribe = null;
                }
            	
            	// 기존에 있을 수 있는 후기 버튼 제거
            	document.querySelectorAll(".review-button").forEach(btn => {
				    const wrapper = btn.closest(".system-message");
				    if (wrapper) wrapper.remove();
				});
            	
                window.chatRoomId = chat.getAttribute("data-chat-room-id");
                console.log("window.chatRoomId :", window.chatRoomId);
                
                const openImg = chat.getAttribute("data-open-chat-profile");
				const profileImg = chat.getAttribute("data-chat-profile");	
					
                const chatRoomType = chat.getAttribute("data-chat-type");
                window.chatRoomTypeOf = chatRoomType; 
                
                const chatBoardId = chat.getAttribute("data-board-id");                
                console.log("chatBoardId :", chatBoardId);
                window.chatBoardNum = chatBoardId;

                const chatHeader2 = document.getElementById("chat-header2-title");

                const transMenuIcon = document.getElementById("transMenuIcon");

                const chatContent2 = document.querySelector('.chat-content2');
                const itemBoard = document.getElementById("item-board");

                if (itemBoard) {
                    itemBoard.style.display = "block";
                } else {
                    console.warn("itemBoard가 존재하지 않습니다.");
                }

                console.log("채팅방 유형 : ", chatRoomType);
                console.log("채팅방 번호 : ", window.chatRoomId);

                window.chatRightTitle = chatRoomType === "오픈채팅방"
                    ? chat.getAttribute("data-open-chat-room-name")
                    : chat.getAttribute("data-chat-nickname");

                window.boardInfo = null;

                // ========================= 거래 채팅방인 경우 =========================
                if (chatRoomType!=="오픈채팅방") { 
                    transMenuIcon.style.display = "block";
                    itemBoard.style.display = "block";
                    
                    console.log("거래 채팅방 이미지 경로 : ", profileImg);                   

                 	// ========================== 상대방 정보 나타내기 ==========================
					fetch("${contextPath}/chat/selectOpponentProfile?chatRoomId=" + window.chatRoomId)
                        .then(response => {
                            if (!response.ok) throw new Error("게시물 정보 응답 실패");
                            return response.json();
                        })
                        .then(opponentInfo => {
                           	console.log("후기 당하는 사람(상대방) :", opponentInfo);
                           	
                        	// 리뷰 당하는 사람이름 지정 및 오른쪽 채팅방 이름 설정
                        	chatHeader2.textContent = opponentInfo.nickName;   
                        	document.getElementById("revieweeName").textContent = opponentInfo.nickName;
                        	document.getElementById("reviewee-Img").src = "/itda"+opponentInfo.imageUrl;
                        	
                        	// ========================== 거래 정보 나타내기 ==========================
                        	return fetch("${contextPath}/chat/selectBoardInfo?boardId=" + chatBoardId)
                        })                                           
                        .then(response => {
                            if (!response.ok) throw new Error("게시물 정보 응답 실패");
                            return response.json();
                        })
                        .then(data => {
                        	// 거래 채팅방이니 거래 게시물 정보 표기
                            window.boardInfo = data; 

                            // 게시물 번호로 끌고 온 게시물 정보, 오른쪽 채팅방 할당
                            // 오른쪽 채팅방 제목 할당                            
                            document.getElementById("product-name").textContent = "상품명 : " + data.productName;
                            document.getElementById("transaction-type").textContent = "거래 유형 : " + chatRoomType;
                            document.getElementById("board-id").textContent = "게시물 아이디 : " + chatBoardId;                             
                            
                            const extraInfo = document.getElementById("extra-info");
                            extraInfo.innerHTML = ""; // 초기화 먼저 하자
                            
                            // 거래 유형에 맞게 게시물 정보 보여줌
							if(chatRoomType === "대여"){
							// 대여금액, 보증금	
								extraInfo.textContent = "대여금액 : " + data.rentalFee + 
								"원\n보증금 : " + data.deposit + "원";				    
							} else if(chatRoomType === "경매"){
								// 거래 낙찰 상태인경우
								console.log("경매 정보 :", data);
								if(data.bid !== 0){
									extraInfo.textContent = "<낙찰 완료>\n입찰 시작가 : " + data.auctionStartingFee + 
									"원\n최종 낙찰가 : " + data.bid;
								}
								else {
									extraInfo.textContent = "<입찰 진행중>\n입찰 시작가 : " + data.auctionStartingFee + 
									"원\n종료일 : " + data.auctionEndDate;
								}
							} else if(chatRoomType === "나눔"){
							// 나눔 갯수
								extraInfo.textContent = "나눔 갯수 : " + data.sharingCount + "개";
							}       
                            
                            // 거래 유형에 맞게 사진 경로 정해줌
                    		if(chatRoomType === "대여"){
                    			const imgSrc = "${contextPath}/resources/images/board/rental/" + data.fileName;                    			
                    			document.getElementById("product-img").src = imgSrc;                     			
                    			
                    		} else if(chatRoomType === "경매"){
                    			const imgSrc = "${contextPath}/resources/images/board/auction/" + data.fileName;
                    			document.getElementById("product-img").src = imgSrc;
                    			
                    		} else if(chatRoomType === "교환"){
                    			const imgSrc = "${contextPath}/resources/images/board/exchange/" + data.fileName;
                    			document.getElementById("product-img").src = imgSrc;
                    		}                            
                            // 이제 메세지 가져오자
                            return fetch("${contextPath}/chat/messages/" + window.chatRoomId);
                        })
                        .then(res => {
                            if (!res.ok) throw new Error("메세지 가져오기 실패");
                            return res.json();
                        })
                        .then(messages => {
                        	console.log("출력되는 메세지 : ", messages);
                        	// 출력됐던 메세지 & 사진 모두 지우자
                            document.querySelectorAll(".chat-message-received, .chat-message-sent, .chat-system-message, .chat-content2 > img").forEach(element => {
                            	element.remove();
                            	});
                            messages.forEach(msg => {
                            	showMessage(msg);
                            });
                        })
                        .catch(err => {
                            console.error("메세지 받아와서 뿌리는거에서 오류!:", err);
                        });

                    
                } else if (chatRoomType === "오픈채팅방") {
                	// ========================= 오픈채팅방인 경우, 게시물 없이 메세지만 가져오자 =========================
                	chatHeader2.textContent = window.chatRightTitle;

                	transMenuIcon.style.display = "none";
                	itemBoard.style.display = "none";
                	// 오픈 채팅방인 경우 게시물 정보, 거래 버튼 (거래완료 등) 안 보여줌

                	console.log("오픈 채팅방 대표 이미지 경로 : ", openImg);

                	fetch("${contextPath}/chat/messages/" + window.chatRoomId)
                		.then(res => {
                			if (!res.ok) throw new Error("메세지 가져오기 실패");
                			return res.json();
                		})
                		// 출력됐던 메세지 & 사진 모두 지우자
                		.then(messages => {
                			console.log("출력되는 메세지 : ", messages);
                			document.querySelectorAll(".chat-message-received, .chat-message-sent, .chat-system-message, .chat-content2 > img").forEach(element => {
                				element.remove();
                			});
                			messages.forEach( msg => {
                				showMessage(msg);                				
                			});
                		})
                		.catch(err => {
                			console.error("메세지 받아와서 뿌리는거에서 오류!:", err);
                		});
                }      
                // 실시간으로 메세지 보여줌 -> chatStompController 호출
                currentSubscribe = stompClient.subscribe("/topic/room/" + window.chatRoomId, function(message){
                    // message.body가 본문 
                    const chatMessage = JSON.parse(message.body);
                    console.log("발송하는 채팅 메세시 속성 : ", chatMessage)
                    showMessage(chatMessage);                    
                });          
                
            }); // addEventListener close
        }); // forEach close
        
        (function() {
        	  const params     = new URLSearchParams(window.location.search);
        	  const rawParam   = params.get("chatRoomId") || params.get("roomId");
        	  const fromParam  = rawParam && rawParam.trim().length>0 ? rawParam.trim() : null;
        	  const rawSession = sessionStorage.getItem('pendingOpenRoomId');
        	  const fromSession = rawSession && rawSession.trim().length>0 ? rawSession.trim() : null;
        	  const roomToOpen = fromParam || fromSession;

        	  console.log(`🔍 URL chatRoomId: ${params.get("chatRoomId")}, URL roomId: ${params.get("roomId")}, 세션: ${fromSession}`);
        	  if (!roomToOpen) {
        	    console.log("⁉️ 자동 열기 대상이 없습니다.");
        	    sessionStorage.removeItem('pendingOpenRoomId');
        	    return;
        	  }

        	  const el = Array.from(chatRooms).find(c => c.dataset.chatRoomId === roomToOpen);
        	  if (el) {
        	    console.log(`✅ 자동 열기 성공! roomId=${roomToOpen}`);
        	    el.click();
        	  } else {
        	    console.warn(`❌ 자동 열기 실패, 못 찾음: ${roomToOpen}`);
        	  }
        	  sessionStorage.removeItem('pendingOpenRoomId');
        	})();
      });
</script>

	<!-- chat.js 참조 -->
	<script type="text/javascript"
		src="${contextPath}/resources/js/chat/chat.js"></script>

	<jsp:include page="/WEB-INF/views/report/report.jsp" />
	<script
		src="${pageContext.request.contextPath}/resources/js/report/reports.js"></script>
</body>

</html>
