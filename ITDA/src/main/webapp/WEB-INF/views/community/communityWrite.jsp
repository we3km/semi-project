<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- JSTL c태그를 사용하기 위한 태그 라이브러리 (c:url 등 사용 시 필요) --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<%-- 모바일 뷰 --%>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>communityWrite</title>
<link
	href="https://fonts.googleapis.com/css2?family=SUIT:wght@400;600;700&display=swap"
	rel="stylesheet">

<%-- communityWrite CSS 파일 --%>

<link
	href="${pageContext.request.contextPath}/resources/css/communityWrite.css"
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

		<!-- 상단 타이틀 / 위치 영역 -->
		<div class="top-title">
			<span class="community-title"><strong style="color: #7f8cff;">커뮤니티</strong>
				글쓰기</span> | <span class="location">활동지역 &gt; <span
				class="highlight">서울특별시 강남구</span> 📍
			</span>
		</div>
		<hr>

		<div class="form-container">
			<form:form modelAttribute="c" action="${pageContext.request.contextPath}/community/insert/${communityCode}"
				id="enrollForm" method="post" enctype="multipart/form-data">
				<div class="write-buttons">
					<button type="button" class="btn-cancel" id="cancelBtn">작성 취소</button>
					<button type="submit" class="btn-submit" id="submitBtn">작성 완료</button>
				</div>

				<!-- 카테고리 -->
				<div class="form-group">
			    <label>카테고리 선택</label>
			    <form:select path="communityCd" cssClass="select-category" id="category" required="required">
				  <form:option value="">카테고리 선택</form:option>
				  <c:forEach var="entry" items="${communityTypeMap}">
				    <form:option value="${entry.key}">${entry.value.communityName}</form:option>
				  </c:forEach>
				</form:select>
				</div>

				<!-- 제목 -->
				<div class="form-group">
					<label for="title">제목</label> 
					<!-- <input type="text" id="communityTitle" placeholder="제목을 입력하세요"> -->
					<form:input path="communityTitle" id="communityTitle" placeholder="제목을 입력하세요" required="required"/>
				</div>

				<!-- 태그 -->
				<div class="form-group">
					<label for="tagInput">태그</label>
					<div id="tagArea">
						<div class="tag-wrap">
							<div id="tagList"></div>
							<input type="text" id="tagInput" placeholder="엔터키로 추가 가능">
						</div>
						<img src="${pageContext.request.contextPath}/resources/images/search.png"
							class="search-icon" />
					</div>

				</div>

				<!-- 내용 -->
				<div class="form-group">
					<label for="content">게시글 상세 내용</label>
					<form:textarea path="communityContent" id="content" placeholder="욕설, 비속어 사용은 자제해주세요. 내용은 1000자까지 입력이 가능합니다." required="required"/>
				</div>

				<div class="form-group file-group">
					<label for="fileInput">첨부파일</label> <span id="fileName" style="color: #666;"></span> 
					<label for="fileInput" class="file-label">파일선택</label> 
					<input type="file" id="fileInput" name="upfile" multiple>
					<%-- <form:input path="upfile" id="fileInput" "/> --%>
				</div>
			</form:form>
		</div>

	</div>

	<%-- communityWrite JavaScript 파일 불러오기--%>
	<%-- <script src="${pageContext.request.contextPath}/resources/js/communityWrite.js"></script> --%>
	<script>
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

    // 작성 완료 → 그냥 form 전송
    $submitBtn.on('click', function () {
        $('#enrollForm').submit();
    });

    // 태그 입력
    $tagInput.on('keypress', function (e) {
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

    // 태그 지우기
    $(document).on('click', '.remove-tag', function () {
        const tag = $(this).data('tag');
        tags = tags.filter(t => t !== tag);
        $(this).parent().remove();
    });

});
</script>


</body>
</html>