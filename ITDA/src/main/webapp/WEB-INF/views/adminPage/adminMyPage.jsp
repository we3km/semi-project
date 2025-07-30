<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>관리자 정보</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/adminPage/adminMyPage.css" />
<script src="${pageContext.request.contextPath}/resources/js/jquery.min.js"></script> <!-- jQuery 경로 맞게 -->
</head>
<body>
    <div class="container">
        <h2>관리자 마이페이지</h2>
        <p>아이디: ${user.userId}</p>
        <p>닉네임: ${user.nickName}</p>
        <p>이메일: ${user.email}</p>
        <nav>
            <ul>
                <li><a href="${pageContext.request.contextPath}/admin/reports">신고 관리 페이지</a></li>
            </ul>
        </nav>

        <!-- 회원 검색 영역 -->
        <section>
            <h3>회원 검색</h3>
            <input type="text" id="searchKeyword" placeholder="회원 아이디 또는 닉네임 입력" />
            <button id="searchBtn">검색</button>
            <div id="searchResults" style="margin-top:20px;"></div>
        </section>
    </div>

<script>
$(document).ready(function(){
    $('#searchBtn').click(function(){
        let keyword = $('#searchKeyword').val().trim();
        if(keyword === '') {
            alert('검색어를 입력하세요.');
            return;
        }
        $.ajax({
            url: '${pageContext.request.contextPath}/admin/memberSearch',
            method: 'GET',
            data: { keyword: keyword },
            dataType: 'json',
            success: function(data) {
                let html = '<ul>';
                if(data.length === 0) {
                    html += '<li>검색 결과가 없습니다.</li>';
                } else {
                    data.forEach(function(user){
                        html += `<li>${user.userId} (${user.nickName}) - ${user.email}</li>`;
                    });
                }
                html += '</ul>';
                $('#searchResults').html(html);
            },
            error: function() {
                alert('검색 중 오류가 발생했습니다.');
            }
        });
    });
});

$('#searchKeyword').keypress(function(e){
    if (e.which === 13) {
        $('#searchBtn').click();
    }
});
</script>

</body>
</html>