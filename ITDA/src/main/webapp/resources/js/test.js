function createCommentHtml(comment) {
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
			<div class="reply-box" id="reply-box-${comment.boardCmtId}">
				<input type="text" class="reply-input" placeholder="답글 추가...">
				<button class="reply-submit-btn" data-parent-no="${comment.boardCmtId}">등록</button>
			</div>
			<div class="replies">${repliesHtml}</div>
		</div>
	</div>`;
	return commentHtml;
}
// 문서 로딩 완료 후 이벤트 바인딩
$(document).on('click', '.reply-toggle-btn', function() {
	const commentNo = $(this).data('comment-no');
	const replyBox = $('#reply-box-' + commentNo);

	// 답글창 토글
	replyBox.toggle();
});