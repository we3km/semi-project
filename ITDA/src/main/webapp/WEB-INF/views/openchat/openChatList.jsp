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
</head>
<body>
	<div class="container">
		<header class="header"></header>
		<div class="layout">
			<main class="main-content">
				<h1 class="main-title">오픈 채팅방 리스트</h1>

				<div class="top-bar">
					<input type="text" class="search-bar" placeholder="채팅방 검색" />
					<button type="button" class="create-chat-btn">채팅방 개설</button>
				</div>

				<div class="chat-list-box">
					<c:choose>
						<c:when test="${empty openlist}">
							<div class="no-chat">채팅방이 없습니다.</div>
						</c:when>
						<c:otherwise>
							<c:forEach var="chatRoom" items="${openlist}">
								<div class="chat-room">
									<div class="chat-title">${chatRoom.chatName}</div>
									<div class="chat-tags">
										<c:if test="${not empty chatRoom.tagContent}">
											<c:forEach var="tag" items="${fn:split(chatRoom.tagContent, ',')}" varStatus="status">
												<c:if test="${status.index lt 3}">
													${tag}&nbsp;
												</c:if>
											</c:forEach>
										</c:if>
									</div>
									<div class="chat-members">참여인원: ${chatRoom.chatCount} / ${chatRoom.maxchatCount}</div>
									<form action="${contextPath}/openchat/room/${chatRoom.chatRoomID}" method="get">
										<button type="submit" class="join-btn">참여하기</button>
									</form>
								</div>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</div>

				<!-- 페이지네이션 -->
				<div class="pagination">
					<button class="page-btn prev">&laquo;</button>
					<c:forEach var="page" begin="1" end="10">
						<button class="page-btn ${page == 1 ? 'active' : ''}">${page}</button>
					</c:forEach>
					<button class="page-btn next">&raquo;</button>
				</div>
			</main>
		</div>
		<footer class="footer"></footer>
	</div>

	<!-- 모달 -->
	<div id="modal" class="modal" style="display: none;">
		<div class="modal-content">
			<span class="close-btn">&times;</span>
			<h2>오픈 채팅방 개설</h2>
			<form  action="${contextPath}/openchat/createOpenChat" method="post" enctype="multipart/form-data" onsubmit="return validateForm(this)">
				<!-- 이미지 업로드 -->
				<div class="image-upload-area">
					<label class="image-label">이미지 업로드</label>
					<div class="image-preview-box">
						<div id="previewContainer" style="display: flex;"></div>
						<button type="button" class="add-image-btn" id="addImageBtn">+</button>
						<input type="file" id="imageFile" name="openImage" multiple accept="image/*"
							style="opacity: 0; position: absolute; left: -9999px;" />
					</div>
				</div>

				<!-- 제목 -->
				<div class="form-row">
					<label for="chatName">제목:</label>
					<input type="text" id="chatName" name="chatName" required />
				</div>

				<!-- 태그 -->
				<div class="form-row">
					<label for="tagContent">태그:</label>
					<input type="text" id="tagContent" name="tagContent" placeholder="#음악 #운동 처럼 공백으로 구분하여 입력" />
				</div>

				<!-- 최대 인원 -->
				<div class="form-row">
					<label for="maxchatCount">최대인원:</label>
					<input type="number" id="maxchatCount" name="maxchatCount" min="1" value="2" />
				</div>

				<!-- 세부사항 -->
				<label for="description" class="details-label">세부사항:</label>
				<textarea id="description" name="description" rows="6" maxlength="2000" class="details-textarea"></textarea>

				<div style="margin-top: 10px; text-align: right;">
					<button type="submit" class="submit-btn">개설하기</button>
				</div>
			</form>
		</div>
	</div>

<script>
document.addEventListener("DOMContentLoaded", function () {
	const addImageBtn = document.getElementById('addImageBtn');
	const imageFileInput = document.getElementById('imageFile');
	const previewContainer = document.getElementById('previewContainer');

	addImageBtn.onclick = function () {
		imageFileInput.click();
	};

	imageFileInput.onchange = function (e) {
		const files = e.target.files;
		previewContainer.innerHTML = '';
		if (files.length > 0) {
			for (let i = 0; i < files.length; i++) {
				const img = document.createElement('img');
				img.src = URL.createObjectURL(files[i]);
				img.style.width = '100px';
				img.style.marginRight = '5px';
				img.style.borderRadius = '8px';
				previewContainer.appendChild(img);
			}
		}
	};

	document.querySelector(".create-chat-btn").onclick = function () {
		document.getElementById("modal").style.display = "block";
	};

	document.querySelector(".close-btn").onclick = function () {
		document.getElementById("modal").style.display = "none";
	};

	window.onclick = function (event) {
		const modal = document.getElementById("modal");
		if (event.target == modal) {
			modal.style.display = "none";
		}
	};
});

function validateForm(form) {
	console.log("=== [FORM 제출 값 확인] ===");
	console.log("chatName:", form.chatName.value);
	console.log("tagContent:", form.tagContent.value);
	console.log("description:", form.description.value);
	console.log("maxchatCount:", form.maxchatCount.value);
	console.log("파일 선택 수:", form.openImage.files.length);
	console.log("=========================");
	return true;
}
</script>
</body>
</html>
