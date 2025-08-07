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