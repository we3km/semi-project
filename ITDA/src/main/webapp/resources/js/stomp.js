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

    stompClient.send("/app/chat/sendMessage", {}, JSON.stringify({
        chatContent: message,
        chatRoomId: window.chatRoomId
    }))

    input.value = ""; // 입력란 비워줌
}

const showMessage = data => {
    const chatContent = document.querySelector('.chat-content2');

    const newMessage = document.createElement('div');
    newMessage.className = 'chat-message sent';
    newMessage.textContent = data.chatContent;

    chatContent.appendChild(newMessage);
    chatContent.scrollTop = chatContent.scrollHeight;
}
