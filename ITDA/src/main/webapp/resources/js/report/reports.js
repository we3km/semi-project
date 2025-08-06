// 1. 신고 모달창 열기 함수
function openReportModal(type, targetId, targetUserNum) {
    // hidden input 필드에 값 설정
    $('#type').val(type);
    $('#targetId').val(targetId);
    $('#targetUserNum').val(targetUserNum);

    // 신고 대상 정보 표시
    let typeName = '';
    switch (type) {
        case 'BOARD': typeName = '게시물'; break;
        case 'COMMENT': typeName = '댓글'; break;
        case 'USER': typeName = '사용자'; break;
        case 'OPENCHAT': typeName = '오픈채팅'; break;
    }
    $('#targetInfo').text(`${typeName} 신고`); // .text()로 내용 변경

    // 신고 사유 카테고리 동적 생성
    const $categorySelect = $('select[name="reason"]');
    $categorySelect.html(''); // .html('')로 내용 초기화

    // 기본 옵션 추가
    $categorySelect.append('<option value="">-- 신고 사유를 선택하세요 --</option>');

    // 타입에 따른 신고 사유 옵션 추가
    let optionsHtml = '';
    if (type === 'BOARD') {
        optionsHtml = `
            <option value="부적절한 게시물">부적절한 게시물</option>
            <option value="허위 정보">허위 정보</option>
            <option value="스팸/광고">스팸/광고</option>
            <option value="사기">사기</option>
        `;
    } else if (type === 'COMMENT') {
        optionsHtml = `
            <option value="욕설/비방">욕설/비방</option>
            <option value="음란물">음란물</option>
            <option value="스팸/광고">스팸/광고</option>
        `;
    } else if (type === 'USER') {
        optionsHtml = `
            <option value="욕설/비방">욕설/비방</option>
            <option value="사기 의심">사기 의심</option>
            <option value="부적절한 프로필">부적절한 프로필</option>
        `;
    } else if (type === 'OPENCHAT') {
        optionsHtml = `
            <option value="부적절한 대화">부적절한 대화</option>
            <option value="욕설/비방">욕설/비방</option>
            <option value="음란물">음란물</option>
            <option value="사기 의심">사기 의심</option>
        `;
    }
    $categorySelect.append(optionsHtml); // 옵션들을 한번에 추가

    // 모달 열기
    $('#reportModal').css('display', 'flex').addClass('active');
}

// 2. 신고 모달창 닫기 함수
function closeReportModal() {
    $('#reportModal').hide().removeClass('active');
}

// 3. 문서가 준비되면 AJAX 폼 제출 이벤트 핸들러를 첨부
$(document).ready(function() {
    // id가 'reportForm'인 폼이 'submit'될 때의 동작을 정의
    $('#reportForm').off('submit').on('submit', function(e) {
        
        // 폼의 기본 제출 동작(페이지 새로고침)을 막습니다.
        e.preventDefault(); 

        // AJAX를 통해 폼 데이터를 서버로 전송합니다.
        $.ajax({
            type: "POST",
            url: $(this).attr('action'), // 폼의 action 속성값
            data: $(this).serialize(),   // 폼 안의 모든 데이터
            success: function(response) {
                // 서버로부터 성공적으로 응답을 받았을 때 실행됩니다.
                // 'response'에는 컨트롤러가 반환한 문자열이 담깁니다.
                
                if (response.includes("완료")) {
                    // 응답에 "완료"가 포함된 경우
                    alert(response);       
                    closeReportModal();    // 모달창 닫기

                } else if (response.includes("로그인")) {
                    // 응답에 "로그인"이 포함된 경우
                    alert(response);       
                    // 메인 페이지로 이동 (contextPath를 포함시켜 경로 오류 방지)
                    location.href = "${pageContext.request.contextPath}/"; 
                
                } else {
                    // 그 외 다른 응답 (예: "신고에 실패하였습니다")
                    alert(response);
                }
            },
            error: function() {
                // 서버와 통신 자체를 실패한 경우 (500 에러 등)
                alert("서버와 통신 중 오류가 발생했습니다.");
            }
        });
    });
});