// 좋아요수와 댓글수 변수 초기화
        let recommendCount = 0, commentCount = 0;

        // 댓글 수를 표시하는 요소들(#commentCount, #commentCountDisplay)의 텍스트를 댓글 수로 업데이트
        function updateCommentCount() {
            $('#commentCount, #commentCountDisplay').text(commentCount);
        }

        //게시글
        //좋아요 click
        $('#likeBtn').click(() => {
            // 현재 좋아요 수
            let likeCurrent = +$('#likeCount').text();
            $('#likeCount').text(likeCurrent + 1);  // 좋아요 1 증가

            // 싫어요 수 초기화
            $('#dislikeCount').text(0);

            // 추천 수에 좋아요 수 표시
            $('#recommendCount').text(likeCurrent + 1);

            // 이미지 변경
            
            $('#likeBtn img').attr('src', '${pageContext.request.contextPath}/resources/images/like_clike.png');
            $('#dislikeBtn img').attr('src', '${pageContext.request.contextPath}/resources/images/dislike.png');
        });
        

        //싫어요 click
        $('#dislikeBtn').click(() => {
            // 현재 싫어요 수
            let dislikeCurrent = +$('#dislikeCount').text();
            $('#dislikeCount').text(dislikeCurrent + 1);

            // 좋아요 수 초기화
            $('#likeCount').text(0);

            // 추천 수에 좋아요 수(0) 표시
            $('#recommendCount').text(0);

            // 이미지 변경
            $('#dislikeBtn img').attr('src', '${pageContext.request.contextPath}/resources/images/dislike_click.png');
            $('#likeBtn img').attr('src', '${pageContext.request.contextPath}/resources/images/like.png');
        });




        //댓글 추가 click
        $('#addComment').click(() => {
            const text = $('#commentText').val().trim();
            if (!text) return alert("댓글을 입력하세요.");

            const $comment = createComment(text);
            $('#commentList').append($comment);
            $('#commentText').val('');
            commentCount++;

            updateCommentCount();   //댓글 수 ui업데이트
        });

        //댓글 엘리먼트 생성(댓글 + 대댓글)
        function createComment(text, isReply = false) {
            const $cmt = $(`
        <div class="comment ${isReply ? 'reply' : ''}">
            <div class="profile-icon"></div>
            <div class="content">
                <div class="author">익명</div>
                <div class="text">${$('<div>').text(text).html()}</div>
                <div class="actions">
                    <span class="like"><img src="${pageContext.request.contextPath}/resources/images/like.png" alt="likeBtn" height="17px"> 0</span>
                    <span class="dislike"><img src="${pageContext.request.contextPath}/resources/images/dislike.png" alt="dislikeBtn" height="17px"> 0</span>
                    ${!isReply ? '<span class="reply-toggle">답글</span>' : ''}
                </div>
                ${!isReply ? `
                <div class="reply-box" style="display:none;">
                    <input type="text" placeholder="답글 추가..." />
                    <button class="reply-submit">등록</button>
                </div>` : ''}
            </div>
            <div class="options-btn">⋯</div>
            <div class="options-popup">
                <div class="report">신고하기</div>
                <div class="delete">삭제하기</div>
            </div>
        </div>
    `);

            // 좋아요/싫어요 상태 저장용
            let liked = false;
            let disliked = false;

            // 좋아요/싫어요 기능
            $cmt.find('.like').click(function () {
                let $likeSpan = $(this);
                let $dislikeSpan = $cmt.find('.dislike');

                let likeCount = parseInt($likeSpan.text().replace(/\D/g, ''));
                let dislikeCount = parseInt($dislikeSpan.text().replace(/\D/g, ''));

                if (liked) {
                    liked = false;
                    likeCount--;
                    $likeSpan.removeClass('active');
                    $likeSpan.find('img').attr('src', '${pageContext.request.contextPath}/resources/images/like.png');
                } else {
                    liked = true;
                    likeCount++;
                    if (disliked) {
                        disliked = false;
                        dislikeCount--;
                        $dislikeSpan.removeClass('active');
                        $dislikeSpan.find('img').attr('src', '${pageContext.request.contextPath}/resources/images/dislike.png');
                    }
                    $likeSpan.addClass('active');
                    $dislikeSpan.removeClass('active');
                    $likeSpan.find('img').attr('src', '${pageContext.request.contextPath}/resources/images/like_clike.png');
                }

                // 숫자만 변경 (텍스트 노드만 바꾸기)
                $likeSpan.contents().filter(function () {
                    return this.nodeType === 3;
                }).first().replaceWith(' ' + likeCount);

                $dislikeSpan.contents().filter(function () {
                    return this.nodeType === 3;
                }).first().replaceWith(' ' + dislikeCount);
            });

            //싫어요 click
            $cmt.find('.dislike').click(function () {
                let $dislikeSpan = $(this);
                let $likeSpan = $cmt.find('.like');

                let dislikeCount = parseInt($dislikeSpan.text().replace(/\D/g, ''));
                let likeCount = parseInt($likeSpan.text().replace(/\D/g, ''));

                if (disliked) {
                    disliked = false;
                    dislikeCount--;
                    $dislikeSpan.removeClass('active');
                    $dislikeSpan.find('img').attr('src', '${pageContext.request.contextPath}/resources/images/dislike.png');
                } else {
                    disliked = true;
                    dislikeCount++;
                    if (liked) {
                        liked = false;
                        likeCount--;
                        $likeSpan.removeClass('active');
                        $likeSpan.find('img').attr('src', '${pageContext.request.contextPath}/resources/images/like.png');
                    }
                    $dislikeSpan.addClass('active');
                    $likeSpan.removeClass('active');
                    $dislikeSpan.find('img').attr('src', '${pageContext.request.contextPath}/resources/images/dislike_click.png');
                }

                $dislikeSpan.contents().filter(function () {
                    return this.nodeType === 3;
                }).first().replaceWith(' ' + dislikeCount);

                $likeSpan.contents().filter(function () {
                    return this.nodeType === 3;
                }).first().replaceWith(' ' + likeCount);
            });

            // 옵션 버튼 (⋯)
            $cmt.find('.options-btn').click(e => {
                e.stopPropagation();
                $('.options-popup').hide(); // 다른 팝업 닫기
                $cmt.find('.options-popup').toggle();
            });
            $(document).click(() => $('.options-popup').hide());

            // 삭제 기능
            $cmt.find('.delete').click(() => {
                if (confirm('댓글을 삭제하시겠습니까?')) {
                    if (!isReply) $cmt.next('.replies').remove();
                    $cmt.remove();
                    commentCount--;
                    updateCommentCount();
                }
            });

            // 신고 기능
            $cmt.find('.report').click(() => {
                alert('신고가 접수되었습니다.');
            });

            // 답글 토글
            $cmt.find('.reply-toggle').click(() => {
                $cmt.find('.reply-box').toggle();
                $cmt.find('.reply-box input').focus();
            });

            // 답글 등록
            $cmt.find('.reply-submit').click(() => {
                const txt = $cmt.find('.reply-box input').val().trim();
                if (!txt) return alert("답글을 입력하세요.");
                const $reply = createComment(txt, true);

                // .replies 컨테이너 찾거나 없으면 생성
                let $replies = $cmt.next('.replies');
                if (!$replies.length) {
                    $replies = $('<div class="replies"></div>');
                    $cmt.after($replies);
                }

                $replies.append($reply);
                $cmt.find('.reply-box input').val('');
                $cmt.find('.reply-box').hide();
                commentCount++;
                updateCommentCount();

                // 답글 접기/펼치기 토글 버튼 없으면 생성
                if (!$cmt.find('.replies-toggle').length) {
                    const $toggleBtn = $(`
                <div class="replies-toggle" style="cursor:pointer; color:#6a3ae4; font-size:13px; margin-top:5px;">
                    답글 접기
                </div>
            `);
                    $toggleBtn.click(() => {
                        if ($replies.is(':visible')) {
                            $replies.hide();
                            $toggleBtn.text('답글 펼치기');
                        } else {
                            $replies.show();
                            $toggleBtn.text('답글 접기');
                        }
                    });
                    $cmt.find('.actions').after($toggleBtn);
                }
            });

            // 일반 댓글일 경우 .replies 박스 생성
            if (!isReply) {
                $cmt.after('<div class="replies"></div>');
            }

            return $cmt;
        }

        //공유click
        $('.share-btn').click(function () {
            $('#sharePopup').toggle();
        });

        //신고click
        $('.report-btn').click(function () {
            alert("신고가 접수되었습니다.");
        });

        //url 복사 함수
        function copyUrl() {
            const urlInput = document.getElementById("shareUrl");
            urlInput.select();
            urlInput.setSelectionRange(0, 99999); // For mobile
            document.execCommand("copy");
            alert("URL이 복사되었습니다!");
        }
