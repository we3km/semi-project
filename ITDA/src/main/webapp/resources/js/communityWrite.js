/**
 * communityWrite.js (jQuery 버전)
 */
$(document).ready(function () {

    const $cancelBtn = $('#cancelBtn');
    const $submitBtn = $('#submitBtn');
    const $tagInput = $('#tagInput');
    const $tagList = $('#tagList');
    const $fileInput = $('#fileInput');
    const $fileNameSpan = $('#fileName');

    let tags = [];

    // 작성 취소
    $cancelBtn.on('click', function () {
        if (confirm('작성을 취소하시겠습니까? 변경사항이 저장되지 않습니다.')) {
            location.href = '/community/list';
        }
    });

    // 작성 완료
    $submitBtn.on('click', function () {
        submitForm();
    });

    // 태그 입력
    $tagInput.on('keyup', function (e) {
        if (e.key === 'Enter') {
            e.preventDefault();
            const newTagText = $(this).val().trim();
            if (newTagText) {
                addTag(newTagText);
                $(this).val('');
            }
        }
    });

    // 파일 선택
    $fileInput.on('change', function () {
        if (this.files && this.files.length > 0) {
            $fileNameSpan.text(this.files[0].name);
        } else {
            $fileNameSpan.text('');
        }
    });

    // 태그 추가 함수
    function addTag(text) {
        if (tags.length >= 3) {
            alert("태그는 최대 3개까지 입력할 수 있습니다.");
            return;
        }
        if (tags.includes(text)) {
            alert("이미 추가된 태그입니다.");
            return;
        }

        tags.push(text);

        const $tagSpan = $('<span>').addClass('tag').text(`#${text}`);
        const $removeBtn = $('<span>')
            .addClass('remove-tag')
            .text('×')
            .data('tag', text)
            .on('click', function () {
                const tagToRemove = $(this).data('tag');
                tags = tags.filter(t => t !== tagToRemove);
                $(this).parent().remove();
            });

        $tagSpan.append($removeBtn);
        $tagList.append($tagSpan);
    }

    // 폼 전송
    function submitForm() {
        const category = $('#category').val();
        const title = $('#title').val().trim();
        const content = $('#content').val().trim();
        const file = $fileInput[0].files[0];

        let missing = [];
        if (!category) missing.push("카테고리");
        if (!title) missing.push("제목");
        if (!content) missing.push("게시글 상세 내용");

        if (missing.length > 0) {
            alert(`다음 항목을 작성해주세요: ${missing.join(", ")}`);
            return;
        }

        const formData = new FormData();
        formData.append('category', category);
        formData.append('title', title);
        formData.append('content', content);

        if (file) {
            formData.append('file', file);
        }

        formData.append('tags', JSON.stringify(tags));

        $.ajax({
            url: '/community/write',
            method: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function () {
                alert('게시글이 성공적으로 등록되었습니다.');
                location.href = '/community/list';
            },
            error: function () {
                alert('오류가 발생했습니다. 다시 시도해주세요.');
            }
        });
    }
});
