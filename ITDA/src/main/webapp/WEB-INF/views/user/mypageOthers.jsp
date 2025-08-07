<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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

			<!-- 대여 게시글 -->
			<p class="rnrdj">
				<span class="span">${user.nickName}</span> <span
					class="text-wrapper-4"> 님이 등록한 대여게시글</span>
			</p>

			<c:forEach var="rental" items="${rentalPosts}" varStatus="loop">
				<div class="group-5" style="left: ${loop.index * 233}px;">
					<div class="overlap">
						<img class="vector"
							src="${pageContext.request.contextPath}/resources/img/${rental.image}" />
					</div>
					<div class="overlap-group">
						<div class="text-wrapper">${rental.title}</div>
					</div>
					<div class="overlap-2">
						<div class="text-wrapper-2">보증금 : ${rental.deposit}원</div>
					</div>
					<div class="overlap-group-2">
						<div class="text-wrapper-3">${rental.period}</div>
					</div>
				</div>
			</c:forEach>

			<!-- 경매 게시글 -->
			<p class="p">
				<span class="span">${user.nickName}</span> <span
					class="text-wrapper-4"> 님이 등록한 경매게시글</span>
			</p>

			<c:forEach var="auction" items="${auctionPosts}" varStatus="loop">
				<div class="group-10" style="left: ${loop.index * 233}px;">
					<div class="overlap">
						<img class="vector"
							src="${pageContext.request.contextPath}/resources/img/${auction.image}" />
					</div>
					<div class="overlap-group">
						<div class="text-wrapper">${auction.title}</div>
					</div>
					<div class="overlap-2">
						<div class="text-wrapper-2">보증금 : ${auction.deposit}원</div>
					</div>
					<div class="overlap-group-2">
						<div class="text-wrapper-3">${auction.period}</div>
					</div>
				</div>
			</c:forEach>

			<!-- 나눔 게시글 -->
			<p class="rnrdj-2">
				<span class="span">${user.nickName}</span> <span
					class="text-wrapper-4"> 님이 등록한 나눔게시글</span>
			</p>

			<c:forEach var="share" items="${sharePosts}" varStatus="loop">
				<div class="group-15" style="left: ${loop.index * 233}px;">
					<div class="overlap">
						<img class="vector"
							src="${pageContext.request.contextPath}/resources/img/${share.image}" />
					</div>
					<div class="overlap-group">
						<div class="text-wrapper">${share.title}</div>
					</div>
					<div class="overlap-2">
						<div class="text-wrapper-2">보증금 : ${share.deposit}원</div>
					</div>
					<div class="overlap-group-2">
						<div class="text-wrapper-3">${share.period}</div>
					</div>
				</div>
			</c:forEach>

		</div>
	</div>
	</div>
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
