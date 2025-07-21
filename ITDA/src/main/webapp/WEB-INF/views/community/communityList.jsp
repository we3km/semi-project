<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- JSTL c태그를 사용하기 위한 태그 라이브러리 (c:url 등 사용 시 필요) --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
	<div class="container">
		<jsp:include page="/WEB-INF/views/common/Header.jsp" />

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
					type="checkbox" name="category" value="h"> 공포</label>
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
									<td>${community.communityWriter}</td>
									<td>${community.createDate }</td>
									<td>${community.count }</td>
									<!-- 조회수 -->
									<td>${community.recommendCount }</td>
									<!-- 추천수 -->

								</tr>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</tbody>

			</table>
			<script>
            function movePage(cno) {
                location.href = "${contextPath}/community/detail/${communityCode}/"+cno
            }
        </script>

			<!-- 페이징바 : 원래 작성했던거-->
			<!--      <div class="pagination" id="pagination"></div>		 -->

			<!-- 페이징바 : 학원꺼 -->
			<div id="pagingArea">
				<ul class="pagination">
					<c:if test="${pi.currentPage eq 1 }">
						<li class="page-item"><a class="page-link">Previous</a></li>
					</c:if>
					<c:if test="${pi.currentPage ne 1 }">
						<li class="page-item"><a class="page-link"
							href="${url}${pi.currentPage -1}${searchParam}">Previous</a></li>
					</c:if>

					<c:forEach var="i" begin="${pi.startPage }" end="${pi.endPage }">
						<li class="page-item"><a class="page-link"
							href="${url}${i}${searchParam}">${i}</a></li>
					</c:forEach>

					<c:if test="${pi.currentPage eq pi.maxPage }">
						<li class="page-item"><a class="page-link">Next</a></li>
					</c:if>
					<c:if test="${pi.currentPage ne pi.maxPage }">
						<li class="page-item"><a class="page-link"
							href="${url}${pi.currentPage +1}${searchParam}">Next</a></li>
					</c:if>
				</ul>
			</div>

		</main>
	</div>

	<script>
    $(document).ready(function () {
        // 더미 게시글 데이터
        const posts = Array.from({ length: 50 }, (_, i) => ({
          id: i + 1,
          title: `게시글 제목 ${i + 1}`,
          writer: 'windsky01',
          date: '25.07.09 13:45',
          views: Math.floor(Math.random() * 1000),
          likes: Math.floor(Math.random() * 100),
          region: ['서울특별시', '경기도', '인천'][i % 3],
          category: ['운동', '문화/예술', '동네친구'][i % 3],
        }));

        let currentPage = 1;
        const postsPerPage = 10;

        function getFilteredPosts() {
          const selectedRegions = $('input[name="region"]:checked').map((_, el) => el.value).get();
          const selectedCategories = $('input[name="category"]:checked').map((_, el) => el.value).get();
          const sortBy = $('input[name="sort"]:checked').val();

          let filtered = posts.slice();

          if (selectedRegions.length > 0) {
            filtered = filtered.filter(p => selectedRegions.includes(p.region));
          }

          if (selectedCategories.length > 0) {
            filtered = filtered.filter(p => selectedCategories.includes(p.category));
          }

          if (sortBy === 'views') {
            filtered.sort((a, b) => b.views - a.views);
          } else if (sortBy === 'likes') {
            filtered.sort((a, b) => b.likes - a.likes);
          } else {
            filtered.sort((a, b) => b.id - a.id); // 최신순은 id 기준
          }

          return filtered;
        }

        function renderPosts(page = 1) {
          const filteredPosts = getFilteredPosts();
          const start = (page - 1) * postsPerPage;
          const end = start + postsPerPage;
          const pagePosts = filteredPosts.slice(start, end);

          $('#postList').empty();
          pagePosts.forEach(post => {
            $('#postList').append(`
              <tr class="post-row" data-id="${post.id}">
                <td>${post.id}</td>
                <td>${post.title}</td>
                <td>${post.writer}</td>
                <td>${post.date}</td>
                <td>${post.views}</td>
                <td>${post.likes}</td>
              </tr>
            `);
          });

          renderPagination(filteredPosts.length);
        }

        function renderPagination(totalPosts) {
          const totalPages = Math.ceil(totalPosts / postsPerPage);
          $('#pagination').empty();
          for (let i = 1; i <= totalPages; i++) {
            $('#pagination').append(`<span class="page-btn ${i === currentPage ? 'active' : ''}" data-page="${i}">${i}</span>`);
          }
        }

        $(document).on('click', '.page-btn', function () {
          currentPage = parseInt($(this).data('page'));
          renderPosts(currentPage);
        });

      //   // 필터 변경 시 렌더링
      //   $('input[name="region"], input[name="sort"], input[name="category"]').on('change', function () {
      //     currentPage = 1;
      //     renderPosts(currentPage);
      //   });
        //필터 변경시 적용
        $('#applyFilterBtn').on('click',function(){
          currentPage = 1;
          renderPosts(currentPage);
        })

        // 초기 렌더링
        renderPosts(currentPage);

        $('#openListBtn').click(() => {
          alert("오픈채팅방 리스트 연결");
        });
      });
    </script>
</body>
</html>