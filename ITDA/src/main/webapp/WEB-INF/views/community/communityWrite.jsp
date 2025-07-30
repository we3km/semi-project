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
			<form:form modelAttribute="c"
				action="${pageContext.request.contextPath}/community/insert"
				id="enrollForm" method="post" enctype="multipart/form-data">
				<div class="write-buttons">
					<button type="button" class="btn-cancel" id="cancelBtn">작성
						취소</button>
					<button type="submit" class="btn-submit" id="submitBtn">작성
						완료</button>
				</div>

				<!-- 카테고리 -->
				<div class="form-group">
					<label>카테고리 선택</label>
					<form:select path="communityCd" cssClass="select-category"
						id="category" required="required">
						<form:option value="">카테고리 선택</form:option>
						<%-- <c:forEach var="entry" items="${communityTypeMap}">
				    <form:option value="${entry.key}">${entry.value.communityName}</form:option>
				  </c:forEach> --%>
						<c:forEach var="entry"
							items="${applicationScope.communityTypeMap}">
							<c:if test="${entry.key ne 'all'}">
								<form:option value="${entry.key}">${entry.value.communityName}</form:option>
							</c:if>
						</c:forEach>
					</form:select>
				</div>

				<!-- 제목 -->
				<div class="form-group">
					<label for="title">제목</label>
					<!-- <input type="text" id="communityTitle" placeholder="제목을 입력하세요"> -->
					<form:input path="communityTitle" id="communityTitle"
						placeholder="제목을 입력하세요" required="required" />
				</div>

				<!-- 태그 -->
				<div class="form-group">
					<label for="tagInput">태그</label>
					<div id="tagArea">
						<div class="tag-wrap">
							<div id="tagList"></div>
							<input type="text" id="tagInput" placeholder="엔터키로 추가 가능">
						</div>
						<img
							src="${pageContext.request.contextPath}/resources/images/search.png"
							class="search-icon" />
					</div>

				</div>

				<!-- 내용 -->
				<div class="form-group">
					<label for="content">게시글 상세 내용</label>
					<form:textarea path="communityContent" id="content"
						placeholder="욕설, 비속어 사용은 자제해주세요. 내용은 1000자까지 입력이 가능합니다."
						required="required" />
				</div>

				<!-- 첨부파일 -->
				<div class="form-group file-group">
					<label>첨부파일</label>

					<div class="file-attach-area">
						<div id="file-list-display" class="file-list-display"></div>

						<label for="fileInput" class="file-label">파일선택</label> <input
							type="file" id="fileInput" name="upfile" multiple
							accept="image/*" style="display: none;">
					</div>
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
	
	    //태그 관련 변수
	    let tags = [];
	    const $tagInput = $('#tagInput');
	    const $tagList = $('#tagList');
	    
	    const $fileInput = $('#fileInput');
	    const $fileNameSpan = $('#fileName');
	
	
	    // 작성 취소
	    $cancelBtn.on('click', function () {
	        if (confirm('작성을 취소하시겠습니까? 변경사항이 저장되지 않습니다.')) {
	        	location.href = '${pageContext.request.contextPath}/community/list/all';
	        }
	    });
	
	    // 작성 완료 → 그냥 form 전송
	    $submitBtn.on('click', function () {
	        $('#enrollForm').submit();
	    });
	
	    // 태그 입력
	    $tagInput.on('keypress', function (e) {
	        if (e.which === 13) {
	            e.preventDefault();	// 폼 전송 막기
	            
	            const newTag = $(this).val().trim();
	            
	            
	            
	         	// 유효성 검사
	            if (newTag === '') {
	                alert('태그 내용을 입력해주세요.');
	                return;
	            }
	            if (tags.includes(newTag)) {
	                alert('이미 추가된 태그입니다.');
	                $(this).val('');	//중복시 지우기
	                return;
	            }
	            if (tags.length >= 5) { // 태그는 최대 5개까지로 제한 (원하시면 숫자 변경)
	                alert("태그는 최대 5개까지 추가할 수 있습니다.");
	                return;
	            }
	            
	         	// 태그 배열 및 화면에 추가
	            tags.push(newTag);
	         	
	            /* const tagElement = `
	                <span class="tag">
	                    #
	                    ${newTag}
	                    <span class="remove-tag" data-tag="${newTag}">&times;</span>
	                </span>
	            `;
	            $tagList.append(tagElement); */
	         	// 1. <span> 태그를 jQuery 객체로 직접 생성합니다.
	            const $tag = $('<span class="tag"></span>');
	
	            // 2. 'X' 버튼(span)을 만들고, data-tag 속성에 newTag 값을 넣습니다.
	            const $removeBtn = $('<span class="remove-tag">&times;</span>').attr('data-tag', newTag);
	
	            // 3. <span> 태그의 텍스트를 '#[태그내용]' 으로 설정하고, 그 뒤에 X 버튼을 추가합니다.
	            $tag.text('#' + newTag).append($removeBtn);
	
	            // 4. 완성된 태그 요소를 화면에 추가합니다.
	            $tagList.append($tag);
	            
	            // 입력창 비우기
	            $(this).val('');
	        }
	    });
	
	 	// 2. 태그 삭제 (X 버튼 클릭)
	    $(document).on('click', '.remove-tag', function () {
	        const tagToRemove = $(this).data('tag');
	        
	        // 배열에서 해당 태그 제거
	        tags = tags.filter(t => t !== tagToRemove);
	        
	        // 화면에서 해당 태그 요소 제거
	        $(this).parent().remove();
	    });
	 	
	 	// 3. 폼 전송 시 태그 데이터 넘기기 (작성 완료 버튼 클릭)
	    $('#submitBtn').on('click', function (e) {
	        e.preventDefault(); // 폼의 자동 전송을 일단 막음
	
	        // tags 배열을 쉼표(,)로 구분된 하나의 문자열로 변환합니다.
	        const tagString = tags.join(',');
	        
	        
	    	 // hidden input 필드가 form 안에 있는지 확인해주세요.
	        if ($('#tagHiddenInput').length === 0) {
	            // form 안에 hidden input이 없으면 동적으로 추가
	             $('#enrollForm').append('<input type="hidden" id="tagHiddenInput" name="tagStr">');
	        }
	        
	        
	        // 이전에 추가했던 hidden input에 합쳐진 태그 문자열을 값으로 설정합니다.
	        $('#tagHiddenInput').val(tagString);
	
	        // 이제 폼을 전송합니다.
	        $('#enrollForm').submit();
	    })
	    
	    // 작성 취소 버튼
	    $('#cancelBtn').on('click', function () {
	        if (confirm('작성을 취소하시겠습니까? 변경사항이 저장되지 않습니다.')) {
	            location.href = contextPath + '/community/list/all';
	        }
	    });
	 	
		//이미지 미리보기
	    $('#fileInput').on('change', function(event) {
	        const files = event.target.files;
	        const fileListDisplay = $('#file-list-display');

	        // 목록 초기화
	        fileListDisplay.empty();

	        if (files.length > 0) {
	            Array.from(files).forEach(file => {
	                const reader = new FileReader();

	                reader.onload = function(e) {
	                    // 각 파일을 감싸는 div 생성
	                    const fileItem = $('<div class="file-preview-item"></div>');
	                    
	                    // 이미지 미리보기 생성
	                    const img = $('<img>').attr('src', e.target.result);
	                    
	                    // 파일명 span 생성
	                    const fileName = $('<span class="file-name"></span>').text(file.name);
	                    
	                    // div 안에 이미지와 파일명을 추가하고, 최종적으로 화면에 추가
	                    fileItem.append(img).append(fileName);
	                    fileListDisplay.append(fileItem);
	                };

	                reader.readAsDataURL(file);
	            });
	        }
	    });
	});
</script>


</body>
</html>