<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>신고 상세</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/adminPage/reportDetail.css">
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
    <p><strong>신고 번호:</strong> ${report.reportNum}</p>
    <p><strong>신고 이유:</strong> ${report.reason}</p>
    <p><strong>신고일:</strong> <fmt:formatDate value="${report.createdAt}" pattern="yyyy-MM-dd HH:mm" /></p>
    <p><strong>대상 유형:</strong> ${report.type}</p>
    <p><strong>신고 대상 유저번호:</strong> ${report.userNum}</p>
    <p><strong>신고 대상 닉네임:</strong> ${report.targetName}</p>
    <p><strong>상태:</strong> 
        <c:choose>
            <c:when test="${report.status == '접수'}">접수</c:when>
            <c:when test="${report.status == '처리중'}">처리중</c:when>
            <c:otherwise>완료</c:otherwise>
        </c:choose>
    </p>
</div>
    
    <form method="post" action="${pageContext.request.contextPath}/admin/reports/updateStatus">
        <input type="hidden" name="reportNum" value="${report.reportNum}" />
        <label for="status">처리 상태 변경:</label>
        <select name="status" id="status">
            <option value="접수" ${report.status == '접수' ? 'selected' : ''}>접수</option>
            <option value="처리중" ${report.status == '처리중' ? 'selected' : ''}>처리중</option>
            <option value="완료" ${report.status == '완료' ? 'selected' : ''}>완료</option>
        </select>
        <button type="submit">저장</button>
    </form>

    <a href="${pageContext.request.contextPath}/admin/reports">← 신고 리스트로 돌아가기</a>
</div>
</body>
</html>