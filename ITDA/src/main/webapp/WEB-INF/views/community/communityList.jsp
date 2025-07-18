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
<link href="${pageContext.request.contextPath}/resources/css/communityList.css"
	rel="stylesheet">

<%-- jQuery --%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<div class="container">


        <!-- 📌 Main Content -->
        <main class="main-content">
            <div class="top-bar">
                <button id="openListBtn">오픈채팅방 리스트</button>
                <button id="writeBtn">글쓰기</button>
            </div>

            <!-- 📝 게시글 목록 -->
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
                <tbody id="postList">
                    <!-- JS로 게시글 삽입 -->
                </tbody>
            </table>

            <!-- ⬅️ 페이지네이션 -->
            <div class="pagination" id="pagination"></div>

            <!-- 📝 글쓰기 폼 -->
            <!-- <section id="communityWrite" style="display: none;">
                <h3>글쓰기</h3>
                <input type="text" id="newTitle" placeholder="제목 입력" />
                <textarea id="newContent" placeholder="내용 입력"></textarea>
                <button id="submitPost">작성 완료</button>
                <button id="cancelWrite">취소</button>
            </section> -->
        </main>
    </div>
    
    <%-- communityList JavaScript 파일 불러오기--%>
	<script src="${pageContext.request.contextPath}/resources/js/communityList.js"></script>
</body>
</html>