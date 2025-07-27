 <%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>

<head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<link href="${pageContext.request.contextPath}/resources/css/board/rentalBoard.css"
	rel="stylesheet">
  <meta charset="UTF-8">
  <title>대여 게시판</title>
  
</head>
<body>

  <div class="sidebar">
  <form id="filterForm" method="get" action="${pageContext.request.contextPath}/board/rental">
    <div class="filter-section">
      <h3>정렬 조건</h3>
      <button type="submit" id="filter-btn">정렬</button>
    </div>
    
      <select name="sort">
    	<option value="date">게시일 순</option>
    	<option value="views">조회수 순</option>
    	<option value="dibs">찜 순</option>
    	<option value="price">가격 순</option>
  	</select>

    <div class="filter-section">
      <h4>지역</h4>
      <label><input type="checkbox"> 강남</label>
      <label><input type="checkbox"> 강서</label>
      <label><input type="checkbox"> 강동</label>
      <label><input type="checkbox"> 강북</label>
    </div>

    <div class="filter-section">
      <h4>상품유형</h4>
      <label><input type="checkbox"> 의류</label>
      <label><input type="checkbox"> 전자기기</label>
      <label><input type="checkbox"> 생활가전</label>
      <label><input type="checkbox"> 가구</label>
      <label><input type="checkbox"> 도서</label>
      <label><input type="checkbox"> 뷰티</label>
      <label><input type="checkbox"> 식품</label>
      <label><input type="checkbox"> 스포츠</label>
    </div>

    <div class="filter-section">
      <h4>가격</h4>
      <label>5,000원 ~ 30,000원</label>
      <input type="range" min="5000" max="30000" value="15000">
    </div>

    <div class="filter-section">
      <h4>대여 기간</h4>
      <input type="date" >
      <input type="date">
    </div>
	</form>
  </div>
	
  <div class="main">
    <div class="top">
      <div>
        <h2>대여 게시판</h2>
        <span class="location">서울특별시 강남구 📍</span> <!-- 로그인한 회원의 주소 -->
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

      <div class="card" onclick="moveDetail(${board.boardCommon.boardId});">
        <c:set var="boardId" value="${board.boardCommon.boardId}" />
		<c:if test="${fn:contains(likedBoardIds, boardId)}">
			<div class="heart liked"
				onclick="event.stopPropagation(); toggleLike(this, ${boardId});">♥</div>
		</c:if>
		<c:if test="${!fn:contains(likedBoardIds, boardId)}">
			<div class="heart"
				onclick="event.stopPropagation(); toggleLike(this, ${boardId});">♡</div>
		</c:if>

		<img src="${pageContext.request.contextPath}/${board.filePath.categoryPath}/${board.filePath.fileName}" alt="이미지"
				style="width: 90%; height: auto; "/>
        <p id="product-name">${board.boardCommon.productName }</p>

        <p id="rental-fee">대여료 : ${board.boardRental.rentalFee }</p>
        <p class="date"><fmt:formatDate value="${board.boardRental.rentalStartDate }" pattern="yyyy/MM/dd"/>~<fmt:formatDate value="${board.boardRental.rentalEndDate }" pattern="yyyy/MM/dd"/></p>
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



</body>
</html>