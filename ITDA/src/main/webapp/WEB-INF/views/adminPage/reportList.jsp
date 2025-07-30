<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>신고 리스트</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/adminPage/reportList.css">
</head>
<body>
	<div class="report-container">
		<h2>신고 리스트</h2>
		<table class="report-table">
			<thead>
				<tr>
					<th>신고 번호</th>
					<th>제목</th>
					<th>신고일</th>
					<th>대상 유형</th>
					<th>처리 상태</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="report" items="${reportList}">
					<tr
						onclick="location.href='${pageContext.request.contextPath}/admin/reports/detail/${report.reportNum}'"
						style="cursor: pointer;">
						<td>${report.reportNum}</td>
						<td>${report.reason}</td>
						<td><fmt:formatDate value="${report.createdAt}"
								pattern="yyyy-MM-dd" /></td>
						<td>${report.type}</td>
						<td><c:choose>
								<c:when test="${report.status == 'N'}">접수</c:when>
								<c:when test="${report.status == 'P'}">처리중</c:when>
								<c:otherwise>완료</c:otherwise>
							</c:choose></td>
					</tr>
				</c:forEach>
			</tbody>
		</table>

		<!-- 페이지네이션 UI -->
		<div class="pagination">
			<c:if test="${currentPage > 1}">
				<a href="?page=${currentPage - 1}">이전</a>
			</c:if>

			<%
			int currentPage = (Integer) pageContext.getAttribute("currentPage");
			int totalPages = (Integer) pageContext.getAttribute("totalPages");
			int pageGroupSize = 10;
			int startPage = ((currentPage - 1) / pageGroupSize) * pageGroupSize + 1;
			int endPage = Math.min(startPage + pageGroupSize - 1, totalPages);
			%>

			<c:forEach var="i" begin="<%=startPage%>" end="<%=endPage%>">
				<c:choose>
					<c:when test="${i == currentPage}">
						<span class="current">${i}</span>
					</c:when>
					<c:otherwise>
						<a href="?page=${i}">${i}</a>
					</c:otherwise>
				</c:choose>
			</c:forEach>

			<c:if test="${currentPage < totalPages}">
				<a href="?page=${currentPage + 1}">다음</a>
			</c:if>

			<!-- 페이지 직접 입력 폼 -->
			<form action="" method="get" class="page-form">
				<label for="pageInput">페이지 이동:</label> <input type="number"
					id="pageInput" name="page" min="1" max="${totalPages}"
					value="${currentPage}" />
				<button type="submit">이동</button>
			</form>
		</div>
	</div>
</body>
</html>