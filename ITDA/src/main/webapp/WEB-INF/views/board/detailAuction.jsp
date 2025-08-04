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
	background-color:red;
  color: white; /* 좋아요 상태일 때 빨간색 하트 */
}

#dibsBtn.not-liked {
  background-color:gray;
  color: white; /* 찜 안한 상태일 때 회색 하트 */
}

.top-bid {
    background-color: #ffd700; /* 골드 느낌 배경 */
    width:max-content;
    font-weight: bold;
    color: #b35900;
    border-radius: 4px;
    padding: 2px 6px;
}


</style>

</head>
<body>
	<div class="wrapper">
		<header class="header">
			<jsp:include page="/WEB-INF/views/common/Header.jsp" />
		</header>
	</div>
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

				<div class="price">경매시작금 : ${board.boardAuction.auctionStartingFee}원</div>
				<div class="date-range">
					대여기간 :
					<fmt:formatDate value="${board.boardAuction.auctionStartDate }"
						pattern="yyyy/MM/dd" />
					~
					<fmt:formatDate value="${board.boardAuction.auctionEndDate }"
						pattern="yyyy/MM/dd" />
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
					<!-- 게시자가 아닌 다른 사용자가 상세보기에 들어왔을 때 -->
					<c:if test="${userNum ne board.boardCommon.userNum}">
						<button>메시지 보내기</button>
					</c:if>
					<!-- 경매가 종료 되고 게시글 게시자가 상세보기에 들어왔을 때 -->
					<c:if test="${userNum eq board.boardCommon.userNum and auctionEnd eq 'end' and not empty bidList}">
						<button id="message-winner" onclick="messageWinner(${board.boardCommon.boardId})">낙찰자에게 채팅 보내기</button>
					</c:if>
					
					<!-- 경매가 종료 되었지만 입찰자가 단 한명도 없을때 게시글 게시자가 상세보기에 들어왔을 때 -->
					<c:if test="${userNum eq board.boardCommon.userNum and auctionEnd eq 'end' and empty bidList}">
						<button id="message-winner">입찰자 없음</button>
					</c:if>
					
					<script>
						function messageWinner(boardId) {
						    $.ajax({
						      url: "${pageContext.request.contextPath}/board/auction/winner",
						      method: "POST",
						      data: { boardId: ${board.boardCommon.boardId} }, // JSP 변수 그대로 사용
						      success: function(data) {
						        console.log("서버 응답:", data);
						        alert("성공: " + data);
						        // 채팅방 이동로직 추가
						      },
						      error: function(xhr) {
						        alert("입찰 저장 실패: " + xhr.responseText);
						      }
						    });
						}
					</script>
					<!-- 게시자가 상세보기에 들어왔을 때 -->
					<c:if test="${userNum eq board.boardCommon.userNum}">
						<button>수정</button>
						<button>삭제</button>
					</c:if>
					
					<!-- 게시가 아닌 다른 사용자가 상세보기에 들어왔을 때 -->
					<c:if test="${userNum ne board.boardCommon.userNum}">
						<button id="dibsBtn" class="${isDibs ? 'liked' : 'not-liked'}">
	  						<i class="fa fa-heart"></i> 찜하기
						</button>
					</c:if>
					
						<!-- 경매가 종료되고 게시자가 아닌 다른 사용자가 상세보기에 들어왔을 때   -->
						<!-- 경매가 종료되지 않고 게시자가 아닌 다른 사용자가 상세보기에 들어왔을 때 -->
					<c:choose>
						<c:when test="${userNum ne board.boardCommon.userNum and auctionEnd eq 'end'}">
							<button class="auctionEnd" style="cursor: default; background-color:gray; color: white;">
							경매종료</button>
						</c:when>
						<c:when test="${userNum ne board.boardCommon.userNum and auctionEnd eq 'doing'}">
							<button onclick="openModal('${boardId}', '${userNum}')">입찰하기</button>
						</c:when>
					</c:choose>
					
					
					<div id="bidModal" style="display:none; position:fixed; top:20%; left:30%; width:300px; height:200px; background:white; border:1px solid black; padding:20px;">
					  <h3>${board.boardCommon.productName}의 입찰금 제시</h3>
					  <h4>입찰금 단위 : ${board.boardAuction.bidUnit}</h4>
					  <button type="button" onclick="changeBid(-1)">-</button>
					  <input type="text" id="popupInput" placeholder="제시할 입찰금"/>
					  <button type="button" onclick="changeBid(1)">+</button>
					  <button onclick="applyValue()">제시</button>
					  <button onclick="closeModal()">닫기</button>
					</div>
					
					<h3>입찰금 현황</h3>
					<div id="biddingList">
						<c:forEach var="bid" items="${bidList }" varStatus="status">
							<p class="bid ${status.first ? 'top-bid' : ''}" 
  							data-nickname="${bid.nickName}">
								${bid.nickName} - ${bid.bid }
<%-- 								<c:if test="${bid.biddingUserNum == userNum}">
							    	<button onclick="openModal('${board.boardCommon.boardId}', '${userNum}')">
							    	수정</button>
								</c:if> --%>
							</p>
						
						</c:forEach>
					</div>
					
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
          	  boardCategory: 'auction'
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
	            	   boardCategory: 'auction'},
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
    
    <!-- 입찰금 제시 모달창 스크립트 -->
	<script>
		const bidUnit = ${board.boardAuction.bidUnit}; // 입찰 단위 (서버에서 받아오는 값)
		let previousBid = 0;        // 사용자의 이전 입찰 금액 (서버에서 받아오는 값)
		let currentBid = 0;
		
		function openModal(userId, boardId) {
		  
		  fetch(`${pageContext.request.contextPath}/board/bidding/check?userNum=${userNum}&boardId=${boardId}`)
		    .then(response => response.json())
		    .then(data => {
		      if (data.hasBid) {
		        // 이전 입찰금 있으면 모달에 값 넣기
		        document.getElementById("popupInput").value = data.bid;
		        previousBid = data.bid;
		        //document.getElementById("bidModalTitle").innerText = "입찰금 수정";
		      } else {
		        // 이전 입찰금 없으면 시작 입찰금
		        document.getElementById("popupInput").value = ${board.boardAuction.auctionStartingFee};
		        previousBid = ${board.boardAuction.auctionStartingFee}
		        //document.getElementById("bidModalTitle").innerText = "입찰금 제시";
		      }
				currentBid = previousBid;
		      document.getElementById("bidModal").style.display = "block";
		    });
		 
			console.log("currentBid:"+currentBid);
			console.log("previousBid:"+previousBid);
		}
		 function changeBid(direction) {
			console.log("currentBid:"+currentBid);
			console.log("previousBid:"+previousBid);
			    const newBid = currentBid + direction * bidUnit;

			    // 이전 입찰 금액보다 작아지는 것은 막음
			    if (newBid < previousBid) {
			      return; // 무시
			    }

			    currentBid = newBid;
			    document.getElementById('popupInput').value = currentBid;
		 }

	
	  function closeModal() {
	    document.getElementById("bidModal").style.display = "none";
	  }
	
	  function applyValue() {
			    const bidValue = $("#popupInput").val();
			    const userNum = ${userNum}; 
				const nickName = '${userNickname}';
				
				if (bidValue <= previousBid) {
					  alert("이전에 제시한 금액보다 높게 입찰해야 합니다.");
					  return;
				}
				
			    $.ajax({
			      url: "${pageContext.request.contextPath}/board/auction/bid", // JSP에서 contextPath 처리
			      type: "POST",
			      contentType: "application/json",
			      data: JSON.stringify({
			        boardId: ${board.boardCommon.boardId}, // JSP 변수 그대로 사용
			        biddingUserNum: userNum,
			        bid: bidValue,
			        nickName: nickName
			      }),
			      success: function(data) {
			        console.log("서버 응답:", data);
					
			        // 전에 제시를 했었는지 확인
			        const existingBid = $(`.bid[data-nickname="${userNickname}"]`);
			        if (existingBid.length > 0) {
			        	// 이미 제시를 했으면 수정
			          existingBid.text(nickName + " - " + bidValue);			        							        			        	
			        } else {
			        	// 아직 제시를 안했으면 추가
			          const bid = $("<p></p>")
			            .addClass("bid")
			            .attr("data-nickname", nickName)
			            .text(nickName + " - " + bidValue);
			
			          $("#biddingList").append(bid);
			        }
			     // 입찰금이 높은 순으로 정렬
		            const bids = $("#biddingList .bid").get();

		            bids.sort((a, b) => {
		                const bidA = parseInt($(a).text().split(" - ")[1]);
		                const bidB = parseInt($(b).text().split(" - ")[1]);
		                return bidB - bidA; // 높은 금액이 앞으로 오도록 내림차순
		            });
		            
		            $("#biddingList").empty();

		            bids.forEach((el, index) => {
		                const $el = $(el);
		                $el.removeClass("top-bid");
						
		         
		                if (index === 0) {
		                    $el.addClass("top-bid");
		                }

		                $("#biddingList").append($el);
		            });

		            $("#biddingList").empty().append(bids);
		            
			        closeModal();
			      },
			      error: function(xhr) {
			        alert("입찰 저장 실패: " + xhr.responseText);
			      }
			    });
			  }
	</script>
		<!-- 게시물 게시자의 다른 대여 글들 -->
		<div class="related-products">
			<h2>${writer}님의 다른 상품</h2>
			<div class="product-list">

				<!-- 카드 반복 -->
				<c:forEach var="writerAuctionWrapper"
					items="${writerAuctionWrapperList }">

					<div class="card"
						onclick="moveDetail(${writerAuctionWrapper.boardCommon.boardId});">
						<img
							src="${pageContext.request.contextPath}/${writerAuctionWrapper.filePath.categoryPath}/${writerAuctionWrapper.filePath.fileName}"
							alt="이미지"
							style="width: 90%; height: auto; border: 2px solid black;" />
						<p>${writerAuctionWrapper.boardCommon.productName }</p>
						<p class="price">경매시작금:${writerAuctionWrapper.boardAuction.auctionStartingFee }</p>
						<c:if test="${writerAuctionWrapper.highestBid ne 0}">
							<p id="highest-bid">최고입찰가 : ${writerAuctionWrapper.highestBid}</p>
						</c:if>
					
						<c:if test="${writerAuctionWrapper.highestBid eq 0}">
							<p id="highest-bid">최고입찰가 : ${writerAuctionWrapper.boardAuction.auctionStartingFee}</p>
						</c:if>
						<p>
							<fmt:formatDate
								value="${writerAuctionWrapper.boardAuction.auctionStartDate }"
								pattern="yyyy/MM/dd" />
						</p>
						~
						<p>
							<fmt:formatDate value="${writerAuctionWrapper.boardAuction.auctionEndDate }"
								pattern="yyyy/MM/dd" />
						</p>
					</div>
				</c:forEach>
				<!-- 클릭시 상세보기로 이동 -->
				<script>
				  	function moveDetail(bid){
				  		location.href = "${pageContext.request.contextPath}/board/detail/auction/"+bid;
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
						<p class="price">경매시작금:${equalsCategoryboard.boardAuction.auctionStartingFee }</p>
						<c:if test="${equalsCategoryboard.highestBid ne 0}">
							<p id="highest-bid">최고입찰가 : ${equalsCategoryboard.highestBid}</p>
						</c:if>
					
						<c:if test="${equalsCategoryboard.highestBid eq 0}">
							<p id="highest-bid">최고입찰가 : ${equalsCategoryboard.boardAuction.auctionStartingFee}</p>
						</c:if>
						
						<p>
							<fmt:formatDate
								value="${equalsCategoryboard.boardAuction.auctionStartDate }"
								pattern="yyyy/MM/dd" />
						</p>
						~
						<p>
							<fmt:formatDate
								value="${equalsCategoryboard.boardAuction.auctionEndDate }"
								pattern="yyyy/MM/dd"/>
						</p>
					</div>
				</c:forEach>
				<!-- 게시물 클릭시 상세보기 이동 -->
				<script>
				  	function moveDetail(bid){
				  		location.href = "${pageContext.request.contextPath}/board/detail/auction/"+bid;
				  	}
				 </script>
			</div>
		</div>
	</div>
</body>
</html>