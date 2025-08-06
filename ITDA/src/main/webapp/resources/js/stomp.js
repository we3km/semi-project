let stompClient = null;
function connect() {
    if (stompClient && stompClient.connected) {
        console.log("이미 연결되어 있음");
        return;
    }

    const socket = new SockJS(contextPath + "/stomp");
    stompClient = Stomp.over(socket);

    stompClient.connect({}, function (frame) {
        console.log('Connected: ' + frame);
    });
}

// 모달에서 작성되는 메세지 보내기
function sendModalMessage(modalMessage) {
    console.log("회원 로그인 번호 : ", loginUserNum);
    console.log("챗룸아이디 전역변수 : ", window.chatRoomId);

    stompClient.send("/app/chat/sendMessage", {}, JSON.stringify({
        chatContent: modalMessage,
        chatRoomId: window.chatRoomId
    }));
}

// 텍스트에서 작성되는 메세지 보내기
function sendMessage() {
    const input = document.querySelector('.chat-input');
    const message = input.value;

    // 회원된 로그인 번호
    console.log("회원 로그인 번호 : ", loginUserNum);
    console.log("메세지 보내는 채팅방 : ", window.chatRoomId);
    console.log("보내는 메세지 : ", message);

    const userNum = loginUserNum;
    let nickName = null;
    let imageUrl = null;

    // 메세지 보내는 사람 정보 따와서 메세지 정보에 할당
    fetch(contextPath + "/chat/getSenderInfo?userNum=" + userNum, {
        method: "GET"
    }).then(response => response.json())
        .then(data => {
            nickName = data.nickName;
            imageUrl = data.imageUrl;

            console.log("채팅자 정보!!!!!! : ", data);

            // ChatStompController 호출
            stompClient.send("/app/chat/sendMessage", {}, JSON.stringify({
                chatContent: message,
                chatRoomId: window.chatRoomId,
                nickName: nickName,
                imageUrl: imageUrl
            }));

            const lastMessageElement = document.getElementById("lastMessage-" + window.chatRoomId);
            if (lastMessageElement) {
                lastMessageElement.textContent = message;
            }

            input.value = ""; // 입력란 비워줌
        }).catch(err => console.error("오류 발생: ", err));

    if (!message) {
        alert("메세지를 입력해주세요!!");
        return;
    }
}

const showMessage = msg => {
    const chatContent = document.querySelector('.chat-content2');
    const loginUserNum = Number(document.body.dataset.usernum);
    const userNum = msg.userNum;

    // userNum이 0인 경우,
    // 시스템 메세지 처리(채팅방 입장 or 채팅방 나가기)
    if (userNum === 0) {
        const sysMessage = document.createElement('div');
        sysMessage.className = "chat-system-message";
        sysMessage.textContent = msg.chatContent;

        chatContent.appendChild(sysMessage);
        chatContent.scrollTop = chatContent.scrollHeight;
        return;
    }
    else {
        const newMessage = document.createElement('div');

        // 내가 보낸 메세지인지 확인
        console.log("dataset에서 받아온 loginUserNum:", loginUserNum);
        console.log("메세지 보낸 사람의 userNum:", userNum);

        const isSender = userNum === loginUserNum;
        newMessage.className = isSender ? "chat-message-sent" : "chat-message-received";

        console.log("발신자 정보 : ", msg);
        // 시간 포맷 처리
        const sentAt = new Date(msg.sentAt).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', hour12: false });

        if (!isSender) {
            // 상대방 프로필과 닉네임 추가
            const userInfo = document.createElement('div');
            userInfo.className = "chat-user-info";

            console.log("프로필 이미지 경로 :", msg.imageUrl);

            const profileImg = document.createElement('img');
            profileImg.className = "chat-profile-img";
            profileImg.src = contextPath + msg.imageUrl;
            profileImg.alt = msg.nickName + " 프로필";

            // 클릭 시 마이페이지로 이동
            profileImg.style.cursor = 'pointer';
            profileImg.addEventListener('click', () => {
                window.location.href = contextPath + "/user/myPage?userNum=" + msg.userNum;
            });

            const nicknameSpan = document.createElement('span');
            nicknameSpan.className = "chat-nickname";
            nicknameSpan.textContent = msg.nickName;

            userInfo.appendChild(profileImg);
            userInfo.appendChild(nicknameSpan);

            newMessage.appendChild(userInfo);
        }

        // 메시지 내용 또는 이미지
        const textDiv = document.createElement('div');
        textDiv.className = "chat-text";

        if (msg.chatImg) {
            const chatImg = document.createElement('img');

            // GPT 이미지 실시간
            chatImg.src = contextPath + msg.chatImg + "?t=" + new Date().getTime();
            chatImg.alt = "채팅 이미지";
            chatImg.style.maxWidth = "200px";
            chatImg.style.borderRadius = "8px";
            textDiv.appendChild(chatImg);
        } else {
            textDiv.textContent = msg.chatContent;
        }
        newMessage.appendChild(textDiv);


        // 보낸 시간 출력
        const timeDiv = document.createElement('div');
        timeDiv.className = "chat-time";
        timeDiv.textContent = sentAt;
        newMessage.appendChild(timeDiv);

        chatContent.appendChild(newMessage);
        chatContent.scrollTop = chatContent.scrollHeight;
    }
};