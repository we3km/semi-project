<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<meta charset="utf-8" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/mypageOthers.css" />
	<%-- report css --%>
<link href="${pageContext.request.contextPath}/resources/css/report/reports.css" rel="stylesheet">

<%-- jQuery --%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
	<div class="wrapper">
		<header class="header">
			<jsp:include page="/WEB-INF/views/common/Header.jsp" />
		</header>
	</div>
	
	<div class="container">
	<div class="div-wrapper">
		<div class="div">

			<div class="overlap-22">
				<div class="text-wrapper-23">
					${user.nickName}
					<text
						style="font-weight: 500; color: #5a54ff; font-size: 35px; text-shadow: 0px 2px 2px #00000040;">
					님의 프로필 </text>
				</div>
			</div>
			<div class="text-wrapper-25" onclick="openReportModal('USER', '${user.userNum}', '${user.userNum}')">신고하기</div>
			<div class="overlap-9">
				<img class="rectangle" src="${pageContext.request.contextPath}${imageUrl}" />
				<div class="text-wrapper-7">NICK NAME</div>
				<div class="text-wrapper-8">${user.nickName}</div>
				<div class="overlap-10">
					<p class="element">
						<span class="text-wrapper-9">${itdaPoint}</span> <span
							class="text-wrapper-10">℃</span>
					</p>
					<div class="rectangle-2">
			            <div class="gauge-fill" id="gauge-fill"></div>
			        </div>
				</div>
			</div>

			

		</div>
	</div>
	
	<div class="user-board-list">	
		<div class="user-write-list">
			<div class="related-products">
				<h2>${user.nickName}님이 게시한 대여 게시글</h2>
				<div class="product-list">
					<!-- 카드 반복 -->
					<c:forEach var="userRentalWrapper"
						items="${userRentalWrapperList }">
						<div class="card"
							onclick="moveRentalDetail(${userRentalWrapper.boardCommon.boardId});">
							<img
								src="${pageContext.request.contextPath}/${userRentalWrapper.filePath.categoryPath}/${userRentalWrapper.filePath.fileName}"
								alt="이미지" />
							<p id="product-name">${userRentalWrapper.boardCommon.productName }</p>
							<p id="rental-fee">대여료:${userRentalWrapper.boardRental.rentalFee }원</p>
							<p class="date">
								<fmt:formatDate
									value="${userRentalWrapper.boardRental.rentalStartDate }"
									pattern="yyyy/MM/dd" />
								~
								<fmt:formatDate value="${userRentalWrapper.boardRental.rentalEndDate }"
									pattern="yyyy/MM/dd" />
							</p>
						</div>
					</c:forEach>
					<!-- 클릭시 상세보기로 이동 -->
					<script>
						function moveRentalDetail(bid){
							location.href = "${pageContext.request.contextPath}/board/detail/rental/"+bid;
						}
					</script>

				</div>
			</div>
			<div class="related-products">
				<h2>${user.nickName}님이 게시한 나눔 게시글</h2>
				<div class="product-list">
					<!-- 카드 반복 -->
					<c:forEach var="userShareWrapper"
						items="${userShareWrapperList }">
						<div class="card"
							onclick="moveShareDetail(${userShareWrapper.boardCommon.boardId});">
							<img
								src="${pageContext.request.contextPath}/${userShareWrapper.filePath.categoryPath}/${userShareWrapper.filePath.fileName}"
								alt="이미지" />
							<p id="product-name">${userShareWrapper.boardCommon.productName }</p>
							<p class="count">나눔수량:${userShareWrapper.boardSharing.sharingCount }개</p>
						</div>
					</c:forEach>
					<!-- 클릭시 상세보기로 이동 -->
					<script>
						function moveShareDetail(bid){
							location.href = "${pageContext.request.contextPath}/board/detail/share/"+bid;
						}
					</script>

				</div>
			</div>
			
			<div class="related-products">
				<h2>${user.nickName}님이 게시한 경매 게시글</h2>
				<div class="product-list">
					<!-- 카드 반복 -->
					<c:forEach var="userAuctionWrapper"
						items="${userAuctionWrapperList }">
						<div class="card"
							onclick="moveAuctionDetail(${userAuctionWrapper.boardCommon.boardId});">
							<img
								src="${pageContext.request.contextPath}/${userAuctionWrapper.filePath.categoryPath}/${userAuctionWrapper.filePath.fileName}"
								alt="이미지" />
							<p id="product-name">${userAuctionWrapper.boardCommon.productName }</p>
													<p id="auction-fee">경매시작금:${userAuctionWrapper.boardAuction.auctionStartingFee }</p>
							<c:if test="${userAuctionWrapper.highestBid ne 0}">
								<p id="highest-bid">최고입찰가 :
									${userAuctionWrapper.highestBid}</p>
							</c:if>
	
							<c:if test="${userAuctionWrapper.highestBid eq 0}">
								<p id="highest-bid">최고입찰가 :
									${userAuctionWrapper.boardAuction.auctionStartingFee}</p>
							</c:if>
							<p class="date">
								<fmt:formatDate
									value="${userAuctionWrapper.boardAuction.auctionStartDate }"
									pattern="yyyy/MM/dd" />
								~						
								<fmt:formatDate
									value="${userAuctionWrapper.boardAuction.auctionEndDate }"
									pattern="yyyy/MM/dd" />
							</p>
						</div>
					</c:forEach>
					<!-- 클릭시 상세보기로 이동 -->
					<script>
						function moveAuctionDetail(bid){
							location.href = "${pageContext.request.contextPath}/board/detail/auction/"+bid;
						}
					</script>

				</div>
			</div>
		</div>
	</div>
	</div>
		<script>
	 const writeBtn = document.getElementById('writeBtn');
	  const likedBtn = document.getElementById('likedBtn');
	  const writeList = document.querySelector('.user-write-list');
	  const likedList = document.querySelector('.user-liked-list');

	  function showWriteList() {
		document.querySelector('.user-write-list').style.display = 'block';
		document.querySelector('.user-liked-list').style.display = 'none';

	    writeBtn.classList.add('active');
	    likedBtn.classList.remove('active');
	  }

	  function showLikedList() {
		document.querySelector('.user-write-list').style.display = 'none';
		document.querySelector('.user-liked-list').style.display = 'block';

	    likedBtn.classList.add('active');
	    writeBtn.classList.remove('active');
	  }
	</script>	
	<jsp:include page="/WEB-INF/views/report/report.jsp" />
	<script>
		const contextPath = "${pageContext.request.contextPath}";
		let score = ${itdaPoint};
		
		// 잇다점수 시각적 표시
		const gaugeFill = document.getElementById('gauge-fill');
		
		function updateGauge(score) { // 0~100으로 제한
			const clampedScore = Math.max(0, Math.min(score, 100));
			gaugeFill.style.width = clampedScore + '%';
		}
		
		updateGauge(score);
	</script>
	<script src="${pageContext.request.contextPath}/resources/js/report/reports.js"></script>
</body>
</html>
