<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>신고 상세</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/adminPage/reportDetail.css">
</head>
<body>
	<c:if test="${not empty msg}">
		<script>
			alert('${msg}');
		</script>
	</c:if>
	<div class="report-detail-container">
		<h2>신고 상세 정보</h2>

		<div class="report-info">
			<p>
				<strong>신고 번호:</strong> ${report.reportNum}
			</p>
			<p>
				<strong>신고 이유:</strong> ${report.reason}
			</p>
			<p>
				<strong>신고일:</strong>
				<fmt:formatDate value="${report.createdAt}"
					pattern="yyyy-MM-dd HH:mm" />
			</p>
			<p>
				<strong>대상 유형:</strong> ${report.type}
			</p>
			<p>
				<strong>신고 대상 유저번호:</strong> ${report.userNum}
			</p>
			<p>
				<strong>신고 대상 닉네임:</strong> ${report.targetId}
			</p>
			<p>
				<strong>상태:</strong>
				<c:choose>
					<c:when test="${report.status == '접수'}">접수</c:when>
					<c:when test="${report.status == '처리중'}">처리중</c:when>
					<c:otherwise>완료</c:otherwise>
				</c:choose>
			</p>
		</div>

		<button type="button" class="ban-button" onclick="openBanModal()">제재
			처리하기</button>
		<div id="banModal" class="modal" style="display: none;">
			<div class="modal-content">
				<span class="close" onclick="closeBanModal()">&times;</span>
				<h3>제재 처리</h3>
				<form id="banForm" method="post"
					action="${pageContext.request.contextPath}/admin/banUser">
					<!-- 신고 번호 같이 넘기기 -->
					<input type="hidden" name="reportNum" value="${report.reportNum}" />

					<input type="hidden" name="userNum" value="${report.userNum}" /> <input
						type="hidden" name="penaltyDate" id="penaltyDate" />

					<!-- BanUser에는 필요 없지만 controller에서는 직접 꺼내쓸 것 -->
					<input type="hidden" name="status" value="완료" />

					<p>
						<strong>제재 사유:</strong>
					</p>
					<textarea name="reason" readonly>${report.reason}</textarea>
					<br />

					<p>
						<strong>제재 종료일:</strong>
					</p>
					<input type="date" name="releaseDate" required /><br />

					<p>
						<strong>제재 관리자:</strong>
					</p>
					<input type="text" name="adminUserName"
						value="${loginUser.nickName}" readonly /><br /> <input
						type="hidden" name="isBanned" value="Y" /> <br />
					<button type="submit">처리하기</button>
				</form>
			</div>
		</div>

		<form method="post"
			action="${pageContext.request.contextPath}/admin/reports/updateStatus">
			<input type="hidden" name="reportNum" value="${report.reportNum}" />
			<label for="status">처리 상태 변경:</label> <select name="status"
				id="status">
				<option value="접수"
					<c:if test="${report.status == '접수'}">selected</c:if>>접수</option>
				<option value="처리중"
					<c:if test="${report.status == '처리중'}">selected</c:if>>처리중</option>
				<option value="완료"
					<c:if test="${report.status == '완료'}">selected</c:if>>완료</option>
			</select>
			<button type="submit">저장</button>
		</form>

		<a href="${pageContext.request.contextPath}/admin/reports">← 신고
			리스트로 돌아가기</a>
	</div>

	<script>
		function openBanModal() {
			const today = new Date().toISOString().slice(0, 16); // yyyy-MM-ddTHH:mm
			document.getElementById('penaltyDate').value = today;
			document.getElementById('banModal').style.display = 'block';
		}
		function closeBanModal() {
			document.getElementById('banModal').style.display = 'none';
		}
	</script>
</body>
</html>