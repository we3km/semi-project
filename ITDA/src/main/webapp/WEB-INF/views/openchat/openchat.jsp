<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>${room.title}</title>
  <link rel="stylesheet" href="${contextPath}/resources/css/chat.css">
  <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
</head>
<body>
  <div class="chat-container">
    <h2 class="chat-room-title">${room.title}</h2>

    <div class="chat-box" id="chat-box">
      <!-- 메시지 표시 영역 -->
    </div>

    <div class="chat-input-area">
      <input type="text" id="username" placeholder="닉네임">
      <input type="text" id="messageInput" placeholder="메시지를 입력하세요">
      <button onclick="sendMessage()">보내기</button>
    </div>
  </div>

  <script>
    let stompClient = null;
    const roomId = "${room.roomId}";
    const chatBox = document.getElementById("chat-box");

    function connect() {
    	console.log('connect called');
      const socket = new SockJS("${contextPath}/stomp");  // ✅ 경로 수정 (/ws → /stomp)
      stompClient = Stomp.over(socket);

      stompClient.connect({}, function () {
    	  console.log('stompClient connected');
        stompClient.subscribe("/topic/chat/" + roomId, function (msg) {
        	console.log('Message received');
          const body = JSON.parse(msg.body);
          const p = document.createElement("p");
          p.textContent = body.sender + ": " + body.content;
          chatBox.appendChild(p);
          chatBox.scrollTop = chatBox.scrollHeight;
        });
      });
    }

    function sendMessage() {
      const sender = document.getElementById("username").value.trim() || "익명";
      const content = document.getElementById("messageInput").value.trim();

      if (content === "") return;

      stompClient.send("/app/chat/" + roomId, {}, JSON.stringify({
        sender: sender,
        content: content
      }));

      document.getElementById("messageInput").value = "";
    }

    connect();
  </script>
</body>
</html>
