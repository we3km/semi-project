<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>고객센터</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/report/CS_Service.css" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/header.css" />
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
	<!-- 헤더부분 -->
	<div id="header"></div>

	<!-- 고객센터 작성 시작 -->
	<div class="center-wrapper">
		<div class="cs-header">
			<div class="cs-service">고객센터</div>
		</div>

		<!-- 고객센터 주의사항 안내 문구박스 -->
		<div class="notice-box">
			<p>최근 6개월 동안 접수하신 내역을 확인할 수 있습니다.</p>
			<p>개인정보가 포함된 문의, 중복된 문의는 삭제될 수 있습니다.</p>
			<p>욕설, 인격침해, 성희롱 등 수치심을 유발하는 표현이 있다면 상담이 중단될 수 있습니다.</p>
		</div>

		<!-- 문의 내역 테이블 및 1:1문의 버튼 -->
		<div class="header-mq">
			<div class="my-question">내 문의 내역</div>
			<button class="inquiry-btn" type="button"
				onclick="location.href='${pageContext.request.contextPath}/cs/inquiry'">1:1문의</button>
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
				<tr>
					<td>배송이 아직 오지 않았습니다. 확인 부탁드립니다.</td>
					<td>2025-07-17</td>
					<td>배송</td>
				</tr>
				<tr>
					<td>사이트 오류로 결제가 두 번 되었어요</td>
					<td>2025-07-16</td>
					<td>결제</td>
				</tr>
				<!-- 더 많은 문의가 여기에 들어갑니다 -->
			</tbody>
		</table>

		<!-- 자주묻는 질문은 Q1,A 슬라이드 토글식 -->
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