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

	<!-- 사용 방법 예시 -->
	<!-- <button onclick="openReportModal('USER', 789, '사용자명')">사용자 신고</button>  -->
	<!-- <button onclick="openReportModal('BOARD', 789, '게시글 제목')">게시판 신고</button>  -->
	<!-- <button onclick="openReportModal('COMMENT', 789, '댓글 작성자명')">댓글 신고</button>  -->
	<!-- <button onclick="openReportModal('OPENCHAT', 789, '오픈채팅방 이름')">오픈채팅 신고</button> -->

	<!-- 신고 모달 -->
	<div id="reportModal" class="modal-overlay" style="display: none;">
		<div class="modal-content">
			<h2>신고하기</h2>

			<!-- 신고 대상 이름 표시 -->
			<p id="targetInfo" style="font-weight: bold; margin-bottom: 10px;"></p>

			<form id="reportForm">
				<input type="hidden" id="reportType" name="reportType">
				<input type="hidden" id="targetId" name="targetId">

				<!-- 신고 사유 카테고리  -->
				<label for="category">신고 사유</label>
				<select name="category" required>
					<option value="">-- 신고 사유를 선택하세요 --</option>
				</select>
				<br><br>

				<!-- 상세 사유 작성란 -->
				<div class="form-group">
					<label for="content">상세 사유</label>
					<textarea id="content" name="content" required></textarea>
				</div>

				<!-- 제출 버튼 -->
				<div class="modal-buttons">
					<button type="submit">제출</button>
					<button type="button" onclick="closeReportModal()">취소</button>
				</div>
			</form>
		</div>
	</div>

	<!-- 🔗 JS 연결 -->
	<script src="reports.js"></script>
</body>

</html>