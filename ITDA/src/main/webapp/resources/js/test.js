<script>
    let currentSubscribe = null; //전역에서 구독 객체 추적, 선언해보자

    document.addEventListener("DOMContentLoaded", function () {
        connect();
    const chatRooms = document.querySelectorAll(".list-chat");
	
        chatRooms.forEach(chat => {
        chat.addEventListener("click", function () {
            // 기존 구독 취소
            if (currentSubscribe) {
                console.log("다른 방 선택!! 기존에 있던 스톰프 연결 취소")
                currentSubscribe.unsubscribe();
                currentSubscribe = null;
            }

            // 기존에 있을 수 있는 후기 버튼 제거
            document.querySelectorAll(".review-button").forEach(btn => {
                const wrapper = btn.closest(".system-message");
                if (wrapper) wrapper.remove();
            });

            window.chatRoomId = chat.getAttribute("data-chat-room-id");

            const openImg = chat.getAttribute("data-open-chat-profile");
            const profileImg = chat.getAttribute("data-chat-profile");

            const chatRoomType = chat.getAttribute("data-chat-type");
            const chatBoardId = chat.getAttribute("data-board-id");

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

            // ===== 일반 채팅방인 경우 =====
            if (chatRoomType !== "오픈채팅방") { // 오픈채팅방이 아닌 경우
                transMenuIcon.style.display = "block";
                itemBoard.style.display = "block";

                console.log("거래 채팅방 이미지 경로 : ", profileImg);

                fetch("${contextPath}/chat/selectBoardInfo?boardId=" + chatBoardId)
                    .then(response => {
                        if (!response.ok) throw new Error("게시물 정보 응답 실패");
                        return response.json();
                    })
                    .then(data => {
                        // 거래 채팅방이니 거래 게시물 정보 표기
                        window.boardInfo = data;

                        // 리뷰 당하는 사람이름 지정 및 오른쪽 채팅방 이름 설정
                        document.getElementById("revieweeName").textContent = window.chatRightTitle;
                        chatHeader2.textContent = window.chatRightTitle;

                        // 게시물 번호로 끌고 온 게시물 정보 오른쪽에 할당
                        document.getElementById("product-img").src = data.fileName;
                        document.getElementById("product-name").textContent = data.productName;
                        document.getElementById("transaction-type").textContent = chatRoomType;
                        document.getElementById("board-id").textContent = chatBoardId;

                        return fetch("${contextPath}/chat/messages/" + window.chatRoomId);
                    })
                    .then(res => {
                        if (!res.ok) throw new Error("메세지 가져오기 실패");
                        return res.json();
                    })
                    .then(messages => {
                        console.log("출력되는 메세지 : ", messages);
                        // 출력됐던 메세지 & 사진 모두 지우자
                        document.querySelectorAll(".chat-message received").forEach(element => {
                            element.remove();
                        });
                        document.querySelectorAll(".chat-message sent").forEach(element => {
                            element.remove();
                        });
                        document.querySelectorAll(".img").forEach(element => {
                            element.remove();
                        });
                        messages.forEach(msg => {
                            const newMessage = document.createElement("div");

                            // 내가 보낸 메세지는 오른쪽에
                            if (msg.userNum === loginUserNum) {
                                newMessage.className = "chat-message sent";
                            } else {
                                newMessage.className = "chat-message received";
                            }
                            newMessage.sentAt = msg.sentAt;

                            // 만약 메세지 내용이 null이라면 사진 메세지
                            if (msg.chatContent == null) {
                                if (msg.chatImg) {
                                    console.log("사진 메세지 경로 : ", msg.chatImg);
                                    const img = document.createElement("img");
                                    img.src = contextPath + msg.chatImg;
                                    img.alt = "사진 메시지";
                                    img.style.maxWidth = "200px";
                                    img.style.borderRadius = "8px";
                                    chatContent2.appendChild(img);
                                } else {
                                    newMessage.textContent = "사진이 존재하지 않습니다.";
                                }
                                // 사진이 아니라면 일반 텍스트
                            } else {
                                newMessage.textContent = msg.chatContent;
                                chatContent2.appendChild(newMessage);
                            }
                        });
                    })
                    .catch(err => {
                        console.error("메세지 받아와서 뿌리는거에서 오류!:", err);
                    });

            } else if (chatRoomType === "오픈채팅방") {
                // ===== 오픈채팅방인 경우, 게시물 없이 메세지만 가져오자 =====
                chatHeader2.textContent = window.chatRightTitle;

                transMenuIcon.style.display = "none";
                itemBoard.style.display = "none";
                // 오픈 채팅방인 경우 게시물 정보, 거래 버튼 (거래완료 등) 안 보여줌

                console.log("오픈 채팅방 이미지 경로 : ", openImg);

                fetch("${contextPath}/chat/messages/" + window.chatRoomId)
                    .then(res => {
                        if (!res.ok) throw new Error("메세지 가져오기 실패");
                        return res.json();
                    })
                    // 출력됐던 메세지 & 사진 모두 지우자
                    .then(messages => {
                        console.log("출력되는 메세지 : ", messages);
                        document.querySelectorAll(".chat-message received").forEach(element => {
                            element.remove();
                        });
                        document.querySelectorAll(".chat-message sent").forEach(element => {
                            element.remove();
                        });
                        document.querySelectorAll(".img").forEach(element => {
                            element.remove();
                        });
                        messages.forEach(msg => {
                            const newMessage = document.createElement("div");

                            // 내가 보낸 메세지는 오른쪽에
                            if (msg.userNum === loginUserNum) {
                                newMessage.className = "chat-message sent";
                            } else {
                                newMessage.className = "chat-message received";
                            }
                            newMessage.sentAt = msg.sentAt;

                            // 만약 메세지 내용이 null이라면 사진 메세지
                            if (msg.chatContent == null) {
                                if (msg.chatImg) {
                                    console.log("사진 메세지 경로 : ", msg.chatImg);
                                    const img = document.createElement("img");
                                    img.src = contextPath + msg.chatImg;
                                    img.alt = "사진 메시지";
                                    img.style.maxWidth = "200px";
                                    img.style.borderRadius = "8px";
                                    chatContent2.appendChild(img);
                                } else {
                                    newMessage.textContent = "사진이 존재하지 않습니다.";
                                }
                                // 사진이 아니라면 일반 텍스트
                            } else {
                                newMessage.textContent = msg.chatContent;
                                chatContent2.appendChild(newMessage);
                            }
                        });
                    })
                    .catch(err => {
                        console.error("메세지 받아와서 뿌리는거에서 오류!:", err);
                    });
            }
            // 실시간으로 메세지 보여줌 -> chatStompController 호출
            currentSubscribe = stompClient.subscribe("/topic/room/" + window.chatRoomId, function (message) {
                // message.body가 본문 
                const chatMessage = JSON.parse(message.body);
                console.log("발송하는 채팅 메세시 속성 : ", chatMessage)
                showMessage(chatMessage);
            });
        }); // addEventListener close
        }); // forEach close
    });
// 왼쪽 채팅방 오른쪽에 반영 끝ㅋ
</script>