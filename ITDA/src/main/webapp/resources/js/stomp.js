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
    console.log("챗룸아이디 전역변수 : ", window.chatRoomId);
    console.log("보내는 메세지 : ", message);
    console.log("나를 호출하는거야 stomp.js");
    if(!message){
        alert("메세지를 입력해주세요!!");
        return;
    }
    // ChatStompController 호출
    stompClient.send("/app/chat/sendMessage", {}, JSON.stringify({
        chatContent: message,
        chatRoomId: window.chatRoomId
    }));
    // const chatContent = document.querySelector('.chat-content2');
    // const newMessage = document.createElement('div');
    // newMessage.className = 'chat-message sent';
    // newMessage.textContent = message;
    // chatContent.appendChild(newMessage);
    // chatContent.scrollTop = chatContent.scrollHeight;
    input.value = ""; // 입력란 비워줌
}
// 실시간으로 채팅 보여짐
const showMessage = msg => {
    const chatContent = document.querySelector('.chat-content2');
    const newMessage = document.createElement('div');
    const loginUserNum = Number(document.body.dataset.usernum); // 로그인 유저 번호
    // [공통] 보낸 사람에 따라 클래스 분기
    if (msg.userNum === loginUserNum) {
        newMessage.className = 'chat-message sent';  // 내가 보낸 메시지 (오른쪽)
    } else {
        newMessage.className = 'chat-message received'; // 상대방 메시지 (왼쪽)
    }
    const contentDiv = document.createElement('div');
    // [공통] 이미지 or 텍스트 여부 분기
    if (msg.chatImg) {
        const img = document.createElement('img');
        img.src = contextPath + msg.chatImg;
        img.alt = "채팅이미지";
        img.style.maxWidth = "200px";
        img.style.borderRadius = "8px";
        contentDiv.appendChild(img);
    } else {
        contentDiv.textContent = msg.chatContent;
    }
    // [공통] 시간
    if (msg.sentAt) {
        const timeDiv = document.createElement('div');
        timeDiv.className = 'message-time';
        timeDiv.textContent = msg.sentAt;
        timeDiv.style.fontSize = '12px';
        timeDiv.style.color = '#888';
        timeDiv.style.marginTop = '4px';
        newMessage.appendChild(contentDiv);
        newMessage.appendChild(timeDiv);
        console.log("보여질 메세지 속성 : ", msg);
    } else {
        newMessage.appendChild(contentDiv);
        console.log("보여질 메세지 속성 : ", msg);
    }
    chatContent.appendChild(newMessage);
    chatContent.scrollTop = chatContent.scrollHeight;
};