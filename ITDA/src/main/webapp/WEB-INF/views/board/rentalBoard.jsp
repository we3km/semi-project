
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>

<head>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<link
	href="${pageContext.request.contextPath}/resources/css/board/rentalBoard.css"
	rel="stylesheet">
<meta charset="UTF-8">
<title>대여 게시판</title>

</head>
<body>
	<div class="wrapper">
		<header class="header">
			<jsp:include page="/WEB-INF/views/common/Header.jsp" />
		</header>
	</div>
<div class="container" >

	<div class="sidebar">
		<form id="filterForm" method="get"
			action="${pageContext.request.contextPath}/board/rental/list">
			<div class="filter-section">
				<h3>정렬 조건</h3>
				<button type="submit" id="filter-btn">정렬</button>
			</div>

			<select name="sort">
				<option value="date">게시일 순</option>
				<option value="views">조회수 순</option>
				<option value="price">가격 순</option>
			</select>
			

<!-- 			<div class="filter-section">
				<h4>지역</h4>
				<label><input type="checkbox"> 강남</label> <label><input
					type="checkbox"> 강서</label> <label><input type="checkbox">
					강동</label> <label><input type="checkbox"> 강북</label>
			</div> -->

			<div class="filter-section">
			  <div class="category-area">
			    <label>상품 카테고리</label>
			
			    <div class="category-wrapper">
			      <!-- 대분류 -->
			      <div class="category-column">
			        <h5>대분류</h5>
			        <div class="category-list-large">
			          <c:forEach items="${categoryList}" var="productCategory">
			            <c:if test="${productCategory.parentNum == 0}">
			              <div class="category-large" data-id="${productCategory.productCategoryNum}">
			                ${productCategory.categoryName}
			              </div>
			            </c:if>
			          </c:forEach>
			        </div>
			        <input type="hidden" id="categoryLargeHiddenInput" name="boardCommon.productCategoryL" />
			      </div>
			
			      <!-- 중분류 -->
			      <div class="category-column" id="middle" style="display: none;">
			        <h5>중분류</h5>
			        <div id="category-list-middle"></div>
			        <input type="hidden" id="categoryMiddleHiddenInput" name="boardCommon.productCategoryM" />
			      </div>
			
			      <!-- 소분류 -->
			      <div class="category-column" id="small" style="display: none;">
			        <h5>소분류</h5>
			        <div id="category-list-small" ></div>
			        <input type="hidden" id="categorySmallHiddenInput" name="boardCommon.productCategoryS" />
			      </div>
			    </div>
			  </div>
			</div>
			
			<script>
			  // Helper 함수: 모든 대/중/소 항목에서 active 제거
			  function clearActive(className) {
			    document.querySelectorAll("." + className).forEach(el => el.classList.remove("active"));
			  }
			  const middleCol = document.getElementById("middle");
			  const smallCol = document.getElementById("small");
			  // 대분류 클릭 이벤트
			  document.querySelectorAll('.category-large').forEach(item => {
			    item.addEventListener('click', () => {
			      const parentId = item.dataset.id;
			      const isActive = item.classList.contains("active");
			
			      // 기존 선택 초기화
			      clearActive("category-large");
			      clearActive("category-middle");
			      clearActive("category-small");
			      document.getElementById("category-list-middle").innerHTML = "";
			      document.getElementById("category-list-small").innerHTML = "";
			      document.getElementById("categoryMiddleHiddenInput").value = "";
			      document.getElementById("categorySmallHiddenInput").value = "";
			
			      if (!isActive) {
			        // 활성화
			        item.classList.add("active");
			        document.getElementById("categoryLargeHiddenInput").value = item.textContent.trim();
			        console.log("선택된 대분류: " + item.textContent.trim());
			        middleCol.style.display = "block";     // 중분류 보이기
			        smallCol.style.display = "none";       // 소분류 숨기기
			
			        // 중분류 불러오기
			        fetch("${pageContext.request.contextPath}/board/getSubCategories?parentNum=" + parentId)
			          .then(response => response.json())
			          .then(data => {
			            const middleContainer = document.getElementById("category-list-middle");
			            data.forEach(sub => {
			              const div = document.createElement("div");
			              div.textContent = sub.categoryName;
			              div.classList.add("category-middle");
			              div.setAttribute("data-id", sub.productCategoryNum);
			              middleContainer.appendChild(div);
			            });
			          });
			      } else {
			        // 다시 클릭하면 닫기 (초기화)
			        document.getElementById("categoryLargeHiddenInput").value = "";
			        middleCol.style.display = "none";  // 중분류 숨기기
			        smallCol.style.display = "none";   // 소분류 숨기기
			      }
			    });
			  });
			
			  // 중분류 클릭 이벤트
			  document.getElementById("category-list-middle").addEventListener("click", (e) => {
			    const clicked = e.target;
			    if (!clicked.classList.contains("category-middle")) return;
			
			    const parentId = clicked.dataset.id;
			    const isActive = clicked.classList.contains("active");
			
			    clearActive("category-middle");
			    clearActive("category-small");
			    document.getElementById("category-list-small").innerHTML = "";
			    document.getElementById("categorySmallHiddenInput").value = "";
			
			    if (!isActive) {
			      clicked.classList.add("active");
			      document.getElementById("categoryMiddleHiddenInput").value = clicked.textContent.trim();
			      console.log("선택된 중분류: " + clicked.textContent.trim());
			      smallCol.style.display = "block"; // 소분류 보여주기
			
			      // 소분류 불러오기
			      fetch("${pageContext.request.contextPath}/board/getSubCategories?parentNum=" + parentId)
			        .then(response => response.json())
			        .then(data => {
			          const smallContainer = document.getElementById("category-list-small");
			          data.forEach(sub => {
			            const div = document.createElement("div");
			            div.textContent = sub.categoryName;
			            div.classList.add("category-small");
			            smallContainer.appendChild(div);
			          });
			        });
			    } else {
			      document.getElementById("categoryMiddleHiddenInput").value = "";
			      smallCol.style.display = "none"; // 소분류 숨기기
			    }
			  });
			
			  // 소분류 클릭 이벤트
			  document.getElementById("category-list-small").addEventListener("click", (e) => {
			    const clicked = e.target;
			    if (!clicked.classList.contains("category-small")) return;
			
			    clearActive("category-small");
			
			    clicked.classList.add("active");
			    document.getElementById("categorySmallHiddenInput").value = clicked.textContent.trim();
			    console.log("선택된 소분류: " + clicked.textContent.trim());
			  });
			</script>

			<div class="filter-section">
			  <h4>가격</h4>
			  <label>최소 가격:</label>
			  <input type="number" name="minRentalFee" min="0">
			
			  <label>최대 가격:</label>
			  <input type="number" name="maxRentalFee" min="0">
			</div>
			
			<div class="filter-section">
				<h4>대여 기간</h4>
				<input type="date" name="startDate"> <input type="date" name="endDate">
			</div>
		</form>
		<form id="filterForm" method="get"
				<%-- 여기 액션 부분만 바꿔주세요 --%>
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
						<div class="gu-radio-group"
							style="max-height: 250px; overflow-y: auto;">
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
						<div class="gu-list" id="guListContainer"
							style="max-height: 250px; overflow-y: auto;">
							<c:forEach var="g" items="${guList}" varStatus="st">
								<label class="gu-item"> <input type="radio" name="gu"
									value="${g}" ${g == selectedGu ? 'checked' : ''}
									onchange="document.getElementById('filterForm').submit()" /> <span
									class="gu-label">${g}</span>
								</label>
							</c:forEach>
						</div>
					</c:if>
				</aside>
			</form>
		
	</div>

	<div class="main">
		<div class="top">
			<div>
				<h2>대여 게시판</h2>
				<span class="location">서울특별시 강남구 📍</span>
				<!-- 로그인한 회원의 주소 -->
			</div>
			<!-- 글쓰기를 클릭했을 때의 url에 컨트롤러에서 사용할 boardCategory를 지정해준다 -->
			<button id="write-btn">거래 글 쓰기</button>
		</div>
		<script>
		  document.getElementById('write-btn').addEventListener('click', function() {
		    window.location.href = '${pageContext.request.contextPath}/board/write/rental';
		  });
	</script>
		<div class="grid">
			<!-- 카드 반복 -->
			<c:forEach var="board" items="${list }">

				<div class="card"
					onclick="moveDetail(${board.boardCommon.boardId});">
					<c:set var="boardId" value="${board.boardCommon.boardId}" />
					<c:if test="${fn:contains(likedBoardIds, boardId)}">
						<div class="heart liked"
							onclick="event.stopPropagation(); toggleLike(this, ${boardId});">♥</div>
					</c:if>
					<c:if test="${!fn:contains(likedBoardIds, boardId)}">
						<div class="heart"
							onclick="event.stopPropagation(); toggleLike(this, ${boardId});">♡</div>
					</c:if>

					<img
						src="${pageContext.request.contextPath}/${board.filePath.categoryPath}/${board.filePath.fileName}"
						alt="이미지" style="width: 90%; height: auto;" />
					<p id="product-name">${board.boardCommon.productName }</p>

					<p id="rental-fee">대여료 : ${board.boardRental.rentalFee }</p>
					<p class="date">
						<fmt:formatDate value="${board.boardRental.rentalStartDate }"
							pattern="yyyy/MM/dd" />
						~
						<fmt:formatDate value="${board.boardRental.rentalEndDate }"
							pattern="yyyy/MM/dd" />
					</p>
				</div>
			</c:forEach>
			<script>
	  	function moveDetail(bid){
	  		location.href = "${pageContext.request.contextPath}/board/detail/rental/"+bid;
	  	}
	  </script>

			<script>
		function toggleLike(heartEl, boardId) {
        	$.ajax({
              	type: 'POST',
              	url: '${pageContext.request.contextPath}/board/addDibs',
              	data: {
              	  userId: 1,
              	  boardId: boardId,
              	  boardCategory: 'rental'
             	 },
             	 success: function (res) {
             		 console.log(res);
    	       		  const liked = heartEl.classList.contains('liked');
    	      		
    	    		  if (liked) {
    	    		    // 찜 취소
    	    		    heartEl.textContent = '♡';
    	    		    heartEl.classList.remove('liked');
    	    		
    	    		    // TODO: 서버로 찜 취소 요청 (Ajax)
    	    		    console.log(`찜 취소: ${boardId}`);
    	    		  } else {
    	    		    // 찜 등록
    	    		    heartEl.textContent = '♥';
    	    		    heartEl.classList.add('liked');
    	    		
    	    		    // TODO: 서버로 찜 등록 요청 (Ajax)
    	    		    console.log(`찜 등록: ${boardId}`);
    	    		  }
             	 },
             	 error: function (err) {   
             	    console.error(err);
             	  }
               
             	 
               });
		}
		
    	

    	
		
		
		
		</script>

		</div>
	</div>
</div>

<script>
  window.addEventListener('DOMContentLoaded', () => {
    if (window.history.replaceState) {
      const cleanUrl = window.location.protocol + "//" + window.location.host + window.location.pathname;
      window.history.replaceState(null, null, cleanUrl);
    }
  });
</script>
<script>
	//필터 옵션
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
</script>

</body>
</html>