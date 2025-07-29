<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- JSTL c태그를 사용하기 위한 태그 라이브러리 (c:url 등 사용 시 필요) --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%-- 모바일 뷰 --%>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>communityList</title>
<link
	href="https://fonts.googleapis.com/css2?family=SUIT:wght@400;600;700&display=swap"
	rel="stylesheet">

<%-- communityList CSS 파일 --%>
<link
	href="${pageContext.request.contextPath}/resources/css/communityList.css"
	rel="stylesheet">

<%-- jQuery --%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>

	<div class="wrapper">
		<header class="header">
			<jsp:include page="/WEB-INF/views/common/Header.jsp" />
		</header>
	</div>
	<c:set var="contextPath" value="${pageContext.request.contextPath}" />
	<c:set var="url" value="${pageContext.request.contextPath}/community/list/${communityCode}?currentPage=" />
	<c:set var="searchParam" value="" />
	
	<div class="container">

		<!-- Sidebar -->
		<aside class="sidebar">
			<h3>정렬 조건</h3>
			<div class="filter">
				<p>
					<strong>지역</strong>
				</p>
				<label><input type="checkbox" name="region" value="서울특별시"> 서울특별시</label> 
				<label><input type="checkbox" name="region" value="경기도"> 경기도</label> 
				<label><input type="checkbox" name="region" value="인천"> 인천</label>

				<p>
					<strong>정렬순</strong>
				</p>
				<label><input type="radio" name="sort" value="latest" ${empty param.sort || param.sort == 'latest' ? 'checked' : ''}> 최신순</label> 
				<label><input type="radio" name="sort" value="views" ${param.sort == 'views' ? 'checked' : ''}>조회순</label> 
				<label><input type="radio" name="sort" value="likes" ${param.sort == 'likes' ? 'checked' : ''}>추천순</label>

				<p>
					<strong>카테고리</strong>
				</p>
				<label> <input type="checkbox" name="category" value="w"> 운동</label> 
				<label><input type="checkbox" name="category" value="a">문화/예술</label> 
				<label><input type="checkbox" name="category" value="g"> 취미/오락</label> 
				<label><input type="checkbox" name="category" value="p"> 반려동물</label> 
				<label><input type="checkbox" name="category" value="f"> 동네친구</label> 
				<label><input type="checkbox" name="category" value="s"> 자기계발/스터디</label> 
				<label><input type="checkbox" name="category" value="h"> 공포</label> 
				<label><input type="checkbox" name="category" value=""> 전체</label>

				<button id="applyFilterBtn">적용</button>
			</div>
		</aside>

		<!-- Main Content -->
		<main class="main-content">
			<div class="top-bar">
				<h2 class="content-title"> ❗ 
					<c:choose>
			            <%-- 선택된 카테고리가 있으면, 그 이름들을 출력 --%>
			            <c:when test="${not empty selectedCategories}">
			                <c:forEach var="catCode" items="${selectedCategories}" varStatus="status">
			                    ${applicationScope.communityTypeMap[catCode].communityName}
			                    <c:if test="${not status.last}"> · </c:if>
			                </c:forEach>
			            </c:when>
			            <%-- 선택된 카테고리가 없으면, 기본 카테고리 이름을 출력 --%>
			            <c:otherwise>
			                ${applicationScope.communityTypeMap[communityCode].communityName}
			            </c:otherwise>
			        </c:choose> 게시판 ❗ 
			    </h2>
			    

		        <div class="top-bar-buttons">
		            <button id="openListBtn">오픈채팅방 리스트</button>
		            <button id="writeBtn">글쓰기</button>
		        </div>
				
			</div>

			<table class="community-table">
				<thead>
					<tr>
						<th>번호</th>
						<th>제목</th>
						<th>글쓴이</th>
						<th>작성일</th>
						<th>조회수</th>
						<th>추천</th>
					</tr>
				</thead>
				

				<!--  게시글 리스트 추가 -->
				<tbody id="postList">
					<c:choose>
						<c:when test="${empty list}">
							<tr>
								<td colspan="6">게시글이 없습니다</td>
							</tr>
						</c:when>
						<c:otherwise>
							<c:forEach var="community" items="${list }">
								<tr onclick="movePage('${community.communityCd}', ${community.communityNo})">
									<td>${community.communityNo}</td>
									<td>${community.communityTitle }</td>
									<td>${community.communityNickname}</td>
									
									 <td><fmt:formatDate value="${community.writeDate}" pattern="yyyy-MM-dd HH:mm" /></td>
									<td>${community.views }</td>
									<!-- 조회수 -->
									<td>${community.recommendCount }</td>
									<!-- <td>추천수</td> -->
									<!-- 추천수 -->

								</tr>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</tbody>
			</table>
			<script>
            function movePage(cd, cno) {
            	location.href = "${pageContext.request.contextPath}/community/detail/" + cd + "/" + cno;
            }
        	</script>
			
			
			<div id="pagingArea">
			    <ul class="pagination">
			        <c:if test="${pi.currentPage > 1}">
			            <c:url var="prevUrl" value="/community/list/${communityCode}">
			                <c:param name="currentPage" value="${pi.currentPage - 1}" />
			                <c:if test="${not empty param.sort}"><c:param name="sort" value="${param.sort}" /></c:if>
			                <c:if test="${not empty param.category}"><c:param name="category" value="${param.category}" /></c:if>
			                <c:if test="${not empty param.keyword}"><c:param name="keyword" value="${param.keyword}" /></c:if>
			            </c:url>
			            <li class="page-item"><a class="page-link" href="${prevUrl}">◀</a></li>
			        </c:if> 
			
			        <c:forEach var="p" begin="${pi.startPage}" end="${pi.endPage}">
			            <c:url var="pageUrl" value="/community/list/${communityCode}">
			                <c:param name="currentPage" value="${p}" />
			                <c:if test="${not empty param.sort}"><c:param name="sort" value="${param.sort}" /></c:if>
			                <c:if test="${not empty param.category}"><c:param name="category" value="${param.category}" /></c:if>
			                <c:if test="${not empty param.keyword}"><c:param name="keyword" value="${param.keyword}" /></c:if>
			            </c:url>
			            <li class="page-item ${pi.currentPage eq p ? 'active' : ''}">
			                <a class="page-link" href="${pi.currentPage eq p ? '#' : pageUrl}">${p}</a>
			            </li>
			        </c:forEach>
			
			        <c:if test="${pi.currentPage < pi.maxPage}">
			            <c:url var="nextUrl" value="/community/list/${communityCode}">
			                <c:param name="currentPage" value="${pi.currentPage + 1}" />
			                <c:if test="${not empty param.sort}"><c:param name="sort" value="${param.sort}" /></c:if>
			                <c:if test="${not empty param.category}"><c:param name="category" value="${param.category}" /></c:if>
			                <c:if test="${not empty param.keyword}"><c:param name="keyword" value="${param.keyword}" /></c:if>
			            </c:url>
			            <li class="page-item"><a class="page-link" href="${nextUrl}">▶</a></li>
			        </c:if>
			    </ul>
			</div>

		</main>
	</div>

	<script>
    $(document).ready(function () {
    	const contextPath = "${pageContext.request.contextPath}";

        // [핵심 수정] 현재 페이지의 URL 경로에서 직접 communityCode를 추출합니다.
        // 예: /itda/community/list/all -> 'all' 추출
        const pathParts = window.location.pathname.split('/');
        //const communityCode = pathParts[pathParts.length - 1];
        
        const listIndex = pathParts.indexOf("list");
        const communityCode = pathParts[listIndex + 1]; 

        // 필터 적용 버튼 클릭 이벤트
        $('#applyFilterBtn').on('click', function() {
            const sort = $('input[name="sort"]:checked').val() || 'latest';
            
            const searchParams = new URLSearchParams();
            searchParams.append("sort", sort);

            $('input[name="category"]:checked').each(function() {
                searchParams.append("category", $(this).val());
            });

            $('input[name="region"]:checked').each(function() {
                searchParams.append("region", $(this).val());
            });

            // 이제 communityCode는 항상 현재 URL에서 가져오므로 절대 사라지지 않습니다.
            location.href = `${contextPath}/community/list/${communityCode}?` + searchParams.toString();
        });

        // 글쓰기 버튼 클릭 이벤트
        $('#writeBtn').on('click', function() {
            location.href = contextPath + `/community/insert`;
        });

        $('#openListBtn').click(() => {
            alert("오픈채팅방 리스트 연결");
        });
    });

</script>

</body>
</html>