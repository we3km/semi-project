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
				
				<label>
					<input type="checkbox" name="category" value="all"
					<c:if test="${empty param.category}">checked</c:if>
					    <c:forEach var="c" items="${paramValues.category}">
					        <c:if test="${c == ''}">checked</c:if>
					    </c:forEach>> 전체
				</label>
				<label> 
					<input type="checkbox" name="category" value="w" 
						<c:forEach var="c" items="${paramValues.category}">
					      <c:if test="${c == 'w'}">checked</c:if>
					    </c:forEach>	
					> 운동
				</label> 
				
				<label>
					<input type="checkbox" name="category" value="a"
						<c:forEach var="c" items="${paramValues.category}">
					      <c:if test="${c == 'a'}">checked</c:if>
					    </c:forEach>	
					>문화/예술
				</label> 
				
				<label>
					<input type="checkbox" name="category" value="g" 
						<c:forEach var="c" items="${paramValues.category}">
					      <c:if test="${c == 'g'}">checked</c:if>
					    </c:forEach>
					> 취미/오락
				</label> 
				
				<label>
					<input type="checkbox" name="category" value="p"
						<c:forEach var="c" items="${paramValues.category}">
					      <c:if test="${c == 'p'}">checked</c:if>
					    </c:forEach>
					 > 반려동물
				</label> 
				
				<label>
					<input type="checkbox" name="category" value="f"
						<c:forEach var="c" items="${paramValues.category}">
					      <c:if test="${c == 'f'}">checked</c:if>
					    </c:forEach>
					> 동네친구
				</label> 
				
				<label>
					<input type="checkbox" name="category" value="s"
						<c:forEach var="c" items="${paramValues.category}">
					      <c:if test="${c == 's'}">checked</c:if>
					    </c:forEach>
					> 자기계발/스터디
				</label> 
				
				<label>
					<input type="checkbox" name="category" value="h"
						<c:forEach var="c" items="${paramValues.category}">
					      <c:if test="${c == 'h'}">checked</c:if>
					    </c:forEach>
					> 공포
				</label> 
				
				

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

        // 현재 페이지의 URL 경로에서 직접 communityCode를 추출합니다.
        // 예: /itda/community/list/all -> 'all' 추출
        const pathParts = window.location.pathname.split('/');
        //const communityCode = pathParts[pathParts.length - 1];
        
        const listIndex = pathParts.indexOf("list");
        const communityCode = pathParts[listIndex + 1]; 
        
        //전체 체크
         $('input[name="category"][value="all"]').on('change', function() {
            const isChecked = $(this).is(':checked');
            $('input[name="category"]').not('[value="all"]').prop('checked', isChecked);
        });

        // 전체 언체크
        $('input[name="category"]').not('[value="all"]').on('change', function() {
            const total = $('input[name="category"]').not('[value="all"]').length;
            const checked = $('input[name="category"]:checked').not('[value="all"]').length;
            $('input[name="category"][value="all"]').prop('checked', total === checked);
        });

        // 필터 적용 버튼 클릭 이벤트
        $('#applyFilterBtn').on('click', function() {
            const sort = $('input[name="sort"]:checked').val() || 'latest';
            const $allCheckbox = $('input[name="category"][value="all"]');

            // '전체'가 선택되었거나, 아무 카테고리도 선택되지 않았을 경우
            if ($allCheckbox.is(':checked') || $('input[name="category"]:checked').length === 0) {
                // [핵심 수정] sort 파라미터 없이 /community/list/all 로만 이동합니다.
                location.href = contextPath + '/community/list/all';
                return; // 함수 종료
            }

            // '전체'가 아닌 다른 카테고리들이 선택된 경우
            const searchParams = new URLSearchParams();
            searchParams.append("sort", sort);

            $('input[name="category"]:checked').not('[value="all"]').each(function() {
                searchParams.append("category", $(this).val());
            });

            location.href = contextPath + '/community/list/all?' + searchParams.toString();
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