<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- JSTL c태그를 사용하기 위한 태그 라이브러리 (c:url 등 사용 시 필요) --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
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
	<div class="wrapper">
		<header class="header">
			<jsp:include page="/WEB-INF/views/common/Header.jsp" />
		</header>
	</div>
	<div class="container">
        <!-- 카테고리 + 제목 -->
        <div class="top-row">
            <div class="category">${community.communityCdName}</div>
            <div class="separator">|</div>
            <div class="post-title">${community.communityTitle }</div>
        </div>

        <!-- 게시글 정보 -->
        <!--작성자, 작성일, 조회수, 추천수, 댓글수-->
        <div class="meta-row">
            <div class="left">작성자 ${community.communityNickname} · 작성일 <fmt:formatDate value="${community.writeDate }" pattern="yyyy-MM-dd HH:mm" /></div>
            <div class="right">
                <span>조회수 <span id="views">${community.views}</span> </span>
                <span>추천 <span id="recommendCount"> ${community.recommendCount} </span></span>
                <span class="red">댓글 <span id="commentCount"> ${community.commentCount }</span></span>
            </div>
        </div>
        <hr>

        <!-- 공유 + 신고하기 버튼-->
        <div class="post-actions">
            <button class="share-btn">공유</button>
            <button class="report-btn">신고하기</button>
				<%
				    String currentURL = request.getRequestURL().toString();
				    String queryString = request.getQueryString();
				    if(queryString != null) {
				        currentURL += "?" + queryString;
				    }
				%>
            <div class="share-popup" id="sharePopup">
                <input type="text" id="shareUrl" readonly value="<%= currentURL %>">
                <button onclick="copyUrl()">복사</button>
            </div>
        </div>

        <!-- 게시글 내용 -->
        <div class="post-content">
            ${community.communityContent}
        </div>
        
       	<!-- 게시글 이미지 -->
        <div class="post-img">
        </div>

        <div class="vote-buttons">
		    <!-- 좋아요 버튼 -->
		    <button type="button" id="likeBtn" data-type="LIKE">
		        <img src="${pageContext.request.contextPath}/resources/images/like.png" 
		             alt="likeBtn" height="40px">
		        <span id="likeCount">${community.recommendCount}</span>
		    </button>
		
		    <!-- 싫어요 버튼 -->
		    <button type="button" id="dislikeBtn" data-type="DISLIKE">
		        <img src="${pageContext.request.contextPath}/resources/images/dislike.png"
		             alt="dislikeBtn" height="40px">
		        <span id="dislikeCount">${community.recommendDiscount}</span>
		    </button>
		</div>
		<script>
		const userReaction = "${userReaction}";
	    const communityNo = "${community.communityNo}";
	    const communityCd = "${communityCd}";
		
		console.log("userReaction:", userReaction);
		
	    $(document).ready(function(){
	    	//이미지 초기설정
	    	 if (userReaction === 'LIKE') {
	            $('#likeBtn img').attr('src', '${pageContext.request.contextPath}/resources/images/like_clike.png');
	            $('#dislikeBtn img').attr('src', '${pageContext.request.contextPath}/resources/images/dislike.png');
	        } else if (userReaction === 'DISLIKE') {
	            $('#likeBtn img').attr('src', '${pageContext.request.contextPath}/resources/images/like.png');
	            $('#dislikeBtn img').attr('src', '${pageContext.request.contextPath}/resources/images/dislike_click.png');
	        } else {
	            $('#likeBtn img').attr('src', '${pageContext.request.contextPath}/resources/images/like.png');
	            $('#dislikeBtn img').attr('src', '${pageContext.request.contextPath}/resources/images/dislike.png');
	        }
	    	
	    	//버튼클릭
			 $('#likeBtn').click(function () {
			        sendReaction("LIKE");
			    });
	
			    $('#dislikeBtn').click(function () {
			        sendReaction("DISLIKE");
			    });
	    });
	    

		    function sendReaction(type) {
		        $.ajax({
		            type: "POST",
		            url: "${pageContext.request.contextPath}/community/react",
		            contentType: "application/json",
		            data: JSON.stringify({
		                communityNo: ${community.communityNo},
		                communityCd: "${communityCd}",
		                type: type
		            }),
		            success: function (res) {
		                // 추천 수 업데이트
		                $('#likeCount').text(res.likeCount);
		                $('#dislikeCount').text(res.dislikeCount);
						$("#recommendCount").text(res.likeCount);
		                // 이미지 변경
		                if (res.userReaction === 'LIKE') {
		                    $('#likeBtn img').attr('src', '${pageContext.request.contextPath}/resources/images/like_clike.png');
		                    $('#dislikeBtn img').attr('src', '${pageContext.request.contextPath}/resources/images/dislike.png');
		                } else if (res.userReaction === 'DISLIKE') {
		                    $('#likeBtn img').attr('src', '${pageContext.request.contextPath}/resources/images/like.png');
		                    $('#dislikeBtn img').attr('src', '${pageContext.request.contextPath}/resources/images/dislike_click.png');
		                } else {
		                    // 취소된 경우
		                    $('#likeBtn img').attr('src', '${pageContext.request.contextPath}/resources/images/like.png');
		                    $('#dislikeBtn img').attr('src', '${pageContext.request.contextPath}/resources/images/dislike.png');
		                }
		            },
		            error: function () {
		                alert("처리 중 오류가 발생했습니다.");
		            }
		        });
		    }
		</script>

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

        <!-- 댓글 입력 부분 변경-->
        <div class="comment-input">
            <div class="profile-icon"></div>
            <input id="commentText" type="text" placeholder="댓글 추가..." />
            <button id="addComment">등록</button>
        </div> 

        <!-- 댓글 리스트 영역 추가-->
        <div id="commentList"></div> 
    </div>
    
    
    <%-- communityDetail JavaScript 파일 불러오기--%>
	<%-- <script src="${pageContext.request.contextPath}/resources/js/communityDetail.js"></script> --%>
	

</body>
</html>