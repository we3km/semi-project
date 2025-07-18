<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8">
<title>신고하기</title>

<!-- 🔗 CSS 연결 -->
<link rel="stylesheet" href="/resources/css/reports.css" />
</head>

<body>

	<!-- 신고 팝업 버튼 -->
	<button onclick="openReportModal('BOARD', 123)">신고하기</button>

	<!-- 신고 모달 -->
	<div id="reportModal" class="modal-overlay" style="display: none;">
		<div class="modal-content">
			<h2>신고하기</h2>
			<form id="reportForm">
				<input type="hidden" id="reportType" name="reportType"> <input
					type="hidden" id="targetId" name="targetId">
				<!-- 신고 사유 카테고리  -->
				<label for="category">신고 사유</label> <select name="category" required>
					<option value="허위 정보">허위 정보</option>
					<option value="욕설">욕설</option>
					<option value="사기">사기</option>
					<option value="음란">음란</option>
					<option value="부적절한 게시물">부적절한 게시물</option>
				</select> <br>
				<br>
				<!-- 상세 사유 작성란 -->
				<div class="form-group">
					<label for="content">상세 사유</label>
					<textarea id="content" name="content" required></textarea>
				</div>

				<!-- 제출 버튼 -->
				<div class="modal-buttons">
					<button type="submit">제출</button>
					<!-- 모달 취소 버튼 (모달 사라짐)-->
					<button type="button" onclick="closeReportModal()">취소</button>
				</div>
			</form>
		</div>
	</div>

	<!-- 🔗 JS 연결 -->
	<script src="reports.js"></script>
</body>

</html>