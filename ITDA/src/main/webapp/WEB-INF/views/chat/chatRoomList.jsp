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

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script
	src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<!-- 우편번호 카카오 API -->

<link
	href="${pageContext.request.contextPath
}/resources/css/globals.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/chat-style.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/modal_css/shippingInform.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/modal_css/shipping_Inform.css">
<link rel="stylesheet" href="/테스트용/style.css">

<c:set var="contextPath" value="${pageContext.request.contextPath}" />


<link rel="stylesheet" href="css/modal.css">
</head>

<body>

	<!-- chat.js 불러오기 -->
	<script src="${contextPath}/resources/js/chat.js"></script>

	<div class="chat-wrapper">

		<!-- 왼쪽 채팅창 -->
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

				<!-- 채팅방 생성 -->
				<form action="${contextPath}/chat/openChatRoom" method="post">
					<input type="hidden" name="refNum" value="3" /> <input
						type="hidden" name="chatRoomId" value="3" /> <input type="hidden"
						name="boardId" value="1001" /> <input type="hidden"
						name="nickName" value="나는야 현이" />

					<button type="submit" class="ellipse-button-chatRoomType">
						<b>채팅방 임의 생성</b>
					</button>
				</form>
				<!-- <button class="ellipse-button-chatRoomType" onclick="openChatRoom()">
					<b>채팅방 임의 생성</b>
				</button>

				<script>
				function openChatRoom() {
				  const data = {
				    refNum: 3,
				    chatRoomId: 3,
				    boardId: 1001,
				    nickName: "나는야 현이"
				  };
				
				  $.ajax({
				    type: "POST",
				    url: "/itda/chat/openChatRoom",
				    data: data,
				    success: function(response) {
				      alert(response.message);
				      if (response.success) {
				    	  alert("서버 오류로 채팅방 생성 성공!");
				      }
				    },
				    error: function() {
				      alert("서버 오류로 채팅방 생성에 실패했습니다.");
				    }
				  });
				}
				</script> -->


				<script>
					// 메뉴 토글 함수
					function chatRoomType() {
						const menu = document.getElementById("chatMenu");
						menu.classList.toggle("hidden");
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


			<!-- 채팅방이 살아 있는 경우 -->
			<c:forEach var="chatRoom" items="${chatRoomList}">
				<c:choose>
					<c:when test="${chatRoom.status == 'Y'}">
						<%-- <p>채팅방 번호: ${chatRoom.chatRoomId}</p>
						<p>상태: ${chatRoom.status}</p>
						<p>유저 번호: ${chatRoom.userNum}</p>
						<p>게시판 번호: ${chatRoom.boardId}</p>
						<p>채팅 유형: ${chatRoom.refNum}</p> --%>

						<!-- 각 채팅방 리스트 for문 돌면서 검색 -->
						<!-- 채팅 리스트 -->
						<div class="chat-content1">

							<!-- 각각의 채팅방 속성 -->
							<!-- 채팅방 거래 유형 할당 ${chatRoom.refName} -->
							<div class="list-chat" data-chat-type="${chatRoom.refName}"
								<%-- data-chat-room-id="${chatRoom.chatRoomId}" --%>
								data-chat-room-id="11"
								style="display: flex; align-items: center; justify-content: space-between; width: 100%;">

								<!-- 프로필 이미지 -->
								<!-- 프로필 버튼 누르면 유저 페이지로 이동 -->
								<button class="profile-button" onclick="goToUserPage('user123')">
									<img src="${contextPath}/resources/images/chat/personEx.png"
										alt="프로필 이미지" width="50" height="50"
										style="border-radius: 20%;" />
								</button>
								<!-- 상대 닉네임, 맨 마지막에 했던 채팅 메세지 -->
								<div style="flex: 1; margin-left: 20px;">
									<!-- 상대 닉네임 -->
									<div class="chatname">${chatRoom.nickName}</div>
									<!-- 마지막 메세지 -->
									<div class="last-message">${chatRoom.chatContent}</div>
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
						</div>
					</c:when>
				</c:choose>
			</c:forEach>

			<!-- 채팅방 나가기, 신고하기 -->
			<script>
          function toggleActionMenu(el) {
            const menu = el.nextElementSibling;
            menu.classList.toggle('hidden');
          }

          function reportChat() {
            alert("신고가 접수되었습니다.");
            // 실제 신고 처리 로직 추가 가능
          }

          // 채팅방 나가면 STATUS = 'N' 처리 
			function leaveChat(button) {
			  const confirmLeave = confirm("대화방에서 나가시겠습니까?");
			  if (confirmLeave) {
			    let listChat = button.closest(".list-chat");
			    if (listChat) {
			      const chatRoomId = listChat.getAttribute("data-chat-room-id");
			
			      // 서버에 POST 요청만 보내고 응답은 무시
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
          
          // 프로필 이미지 누르면 그 사람 소개페이지로 이동
				function goToUserPage(userId) {
					// 예: /mypage/user123 으로 이동
					window.location.href = `/mypage/${userId}`;
				}
        	</script>
			<div class="chat-footer1"></div>
		</div>


		<script>
        // 왼쪽쪽 채팅창 헤더 + 버튼 눌렀을 때 
        // 거래유형에 맞는 채팅방 갈 수 있도록
        function chatRoomType() {
          const menu = document.getElementById('chatMenu');
          menu.classList.toggle('hidden');
        }
        </script>

		<script>
		// 왼쪽 채팅 클릭 시 오른쪽 채팅에 반영
		 const chatRooms = document.querySelectorAll(".list-chat");
		
		 const contextPath = "${pageContext.request.contextPath}";
		
		  chatRooms.forEach(chat => { // 각 채팅방 추출해서 chat에 할당
		    chat.addEventListener("click", function () {
		      const chatRoomId = chat.getAttribute("data-chat-room-id");
		      
		      console.log("chatRoomId:", chatRoomId);
				
		      if (!chatRoomId) {
		          alert("chatRoomId를 찾을 수 없습니다.");
		          return;
		        }
		      
		      const name = chat.querySelector(".chatname").textContent;
		
		      const chatHeader2 = document.querySelector(".chat-header2");
		      const chatContent2 = document.querySelector(".chat-content2");
		      chatContent2.innerHTML = ""; // 기존 메시지 초기화
		      
		      chatHeader2.childNodes[0].textContent = name;
		
		      console.log("fetch URL:", "${contextPath}/chat/messages/" + chatRoomId);
		      
		      // 컨텍스트 경로 포함해서 요청
		      fetch("${contextPath}/chat/messages/" + chatRoomId)   
			    .then(res => {
			          if (!res.ok) throw new Error("404 또는 서버 응답 오류");
			          return res.json();
			        })
		        .then(messages => {
		          messages.forEach(msg => {
		            const newMessage = document.createElement("div");
		            newMessage.className = "chat-message";
		
		            newMessage.textContent = msg.chatContent;
		            chatContent2.appendChild(newMessage);
		          });
		        })
		        .catch(err => {
		          console.error("메시지 로딩 실패", err);
		        });
		    });
		  });
		</script>




		<!-- 오른쪽 채팅방 -->
		<div class="chatting-room">
			<div class="chat-header2">
				상대방 이름
				<!-- 클릭하면 판매자 or 구매자에 맞춰서 해당하는 기능 제공 창  -->
				<button class="ellipse-button" onclick="transactionService()">
					<b>+</b>
				</button>
				<div id="transMenu" class="trans-menu hidden">
					<button class="trans-option"
						onclick="moveToTransOptionByType('주소 요청')">주소 요청</button>
					<button class="trans-option"
						onclick="moveToTransOptionByType('배송 정상 수령')">배송 정상 수령</button>
					<button class="trans-option"
						onclick="moveToTransOptionByType('상품 발송')">상품 발송</button>
					<button class="trans-option"
						onclick="moveToTransOptionByType('거래 완료')">거래 완료</button>
					<button class="trans-option"
						onclick="moveToTransOptionByType('안전 결제')">안전 결제</button>
					<button class="trans-option"
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
				    switch (type) {
				      case "상품 발송":
				      case "주소 요청":
				        openModal('shipping_Inform_Input');
				        break;
				      case "배송 정상 수령":
				        alert("배송을 정상적으로 수령했습니다.");
				        break;
				      case "거래 완료":
				        alert("거래가 완료되었습니다. 채팅 메시지로 기록됩니다.");
				        break;
				      case "사기 계좌 조회":
				        window.open("https://www.police.go.kr/www/security/cyber/cyber04.jsp", "_blank");
				        break;
				      case "안전 결제":
				        window.open("https://www.iamport.kr/", "_blank");
				        break;
				    }
				  }
				</script>
				</div>
			</div>

			<script>
			function openModal(id) {
      	 	document.getElementById(id).style.display = 'flex';
      		}

      		function closeModal(id) {
      	  	document.getElementById(id).style.display = 'none';
	      	}
			</script>
			<!-- ======================= 각 모달 기술 ======================= -->
			<!-- 상품 발송 모달 -->
			<div class="modal-overlay" id="shipping_Inform_Input">

				<div class="modal-container">
					<button class="close-button"
						onclick="closeModal('shipping_Inform_Input')">×</button>
					<div class="truck-icon">🚚</div>
					<div class="title">운송장 번호 입력</div>
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

					<!-- 배송 정보 저장 -->
					<script>
				document.getElementById('submitShippingInfo').addEventListener('click', function() {
					  var deliveryCompany = document.getElementById('deliveryCompany').value;
					  var trackingNumber = document.getElementById('trackingNumber').value.trim();

					  console.log('택배사:', deliveryCompany);
					  console.log('운송장 번호:', trackingNumber);

					  if (!deliveryCompany) {
					    alert('택배사를 선택해주세요.');
					    return;
					  }
					  if (!trackingNumber) {
					    alert('운송장 번호를 입력해주세요.');
					    return;
					  }

					  const chatContent = document.querySelector('.chat-content2');

					  const shippingMessage = document.createElement('div');
					  shippingMessage.className = 'chat-message sent';
					  shippingMessage.innerHTML = `<배송 정보><br>택배사: [\${deliveryCompany}]<br>운송장 번호: [\${trackingNumber}]`;

					  chatContent.appendChild(shippingMessage);
					  chatContent.scrollTop = chatContent.scrollHeight;

					  closeModal('shipping_Inform_Input');
					});
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
								<strong>상품명:</strong>
							</div>
							<!-- 게시글 제목 -->
							<div class="item-type">
								<strong>거래유형:</strong>
							</div>
							<!-- 거래 유형 -->
							<div class="item-price">
								<strong>가격:</strong>
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


                // 메세지 보내기 (AJAX 버전)
                function sendMessage() {
				    const input = document.querySelector('.chat-input');
				    const message = input.value.trim();
				
				    if (!message) {
				        alert("메시지를 입력해주세요.");
				        return;
				    }
				
				    // AJAX로 서버에 메시지 전송
				    $.ajax({
				        type: 'POST',
				        url: '/itda/chat/sendMessage', // 실제 서버 API URL로 변경
				        data: {
				            chatContent: message,
				            chatRoomId: 11 // 이 값도 꼭 넘겨야 합니다 일단 11로 고정
				        },
				        success: function(response) {
				            // 서버 저장 성공 시 화면에 메시지 추가
				            const chatContent = document.querySelector('.chat-content2');
				
				            const newMessage = document.createElement('div');
				            newMessage.className = 'chat-message sent';
				            newMessage.textContent = message;
				
				            chatContent.appendChild(newMessage);
				            chatContent.scrollTop = chatContent.scrollHeight;
				
				            input.value = "";
				        },
				        error: function() {
				            alert("메시지 전송 실패");
				        }
				    });
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

	</div>

</body>

</html>