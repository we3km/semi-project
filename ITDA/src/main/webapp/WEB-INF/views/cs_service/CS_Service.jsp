<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>고객센터</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/cs_service/CS_Service.css" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/header.css" />
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
	<div class="wrapper">
		<header class="header">
			<jsp:include page="/WEB-INF/views/common/Header.jsp" />
		</header>
	</div>
	_
	<!-- 고객센터 본문 -->
	<div class="center-wrapper">
		<div class="cs-header">
			<div class="cs-service">고객센터</div>
		</div>

		<div class="notice-box">
			<p>최근 6개월 동안 접수하신 내역을 확인할 수 있습니다.</p>
			<p>개인정보가 포함된 문의, 중복된 문의는 삭제될 수 있습니다.</p>
			<p>욕설, 인격침해, 성희롱 등 수치심을 유발하는 표현이 있다면 상담이 중단될 수 있습니다.</p>
		</div>

		<div class="header-mq">
			<div class="my-question">
				<sec:authorize access="hasRole('ROLE_ADMIN')">
					<div class="my-question">전체 문의 내역</div>
				</sec:authorize>
				<sec:authorize access="hasRole('ROLE_USER')">
					<div class="my-question">내 문의 내역</div>
				</sec:authorize>
			</div>

			<!-- 일반 사용자만 1:1문의 버튼 보이기 -->
			<sec:authorize access="hasRole('ROLE_USER')">
				<form:form method="get"
					action="${pageContext.request.contextPath}/cs/inquiry">
					<button class="inquiry-btn" type="submit">1:1문의</button>
				</form:form>
			</sec:authorize>
		</div>

		<table class="inquiry-table">
			<thead>
				<tr>
					<th>제목</th>
					<th>문의 날짜</th>
					<th>카테고리</th>
				</tr>
			</thead>
			<tbody>
				<c:choose>
					<c:when test="${not empty list}">
						<c:forEach var="inq" items="${list}">
							<tr
								onclick="location.href='${pageContext.request.contextPath}/cs/inquiry/detail/${inq.csNum}'"
								style="cursor: pointer;">
								<td>${inq.csTitle}</td>
								<td><fmt:formatDate value="${inq.csDate}"
										pattern="yyyy-MM-dd" /></td>
								<td>${inq.categoryName}</td>
							</tr>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<tr>
							<td colspan="3" style="text-align: center; color: #333;">문의
								내역이 없습니다.</td>
						</tr>
					</c:otherwise>
				</c:choose>
			</tbody>
		</table>

		<!-- 자주 묻는 질문 -->
		<div class="QNA">자주 묻는 질문</div>

		<div class="faq-list">
			<div class="qa-item">
				<button class="question" type="button">Q1. 비매너 채팅을 하는 유저가
					있어요!</button>
				<div class="answer" style="display: none;">
					<p>A. 스크린샷을 찍은 후 문의하기로 신고해주시면 빠르게 처리하겠습니다.</p>
				</div>
			</div>

			<div class="qa-item">
				<button class="question" type="button">Q2. 상대방이 물건을 보내주지
					않았어요.</button>
				<div class="answer" style="display: none;">
					<p>A. 상대방이 물건을 보내지 않았다면 돈을 보내지 않으시면 됩니다.</p>
				</div>
			</div>

			<div class="qa-item">
				<button class="question" type="button">Q3. 경매에 낙찰됐는데 구매하기가
					싫어요 ㅠㅠ</button>
				<div class="answer" style="display: none;">
					<p>A. 다음으로 높은 금액을 부른 사람에게 구매 권한이 넘어갑니다.</p>
					<p>* 구매 번복은 안 되니 신중히 결정해주세요.</p>
				</div>
			</div>

			<div class="qa-item">
				<button class="question" type="button">Q4. 이상한 글을 보았어요!</button>
				<div class="answer" style="display: none;">
					<p>A. 스크린샷을 찍은 후 문의하기로 신고해주시면 빠르게 처리하겠습니다.</p>
				</div>
			</div>
		</div>
	</div>

	<script>
		$(function() {
			$('.question').click(function() {
				$(this).next('.answer').slideToggle();
			});
		});
		$(function() {
			$('#header').load('../components/header.html', function() {
				console.log('헤더 삽입 완료');
				$.getScript('../components/header.js');
			});
		});
	</script>
</body>
</html>
