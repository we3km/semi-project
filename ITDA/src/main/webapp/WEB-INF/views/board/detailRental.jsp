<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>잇다 - 대여게시판 > ${board.boardCommon.productName}</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<link
	href="${pageContext.request.contextPath}/resources/css/board/detailRental.css"
	rel="stylesheet">
</head>
<body>
	<div class="wrapper">
		<header class="header">
			<jsp:include page="/WEB-INF/views/common/Header.jsp" />
		</header>
	</div>
	<div class="container">
		<div class="product-catrgory">
						${board.boardCommon.productCategoryL}
						&gt;
						${board.boardCommon.productCategoryM}
						&gt;
						${board.boardCommon.productCategoryS}
					</div>
		<div class="top-section">
			<!-- 게시물에 저장된 사진 -->
			<div class="related-img">
				<div class="img-list" id="slider">
					<c:forEach var="img" items="${imgList}">
						<img
							src="${pageContext.request.contextPath}/${img.categoryPath}/${img.fileName}"
							alt="이미지" />
					</c:forEach>
				</div>
					<button class="slider-btn prev-btn" onclick="moveSlide(-1)">‹</button>
  					<button class="slider-btn next-btn" onclick="moveSlide(1)">›</button>
			</div>
			
			<script>
			const slider = document.getElementById('slider');
			const images = slider.querySelectorAll('img');
			let currentIndex = 0;

			function updateSlide() {
			  const parentWidth = slider.parentElement.clientWidth;
			  slider.style.width = `\${parentWidth * images.length}px`;

			  images.forEach(img => {
			    img.style.width = `\${parentWidth - 10}px`;
			  });

			  slider.style.transform = `translateX(\${-currentIndex * parentWidth}px)`;
			}

			function moveSlide(direction) {
			  currentIndex += direction;
			  if (currentIndex < 0) currentIndex = images.length - 1;
			  if (currentIndex >= images.length) currentIndex = 0;
			  updateSlide();
			}

			window.addEventListener('load', updateSlide);
			window.addEventListener('resize', updateSlide);
			</script>
			<!-- 입력한 게시물 정보 -->
			<div class="info">
				<div class="title">
				<h1>${board.boardCommon.productName}</h1>
					<div class="product-catrgory">
						${board.boardCommon.productCategoryL}
						&gt;
						${board.boardCommon.productCategoryM}
						&gt;
						${board.boardCommon.productCategoryS}
					</div>
				</div>
				<div class="views">조회수:${board.boardCommon.views}</div>
				<div class="dibs">
					찜 수:
					<p id="dibCount">${dibsCount}</p>
				</div>
				
				<div class="create-date">
					게시날짜:
					<fmt:formatDate value="${board.boardCommon.createDate }"
						pattern="yyyy/MM/dd" />
				</div>

				<div class="price">대여금액 : ${board.boardRental.rentalFee}원</div>
				<div class="date-range">
					대여기간 :
					<fmt:formatDate value="${board.boardRental.rentalStartDate }"
						pattern="yyyy/MM/dd" />
					~
					<fmt:formatDate value="${board.boardRental.rentalEndDate }"
						pattern="yyyy/MM/dd" />
				</div>
				<div class="keywords">
					<c:forEach var="tag" items="${tags}">
						<span>#${tag}</span>
					</c:forEach>
				</div>
				
				<!-- 게시자의 매너 정보 -->
				<div class="seller-info">
					<div class="profile-icon">
						<img class="profile-img"
							src="${pageContext.request.contextPath}${profileImage}"
							alt="프로필" />
					</div>
					<strong>${writer} </strong>
					<p>매너점수 : ${mannerScore }</p>
				</div>
				<!-- 채팅방 열기와 찜하기, 신고하기 버튼 -->				
				<div class="buttons">
					<!-- 연결해야함 -->
					<c:if test="${userNum ne board.boardCommon.userNum}">
						<button>메시지 보내기</button>
						<button id="dibsBtn" class="${isDibs ? 'liked' : 'not-liked'}">
	  						<i class="fa fa-heart"></i> 찜하기
						</button>
					</c:if>
					
					<!-- 게시자가 상세보기에 들어왔을 때 -->
					<c:if test="${userNum eq board.boardCommon.userNum}">
						<form action="${pageContext.request.contextPath}/board/delete/rental/${board.boardCommon.boardId}" method="post" onsubmit="return confirm('정말 삭제하시겠습니까?');">
						    <button type="submit">삭제</button>
						</form>
					</c:if>

					
					<!-- 연결해야함 -->
					<button>신고하기</button>
				</div>
			</div>
		</div>
		<!-- 찜하기 버튼 스크립트 -->
		<script>
    	$('#dibsBtn').on('click', function () {
        	$.ajax({
          	type: 'POST',
          	url: '${pageContext.request.contextPath}/board/addDibs',
          	data: {
          	  userId: '${userNum}',
          	  boardId: '${boardId}',
          	  boardCategory: 'rental'
         	 },
         	 success: function (res) {
         		 console.log(res);
         	   if (res === 'liked') {
        	      $('#dibsBtn').addClass('liked').removeClass('not-liked');
        	    } else {
        	      $('#dibsBtn').removeClass('liked').addClass('not-liked');
        	    }
         	// 찜을 누르면 바로 찜수 변경 확인
	             $.ajax({
	               type: 'GET',
	               url: '${pageContext.request.contextPath}/board/dibsCount',
	               data: { boardId: '${boardId}',
	            	   boardCategory: 'rental'},
	               success: function (count) {
	                 $('#dibCount').text(count);
	               }
	             });
         	 },
         	 error: function (err) {   
         	    console.error(err);
         	  }
           
         	 
           });
    	});
    </script>
		<!-- 게시물 게시자의 다른 대여 글들 -->
		<div class="related-products">
			<h2>${writer}님의 다른 상품</h2>
			<div class="product-list">

				<!-- 카드 반복 -->
				<c:forEach var="writerRentalWrapper"
					items="${writerRentalWrapperList }">

					<div class="card"
						onclick="moveDetail(${writerRentalWrapper.boardCommon.boardId});">
						<img
							src="${pageContext.request.contextPath}/${writerRentalWrapper.filePath.categoryPath}/${writerRentalWrapper.filePath.fileName}"
							alt="이미지"
							style="width: 90%; height: auto; border: 2px solid black;" />
						<p>${writerRentalWrapper.boardCommon.productName }</p>
						<p class="price">${writerRentalWrapper.boardRental.rentalFee }</p>
						<p>
							<fmt:formatDate
								value="${writerRentalWrapper.boardRental.rentalStartDate }"
								pattern="yyyy/MM/dd" />
						</p>
						~
						<p>
							<fmt:formatDate value="${board.boardRental.rentalEndDate }"
								pattern="yyyy/MM/dd" />
						</p>
					</div>
				</c:forEach>
				<!-- 클릭시 상세보기로 이동 -->
				<script>
				  	function moveDetail(bid){
				  		location.href = "${pageContext.request.contextPath}/board/detail/rental/"+bid;
				  	}
				 </script>

			</div>
		</div>
		<!-- 상품 정보 -->
		<div class="description">
			<h3>상품정보</h3>
			<pre>${board.boardCommon.productComment}</pre>
		</div>
		
		<!-- 카테고리 소분류와 같은 다른 대여 게시물들 목록 -->
		<div class="related-products">
			<h2>이 상품과 유사한 상품</h2>
			<div class="product-list">
				<!-- 카드 반복 -->
				<c:forEach var="equalsCategoryboard" items="${equalsCategoryList }">

					<div class="card"
						onclick="moveDetail(${equalsCategoryboard.boardCommon.boardId});">
						<img
							src="${pageContext.request.contextPath}/${equalsCategoryboard.filePath.categoryPath}/${equalsCategoryboard.filePath.fileName}"
							alt="이미지"
							style="width: 90%; height: auto; border: 2px solid black;" />
						<p>${equalsCategoryboard.boardCommon.productName }</p>
						<p class="price">${equalsCategoryboard.boardRental.rentalFee }</p>
						<p>
							<fmt:formatDate
								value="${equalsCategoryboard.boardRental.rentalStartDate }"
								pattern="yyyy/MM/dd" />
						</p>
						~
						<p>
							<fmt:formatDate
								value="${equalsCategoryboard.boardRental.rentalEndDate }"
								pattern="yyyy/MM/dd" />
						</p>
					</div>
				</c:forEach>
				<!-- 게시물 클릭시 상세보기 이동 -->
				<script>
				  	function moveDetail(bid){
				  		location.href = "${pageContext.request.contextPath}/board/detail/rental/"+bid;
				  	}
				 </script>
			</div>
		</div>
	</div>
</body>
</html>