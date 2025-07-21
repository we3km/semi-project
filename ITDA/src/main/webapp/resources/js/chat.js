// 메뉴 토글 함수
function chatRoomType() {
const menu = document.getElementById("chatMenu");
menu.classList.toggle("hidden");
}

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

// 채팅방 나가기, 신고하기
function toggleActionMenu(el) {
const menu = el.nextElementSibling;
menu.classList.toggle('hidden');
}

function reportChat() {
alert("신고가 접수되었습니다.");
// 실제 신고 처리 로직 추가 가능
}

// 채팅방 나가면 채팅방에서 쌓인 데이터베이스 삭제
function leaveChat(button) {
const confirmLeave = confirm("대화방에서 나가시겠습니까?");
if (confirmLeave) {
let listChat = button.closest(".list-chat");
if (listChat) {
listChat.classList.add("left-chat"); // 나간 채팅방 표시
// 채팅방 아예 삭제
listChat.remove();
}

alert("대화방을 나갔습니다.");
// 실제 서버에서 삭제하는 코드도 추가 가능
/* 대화방 나가면 실제 서버에 있는 채팅 정보 삭제할 것인지*/
}
}
// 프로필 이미지 누르면 그 사람 소개페이지로 이동
function goToUserPage(userId) {
// 예: /mypage/user123 으로 이동
window.location.href = `/mypage/${userId}`;
}

// 왼쪽쪽 채팅창 헤더 + 버튼 눌렀을 때
// 거래유형에 맞는 채팅방 갈 수 있도록
function chatRoomType() {
const menu = document.getElementById('chatMenu');
menu.classList.toggle('hidden');
}

// 왼쪽 채팅 클릭 시 오른쪽 채팅에 반영
const chatRooms = document.querySelectorAll(".list-chat");

chatRooms.forEach(chat => {
chat.addEventListener("click", function () {
// 클릭된 상태

// 상대 이름, 마지막 메세지 저장
const name = chat.querySelector(".chatname").textContent;
const lastMsg = chat.querySelector(".last-message").textContent;

// 오른쪽 채팅창 요소들
const chatHeader2 = document.querySelector(".chat-header2");
const chatContent2 = document.querySelector(".chat-content2");

// 상대 이름 업데이트
chatHeader2.childNodes[0].textContent = name;

// 상품 설명은 그대로 두고, 기존 메시지들 삭제
const messages = chatContent2.querySelectorAll(".chat-message:not(#item-board)");
messages.forEach(msg => msg.remove());

// 새 메시지 추가
const newMessage = document.createElement("div");
newMessage.className = "chat-message received";
newMessage.textContent = lastMsg;
chatContent2.appendChild(newMessage);
});
});