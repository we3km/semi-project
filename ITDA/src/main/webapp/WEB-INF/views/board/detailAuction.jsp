<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>잇다 - 경매게시판 > ${board.boardCommon.productName}</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<%-- report css --%>
<link href="${pageContext.request.contextPath}/resources/css/report/reports.css" rel="stylesheet">
<link
	href="${pageContext.request.contextPath}/resources/css/board/detailAuction.css"
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
							alt="이미지"/>
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
					${board.boardCommon.productName}
				</div>
				<div class="detail">
				<ul>
					<li>
						<div class="views">조회수:${board.boardCommon.views}</div>
					</li>
					<li>
						<div class="dibs">
							찜 수: ${dibsCount}
						</div>
					</li>
					<li>
					<div class="create-date">
						게시날짜:
						<fmt:formatDate value="${board.boardCommon.createDate }"
							pattern="yyyy/MM/dd" />
					</div>
					</li>
				</ul>

				<div class="price">경매시작금 :
					${board.boardAuction.auctionStartingFee}원</div>
				<div class="date-range">
					대여기간 :
					<fmt:formatDate value="${board.boardAuction.auctionStartDate }"
						pattern="yyyy/MM/dd" />
					~
					<fmt:formatDate value="${board.boardAuction.auctionEndDate }"
						pattern="yyyy/MM/dd" />
				</div>
				<div class="keywords">
					<c:forEach var="tag" items="${tags}">
						<span>#${tag}</span>
					</c:forEach>
				</div>

				<!-- 게시자의 매너 정보 -->
				<div class="seller-info">
					<div class="profile">
						<div class="profile-icon">
							<img class="profile-img"
								src="${pageContext.request.contextPath}${profileImage}"
								alt="프로필" />
						</div>
						<strong>${writer} </strong>
					</div>
					<c:choose>
					    <c:when test="${mannerScore lt 40}">
					        <c:set var="barColor" value="#ff4d4f" /> <!-- 빨강 -->
					    </c:when>
					    <c:when test="${mannerScore lt 70}">
					        <c:set var="barColor" value="#faad14" /> <!-- 노랑 -->
					    </c:when>
					    <c:otherwise>
					        <c:set var="barColor" value="#52c41a" /> <!-- 초록 -->
					    </c:otherwise>
					</c:choose>
					
					<div class="manner-score-box">
					    <span class="manner-label">매너점수: ${mannerScore}</span>
					    <div class="manner-bar">
					        <div class="manner-fill" style="width: ${mannerScore}%; background-color: ${barColor};"></div>
					    </div>
					</div>
				</div>
				<!-- 채팅방 열기와 찜하기, 신고하기 버튼 -->
				<div class="buttons">
					<!-- 연결해야함 -->
					<!-- 게시자가 아닌 다른 사용자가 상세보기에 들어왔을 때 -->
					<c:if test="${userNum ne board.boardCommon.userNum}">
						<button id="sendMessage" onclick="createTransactionChatRoom()">메시지
							보내기</button>
						
						<button id="dibsBtn" class="${isDibs ? 'liked' : 'not-liked'}">
							<i class="fa fa-heart"></i> 찜하기
						</button>
					</c:if>
					<!-- 경매가 종료 되고 게시글 게시자가 상세보기에 들어왔을 때 -->
					<c:if
						test="${userNum eq board.boardCommon.userNum and auctionEnd eq 'end' and not empty bidList}">
						<button id="message-winner"
							onclick="messageWinner(${board.boardCommon.boardId})">낙찰자에게
							채팅 보내기</button>
					</c:if>
					<script>
					     function createTransactionChatRoom() {
					        const contextPath = '${contextPath}';
					        // 데헷 이거 널값임					        
					        const boardId = "${board.boardCommon.boardId}";
					        
					        console.log("contextPath: ", contextPath);
					        console.log("현재 게시판 번호 : ", boardId);
					
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
					     
					     function createBiddingWinnerChatRoom() {
					    	 const contextPath = '${contextPath}';
										        
						     const boardId = "${board.boardCommon.boardId}";
						        
						        console.log("contextPath: ", contextPath);
						        console.log("현재 게시판 번호 : ", boardId);
						
						        fetch("/itda/chat/selectBoardInfo?boardId=" + boardId, {
						            method: "GET"
						        })
						        .then(response => {
						            if (!response.ok) throw new Error("게시물 정보 응답 실패");
						            return response.json();
						        })
						        .then(data => {
						            console.log("게시물 정보:", data);
						
						            return fetch("/itda/chat/openBidChatRoom", {
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

					<!-- 경매가 종료 되었지만 입찰자가 단 한명도 없을때 게시글 게시자가 상세보기에 들어왔을 때 -->
					<c:if
						test="${userNum eq board.boardCommon.userNum and auctionEnd eq 'end' and empty bidList}">
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
						        // 경매 우승 채팅방 생성
						        createBiddingWinnerChatRoom();
						      },
						      error: function(xhr) {
						        alert("입찰 저장 실패: " + xhr.responseText);
						      }
						    });
						}
					</script>
					<!-- 게시자가 상세보기에 들어왔을 때 -->
					<c:if test="${userNum eq board.boardCommon.userNum}">
						<form action="${pageContext.request.contextPath}/board/delete/auction/${board.boardCommon.boardId}" method="post" onsubmit="return confirm('정말 삭제하시겠습니까?');">
						    <button type="submit">삭제</button>
						</form>
					</c:if>

					<!-- 경매가 종료되고 게시자가 아닌 다른 사용자가 상세보기에 들어왔을 때   -->
					<!-- 경매가 종료되지 않고 게시자가 아닌 다른 사용자가 상세보기에 들어왔을 때 -->
					<c:choose>
						<c:when
							test="${userNum ne board.boardCommon.userNum and auctionEnd eq 'end'}">
							<button class="auctionEnd"
								style="cursor: default; background-color: gray; color: white;">
								경매종료</button>
						</c:when>
						<c:when
							test="${userNum ne board.boardCommon.userNum and auctionEnd eq 'doing'}">
							<button onclick="openModal('${boardId}', '${userNum}')">입찰하기</button>
						</c:when>
					</c:choose>


					<div id="bidModal"
						style="display: none; position: fixed; top: 20%; left: 30%; width: 300px; height: 200px; background: white; border: 1px solid black; padding: 20px;">
						<h3>${board.boardCommon.productName}의입찰금제시</h3>
						<h4>입찰금 단위 : ${board.boardAuction.bidUnit}</h4>
						<button type="button" onclick="changeBid(-1)">-</button>
						<input type="text" id="popupInput" placeholder="제시할 입찰금" />
						<button type="button" onclick="changeBid(1)">+</button>
						<button onclick="applyValue()">제시</button>
						<button onclick="closeModal()">닫기</button>
					</div>

					<!-- 연결해야함 -->
					<button onclick="openReportModal('BOARD', '${board.boardCommon.boardId}', '${board.boardCommon.userNum}')">신고하기</button>
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
		<h3>입찰금 현황</h3>
		<div id="biddingList">
						<c:forEach var="bid" items="${bidList }" varStatus="status">						
							<div class="bid ${status.first ? 'top-bid' : ''}"
								data-nickname="${bid.nickName}">
								<div class="bid-nickname">${bid.nickName}</div>
      							<div class="bid-amount">${bid.bid} 원</div>
							</div>
						</c:forEach>
					
		</div>
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
			<h2>${writer}님의다른상품</h2>
			<div class="product-list">

				<!-- 카드 반복 -->
				<c:forEach var="writerAuctionWrapper"
					items="${writerAuctionWrapperList }">

					<div class="card"
						onclick="moveDetail(${writerAuctionWrapper.boardCommon.boardId});">
						<img
							src="${pageContext.request.contextPath}/${writerAuctionWrapper.filePath.categoryPath}/${writerAuctionWrapper.filePath.fileName}"
							alt="이미지"
							/>
						<p id="product-name">${writerAuctionWrapper.boardCommon.productName }</p>
						<p id="auction-fee">경매시작금:${writerAuctionWrapper.boardAuction.auctionStartingFee }</p>
						<c:if test="${writerAuctionWrapper.highestBid ne 0}">
							<p id="highest-bid">최고입찰가 :
								${writerAuctionWrapper.highestBid}</p>
						</c:if>

						<c:if test="${writerAuctionWrapper.highestBid eq 0}">
							<p id="highest-bid">최고입찰가 :
								${writerAuctionWrapper.boardAuction.auctionStartingFee}</p>
						</c:if>
						<p class="date">
							<fmt:formatDate
								value="${writerAuctionWrapper.boardAuction.auctionStartDate }"
								pattern="yyyy/MM/dd" />
							~						
							<fmt:formatDate
								value="${writerAuctionWrapper.boardAuction.auctionEndDate }"
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
							 />
						<p id="product-name">${equalsCategoryboard.boardCommon.productName }</p>
						<p id="auction-fee">경매시작금:${equalsCategoryboard.boardAuction.auctionStartingFee }</p>
						<c:if test="${equalsCategoryboard.highestBid ne 0}">
							<p id="highest-bid">최고입찰가 : ${equalsCategoryboard.highestBid}</p>
						</c:if>

						<c:if test="${equalsCategoryboard.highestBid eq 0}">
							<p id="highest-bid">최고입찰가 :
								${equalsCategoryboard.boardAuction.auctionStartingFee}</p>
						</c:if>

						<p class="date">
							<fmt:formatDate
								value="${equalsCategoryboard.boardAuction.auctionStartDate }"
								pattern="yyyy/MM/dd" />
							~
							<fmt:formatDate
								value="${equalsCategoryboard.boardAuction.auctionEndDate }"
								pattern="yyyy/MM/dd" />
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
	<jsp:include page="/WEB-INF/views/report/report.jsp" />
	<script src="${pageContext.request.contextPath}/resources/js/report/reports.js"></script>
</body>
</html>