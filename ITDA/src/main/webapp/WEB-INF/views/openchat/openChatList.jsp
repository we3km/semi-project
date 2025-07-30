<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />


<!DOCTYPE html>
<html lang="ko">
<head>
<script
	src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<meta charset="UTF-8">
<title>오픈 채팅방 리스트</title>
<link rel="stylesheet" href="${contextPath}/resources/css/openlist.css">
</head>
<body>
	<div class="container">
		<header class="header"></header>
		<div class="layout">
			<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
			<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

			<form id="filterForm" method="get"
				action="${contextPath}/openchat/openChatList">
				<aside class="filter-sidebar">

					<!-- 1) 시·도 선택 -->
					<div class="sido-select">
						<select name="sido" id="sidoSelect">
							<option value="">시·도 선택</option>
							<c:forEach var="sd" items="${sidoList}">
								<option value="${sd}" ${sd == selectedSido ? 'selected' : ''}>${sd}</option>
							</c:forEach>
						</select>
					</div>

					<!-- 2-1) 시·군 선택 (시군구가 있는 경우) -->
					<c:if test="${fn:length(sigunList) > 0}">
						<div class="sigun-select">
							<select name="sigun" id="sigunSelect"
								onchange="document.getElementById('filterForm').submit()">
								<option value="">시·군 선택</option>
								<c:forEach var="sg" items="${sigunList}">
									<option value="${sg}" ${sg == selectedSigun ? 'selected' : ''}>${sg}</option>
								</c:forEach>
							</select>
						</div>
					</c:if>

					<!-- 2-2) 시 바로 아래 구가 있는 경우: 라디오 버튼 출력 -->
					<c:if test="${fn:length(sigunList) == 0 and not empty guList}">
						<div class="gu-radio-group" style="max-height: 250px; overflow-y: auto;" >
							<p>구 선택</p>
							<c:forEach var="g" items="${guList}">
								<label class="gu-item"> <input type="radio" name="sigun"
									value="${g}"
									${fn:trim(g) == fn:trim(selectedSigun) ? 'checked' : '' }
									onchange="document.getElementById('filterForm').submit()" /> <span
									class="gu-label">${g}</span>
								</label>
							</c:forEach>
						</div>
					</c:if>

					<!-- 3) 위치 표시 -->
					<c:if test="${not empty selectedSido}">
						<div class="location-filter">
							<h4>위치</h4>
							<div class="sido-label">
								${selectedSido}
								<c:if test="${not empty selectedSigun}"> ${selectedSigungu}</c:if>
							</div>
						</div>
					</c:if>

					<!-- 4) 구 리스트 (시군 아래 구 리스트) -->
					<c:if
						test="${not empty guList and not empty selectedSigun and fn:length(sigunList) > 0}">
						<div class="gu-list" id="guListContainer" style="max-height: 250px; overflow-y: auto;">
							<c:forEach var="g" items="${guList}" varStatus="st">
								<label class="gu-item">
									<input type="radio" name="gu" value="${g}"
									${g == selectedGu ? 'checked' : ''}
									onchange="document.getElementById('filterForm').submit()" /> <span
									class="gu-label">${g}</span>
								</label>
							</c:forEach>
						</div>
					</c:if>
				</aside>
			</form>

			<main class="main-content">
				<h1 class="main-title">오픈 채팅방 리스트</h1>
				<h2 class="location"></h2>

				<!-- 상단 바 -->
				<div class="top-bar">
					<form id="sortForm" method="get"
						action="${contextPath}/openchat/openChatList">
						<input type="hidden" name="sido" value="${selectedSido}" /> <input
							type="hidden" name="sigungu" value="${selectedSigungu}" /> <input
							type="text" name="keyword" class="search-bar" value="${keyword}"
							placeholder="채팅방 검색" />
					</form>
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
												<img
													src="${contextPath}/resources/images/chat/openchat/${chatRoom.fileName}"
													alt="채팅방 이미지" class="chat-img" />
											</c:when>
											<c:otherwise>
												<img
													src="${contextPath}/resources/images/chat/openchat_default.jpg"
													alt="기본 이미지" class="chat-img" />
											</c:otherwise>
										</c:choose>
									</div>
									<div class="chat-title">${chatRoom.chatName}</div>

									<div class="chat-tags">
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

									<div class="chat-members">참여인원: ${chatRoom.chatCount} /
										${chatRoom.maxchatCount}</div>

									<div class="join-btn-box">
										<button type="button" class="join-btn open-detail"
											data-room-id="${chatRoom.chatRoomID}"
											data-img="${contextPath}/resources/images/chat/openchat/${chatRoom.fileName}"
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
						<img id="detailImage" class="detailchat-img" />
						<!-- 모달 상세정보 타이틀 -->
						<div class="chat-title" id="detailTitle"></div>
						<!-- 모달 상세정보 태그 -->
						<div class="chat-tags" id="detailTags"></div>
						<!-- 모달 상세정보 참여인원/최대인원 -->
						<div class="chat-members" id="detailMembers"></div>
						<!-- 모달 상세정보 채팅방 상세내용 -->
						<div class="chat-explanation" id="detailExplanation"></div>
						<div>
							<form id="enterForm" method="get"
								action="${contextPath}/openchat/enter">
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
								<label class="image-label">대표 이미지</label>
								<div class="image-preview-box">
									<div id="previewContainer"></div>
									<button type="button" class="add-image-btn" id="addImageBtn">+</button>
									<input type="file" id="imageFile" name="openImage" multiple
										accept="image/*" />
								</div>
							</div>

							<!-- 위도, 경도 숨김 -->
							<input type="hidden" id="latitude" name="latitude" value="" /> <input
								type="hidden" id="longitude" name="longitude" value="" /> <input
								type="hidden" id="sido" name="sido" value="" /> <input
								type="hidden" id="sigungu" name="sigungu" value="" />

							<!-- 위치 자동 입력 & 수정 -->
							<div class="form-row">
								<label for="locationText">지역:</label>
								<div>
									<input type="text" id="locationText" name="locationText"
										placeholder="위치 불러오는 중..." readonly />
									<button type="button" id="editLocationBtn" class="small-btn">주소검색</button>
								</div>
							</div>


							<div class="form-row">
								<label for="chatName">제목:</label> <input type="text"
									id="chatName" name="chatName" required />
							</div>

							<div class="form-row">
								<label for="tagContent">태그:</label> <input type="text"
									id="tagContent" name="tagContent" placeholder="#음악 #운동"
									required />
							</div>

							<div class="form-row">
								<label for="maxchatCount">최대인원:</label> <input type="number"
									id="maxchatCount" name="maxchatCount" min="1" max="30"
									placeholder="최대인원 30명" required />
							</div>

							<label for="explanation" class="details-label">세부사항:</label>
							<textarea id="explanation" name="explanation" rows="6"
								maxlength="2000" class="details-textarea" required></textarea>

							<div>
								<button type="submit" class="submit-btn" id="submitBtn" disabled>개설하기</button>
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

// 1) 위치 가져오기
function getLocation() {
  if (!navigator.geolocation) {
    alert("이 브라우저에서는 위치 정보가 지원되지 않습니다.");
    return;
  }
  navigator.geolocation.getCurrentPosition(success, error, {
    enableHighAccuracy: true,
    timeout: 10000,
    maximumAge: 0
  });
}

function success(position) {
	  const lat = position.coords.latitude;
	  const lng = position.coords.longitude;
	  console.log("위도:", lat, "경도:", lng);

	  // 위도/경도 hidden input에 저장
	  document.getElementById("latitude").value  = lat;
	  document.getElementById("longitude").value = lng;

	  // 카카오 reverse API 호출
	  fetch(contextPath + "/kakao/reverse?lat=" + lat + "&lng=" + lng)
	    .then(res => {
	      if (!res.ok) throw new Error(res.status);
	      return res.json();
	    })
	    .then(data => {
	    	console.log("locHeader element is:", document.querySelector("h2.location"));
	    	const fullAddr = data.address || "";
	    	document.getElementById("locationText").value = fullAddr;
	    	
	    	const parts= fullAddr.split(" ");
	        const sido =  parts[0] || ""; // e.g. "서울특별시" 또는 "경기도"
	        const r2   =  parts[1] || ""; // e.g. "강남구" or "수원시"
	        const r3   =  parts[2] || "";// e.g. "삼성동" or "팔달구"
	        
	        let sigungu;
		    if ( r2.endsWith("시") || r2.endsWith("군") ) {
		      sigungu = r2 + " " + r3;    
		    } else {
		      sigungu = r2;         
		    }
	 
	      // 시도·시군구 hidden input에 저장
	      document.getElementById("sido").value    = sido;
	      document.getElementById("sigungu").value = sigungu;
	      
	      const locHeader = document.querySelector("h2.location");
	      if (locHeader) {
	        locHeader.textContent = sido + " " + sigungu;
	      }
	      console.log("시:", sido, "구:", sigungu);
	      
	      document.getElementById("submitBtn").disabled = false;
	    })
	    .catch(err => {
	      console.error("주소 가져오기 실패", err);
	      document.getElementById("locationText").value = "주소 오류";
	      document.querySelector("h2.location").textContent =" 위치 불러오기 실패 "
	    });
	}
function error(err) {
  alert("위치 정보를 가져올 수 없습니다. 위치 권한을 허용해주세요.");
}

// 상세 모달 열기/닫기
function showDetailModal() {
  document.getElementById("detailModal").classList.remove("hidden");
}
function hideDetailModal() {
  const modal = document.getElementById("detailModal");
  
  modal.classList.add("hidden");
  document.getElementById("detailTags").innerHTML = '';
  document.getElementById("detailImage").src = '';
  document.getElementById("detailTitle").textContent = '';
  document.getElementById("detailMembers").textContent = '';
  document.getElementById("detailExplanation").textContent = '';
  document.getElementById("roomIdInput").value = '';
}



document.addEventListener("DOMContentLoaded", function() {
	getLocation();
  // ◼ 개설 모달 열기
  const createBtn = document.querySelector(".create-chat-btn");
  const createModal = document.getElementById("modal");
  createBtn.addEventListener("click", function() {
    createModal.classList.remove("hidden");
    createModal.style.display = "block";
    getLocation();
  });

  // ◼ 개설 모달 닫기
  document.getElementById("closeModalBtn")
          .addEventListener("click", () => {
    createModal.classList.add("hidden");
    createModal.style.display = "none";
  //개설 모달 닫으면 안에 내용 초기화
    const createForm = document.querySelector('#modal form');
    if (createForm) createForm.reset();

    const previewContainer = document.getElementById('previewContainer');
    if (previewContainer) previewContainer.innerHTML = '';

    const imageFileInput = document.getElementById('imageFile');
    if (imageFileInput) imageFileInput.value = '';

    const addImageBtn = document.getElementById('addImageBtn');
    if (addImageBtn) addImageBtn.style.display = 'flex'; 
  });
  

  // ◼ 주소 검색/수정 버튼 (Daum 우편번호)
document.getElementById("editLocationBtn")
  .addEventListener("click", () => {
    new daum.Postcode({
      oncomplete: function(data) {
        // 1) 화면에 주소 세팅
        const fullAddr = data.address
        document.getElementById("locationText").value = fullAddr;

        // 2) 위도/경도도 함께 세팅(필요하다면)
        document.getElementById("latitude").value  = data.y;
        document.getElementById("longitude").value = data.x;

        // 3) Daum이 준 시/도·시/군/구를 hidden 필드에 바로 채워주기
        const parts= fullAddr.split(" ");
        const sido =  parts[0] || ""; // e.g. "서울특별시" 또는 "경기도"
        const r2   =  parts[1] || ""; // e.g. "강남구" or "수원시"
        const r3   =  parts[2] || "";// e.g. "삼성동" or "팔달구"

	    
	    let sigungu;
	    if ( r2.endsWith("시") || r2.endsWith("군") ) {
	      sigungu = r2 + " " + r3;    
	    } else {
	      sigungu = r2;         
	    }
	    
        document.getElementById("sido").value    = sido;
        document.getElementById("sigungu").value = sigungu;

        // 4) 버튼 활성화
        document.getElementById("submitBtn").disabled = false;

        // (선택) 디버그 로그
        console.log("Daum postcode → 시:", sido, "구:", sigungu);
      }
    }).open();
  });

  // ◼ 상세 모달 > 참여 버튼 클릭
  document.querySelectorAll(".open-detail").forEach(btn => {
    btn.addEventListener("click", function() {
      const chatRoomID = this.dataset.roomId;
      const image      = this.dataset.img
                         || contextPath + "/resources/images/chat/openchat_default.jpg";
      const name       = this.dataset.name;
      const tags       = this.dataset.tags;
      const count      = this.dataset.count;
      const max        = this.dataset.max;
      const explanation= this.dataset.des;
      if (!chatRoomID || !name) return;

      document.getElementById("detailImage").src = image;
      document.getElementById("detailTitle").textContent = name;
      const tagContainer = document.getElementById("detailTags");

      tagContainer.innerHTML = '';

      if (tags) {
        // 1. 먼저 태그 문자열을 공백 또는 쉼표 또는 # 기준으로 분할
        const rawTags = tags.split(/[\s,#]+/); // 공백, 쉼표, # 전부 분리 기준

        rawTags.forEach(tag => {
          tag = tag.trim();
          if (tag.length > 0) {
            const cleaned = '#' + tag.replace(/^#+/, ''); // # 여러 개 제거 후 하나만 붙임

            const span = document.createElement('span');
            span.className = 'tag';
            span.textContent = cleaned;
            tagContainer.appendChild(span);
          }
        });
      }
      document.getElementById("detailMembers").textContent     = 
        "참여 인원: " + count + " / " + max;
      document.getElementById("detailExplanation").textContent = 
        explanation || '설명이 없습니다.';
      document.getElementById("enterForm").action = 
        `${contextPath}/openchat/enter`;
      document.getElementById("roomIdInput").value = chatRoomID;
      showDetailModal();
    });
  });
  
  function validateForm(form) {
	  if (!form.sido.value || !form.sigungu.value) {
	    alert("위치 정보가 아직 설정되지 않았습니다.\n“새로고침” 또는 “주소검색” 버튼을 눌러주세요.");
	    return false;
	  }
	  return true;
	}

  // ◼ 상세 모달 닫기
  document.getElementById("closeDetailBtn")
          .addEventListener("click", hideDetailModal);

  const addImageBtn      = document.getElementById('addImageBtn');
  const imageFileInput   = document.getElementById('imageFile');
  const previewContainer = document.getElementById('previewContainer');

  // "+" 버튼 누르면 파일 선택창 열기
  addImageBtn.addEventListener("click", () => imageFileInput.click());

  // 파일이 선택되면
  imageFileInput.addEventListener('change', function() {
    const file = this.files[0];    // 첫 번째 파일만 꺼냄
    if (!file) return;

    // 기존 미리보기 초기화
    previewContainer.innerHTML = '';

    const reader = new FileReader();
    reader.onload = function(e) {
      // 대표 이미지로 하나만 보여주기
      const img = document.createElement('img');
      img.src = e.target.result;
      img.classList.add('preview-img');
      previewContainer.appendChild(img);
      // "+" 버튼 숨기기
      addImageBtn.style.display = 'none';
    };
    reader.readAsDataURL(file);
  });
});


 	document.addEventListener("DOMContentLoaded", function() {
	const toggleBtn = document.getElementById('toggleSidoSelect');
	const container = document.getElementById('sidoSelectContainer');

	// 초기 상태(숨김)가 필요하면 스타일시트나 여기서 명시적으로 처리
	container.style.display = 'none';
	toggleBtn.textContent    = '다른 지역 검색';

	toggleBtn.addEventListener('click', function() {
	  // block ↔ none 토글
	  const isHidden = container.style.display === 'none';
	  
	  container.style.display = isHidden ? 'block' : 'none';
	  this.textContent        = isHidden ? '검색 영역 접기' : '다른 지역 검색';
	});
  });
 	const maxCount = document.getElementById('maxchatCount');
 	maxCount.addEventListener('input', () => {
 	  let v = parseInt(maxCount.value, 10) || 0;
 	  if (v > 30)      maxCount.value = 30;
 	  else if (v < 1)  maxCount.value = 1;
 	});
</script>

	<script>
document.addEventListener("DOMContentLoaded", function () {
  const form = document.getElementById("filterForm");
  const sidoSelect = document.getElementById("sidoSelect");

  if (!sidoSelect || !form) return;

  // 1) 시도 변경 시 하위 필터 초기화 후 제출
  sidoSelect.addEventListener("change", function () {
    // 시군 select 초기화
    const sigunSelect = document.getElementById("sigunSelect");
    if (sigunSelect) sigunSelect.selectedIndex = 0;

    // sigun 라디오 초기화 (서울특별시처럼 시 밑에 구 있는 경우)
    const sigunRadios = form.querySelectorAll('input[type="radio"][name="sigun"]');
    sigunRadios.forEach(r => r.checked = false);

    // gu 라디오 초기화
    const guRadios = form.querySelectorAll('input[type="radio"][name="gu"]');
    guRadios.forEach(r => r.checked = false);

    form.submit();
  });

  // 3) gu 라디오 (시군 하위 구) 자동 submit
  const guRadios = form.querySelectorAll('input[type="radio"][name="gu"]');
  
const sigunRadios = form.querySelectorAll('input[type="radio"][name="sigun"]');
});

// sigun 라디오 (시/군 선택없이 구만 보여줄때)
</script>

</body>
</html>