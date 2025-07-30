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
<link rel="icon" href="${pageContext.request.contextPath}/resources/images/favicon.ico" type="image/x-icon">
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
            <div class="separator">|</div>
            <div class="tag-display-area">
		    <c:if test="${not empty community.tags}">
			        <c:forEach var="tag" items="${community.tags}">
			            <span class="tag-item" >#${tag.tagContent}</span>
			        </c:forEach>
			    </c:if>
			</div>      
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

        <!-- 공유 + 신고하기 + 삭제 버튼-->
        <div class="post-actions">
            <button class="share-btn">공유</button>
            <button class="report-btn">신고하기</button>
            <button class="sub-btn">︙</button>
            <div class="share-popup" id="sharePopup">
                <input type="text" id="shareUrl" readonly >
                <button onclick="copyUrl()" id="copy">복사</button>
            </div>
            
            <div id="deleteToggleArea" class="delete-menu hidden">
				<form id="deleteForm" method="post" action="${pageContext.request.contextPath}/community/delete">
			        <input type="hidden" name="communityNo" value="${community.communityNo}" />
			        <button type="submit" class="delete-btn">삭제하기</button>
			    </form>
			</div>
        </div>

        <!-- 게시글 내용 -->
        <div class="post-content">
            ${community.communityContent}
        </div>
        
       	<!-- 게시글 이미지 -->
        <div class="post-img">
	        <c:if test="${not empty community.imgList}">
		        <c:forEach var="img" items="${community.imgList}">
		            <%-- 
		                Utils.saveFile에서 저장한 경로와 맞춰주어야 합니다.
		                예시: /resources/uploads/커뮤니티코드/파일명
		            --%>
		            <img src="${pageContext.request.contextPath}/resources/images/community/${community.communityCd }/${img.changeName}">
		        </c:forEach>
		    </c:if>
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
    
    
		<script>
		const userReaction = "${userReaction}";
	    const communityNo = "${community.communityNo}";
	    const communityCd = "${communityCd}";
		
	    $(document).ready(function(){
	    	//댓글목록 불러오기
	    	selectCommentList();
	    	
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
			    
			  //url 복사 함수
			    $('.share-btn').click(function () {
		            $('#sharePopup').toggle();         
		        });
			  //신고하기
			   $('.report-btn').click(function(){
				    /* openReportModal('community', ${communityNo}, "${community.communityTitle}"); */
				    alert('신고 모달창');
				});
			 // 복사 버튼 클릭
			 	$('#shareUrl').val(window.location.href);
			 
				$('#copy').click(function () {
					const $urlInput = $('#shareUrl');
					$urlInput.prop('readonly', false); // 복사 위해 잠깐 활성화
					$urlInput.select();
					document.execCommand('copy');
					$urlInput.prop('readonly', true); // 다시 readonly로 복구
					alert('URL이 복사되었습니다!');
				});
				// sub-btn 클릭 → 삭제 버튼 토글
				$('.sub-btn').click(function () {
					$('#deleteToggleArea').toggle();
				});
				$('#deleteForm').on('submit',function(e){
					if(!confirm('정말로 이 게시글을 삭제하시겠습니까?')){
						e.preventDefault();
					}
				});
		    
	    });
	    
			// 좋아요·싫어요 보내기
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
			
			//댓글 목록 조회
		    function selectCommentList() {
		        $.ajax({
		            url: "${pageContext.request.contextPath}/community/comments/" + communityNo,
		            type: "GET",
		            dataType: "json",
		            success: function(commentTree) { // 서버로부터 계층형 댓글 목록(List<BoardCommentExt>)을 받음
		            	 console.log("서버로부터 받은 댓글 목록:", commentTree);
		            	
		            	
		                const $commentListDiv = $('#commentList');
		                $commentListDiv.empty(); // 기존 목록을 비움

		                if (commentTree && commentTree.length > 0) {
		                    let totalComments = 0;
		                    commentTree.forEach(c => { // 답글까지 포함하여 전체 댓글 수 계산
		                        totalComments++;
		                        if (c.replies) {
		                            totalComments += c.replies.length;
		                        }
		                    });
		                    $('#commentCount, #commentCountDisplay').text(totalComments);

		                    // 댓글 목록 HTML 생성 및 추가
		                    $.each(commentTree, function(index, comment) {
		                        $commentListDiv.append(createCommentHtml(comment));
		                    });
		                } else {
		                    $('#commentCount, #commentCountDisplay').text(0);
		                    $commentListDiv.append('<div class="comment-empty">작성된 댓글이 없습니다.</div>');
		                }
		            },
		            error: function() { console.log("댓글 목록 조회에 실패했습니다."); }
		        });
		    }
		    
		    // 댓글 객체를 받아 HTML 문자열을 생성하는 함수 (재귀 호출로 답글까지 처리)
		    /* function createCommentHtml(comment) {
		        let repliesHtml = '';
		        // 답글(replies)이 있으면 재귀적으로 이 함수를 다시 호출하여 답글 HTML을 생성
		        if (comment.replies && comment.replies.length > 0) {
		            $.each(comment.replies, function(index, reply) {
		                repliesHtml += createCommentHtml(reply);
		            });
		        }
		        
		        // 날짜 포맷 변경 (yyyy. MM. dd.)
		        const writeDate = new Date(comment.cmtWriteDate).toLocaleDateString('ko-KR');
		        
		        let replyBtnHtml = '';
		        
		        if (comment.refCommentId=== 0) {
		            replyBtnHtml = `<span class="reply-toggle-btn" data-comment-no="${comment.boardCmtId }">답글</span>`;
		        }
		        console.log(" 댓글 :", comment);

		        // 각 댓글의 HTML 구조
		        const commentHtml = `
		        	 <div class="comment ${comment.refCommentId > 0 ? 'reply' : ''}">
		            <div class="profile-icon"></div>
		            <div class="content">
		                <div class="author">${comment.nickName}</div>
		                <div class="text">${comment.boardCmtContent}</div>
		                <div class="actions">
		                    <span>${writeDate}</span>
		                    ${replyBtnHtml}  
		                </div>
		                <div class="reply-box" id="reply-box-${comment.commentNo}">
		                    <input type="text" class="reply-input" placeholder="답글 추가...">
		                    <button class="reply-submit-btn" data-parent-no="${comment.commentNo}">등록</button>
		                </div>
		                <div class="replies">${repliesHtml}</div>
		            </div>
		        </div>`;
		        return commentHtml;
		    } */
		    

		    // '답글' 버튼 클릭 시 입력창 토글
		    $('#commentList').on('click', '.reply-toggle-btn', function() {
		        const commentNo = $(this).data('comment-no');
		        $('#reply-box-' + commentNo).toggle().find('input').focus();
		    });

		    // 답글 '등록' 버튼 클릭 이벤트
		    $('#commentList').on('click', '.reply-submit-btn', function() {
		        const parentNo = $(this).data('parent-no');
		        const content = $(this).siblings('.reply-input').val();
		        addComment(content, parentNo);
		    });
		    
		    // 최상위 댓글 '등록' 버튼 클릭 이벤트
		    $('#addComment').on('click', function() {
		        const content = $('#commentText').val();
		        addComment(content, 0); // 최상위 댓글의 부모 번호는 0
		    });
		    
		    // 댓글/답글 등록 AJAX 공통 함수
		    function addComment(content, refCommentId) {
		        if (!content.trim()) {
		            alert("내용을 입력해주세요.");
		            return;
		        }
		        $.ajax({
		            url: "${pageContext.request.contextPath}/community/comments",
		            type: "POST", 
		            contentType: "application/json",
		            data: JSON.stringify({
		                boardCmtContent: content,
		                refNo: communityNo,
		                refCommentId: refCommentId // 부모 댓글 번호 (최상위 댓글은 0)
		            }),
		            success: function(result) {
		                if (result === "success") {
		                    selectCommentList(); // 성공 시 댓글 목록 전체 새로고침
		                } else {
		                    alert("댓글 등록에 실패했습니다.");
		                }
		            },
		            error: function() { alert("댓글 등록 중 오류가 발생했습니다."); }
		        });
		    }
		    
		</script>
	 <script src="${pageContext.request.contextPath}/resources/js/test.js"></script>

</body>
</html>