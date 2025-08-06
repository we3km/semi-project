<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>신고 리스트</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/adminPage/reportList.css" />
</head>
<body>
	<div class="wrapper">
		<header class="header">
			<jsp:include page="/WEB-INF/views/common/Header.jsp" />
		</header>
	</div>
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
            <c:choose>
                <c:when test="${not empty reportList}">
                    <c:forEach var="report" items="${reportList}">
                        <tr onclick="location.href='${pageContext.request.contextPath}/admin/reports/detail/${report.reportNum}'" style="cursor:pointer;">
                            <td>${report.reportNum}</td>
                            <td>${report.reason}</td>
                            <td><fmt:formatDate value="${report.createdAt}" pattern="yyyy-MM-dd" /></td>
                            <td>${report.type}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${report.status == '접수'}">접수</c:when>
                                    <c:when test="${report.status == '처리중'}">처리중</c:when>
                                    <c:otherwise>완료</c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="5" style="text-align:center; font-style:italic; color:#888;">
                            신고 접수된 건이 없습니다.
                        </td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>

    <!-- 페이지네이션 -->
    <div id="pagingArea">
        <ul class="pagination">
            <!-- 이전 페이지 -->
            <c:if test="${pi.currentPage > 1}">
                <c:url var="prevUrl" value="/admin/reports">
                    <c:param name="currentPage" value="${pi.currentPage - 1}" />
                    <c:if test="${not empty param.sort}"><c:param name="sort" value="${param.sort}" /></c:if>
                    <c:if test="${not empty param.category}"><c:param name="category" value="${param.category}" /></c:if>
                    <c:if test="${not empty param.keyword}"><c:param name="keyword" value="${param.keyword}" /></c:if>
                </c:url>
                <li><a href="${prevUrl}">◀</a></li>
            </c:if>

            <!-- 페이지 번호 -->
            <c:forEach var="p" begin="${pi.startPage}" end="${pi.endPage}">
                <c:url var="pageUrl" value="/admin/reports">
                    <c:param name="currentPage" value="${p}" />
                    <c:if test="${not empty param.sort}"><c:param name="sort" value="${param.sort}" /></c:if>
                    <c:if test="${not empty param.category}"><c:param name="category" value="${param.category}" /></c:if>
                    <c:if test="${not empty param.keyword}"><c:param name="keyword" value="${param.keyword}" /></c:if>
                </c:url>
                <li class="${pi.currentPage == p ? 'active' : ''}">
                    <a href="${pi.currentPage == p ? '#' : pageUrl}">${p}</a>
                </li>
            </c:forEach>

            <c:if test="${pi.currentPage < pi.maxPage}">
                <c:url var="nextUrl" value="/admin/reports">
                    <c:param name="currentPage" value="${pi.currentPage + 1}" />
                    <c:if test="${not empty param.sort}"><c:param name="sort" value="${param.sort}" /></c:if>
                    <c:if test="${not empty param.category}"><c:param name="category" value="${param.category}" /></c:if>
                    <c:if test="${not empty param.keyword}"><c:param name="keyword" value="${param.keyword}" /></c:if>
                </c:url>
                <li><a href="${nextUrl}">▶</a></li>
            </c:if>
        </ul>
    </div>
</div>
</body>
</html>