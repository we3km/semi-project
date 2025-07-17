<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>오픈 채팅방 리스트</title>
<link rel="stylesheet" href="${contextPath }/resources/css/openlist.css">
</head>
<body>
	<div class="container">
		<header class="header"></header>

		<div class="layout">
			<!-- 좌측 필터 -->
			<aside class="sidebar">
				<h2>정렬 조건</h2>
				<select class="filter">
					<option>최신순</option>
					<option>참여자 많은 순</option>
					<option>이름순</option>
				</select>
			</aside>

			<!-- 우측 메인 -->
			<main class="main-content">
				<h1 class="main-title">오픈 채팅방 리스트</h1>

				<div class="top-bar">
					<input type="text" class="search-bar" placeholder="채팅방 검색">
					<button class="create-chat-btn">채팅방 개설</button>
				</div>

				<div class="chat-list-box">
					<c:forEach var="room" items="${roomList}">
						<div class="chat-room">
							<img src="${contextPath}/resources/images/chat1.jpg"
								class="chat-img" alt="채팅방 이미지">
							<div class="chat-title">${room.title}</div>
							<div class="chat-tags">${room.tags}</div>
							<div class="chat-members">참여자: ${room.currentMembers} /
								${room.maxMembers}</div>
							<form action="${contextPath}/openchat/room/${room.roomId}"
								method="get">
								<button class="join-btn" type="submit">참여하기</button>
							</form>
						</div>
					</c:forEach>
				</div>

				<!-- 페이지네이션 -->
				<div class="pagination">
					<button class="page-btn prev">&laquo;</button>
					<c:forEach var="page" begin="1" end="5">
						<button class="page-btn ${page == 1 ? 'active' : ''}">${page}</button>
					</c:forEach>
					<button class="page-btn next">&raquo;</button>
				</div>
			</main>
		</div>

		<footer class="footer"></footer>
	</div>
	<!-- 모달 배경 -->
<!-- 모달 배경 -->
<div id="modal" class="modal" style="display:none;">
  <div class="modal-content">
    <span class="close-btn">&times;</span>
    <h2>오픈 채팅방 개설</h2>
    <form action="${contextPath}/openchat/create" method="post" enctype="multipart/form-data">
      <!-- 이미지 업로드 영역 -->
      <div class="image-upload-area">
        <label class="image-label">이미지 업로드</label>
        <div class="image-preview-box">
          <img id="preview" class="image-preview" src="#" alt="이미지 미리보기" style="display: none;">
          <button type="button" class="add-image-btn" id="addImageBtn">+</button>
          <input type="file" id="chatImage" name="chatImage" accept="image/*" class="image-input" style="display: none;">
        </div>
      </div>
      <!-- 제목, 세부사항, 태그, 최대인원 -->
      <div class="form-row">
        <label for="title">제목:</label>
        <input type="text" id="title" name="title" required>
      </div>
      <div class="form-row">
        <label for="tags">태그:</label>
        <input type="text" id="tags" name="tags" placeholder="태그를 입력하세요">
      </div>
      <div class="form-row">
        <label for="maxMembers">최대인원:</label>
        <input type="number" id="maxMembers" name="maxMembers" min="1" value="2">
      </div>
      <label for="details" class="details-label">세부사항:</label>
      <textarea id="details" name="details" rows="6" maxlength="2000" class="details-textarea"></textarea>
      <div style="margin-top: 10px; text-align: right;">
        <button type="submit" class="submit-btn">개설하기</button>
      </div>
    </form>
  </div>
</div>

<script>
// 이미지 미리보기
document.getElementById('addImageBtn').onclick = function() {
  document.getElementById('chatImage').click();
};
document.getElementById('chatImage').onchange = function(e) {
  const preview = document.getElementById('preview');
  const file = e.target.files[0];
  if (file) {
    preview.src = URL.createObjectURL(file);
    preview.style.display = 'block';
    document.getElementById('addImageBtn').style.display = 'none';
  } else {
    preview.src = '#';
    preview.style.display = 'none';
    document.getElementById('addImageBtn').style.display = 'block';
  }
};

// 모달 열기
document.querySelector(".create-chat-btn").onclick = function() {
  document.getElementById("modal").style.display = "block";
};

// 모달 닫기
document.querySelector(".close-btn").onclick = function() {
  document.getElementById("modal").style.display = "none";
};

// 모달 외부 클릭 시 닫기
window.onclick = function(event) {
  const modal = document.getElementById("modal");
  if (event.target == modal) {
    modal.style.display = "none";
  }
};
</script>

</body>
</html>
