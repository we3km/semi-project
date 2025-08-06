<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>신고하기</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/report/reports.css" />
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>

	<!-- 신고 모달 -->
	<div id="reportModal" class="modal-overlay" style="display: none;">
		<div class="modal-content">
			<h2>신고하기</h2>

			<p id="targetInfo" style="font-weight: bold; margin-bottom: 10px;"></p>

			<!-- Spring form:form 시작 -->
			<form:form id="reportForm" method="post" modelAttribute="report"
				action="${pageContext.request.contextPath}/report/submit">

				<!-- 신고 타입 및 대상 닉네임 -->
				<form:hidden path="type" id="type" />
				<form:hidden path="targetId" id="targetId" />

				<!-- 신고 대상 작성자 userNum 추가 -->
				<form:hidden path="targetUserNum" id="targetUserNum" />

				<!-- 신고 사유 카테고리 -->
				<label for="reason">신고 사유</label>
				<form:select path="reason" id="reason" required="required">
					<form:option value="" label="-- 신고 사유를 선택하세요 --" />
				</form:select>

				<br>
				<br>

				<!-- 상세 사유 -->
				<div class="form-group">
					<label for="detailReason">상세 사유</label>
					<form:textarea path="detailReason" id="content" required="required" />
				</div>

				<!-- 버튼 -->
				<div class="modal-buttons">
					<button type="submit">제출</button>
					<button type="button" onclick="closeReportModal()">취소</button>
				</div>

			</form:form>
		</div>
	</div>

	<script src="${pageContext.request.contextPath}/resources/js/report/reports.js"></script>
</body>
</html>