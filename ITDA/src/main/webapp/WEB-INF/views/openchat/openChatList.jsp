<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />


<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>오픈 채팅방 리스트</title>
<link rel="stylesheet" href="${contextPath}/resources/css/openlist.css">
<style>
.hidden {
	display: none !important;
}
</style>
</head>
<body>
	<div class="container">
		<header class="header"></header>
		<div class="layout">
			<main class="main-content">
				<h1 class="main-title">오픈 채팅방 리스트</h1>

				<!-- 상단 바 -->
				<div class="top-bar">
					<input type="text" class="search-bar" placeholder="채팅방 검색" />
					<button type="button" class="create-chat-btn">채팅방 개설</button>
				</div>

				<!-- 채팅방 리스트 -->
				<div class="chat-list-box">
					<c:choose>
						<c:when test="${empty openlist}">
							<div class="no-chat">채팅방이 없습니다.</div>
						</c:when>
						<c:otherwise>
							<c:forEach var="chatRoom" items="${openlist}">
								<div class="chat-room">
									<div class="chat-img-box">
										<c:choose>
											<c:when test="${not empty chatRoom.fileName}">
												<img src="${contextPath}/resources/images/chat/${chatRoom.fileName}" alt="채팅방 이미지" class="chat-img" />
											</c:when>
											<c:otherwise>
												<img src="${contextPath}/resources/images/chat/openchat_default.jpg" alt="기본 이미지" class="chat-img" />
											</c:otherwise>
										</c:choose>
									</div>
									<div class="chat-title" style="text-align: center;">${chatRoom.chatName}</div>

									<div class="chat-tags" style="text-align: center;">
										<c:if test="${not empty chatRoom.tagContent}">
											<c:forEach var="tag" items="${fn:split(chatRoom.tagContent, ',')}" varStatus="status">
												<c:if test="${status.index lt 3}">
													<span class="tag">#${tag}</span>
												</c:if>
											</c:forEach>
										</c:if>
									</div>

									<div class="chat-members" style="text-align: center;">
										참여인원: ${chatRoom.chatCount} / ${chatRoom.maxchatCount}
									</div>

									<div class="join-btn-box" style="text-align: center;">
										<button type="button" class="join-btn open-detail"
											data-room-id="${chatRoom.chatRoomID}"
											data-img="${contextPath}/resources/images/chat/${chatRoom.fileName}"
											data-name="${chatRoom.chatName}"
											data-tags="${chatRoom.tagContent}"
											data-count="${chatRoom.chatCount}"
											data-max="${chatRoom.maxchatCount}"
											data-des="${chatRoom.explanation}">참여하기</button>
									</div>
								</div>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</div>

				<!-- 이하 기존 코드(모달, 페이징, JS 등)는 그대로 유지 -->

				<!-- 페이지네이션 -->
				<div class="pagination">
					<c:if test="${currentPage > 1}">
						<a
							href="${contextPath}/openchat/openChatList?page=${currentPage - 1}"
							class="page-btn prev">&laquo;</a>
					</c:if>
					<c:forEach var="i" begin="${startPage}" end="${endPage}">
						<a href="${contextPath}/openchat/openChatList?page=${i}"
							class="page-btn ${i == currentPage ? 'active' : ''}">${i}</a>
					</c:forEach>
					<c:if test="${currentPage < totalPage}">
						<a
							href="${contextPath}/openchat/openChatList?page=${currentPage + 1}"
							class="page-btn next">&raquo;</a>
					</c:if>
				</div>

				<!-- 상세 모달 -->
				<div id="detailModal" class="modal hidden">
					<div class="modal-content">
						<span class="close-btn" id="closeDetailBtn">&times;</span>
						<h2>채팅방 정보</h2>
						<img id="detailImage" class="chat-img"
							style="width: 100%; border-radius: 10px;" />
							<!-- 모달 상세정보 타이틀 -->
						<div class="chat-title" id="detailTitle"></div>
						<!-- 모달 상세정보 태그 -->
						<div class="chat-tags" id="detailTags"></div>
						<!-- 모달 상세정보 참여인원/최대인원 -->
						<div class="chat-members" id="detailMembers"></div>
						<!-- 모달 상세정보 채팅방 상세내용 -->
						<div class="chat-explanation" id="detailExplanation"
							style="margin-top: 10px; white-space: pre-line; font-size: 14px;"></div>
						<div style="text-align: center; margin-top: 16px;">
							<form id="enterForm" method="get" action="${contextPath}/chat/enter">
								<input type="hidden" name="roomId" id="roomIdInput">
								<button type="submit" class="submit-btn">입장하기</button>
							</form>
						</div>
					</div>
				</div>

				<!-- 개설 모달 -->
				<div id="modal" class="modal hidden">
					<div class="modal-content">
						<span class="close-btn" id="closeModalBtn">&times;</span>
						<h2>오픈 채팅방 개설</h2>
						<form action="${contextPath}/openchat/createOpenChat"
							method="post" enctype="multipart/form-data"
							onsubmit="return validateForm(this)">
							<div class="image-upload-area">
								<label class="image-label">이미지 업로드</label>
								<div class="image-preview-box">
									<div id="previewContainer" style="display: flex;"></div>
									<button type="button" class="add-image-btn" id="addImageBtn">+</button>
									<input type="file" id="imageFile" name="openImage" multiple
										accept="image/*"
										style="opacity: 0; position: absolute; left: -9999px;" />
								</div>
							</div>
							<!-- <div class="form-row">
								<label for="address">위치:</label> <input type="text" id="address"
									name="address" readonly placeholder="위치 불러오는 중..." />
							</div> -->
							<input type="hidden" id="latitude" name="latitude" /> <input
								type="hidden" id="longitude" name="longitude" />

							<div class="form-row">
								<label for="chatName">제목:</label> <input type="text"
									id="chatName" name="chatName" required />
							</div>

							<div class="form-row">
								<label for="tagContent">태그:</label> <input type="text"
									id="tagContent" name="tagContent" placeholder="#음악 #운동" />
							</div>

							<div class="form-row">
								<label for="maxchatCount">최대인원:</label> <input type="number"
									id="maxchatCount" name="maxchatCount" min="1" max ="30" value="2" />
							</div>

							<label for="explanation" class="details-label">세부사항:</label>
							<textarea id="explanation" name="explanation" rows="6"
								maxlength="2000" class="details-textarea"></textarea>

							<div style="margin-top: 10px; text-align: right;">
								<button type="submit" class="submit-btn">개설하기</button>
							</div>
						</form>
					</div>
				</div>
			</main>
		</div>
	</div>

	<!-- 자바스크립트 -->
	<script>
const contextPath = '${contextPath}';

// [1] 상세 모달 열기
function showDetailModal() {
  document.getElementById("detailModal").classList.remove("hidden");
}

// [2] 상세 모달 닫기 + 내용 초기화
function hideDetailModal() {
  const modal = document.getElementById("detailModal");
  modal.classList.add("hidden");

  // 🧹 모달 내 요소 초기화
  document.getElementById("detailTags").innerHTML = '';
  document.getElementById("detailImage").src = '';
  document.getElementById("detailTitle").textContent = '';
  document.getElementById("detailMembers").textContent = '';
  document.getElementById("detailExplanation").textContent = '';
  document.getElementById("roomIdInput").value = '';
}

document.addEventListener("DOMContentLoaded", function () {
  // [1] 채팅방 리스트 > 상세정보 보기 (참여 버튼)
  document.querySelectorAll(".open-detail").forEach(btn => {
    btn.addEventListener("click", function () {
      const chatRoomID = this.dataset.roomId;
      const image = this.dataset.img || contextPath + "/resources/images/chat/openchat_default.jpg";
      const name = this.dataset.name;
      const tags = this.dataset.tags;
      const count = this.dataset.count;
      const max = this.dataset.max;
      const explanation = this.dataset.des;

      if (!chatRoomID || !name) return;

      document.getElementById("detailImage").src = image;
      document.getElementById("detailTitle").textContent = name;

      const tagContainer = document.getElementById("detailTags");
      tagContainer.innerHTML = ''; // 중복 방지
      if (tags) {
        tags.split(',').forEach(tag => {
          const span = document.createElement('span');
          span.className = 'tag';
          span.textContent = '#' + tag.trim();
          tagContainer.appendChild(span);
        });
      }

      document.getElementById("detailMembers").textContent = "참여 인원: " + count + " / " + max;
      document.getElementById("detailExplanation").textContent = explanation || '설명이 없습니다.';
      document.getElementById("enterForm").action = `${contextPath}/chat/enter`;
      document.getElementById("roomIdInput").value = chatRoomID;
      showDetailModal();
    });
  });

  document.getElementById("closeDetailBtn").onclick = hideDetailModal;

  // [2] 채팅방 개설 모달 열기
  document.querySelector(".create-chat-btn").onclick = () => {
    const modal = document.getElementById("modal");
    modal.classList.remove("hidden");
    modal.style.display = "block";
  };

  // [2] 채팅방 개설 모달 닫기
  document.getElementById("closeModalBtn").onclick = () => {
    const modal = document.getElementById("modal");
    modal.classList.add("hidden");
    modal.style.display = "none";
  };

  // [3] 이미지 미리보기
  const addImageBtn = document.getElementById('addImageBtn');
  const imageFileInput = document.getElementById('imageFile');
  const previewContainer = document.getElementById('previewContainer');

  addImageBtn.onclick = () => imageFileInput.click();

  imageFileInput.addEventListener('change', function () {
    const files = imageFileInput.files;
    previewContainer.innerHTML = '';

    Array.from(files).forEach(file => {
      const reader = new FileReader();
      reader.onload = function (e) {
        const img = document.createElement('img');
        img.src = e.target.result;
        img.style.width = '80px';
        img.style.height = '80px';
        img.style.marginRight = '5px';
        img.style.borderRadius = '10px';
        previewContainer.appendChild(img);
      };
      reader.readAsDataURL(file);
    });
  });
});
</script>



</body>
</html>