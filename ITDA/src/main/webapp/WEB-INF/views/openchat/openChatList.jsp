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
											<c:when
												test="${not empty chatRoom.filePath && not empty chatRoom.fileName}">
												<img
													src="${contextPath}${chatRoom.filePath}${chatRoom.fileName}"
													alt="채팅방 이미지" class="chat-img" />
											</c:when>
											<c:otherwise>
												<img
													src="${contextPath}/resources/images/openchat/default.jpg"
													alt="기본 이미지" class="chat-img" />
											</c:otherwise>
										</c:choose>
									</div>

									<div class="chat-title" style="text-align: center;">${chatRoom.chatName}</div>

									<div class="chat-tags" style="text-align: center;">
										<c:if test="${not empty chatRoom.tagContent}">
											<c:forEach var="tag"
												items="${fn:split(chatRoom.tagContent, ',')}"
												varStatus="status">
												<c:if test="${status.index lt 3}">
													<span class="tag">#${tag}</span>
												</c:if>
											</c:forEach>
										</c:if>
									</div>

									<div class="chat-members" style="text-align: center;">
										참여인원: ${chatRoom.chatCount} / ${chatRoom.maxchatCount}</div>

									<div class="join-btn-box" style="text-align: center;">
										<button type="button" class="join-btn open-detail"
											data-room-id="${chatRoom.chatRoomID}"
											data-img="${contextPath}${chatRoom.filePath}${chatRoom.fileName}"
											data-name="${chatRoom.chatName}"
											data-tags="${chatRoom.tagContent}"
											data-count="${chatRoom.chatCount}"
											data-max="${chatRoom.maxchatCount}"
											data-des="${chatRoom.description}">참여하기</button>
									</div>
								</div>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</div>

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
						<div class="chat-title" id="detailTitle"></div>
						<div class="chat-tags" id="detailTags"></div>
						<div class="chat-members" id="detailMembers"></div>
						<div class="chat-description" id="detailDescription"
							style="margin-top: 10px; white-space: pre-line; font-size: 14px;"></div>
						<div style="text-align: center; margin-top: 16px;">
							<form id="enterForm" method="get">
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
									id="maxchatCount" name="maxchatCount" min="1" value="2" />
							</div>

							<label for="description" class="details-label">세부사항:</label>
							<textarea id="description" name="description" rows="6"
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

function showDetailModal() {
  const modal = document.getElementById("detailModal");
  modal.classList.remove("hidden");
  modal.style.display = "block";
}

function hideDetailModal() {
  const modal = document.getElementById("detailModal");
  modal.classList.add("hidden");
  modal.style.display = "none";
}

document.addEventListener("DOMContentLoaded", function () {
  // 참여 상세 모달
  document.querySelectorAll(".open-detail").forEach(btn => {
    btn.addEventListener("click", function () {
      const roomId = this.dataset.roomId;
      const image = this.dataset.img;
      const name = this.dataset.name;
      const tags = this.dataset.tags;
      const count = this.dataset.count;
      const max = this.dataset.max;
      const description = this.dataset.des;

      if (!roomId || !name) return;

      document.getElementById("detailImage").src = image || contextPath + "/resources/images/openchat/default.jpg";
      document.getElementById("detailTitle").textContent = name;

      const tagContainer = document.getElementById("detailTags");
      tagContainer.innerHTML = '';
      if (tags) {
        tags.split(',').forEach(tag => {
          const span = document.createElement('span');
          span.className = 'tag';
          span.textContent = '#' + tag.trim();
          tagContainer.appendChild(span);
        });
      }

      document.getElementById("detailMembers").textContent = "참여 인원: " + count + " / " + max;
      document.getElementById("detailDescription").textContent = description || '';
      document.getElementById("enterForm").action = contextPath + "/openchat/room/" + roomId;

      showDetailModal();
    });
  });

  document.getElementById("closeDetailBtn").onclick = hideDetailModal;

  // 개설 모달
  document.querySelector(".create-chat-btn").onclick = () => {
    document.getElementById("modal").classList.remove("hidden");
    document.getElementById("modal").style.display = "block";
  };
  document.getElementById("closeModalBtn").onclick = () => {
    document.getElementById("modal").classList.add("hidden");
    document.getElementById("modal").style.display = "none";
  };

  // 이미지 미리보기
  const addImageBtn = document.getElementById('addImageBtn');
  const imageFileInput = document.getElementById('imageFile');
  const previewContainer = document.getElementById('previewContainer');

  addImageBtn.onclick = () => imageFileInput.click();
  imageFileInput.onchange = (e) => {
    const files = e.target.files;
    previewContainer.innerHTML = '';
    if (files.length > 0) {
      for (let i = 0; i < files.length; i++) {
        const img = document.createElement('img');
        
        img.src = URL.createObjectURL(files[i]);
        
        previewContainer.appendChild(img);
      }
    }
  };
});

// 유효성 검사
function validateForm(form) {
  console.log("폼 제출 값 확인");
  console.log("chatName:", form.chatName.value);
  console.log("tagContent:", form.tagContent.value);
  console.log("description:", form.description.value);
  console.log("maxchatCount:", form.maxchatCount.value);
  console.log("파일 수:", form.openImage.files.length);
  return true;
}
</script>
</body>
</html>