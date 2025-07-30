<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<title>신고하기</title>
	<link rel="stylesheet" href="/resources/css/reports.css" />
</head>
<body>

	<!-- 신고 모달 -->
	<div id="reportModal" class="modal-overlay" style="display: none;">
		<div class="modal-content">
			<h2>신고하기</h2>

			<p id="targetInfo" style="font-weight: bold; margin-bottom: 10px;"></p>

			<!-- Spring form:form 시작 -->
			<form:form id="reportForm" method="post" modelAttribute="report" action="/report/submit">

				<!-- 신고 타입 및 대상 ID -->
				<form:hidden path="reportType" id="reportType" />
				<form:hidden path="targetId" id="targetId" />

				<!-- 신고 사유 카테고리 -->
				<label for="category">신고 사유</label>
				<form:select path="category" required="required">
					<form:option value="" label="-- 신고 사유를 선택하세요 --" />
					<form:option value="욕설">욕설</form:option>
					<form:option value="음란물">음란물</form:option>
					<form:option value="도배">도배</form:option>
					<form:option value="기타">기타</form:option>
				</form:select>

				<br><br>

				<!-- 상세 사유 -->
				<div class="form-group">
					<label for="content">상세 사유</label>
					<form:textarea path="content" id="content" required="required" />
				</div>

				<!-- 버튼 -->
				<div class="modal-buttons">
					<button type="submit">제출</button>
					<button type="button" onclick="closeReportModal()">취소</button>
				</div>

			</form:form>
		</div>
	</div>

	<script src="reports.js"></script>
</body>
</html>