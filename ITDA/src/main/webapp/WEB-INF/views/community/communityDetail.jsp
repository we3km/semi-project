<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- JSTL c태그를 사용하기 위한 태그 라이브러리 (c:url 등 사용 시 필요) --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

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
	
<%-- report css --%>
<link href="${pageContext.request.contextPath}/resources/css/report/reports.css" rel="stylesheet">

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
            <div class="left">작성자 : ${community.communityNickname} | 작성일 : <fmt:formatDate value="${community.writeDate }" pattern="yyyy-MM-dd HH:mm" />
            	<c:if test="${not empty community.editDate}">
		            <span class="edit-date">| 수정일: <fmt:formatDate value="${community.editDate}" pattern="yyyy-MM-dd HH:mm" /></span>
		        </c:if>
            </div>
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
            <button class="report-btn" 
			        onclick="openReportModal('BOARD', '${community.communityNo}', '${community.communityWriter}')">
			    신고하기
			</button>
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
			    <form id="editForm" method="get" action="${pageContext.request.contextPath}/community/update/${community.communityNo}">
			        <input type="hidden" name="communityNo" value="${community.communityNo}" />
			        <button type="submit" class="edit-btn">수정하기</button>
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
	        	<div class="img-area">
		        	<c:forEach var="img" items="${community.imgList}">
		            	<div class="img-item">
			            	<img src="${pageContext.request.contextPath}/resources/images/community/${community.communityCd }/${img.changeName}" class="detail-img">
		            	</div>
		        	</c:forEach>
		        </div>
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
        
         <c:set var="loginUserNum" value="${sessionScope.loginUser.userNum}" />
       
        
    </div>
    <jsp:include page="/WEB-INF/views/report/report.jsp" />
   
    
		<script>
		const userReaction = "${userReaction}";
		const communityNo = "${community.communityNo}";
	    const communityCd = "${community.communityCd}";
	    const loginUserNum = '<sec:authentication property="principal.userNum" />';
		const communityWriter = "${community.communityWriter}";
		const contextPath = '${pageContext.request.contextPath}';
		
		let currentSort = 'asc';
		
	    $(document).ready(function(){
	    	//댓글목록 불러오기
	    	selectCommentList();
	    	
	    	// 댓글 정렬
	    	$('.tabs div').on('click',function(){
				$('.tabs div').removeClass('active');
				$(this).addClass('active');
				
				const sortType= $(this).text();
				if(sortType === '최신순'){
					currentSort = 'desc';
				}else if(sortType === '답글순'){
					currentSort = 'reply';
				}else{
					currentSort = 'asc';
				}
				
				selectCommentList();
			});
	    	
	    	console.log("loginUserNum:", loginUserNum);
	    	console.log("communityWriter:", communityWriter);
	    	 setTimeout(() => {
	    	        if (!loginUserNum || parseInt(loginUserNum) !== parseInt(communityWriter)) {
	    	            console.log("숨김 처리됨");
	    	            $('.sub-btn').hide(); 
	    	        } else {
	    	            console.log("표시됨");
	    	            $('.sub-btn').show(); 
	    	        }
	    	    }, 200);
	    	/* // 수정 버튼 숨기기
	    	if (!loginUserNum || parseInt(loginUserNum) !== communityWriter) {
	            $('.sub-btn').hide(); 
	        }
	    	 */
	    	
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
			    	$('#deleteToggleArea').hide();
		            $('#sharePopup').toggle();         
		        });
			  //신고하기
			   /* $('.report-btn').click(function(){
				   const id = $(this).data('id');
				    const title = $(this).data('title');
				    openReportModal('community', id, title);
				}); */
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
				// sub-btn 클릭 → 삭제/수정 버튼 토글
				$('.sub-btn').click(function () {
					$('#deleteToggleArea').toggle();
					$('#sharePopup').hide();   
				});
				
				// 게시글 삭제
				$('#deleteForm').on('submit',function(e){
					if(!loginUserNum /* || loginUserNum !== communityWriter */){
						e.preventDefault();
						alert('삭제 권한이 없습니다.');
						console.log("로그인 유저 : "+ loginUserNum +", 게시글 작성자 : "+communityWriter);
						return;
					}
					if(!confirm('정말로 이 게시글을 삭제하시겠습니까?')){
						e.preventDefault();
					}
				});
				
				//게시글 수정
				$('#editForm').on('submit',function(e){
					
					if(!confirm('정말로 이 게시글을 수정하시겠습니까?')){
						e.preventDefault();
					}
				});
				
				$(document).click(function (event) {
				    if (!$(event.target).closest('.share-btn, #sharePopup, .sub-btn, #deleteToggleArea').length) {
				        $('#sharePopup').hide();
				        $('#deleteToggleArea').hide();
				    }
				});
				
				
	    });
			 
	    
			// 좋아요·싫어요 보내기
		    function sendReaction(type) {
		    	const dataToSend = {
		    	        communityNo: communityNo, 
		    	        communityCd: communityCd, 
		    	        type: type
		    	    };
		        $.ajax({
		            type: "POST",
		            url: "${pageContext.request.contextPath}/community/react",
		            contentType: "application/json",
		            data: JSON.stringify({
		            	communityNo: parseInt(communityNo), 
		                communityCd: communityCd,
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
				console.log("현재 정렬 타입"
						+currentSort);
		        $.ajax({
		            url: "${pageContext.request.contextPath}/community/comments/" + communityNo,
		            type: "GET",
		            dataType: "json",
		            data : {
		            	sort : currentSort
		            },
		            success: function(commentTree) { // 서버로부터 계층형 댓글 목록(List<BoardCommentExt>)을 받음
		            	
		            	 console.log("'" + currentSort + "' 기준으로 서버로부터 받은 댓글:", commentTree);
		            	
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
		                }
		            },
		            error: function() { console.log("댓글 목록 조회에 실패했습니다."); }
		        });
		    }
			//댓글 시간 포멧
		    function formatCommentDate(dateTimestamp) {
		
				
			    const now = new Date();
			    const writeDate = new Date(dateTimestamp);
			    const diffMs = now - writeDate;
			    const diffMinutes = Math.floor(diffMs / 1000 / 60);
			    const diffHours = Math.floor(diffMinutes / 60);
			    const diffDays = Math.floor(diffHours / 24);
			    
			    
			    if (diffMinutes < 1) {
			        return '방금 전';
			    } else if (diffMinutes < 60) {
			        return diffMinutes + '분 전';
			    } else if (diffHours < 24) {
			        return diffHours + '시간 전';
			    } else {
			        return writeDate.toLocaleDateString('ko-KR', {
			            year: '2-digit',
			            month: '2-digit',
			            day: '2-digit'
			        });
			    }
			}
		    
		    // 댓글 객체를 받아 HTML 문자열을 생성하는 함수
		     function createCommentHtml(comment) {

		 		const contextPath = '${pageContext.request.contextPath}';
		 		
		 		//유저 프로필 URL 수정필요
		 		const profileUrl = contextPath + "/user/mypage/" + comment.cmtWriterUserNum;
		 	
		        let repliesHtml = '';
		        if (comment.replies && comment.replies.length > 0) {
		            $.each(comment.replies, function(index, reply) {
		                repliesHtml += createCommentHtml(reply);
		            });
		        }
		        
		        const writeDate = formatCommentDate(comment.cmtWriteDateTimestamp);
		        
		        let replyBtnHtml = '';
		        if (comment.refCommentId=== 0) {
		            replyBtnHtml = '<span class="reply-toggle-btn" data-comment-no="' + comment.boardCmtId + '">답글</span>';
		        }
		        
		        let repliesToggleHtml = '';
		        if (repliesHtml) {
		            repliesToggleHtml = '<div class="replies-toggle-btn" data-comment-no="'+ comment.boardCmtId +'">답글 접기</div>';
		        }
		       
		        /* let commentHtml = '';
		        commentHtml += '<div class="comment ' + (comment.refCommentId > 0 ? 'reply' : '') + '">';
		        commentHtml += '  <div class="profile-icon"><a href="' + profileUrl + '"><img class="profile-img" src="' + contextPath + comment.imageUrl + '" alt="Profile Image"></a></div>';
		        commentHtml += '  <div class="content">';
		        commentHtml += '    <div class="author"><a href="' + profileUrl + '">' + comment.nickName + '</a></div>';
		        commentHtml += '    <div class="text">' + comment.boardCmtContent + '</div>'; 
		        commentHtml += '    <div class="actions">';
		        commentHtml += '      <span>' + writeDate + '</span>';
		        commentHtml +=        replyBtnHtml;
		        commentHtml +=        repliesToggleHtml;
		        commentHtml += '    </div>';
		        commentHtml += '    <div class="reply-section">';
		        commentHtml += '      <div class="reply-box" id="reply-box-' + comment.boardCmtId + '" style="display:none;">';
		        commentHtml += '        <input type="text" class="reply-input" placeholder="답글 추가...">';
		        commentHtml += '        <button class="reply-submit-btn" data-parent-no="' + comment.boardCmtId + '">등록</button>';
		        commentHtml += '      </div>';
		        commentHtml += '      <div class="replies-container" id="replies-container-' + comment.boardCmtId + '">';
		        commentHtml += '        <div class="replies" >' + repliesHtml + '</div>';
		        commentHtml += '      </div>';
		        commentHtml += '    </div>';
		        commentHtml += '  </div>';
		        commentHtml += '  <div class="options-btn">︙</div>';
		        commentHtml += '  <div class="options-popup">';
		        commentHtml += '      <div class="report-comment-btn" data-type="COMMENT" data-target-id="'+ comment.boardCmtId +'" data-target-user-num="'+ comment.cmtWriterUserNum +'">신고하기</div>';
		        if(loginUserNum && parseInt(loginUserNum) === comment.cmtWriterUserNum) {
			        commentHtml += '      <div class="delete-comment-btn" data-comment-no="'+ comment.boardCmtId +'">삭제하기</div>';
		        }
		        
		        commentHtml += '  </div>';
		        commentHtml += '</div>'; */
		        
		        let commentHtml = '';
		        commentHtml += '<div class="comment ' + (comment.refCommentId > 0 ? 'reply' : '') + '">';

		        // 첫 줄: 프로필, 본문, 옵션 버튼을 3등분해서 한 줄에 배치
		        commentHtml += '  <div class="comment-row">';
		        commentHtml += '    <div class="comment-left">';
		        commentHtml += '      <a href="' + profileUrl + '">';
		        commentHtml += '        <div class="profile-icon">';
		        commentHtml += '          <img class="profile-img" src="' + contextPath + comment.imageUrl + '" alt="Profile Image">';
		        commentHtml += '        </div>';
		        commentHtml += '      </a>';
		        commentHtml += '    </div>';

		        commentHtml += '    <div class="comment-center">';
		        commentHtml += '      <div class="author"><a href="' + profileUrl + '">' + comment.nickName + '</a></div>';
		        commentHtml += '      <div class="text">' + comment.boardCmtContent + '</div>';
		        commentHtml += '      <div class="actions">';
		        commentHtml += '        <span>' + writeDate + '</span>';
		        commentHtml +=        replyBtnHtml;
		        commentHtml +=        repliesToggleHtml;
		        commentHtml += '      </div>';
		        commentHtml += '    </div>';

		        commentHtml += '    <div class="comment-right">';
		        commentHtml += '      <div class="options-btn">︙</div>';
		        commentHtml += '      <div class="options-popup">';
		        commentHtml += '        <div class="report-comment-btn" data-type="COMMENT" data-target-id="'+ comment.boardCmtId +'" data-target-user-num="'+ comment.cmtWriterUserNum +'">신고하기</div>';
		        if (loginUserNum && parseInt(loginUserNum) === comment.cmtWriterUserNum) {
		            commentHtml += '        <div class="delete-comment-btn" data-comment-no="'+ comment.boardCmtId +'">삭제하기</div>';
		        }
		        commentHtml += '      </div>';
		        commentHtml += '    </div>';
		        commentHtml += '  </div>'; // comment-row 끝

		        // 답글 입력창과 답글 리스트
		        commentHtml += '  <div class="reply-section">';
		        commentHtml += '    <div class="reply-box" id="reply-box-' + comment.boardCmtId + '" style="display:none;">';
		        commentHtml += '      <div class="profile-icon small"><img class="profile-img" src="' + contextPath + comment.imageUrl + '" alt="Profile Image"></div>';
		        commentHtml += '      <input type="text" class="reply-input" placeholder="답글 추가...">';
		        commentHtml += '      <button class="reply-submit-btn" data-parent-no="' + comment.boardCmtId + '">등록</button>';
		        commentHtml += '    </div>';
		        commentHtml += '    <div class="replies-container" id="replies-container-' + comment.boardCmtId + '">';
		        commentHtml += '      <div class="replies">' + repliesHtml + '</div>';
		        commentHtml += '    </div>';
		        commentHtml += '  </div>'; // reply-section 끝

		        commentHtml += '</div>'; // comment 끝
		        
		        return commentHtml;
		    }
		    

		    // '답글' 버튼 클릭 시 입력창 토글
		    $('#commentList').on('click', '.reply-toggle-btn', function() {
		    	const commentNo = $(this).data('comment-no');
		    	  const $replyBox = $('#reply-box-'+commentNo);

		    	  /* console.log('클릭된 댓글 번호:', commentNo);
		    	  console.log('찾은 replyBox:', $replyBox);
		    	  console.log('현재 display 상태:', $replyBox.css('display')); */

		    	  $replyBox.toggle();

		    	  setTimeout(() => {
		    	    console.log('토글 후 display 상태:', $replyBox.css('display'));
		    	  }, 100);
		    });

		    // 답글 '등록' 버튼 클릭 이벤트
		    $('#commentList').on('click', '.reply-submit-btn', function() {
		        const parentNo = $(this).data('parent-no');
		        const content = $(this).siblings('.reply-input').val();
		        addComment(content, parentNo);
		    });
		    
		    // 답글 접기/펼치기
		    $('#commentList').on('click', '.replies-toggle-btn', function() {
		        const commentNo = $(this).data('comment-no');
		        /* const $repliesDiv = $(this).siblings('.replies'); */
		        const $repliesDiv = $(this).closest('.content').find('.replies'); 
		        const $button = $(this);

		        $repliesDiv.slideToggle(200,function(){
			        const buttonText = $repliesDiv.is(':visible') ? '답글 접기' 
			        					: '답글 ' + $repliesDiv.children('.comment').length + '개 펼치기';
		        	
					$button.text(buttonText);
		        });
		    });
		    
		 	// 옵션(⋯) 버튼 클릭 이벤트
		    $('#commentList').on('click', '.options-btn', function(e) {
		        e.stopPropagation(); // 이벤트 버블링 방지
		        $('.options-popup').not($(this).siblings('.options-popup')).hide(); // 다른 팝업 닫기
		        $(this).siblings('.options-popup').toggle(); // 현재 팝업 토글
		    });
		 	
		 	// 화면 다른 곳 클릭 시 모든 옵션 팝업 닫기
		    $(window).on('click', function() {
		        $('.options-popup').hide();
		        
		    });

		    // 팝업 메뉴의 '신고하기' 클릭 이벤트
		    $('#commentList').on('click', '.report-comment-btn', function() {
			    const type = $(this).data('type');
			    const targetId = $(this).data('target-id');
			    const targetUserNum = $(this).data('target-user-num');
			
			    // openReportModal 함수 호출
			    openReportModal(type, targetId, targetUserNum);
			});
		    
		 	// 	팝업 메뉴의 '삭제하기' 클릭 이벤트
		    $('#commentList').on('click', '.delete-comment-btn', function() {
		        const commentNo = $(this).data('comment-no');
		        
		        if (confirm(commentNo + '번 댓글을 정말 삭제하시겠습니까?')) {
		        	$.ajax({
		                url: "${pageContext.request.contextPath}/community/comments/delete",
		                type: "POST", // 또는 "DELETE"
		                contentType: "application/json",
		                data: JSON.stringify({
		                    boardCmtId: commentNo
		                    // 로그인 연동 후에는 서버가 자동으로 사용자 번호를 알게 됩니다.
		                }),
		                success: function(response) {
		                    if (response.result === "success") {
		                        alert("댓글이 삭제되었습니다.");
		                        selectCommentList(); // 댓글 목록 새로고침
		                    } else {
		                        alert(response.message || "댓글 삭제에 실패했습니다.");
		                    }
		                },
		                error: function() {
		                    alert("댓글 삭제 중 오류가 발생했습니다.");
		                }
		            });
		        }
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
		            success: function(map) {
		                if (map.result === "success") {
		                    selectCommentList(); // 성공 시 댓글 목록 전체 새로고침
		                    $('#commentText').val('');
		                } else {
		                    alert("댓글 등록에 실패했습니다.");
		                }
		            },
		            error: function() { alert("댓글 등록 중 오류가 발생했습니다."); }
		        });
		    }
		    
		</script>
		<script src="${pageContext.request.contextPath}/resources/js/report/reports.js"></script>

</body>
</html>