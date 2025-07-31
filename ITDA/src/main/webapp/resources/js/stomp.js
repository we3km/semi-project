stompClient.connect({}, function (e) {
    console.log(e);
    // 현재 클라이언트가 구독중인 url목록들을 전달
    // 현재 채팅방에 새로운 사용자가 입장하거나,
    // 사용자가 퇴장하는 경우의 구독 url
})

function sendMessage() {
    const input = document.querySelector('.chat-input');
    const message = input.value;

    console.log("챗룸아이디 전역변수 : ", window.chatRoomId);
    console.log("보내는 메세지 : ", message);

    // ChatStompController 호출
    stompClient.send("/app/chat/sendMessage", {}, JSON.stringify({
        chatContent: message, 
        chatRoomId: window.chatRoomId
    }))

    input.value = ""; // 입력란 비워줌
}


// 실시간으로 보여지는 것
const showMessage = msg => {
    const chatContent = document.querySelector('.chat-content2');

    // 채팅 메시지 전체 div
    const newMessage = document.createElement('div');
    newMessage.className = 'chat-message-talk';

    // 메시지 본문(텍스트 또는 이미지)
    const contentDiv = document.createElement('div');

    if (msg.chatImg) {
        console.log("사진 메세지 경로 : ", msg.chatImg);
        const img = document.createElement('img');
        img.src = contextPath + msg.chatImg;
        img.alt = "image";
        img.style.maxWidth = "200px";
        img.style.borderRadius = "8px";

        contentDiv.appendChild(img);
    } else {
        contentDiv.textContent = msg.chatContent;
    }

    // 시간 정보
    if (msg.sentAt) {
        const timeDiv = document.createElement('div');
        timeDiv.className = 'message-time';
        timeDiv.textContent = msg.sentAt;
        timeDiv.style.fontSize = '12px';
        timeDiv.style.color = '#888';
        timeDiv.style.marginTop = '4px';

        newMessage.appendChild(contentDiv);
        newMessage.appendChild(timeDiv);
    } else {
        newMessage.appendChild(contentDiv);
    }

    chatContent.appendChild(newMessage);
    chatContent.scrollTop = chatContent.scrollHeight;
};