<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>${product.title}</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<style>
body {
	font-family: Arial, sans-serif;
	margin: 0;
	padding: 20px;
	background: #f9f9f9;
}

.container {
	max-width: 1200px;
	margin: auto;
	background: #fff;
	padding: 20px;
}

.top-section {
	display: flex;
	flex-wrap: wrap;
	gap: 20px;
}

.image-preview, .info {
	flex: 1 1 300px;
}

.image-preview img {
	width: 100%;
	border-radius: 12px;
}

.info h1 {
	font-size: 24px;
	margin-bottom: 10px;
}

.price, .date-range, .location {
	margin: 5px 0;
	font-size: 16px;
}

.keywords span {
	background: #eef;
	padding: 5px 10px;
	border-radius: 12px;
	margin-right: 5px;
	font-size: 13px;
	display: inline-block;
}

.seller-info {
	margin: 20px 0;
	display: flex;
	align-items: center;
}

.buttons button {
	margin-right: 10px;
	padding: 8px 14px;
	background: #4a4aff;
	color: #fff;
	border: none;
	border-radius: 5px;
	cursor: pointer;
}

.related-products {
	margin-top: 30px;
}

.product-list {
	display: flex;
	overflow-x: auto;
	gap: 10px;
}

.related-img {
	margin-top: 30px;
}

.img-list {
	display: flex;
	overflow-x: auto;
	gap: 10px;
	width: 500px;
}

.product-item {
	flex: 0 0 auto;
	width: 150px;
	background: #fdfdfd;
	border: 1px solid #ddd;
	padding: 10px;
	border-radius: 8px;
	text-align: center;
}

.product-item img {
	width: 100%;
	border-radius: 6px;
}

.description {
	margin-top: 30px;
}

.description pre {
	white-space: pre-wrap;
	background: #f1f1f1;
	padding: 16px;
	border-radius: 8px;
}

@media screen and (max-width: 768px) {
	.top-section {
		flex-direction: column;
	}
}

#dibsBtn.liked {
	background-color: red;
	color: white; /* 좋아요 상태일 때 빨간색 하트 */
}

#dibsBtn.not-liked {
	background-color: gray;
	color: white; /* 찜 안한 상태일 때 회색 하트 */
}
</style>

</head>
<body>
	<div class="container">
		<div class="top-section">
			<!-- 게시물에 저장된 사진 -->
			<div class="related-img">
				<div class="img-list">
					<c:forEach var="img" items="${imgList}">
						<img
							src="${pageContext.request.contextPath}/${img.categoryPath}/${img.fileName}"
							alt="이미지"
							style="width: 90%; height: auto; border: 2px solid black;" />
					</c:forEach>
				</div>
			</div>
			<!-- 입력한 게시물 정보 -->
			<div class="info">
				<h1>${board.boardCommon.productName}</h1>
				<div class="views">조회수:${board.boardCommon.views}</div>
				<div class="dibs">
					찜 수:
					<p id="dibCount">${dibsCount}</p>
				</div>
				<div class="product-catrgory">
					<div class="product-category-large">${board.boardCommon.productCategoryL}</div>
					>
					<div class="product-category-middle">${board.boardCommon.productCategoryM}</div>
					>
					<div class="product-category-small">${board.boardCommon.productCategoryS}</div>
				</div>
				<div class="create-date">
					게시날짜:
					<fmt:formatDate value="${board.boardCommon.createDate }"
						pattern="yyyy/MM/dd" />
				</div>

				<div class="price">나눔수량 : ${board.boardSharing.sharingCount}개</div>

			</div>
			<div class="location">지역 :
				${board.boardCommon.transactionAddress}</div>
			<div class="keywords">
				<c:forEach var="tag" items="${tags}">
					<span>#${tag}</span>
				</c:forEach>
			</div>

			<!-- 게시자의 매너 정보 -->
			<div class="seller-info">
				<strong>${writer} </strong>
				<p>매너점수 : ${mannerScore }</p>
			</div>
			<!-- 채팅방 열기와 찜하기, 신고하기 버튼 -->
			<div class="buttons">
				<!-- 연결해야함 -->

				<button id="dibsBtn" class="${isDibs ? 'liked' : 'not-liked'}">
					<i class="fa fa-heart"></i> 찜하기
				</button>
				<!-- 연결해야함 -->

							
				<button id="sendMessage" onclick="createTransactionChatRoom()">메시지
					보내기</button>
				
				<!-- 채팅방 리스트 이동  -->
				<script>
					     function createTransactionChatRoom() {
					        const contextPath = '${contextPath}';
					        // 데헷 이거 널값임					        
					        const boardId = "${board.boardCommon.boardId}";
					
					        fetch("/itda/chat/selectBoardInfo?boardId=" + boardId, {
					            method: "GET"
					        })
					        .then(response => {
					            if (!response.ok) throw new Error("게시물 정보 응답 실패");
					            return response.json();
					        })
					        .then(data => {
					            console.log("게시물 정보:", data);
					
					            return fetch("/itda/chat/openChatRoom", {
					                method: "POST",
					                headers: {
					                    "Content-Type": "application/json"
					                },
					                body: JSON.stringify(data)
					            });
					        })
					        .then(response => {
					            if (!response.ok) throw new Error("채팅방 열기 실패");
					            location.href = contextPath + "/itda/chat/chatRoomList";
					        })
					        .catch(err => console.error("오류 발생:", err));
					    } 
					</script>
	
				</div>
				<div class="location">지역 :
					${board.boardCommon.transactionAddress}</div>
				<div class="keywords">
					<c:forEach var="tag" items="${tags}">
						<span>#${tag}</span>
					</c:forEach>
				</div>
				
				<!-- 게시자의 매너 정보 -->
				<div class="seller-info">
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
						<button>수정</button>
						<button>삭제</button>
					</c:if>
					
					<!-- 연결해야함 -->
					<button>신고하기</button>
				</div>
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
          	  boardCategory: 'share'
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
	            	   boardCategory: 'share'},
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
		<h2>${writer}님의다른상품</h2>
		<div class="product-list">

			<!-- 카드 반복 -->
			<c:forEach var="writerShareWrapper"
				items="${writerShareWrapperList }">

				<div class="card"
					onclick="moveDetail(${writerShareWrapper.boardCommon.boardId});">
					<img
						src="${pageContext.request.contextPath}/${writerShareWrapper.filePath.categoryPath}/${writerShareWrapper.filePath.fileName}"
						alt="이미지"
						style="width: 90%; height: auto; border: 2px solid black;" />
					<p>${writerShareWrapper.boardCommon.productName }</p>
					<p class="price">나눔수량:${writerShareWrapper.boardSharing.sharingCount }개</p>
				</div>
			</c:forEach>
			<!-- 클릭시 상세보기로 이동 -->
			<script>
				  	function moveDetail(bid){
				  		location.href = "${pageContext.request.contextPath}/board/detail/share/"+bid;
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
					<p class="price">${equalsCategoryboard.boardSharing.sharingCount }</p>

				</div>
			</c:forEach>
			<!-- 게시물 클릭시 상세보기 이동 -->
			<script>
				  	function moveDetail(bid){
				  		location.href = "${pageContext.request.contextPath}/board/detail/share/"+bid;
				  	}
				 </script>
		</div>
<<<<<<< HEAD
	</div>
	</div>
=======
	
>>>>>>> main
</body>
</html>