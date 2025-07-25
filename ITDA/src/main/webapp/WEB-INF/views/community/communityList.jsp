<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- JSTL c태그를 사용하기 위한 태그 라이브러리 (c:url 등 사용 시 필요) --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
	<div class="container">

		<!-- Sidebar -->
		<aside class="sidebar">
			<h3>정렬 조건</h3>
			<div class="filter">
				<p>
					<strong>지역</strong>
				</p>
				<label><input type="checkbox" name="region" value="서울특별시">
					서울특별시</label> <label><input type="checkbox" name="region"
					value="경기도"> 경기도</label> <label><input type="checkbox"
					name="region" value="인천"> 인천</label>

				<p>
					<strong>정렬순</strong>
				</p>
				<label><input type="radio" name="sort" value="latest">
					최신순</label> <label><input type="radio" name="sort" value="views">
					조회순</label> <label><input type="radio" name="sort" value="likes">
					추천순</label>

				<p>
					<strong>카테고리</strong>
				</p>
				<label><input type="checkbox" name="category" value="w">
					운동</label> <label><input type="checkbox" name="category" value="a">
					문화/예술</label> <label><input type="checkbox" name="category"
					value="g"> 취미/오락</label> <label><input type="checkbox"
					name="category" value="p"> 반려동물</label> <label><input
					type="checkbox" name="category" value="f"> 동네친구</label> <label><input
					type="checkbox" name="category" value="s"> 자기계발/스터디</label> <label><input
					type="checkbox" name="category" value="h"> 공포</label> <label><input
					type="checkbox" name="category" value="all"> 전체</label>

				<button id="applyFilterBtn">적용</button>
			</div>
		</aside>

		<!-- Main Content -->
		<main class="main-content">
			<div class="top-bar">
				<button id="openListBtn">오픈채팅방 리스트</button>
				<!-- 오픈채팅방 연결필요 -->
				<button id="writeBtn">글쓰기</button>
				<!-- communityWrite와 연결 -->
			</div>

			<table class="community-table">
				<thead>
					<tr>
						<th>번호</th>
						<th>제목</th>
						<th>글쓴이</th>
						<th>작성일</th>
						<th>조회</th>
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
								<tr onclick="movePage(${community.communityNo})">
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
            function movePage(cno) {
                location.href = "${pageContext.request.contextPath}/community/detail/${communityCode}/"+cno
            }
        </script>


			<!-- 페이징바 : 학원꺼 -->
			<div id="pagingArea">
				<ul class="pagination">
					<c:if test="${pi.currentPage eq 1 }">
						<li class="page-item"><a class="page-link">◀</a></li>
					</c:if>
					<c:if test="${pi.currentPage ne 1 }">
						<li class="page-item"><a class="page-link"
							href="${url}${pi.currentPage -1}${searchParam}">◀</a></li>
					</c:if>

					<%-- <c:forEach var="i" begin="${pi.startPage }" end="${pi.endPage }">
						<li class="page-item ${i == pi.currentPage ? 'active' : ''}">
							<a class="page-link" href="${url}${i}${searchParam}">${i}</a>
						</li>
					</c:forEach> --%>
					<c:choose>
						<c:when test="${pi.maxPage == 1}">
							<li class="page-item active"><a class="page-link"
								href="${url}1${searchParam}">1</a></li>
						</c:when>
						<c:otherwise>
							<c:forEach var="i" begin="${pi.startPage}" end="${pi.endPage}">
								<li class="page-item ${i == pi.currentPage ? 'active' : ''}">
									<a class="page-link" href="${url}${i}${searchParam}">${i}</a>
								</li>
							</c:forEach>
						</c:otherwise>
					</c:choose>


					<c:if test="${pi.currentPage eq pi.maxPage }">
						<li class="page-item"><a class="page-link">▶</a></li>
					</c:if>
					<c:if test="${pi.currentPage ne pi.maxPage }">
						<li class="page-item"><a class="page-link"
							href="${url}${pi.currentPage +1}${searchParam}">▶</a></li>
					</c:if>
				</ul>
			</div>

		</main>
	</div>

	<script>
    $(document).ready(function () {
        const communityCode = "${param.communityCode}"; // Controller에서 받은 communityCode
		const contextPath = "${pageContext.request.contextPath}";
        // 필터 적용 버튼 클릭 이벤트
        $('#applyFilterBtn').on('click', function() {
            // 선택된 값들을 가져옵니다.
            const sort = $('input[name="sort"]:checked').val() || 'latest'; // 기본값 최신순
            
            const searchParams = new URLSearchParams();
            searchParams.append("sort", sort);
            
            // 체크된 카테고리들을 추가
            $('input[name="category"]:checked').each(function() {
                searchParams.append("category", $(this).val());
            });

            // 체크된 지역들을 추가
            $('input[name="region"]:checked').each(function() {
                searchParams.append("region", $(this).val());
            });

            // 완성된 URL로 페이지 이동 (페이지 번호는 1로 초기화)
            location.href = `/community/list/${communityCode}?` + searchParams.toString();
        });

        // 글쓰기 버튼 클릭 이벤트
        $('#writeBtn').on('click', function() {
        	
            location.href = contextPath + `/community/insert/${communityCode}`;
        });

        $('#openListBtn').click(() => {
            alert("오픈채팅방 리스트 연결");
        });
    });

</script>

</body>
</html>