<!-- <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%> -->
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
                <span class="label">제목:</span>
                <span class="value">${inquiry.csTitle}</span>
            </div>

            <div class="detail-row">
                <span class="label">작성자 닉네임:</span>
                <span class="value">${inquiry.nickName}</span>
            </div>

            <div class="detail-row">
                <span class="label">작성일:</span>
                <span class="value"><fmt:formatDate value="${inquiry.csDate}" pattern="yyyy-MM-dd HH:mm:ss"/></span>
            </div>

            <div class="detail-row">
                <span class="label">카테고리:</span>
                <span class="value">${inquiry.categoryName}</span>
            </div>

            <div class="detail-row content-row">
                <span class="label">내용:</span>
                <div class="value content">${inquiry.csContent}</div>
            </div>

            <c:if test="${not empty inquiry.fileName}">
                <div class="detail-row">
                    <span class="label">첨부파일:</span>
                    <a href="${pageContext.request.contextPath}/uploads/${inquiry.fileName}" target="_blank">${inquiry.fileName}</a>
                </div>
            </c:if>
        </div>

        <!-- 답변 및 상태 수정 폼 (관리자만 보이도록 처리 가능) -->
        <c:if test="${isAdmin}">
            <form method="post" action="${pageContext.request.contextPath}/cs/inquiry/reply">
                <input type="hidden" name="csNum" value="${inquiry.csNum}" />
                <label for="csReply">답변 작성:</label><br />
                <textarea id="csReply" name="csReply" rows="5" cols="60">${inquiry.csReply}</textarea><br />
                <button type="submit">답변 저장</button>
            </form>

            <form method="post" action="${pageContext.request.contextPath}/cs/inquiry/updateStatus" style="margin-top: 1em;">
                <input type="hidden" name="csNum" value="${inquiry.csNum}" />
                <label for="csStatus">상태 변경:</label>
                <select id="csStatus" name="csStatus">
                    <option value="처리중" ${inquiry.csStatus == '처리중' ? 'selected' : ''}>처리중</option>
                    <option value="처리완료" ${inquiry.csStatus == '처리완료' ? 'selected' : ''}>처리완료</option>
                    <option value="대기" ${inquiry.csStatus == '대기' ? 'selected' : ''}>접수중</option>
                </select>
                <button type="submit">상태 변경</button>
            </form>
        </c:if>

        <button onclick="history.back()" class="back-btn">목록으로 돌아가기</button>
    </div>
</body>
</html>