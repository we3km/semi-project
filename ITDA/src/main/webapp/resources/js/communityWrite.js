$(function () {
            let tags = [];

            //형식 초기화 형식
            function resetForm() {
                $('#category').val('');
                $('#title').val('');
                $('#tagInput').val('');
                $('#content').val('');
                $('#fileInput').val('');
                tags = [];
                $('#tagList').empty();
                $('#fileName').text('');
            }

            //태그 만들기
            $('#tagInput').on('keypress', function (e) {
                if (e.which === 13) {
                    e.preventDefault();
                    let input = $(this).val().trim();
                    if (input === '' || tags.includes(input)) return;
                    if (tags.length >= 3) {
                        alert("태그는 최대 3개까지 입력할 수 있습니다.");
                        return;
                    }
                    tags.push(input);
                    $('#tagList').append(`<span class="tag"> 
                                                #${input}
                                                <span class="remove-tag" data-tag="${input}">
                                                    &times;
                                                </span>
                                            </span>`);
                    $(this).val('');
                }
            });

            // 태그지우기
            $(document).on('click', '.remove-tag', function () {
                const tag = $(this).data('tag');
                tags = tags.filter(t => t !== tag);
                $(this).parent().remove();
            });

            //파일명 띄우기
            $('#fileInput').on('change', function () {
                const file = this.files[0];
                if (file) {
                    $('#fileName').text(file.name);
                } else {
                    $('#fileName').text('');
                }
            });

            //작성취소시 alert창 띄우기 및 양식 초기화
            $('#cancelBtn').on('click', function () {
                alert("작성이 취소되었습니다.");
                resetForm;
            });

            //작성 완료시 alert창 띄우기
            $('#submitBtn').on('click', function () {
                const category = $('#category').val().trim();
                const title = $('#title').val().trim();
                const content = $('#content').val().trim();
                let missing = [];

                if (!category) missing.push("카테고리");
                if (!title) missing.push("제목");
                if (!content) missing.push("게시글 상세 내용");

                if (missing.length > 0) {
                    alert(`다음 항목을 작성해주세요: ${missing.join(", ")}`);
                } else {
                    // 태그 문자열 만들기
                    const tagList = tags.length > 0 ? tags.map(t => `#${t}`).join(", ") : "태그 없음";

                    // 파일 이름 가져오기
                    const fileInput = $('#fileInput')[0];
                    const fileName = fileInput.files.length > 0 ? fileInput.files[0].name : "첨부된 파일 없음";

                    alert(`✅ 작성이 완료되었습니다! \n
📂 카테고리: ${category}
📝 제목: ${title}
💬 내용: ${content}
🏷️ 태그: ${tagList}
📎 파일: ${fileName}`);
                    resetForm();
                }
            });

        });