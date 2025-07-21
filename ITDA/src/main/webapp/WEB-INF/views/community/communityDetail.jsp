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
<title>communityDetail</title>
<link
	href="https://fonts.googleapis.com/css2?family=SUIT:wght@400;600;700&display=swap"
	rel="stylesheet">

<%-- communityDatil CSS 파일 --%>
<link href="${pageContext.request.contextPath}/resources/css/communityDetail.css"
	rel="stylesheet">

<%-- jQuery --%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
	<div class="container">
        <!-- 카테고리 + 제목 -->
        <div class="top-row">
            <div class="category">공포이야기</div>
            <div class="separator">|</div>
            <div class="post-title">모르는 번호 공포썰</div>
        </div>

        <!-- 게시글 정보 -->
        <!--작성자, 작성일, 조회수, 추천수, 댓글수-->
        <div class="meta-row">
            <div class="left">작성자 익명 · 작성일 23.07.09 13:45</div>
            <div class="right">
                <span>조회수 305</span>
                <span>추천 <span id="recommendCount">0</span></span>
                <span class="red">댓글 <span id="commentCount">0</span></span>
            </div>
        </div>
        <hr>

        <!-- 공유 + 신고하기 버튼-->
        <div class="post-actions">
            <button class="share-btn">공유</button>
            <button class="report-btn">신고하기</button>

            <div class="share-popup" id="sharePopup">
                <input type="text" id="shareUrl" readonly value="https://example.com/post/123">
                <button onclick="copyUrl()">복사</button>
            </div>
        </div>

        <!-- 게시글 내용 -->
        <div class="post-content">
            첫 번째 메시지는 전화 받지 말랍니다.
            두 번째는 이 번호가 너를 따라다닌답니다.
            세 번째는...

            '앗아..수신자?'
        </div>

        <!-- 게시글 좋아요/싫어요 -->
        <div class="vote-buttons">
            <button id="likeBtn"><img src="../img/like.png" alt="likeBtn" height="40px"><span
                    id="likeCount">0</span></button>
            <button id="dislikeBtn"><img src="../img/dislike.png" alt="dislikeBtn" height="40px"><span
                    id="dislikeCount">0</span></button>
        </div>

        <hr>

        <!-- 댓글 리스트 상단 탭 영역 추가 -->
        <div class="comment-list-header">
            <div class="total-comments">전체 댓글 <span class="red" id="commentCountDisplay">0</span>개</div>
            <div class="tabs">
                <div class="active">등록순</div>
                <div>최신순</div>
                <div>답글순</div>
            </div>
        </div>

        <!-- 댓글 입력 부분 변경 -->
        <div class="comment-input">
            <div class="profile-icon"></div>
            <input id="commentText" type="text" placeholder="댓글 추가..." />
            <button id="addComment">등록</button>
        </div>

        <!-- 댓글 리스트 영역 추가 -->
        <div id="commentList"></div>
    </div>
    <%-- communityDetail JavaScript 파일 불러오기--%>
	<script src="${pageContext.request.contextPath}/resources/js/communityDetail.js"></script>

</body>
</html>