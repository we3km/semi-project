<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>문의글 상세조회</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/cs_service/inquiryDetail.css" />
</head>
<body>
	<div class="container">
		<h1>문의글 상세조회</h1>
		<div class="inquiry-detail">
			<div class="detail-row">
				<span class="label">제목:</span> <span class="value">${inquiry.csTitle}</span>
			</div>
			<div class="detail-row">
				<span class="label">작성자 닉네임:</span> <span class="value">${inquiry.nickName}</span>
			</div>
			<div class="detail-row">
				<span class="label">작성일:</span> <span class="value"><fmt:formatDate
						value="${inquiry.csDate}" pattern="yyyy-MM-dd HH:mm:ss" /></span>
			</div>
			<div class="detail-row">
				<span class="label">카테고리:</span> <span class="value">${inquiry.categoryName}</span>
			</div>
			<div class="detail-row">
				<span class="label">처리 상태:</span>
				<span class="value">${inquiry.status}</span>
			</div>
			<c:if test="${not empty inquiry.csReplyDate}">
				<div class="detail-row">
					<span class="label">답변 날짜:</span> <span class="value"><fmt:formatDate
							value="${inquiry.csReplyDate}" pattern="yyyy-MM-dd HH:mm:ss" /></span>
				</div>
			</c:if>
			<div class="detail-row content-row">
				<span class="label">내용:</span>
				<div class="value content">${inquiry.csContent}</div>
			</div>
			<c:forEach var="item" items="${fileWithPathList}">
				<c:set var="file" value="${item.file}" />
				<c:set var="filePath" value="${item.filePath}" />
				<a
					href="${pageContext.request.contextPath}/${filePath}/${file.fileName}"
					target="_blank"> <img
					src="${pageContext.request.contextPath}/${filePath}/${file.fileName}"
					alt="${file.fileName}" />
				</a>
			</c:forEach>
			
			<br>
			<br>
			<br>
			<sec:authorize access="!hasRole('ROLE_ADMIN')">
				<c:if test="${not empty inquiry.csReply}">
					<div class="detail-row content-row">
						<span class="label">답변:</span>
						<div class="value content">${inquiry.csReply}</div>
					</div>
				</c:if>
			</sec:authorize>
		</div>
		<sec:authorize access="hasRole('ROLE_ADMIN')">
			<form id="replyForm" method="post"
				action="${pageContext.request.contextPath}/cs/inquiry/replyAndComplete">
				<input type="hidden" name="csNum" value="${inquiry.csNum}" /> <label
					for="csReply">답변 작성:</label><br />
				<textarea id="csReply" name="csReply" rows="30" cols="60">${inquiry.csReply}</textarea>
				<br />
				<c:if test="${not empty successMsg}">
					<script>
						alert("${successMsg}");
					</script>
				</c:if>
				<c:if test="${not empty errorMsg}">
					<script>
						alert('${errorMsg}');
						// 에러시 추가 동작 (필요하면)
					</script>
				</c:if>
				<button type="submit">답변하기</button>
			</form>
		</sec:authorize>
		<button onclick="location.href='/itda/cs'" class="back-btn">목록으로
			돌아가기</button>
	</div>
</body>
</html>