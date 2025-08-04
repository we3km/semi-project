<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<link rel="icon"
	href="${pageContext.request.contextPath}/resources/images/favicon.ico"
	type="image/x-icon">
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>관리자 정보</title>
<style>
body {
	font-family: 'Titillium Web', sans-serif;
	background-color: #fff;
	margin: 0;
	padding: 40px;
	color: #000;
}

.container {
	max-width: 1200px;
	margin: 0 auto;
}

h2 {
	color: #5a54ff;
	font-weight: 800;
	font-size: 30px;
	margin-bottom: 20px;
}

nav ul {
	list-style: none;
	padding: 0;
}

nav ul li {
	display: inline-block;
	margin-right: 15px;
}

nav ul li a {
	text-decoration: none;
	color: #5a54ff;
	font-weight: 600;
}

nav ul li a:hover {
	text-decoration: underline;
}

section {
	margin-top: 30px;
}

#searchKeyword {
	width: 300px;
	padding: 8px 12px;
	font-size: 16px;
	border: 1px solid #ccc;
	border-radius: 5px;
}

#searchBtn {
	padding: 8px 15px;
	font-size: 16px;
	border: none;
	background-color: #5a54ff;
	color: white;
	border-radius: 5px;
	cursor: pointer;
}

#searchBtn:hover {
	background-color: #3f3bbd;
}

#searchResults {
	margin-top: 20px;
	font-size: 16px;
	background-color: #f8f9fa;
	padding: 15px;
	border-radius: 5px;
	border: 1px solid #dee2e6;
}

#searchResults ul {
	padding-left: 20px;
	margin: 0;
}

#searchResults li {
	margin-bottom: 10px;
	padding: 8px;
	background-color: white;
	border-radius: 3px;
	border: 1px solid #e9ecef;
	list-style-type: disc;
}

.user-info {
	background-color: #f8f9fa;
	padding: 20px;
	border-radius: 8px;
	margin-bottom: 30px;
}

.user-info p {
	margin: 10px 0;
	font-size: 16px;
}

.loading {
	color: #5a54ff;
	font-style: italic;
}

.error-message {
	color: #dc3545;
	background-color: #f8d7da;
	padding: 10px;
	border-radius: 5px;
	margin-top: 10px;
}
</style>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<body>
	<header class="header">
		<jsp:include page="/WEB-INF/views/common/Header.jsp" />
	</header>
	<div class="container">
		<h2>관리자 마이페이지</h2>

		<!-- 관리자 정보 표시 -->
		<div class="user-info">
			<sec:authorize access="isAuthenticated()">
				<p>
					<strong>아이디:</strong> ${loginuser.userId}
				</p>
				<p>
					<strong>닉네임:</strong> ${loginuser.nickName}
				</p>
				<p>
					<strong>이메일:</strong> ${loginuser.email}
				</p>
			</sec:authorize>
		</div>

		<nav>
			<ul>
				<li><a href="${pageContext.request.contextPath}/admin/reports">신고
						관리 페이지</a></li>
			</ul>
		</nav>

		<!-- 회원 검색 영역 -->
		<section>
			<h3>회원 검색</h3>
			<input type="text" id="searchKeyword" placeholder="회원 아이디 또는 닉네임 입력" />
			<button id="searchBtn">검색</button>
			<div id="searchResults"></div>
		</section>
	</div>

	<script>
	$(document).ready(function() {
	    console.log('페이지 로드 완료');
	    
	    // 검색 버튼 클릭 이벤트
	    $('#searchBtn').click(function() {
	        performSearch();
	    });
	    
	    // 엔터키 입력 시 검색 실행
	    $('#searchKeyword').keypress(function(e) {
	        if(e.which === 13) {
	            performSearch();
	        }
	    });
	    
	    function performSearch() {
	        let keyword = $('#searchKeyword').val().trim();
	        console.log('검색 키워드:', keyword);
	        
	        if(keyword === '') {
	            alert('검색어를 입력하세요.');
	            return;
	        }
	        
	        // 로딩 메시지 표시
	        $('#searchResults').html('<p class="loading">검색 중...</p>');
	        
	        $.ajax({
	            url: '${pageContext.request.contextPath}/admin/memberSearch',
	            method: 'GET',
	            data: { keyword: keyword },
	            dataType: 'json',
	            timeout: 10000, // 10초 타임아웃
	            success: function(data) {
	                console.log('검색 결과:', data);
	                displaySearchResults(data);
	            },
	            error: function(xhr, status, error) {
	                console.error('검색 오류:', xhr.responseText, status, error);
	                let errorMsg = '검색 중 오류가 발생했습니다.';
	                if (status === 'timeout') {
	                    errorMsg = '검색 시간이 초과되었습니다. 다시 시도해주세요.';
	                } else if (xhr.status === 403) {
	                    errorMsg = '검색 권한이 없습니다.';
	                } else if (xhr.status === 500) {
	                    errorMsg = '서버 오류가 발생했습니다.';
	                }
	                $('#searchResults').html('<div class="error-message">' + errorMsg + '</div>');
	            }
	        });
	    }
	    
	    function displaySearchResults(data) {
	        $('#searchResults').empty();

	        if (!data || data.length === 0) {
	            $('#searchResults').html('<p style="color: #666; font-style: italic;">검색 결과가 없습니다.</p>');
	            return;
	        }

	        let $ul = $('<ul></ul>');

	        data.forEach((user, index) => {
	            console.log(`사용자 ${index + 1}:`, user);

	            let userId = user.userId;
	            let nickName = user.nickName;
	            let email = user.email;

	            let $li = $('<li></li>');
	            $li.html(`<strong>${userId}</strong> (${nickName}) - ${email}`);
	            $ul.append($li);
	        });

	        $('#searchResults').append($ul);
	    }
	    
	    console.log('DOM 업데이트 완료');
	});
	</script>
</body>
</html>