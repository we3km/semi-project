<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- JSTL c태그를 사용하기 위한 태그 라이브러리 (c:url 등 사용 시 필요) --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
	<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
				${c.communityNo > 0 ? '글수정' : '글작성'} </span>
		</div>
		<hr>

		<div class="form-container">
			<c:set var="isUpdate" value="${c.communityNo > 0}" />
	    	<c:set var="formAction" value="${isUpdate ? 'update' : 'insert'}" />
			
			<form:form modelAttribute="c" action="${pageContext.request.contextPath}/community/${formAction}"
				id="enrollForm" method="post" enctype="multipart/form-data">
				
				<c:if test="${isUpdate}">
		            <form:hidden path="communityNo"/>
		        </c:if>
		        
				<div class="write-buttons">
					<button type="button" class="btn-cancel" id="cancelBtn">작성 취소</button>
					<button type="submit" class="btn-submit" id="submitBtn">
		               ${isUpdate ? '수정 완료' : '작성 완료'}
		            </button>
				</div>

				<!-- 카테고리 -->
				<div class="form-group">
			    <label>카테고리 선택</label>
			    <form:select path="communityCd" cssClass="select-category" id="category" required="required">
				  <form:option value="">카테고리 선택</form:option>
				  
				  <c:forEach var="entry" items="${applicationScope.communityTypeMap}">
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

				<!-- 첨부파일 -->
				<div class="form-group file-group">
				    <label>첨부파일</label>
				   
				    <div class="file-attach-area">
				        <div id="file-list-display" class="file-list-display">
				        	 <c:if test="${isUpdate and not empty c.imgList}">
		                        <c:forEach items="${c.imgList}" var="img">
		                            <div class="file-preview-item existing">
		                                <img src="${pageContext.request.contextPath}${img.changeName}">
		                                <span class="file-name">${img.originName}</span>
		                                <span class="remove-existing-file" data-img-no="${img.communityImgNo}">&times;</span>
		                            </div>
		                        </c:forEach>
		                    </c:if>
				        </div>
				
				        <label for="fileInput" class="file-label">파일선택</label>
				        <input type="file" id="fileInput" name="upfile" multiple accept="image/*" style="display: none;">
				    </div>
				</div>
			</form:form>
		</div>

	</div>

	<script>
	$(document).ready(function () {
		const contextPath = "${pageContext.request.contextPath}";
		const form = $('#enrollForm');
	
	    const isUpdate = ${not empty c.communityNo};
	    
	    //=========================================태그=========================================
	    //태그 관련 변수
	    let tags = [];
	    const $tagInput = $('#tagInput');
	    const $tagList = $('#tagList');
	    
	 	// 수정 모드
	    if (isUpdate) {
	        <c:if test="${not empty c.tags}">
	            <c:forEach var="tag" items="${c.tags}">
	                // 1) JavaScript 배열에 태그 이름을 추가합니다.
	                tags.push("${fn:escapeXml(tag.tagContent)}");

	                // 2) 화면에 태그 요소를 만들어서 보여줍니다.
	                const $tag = $('<span class="tag"></span>');
	                const $removeBtn = $('<span class="remove-tag">&times;</span>').attr('data-tag', "${fn:escapeXml(tag.tagContent)}");
	                $tag.text('#' + "${fn:escapeXml(tag.tagContent)}").append($removeBtn);
	                $tagList.append($tag);
	            </c:forEach>
	        </c:if>
	    }
	    
	 	// 태그 입력 (엔터 키)
	    $tagInput.on('keypress', function (e) {
	        if (e.which === 13) {
	            e.preventDefault();
	            const newTag = $(this).val().trim();
	            if (newTag === '') { return alert('태그 내용을 입력해주세요.'); }
	            if (tags.includes(newTag)) { return alert('이미 추가된 태그입니다.'); }
	            if (tags.length >= 5) { return alert("태그는 최대 5개까지 추가할 수 있습니다."); }
	            
	            tags.push(newTag);
	            const $tag = $('<span class="tag"></span>');
	            const $removeBtn = $('<span class="remove-tag">&times;</span>').attr('data-tag', newTag);
	            $tag.text('#' + newTag).append($removeBtn);
	            $tagList.append($tag);
	            $(this).val('');
	        }
	    });
	 	
	 	// 태그 삭제 (X 버튼 클릭)
	    $(document).on('click', '.remove-tag', function () {
	        const tagToRemove = $(this).data('tag');
	        tags = tags.filter(t => t !== tagToRemove);
	        $(this).parent().remove();
	    });
	    
	 	
	 	//===============================이미지=====================================
	 	// 기존 이미지 삭제 (수정 모드일 때만)
	    $('#file-list-display').on('click', '.remove-existing-file', function() {
	        const imgNo = $(this).data('img-no');
	        $(this).parent('.file-preview-item').remove();
	        // 삭제할 이미지 번호를 form에 hidden input으로 추가
	        form.append(`<input type="hidden" name="deleteImgNos" value="${imgNo}">`);
	    });
	
	    // 새 파일 선택 시 미리보기
	    $('#fileInput').on('change', function(event) {
	        const files = event.target.files;
	        const fileListDisplay = $('#file-list-display');
	        
	        // 이전에 추가됐던 '새로운' 파일 미리보기만 삭제 (기존 파일은 유지)
	        fileListDisplay.find('.file-preview-item:not(.existing)').remove();
	
	        if (files.length > 0) {
	            Array.from(files).forEach(file => {
	                const reader = new FileReader();
	                reader.onload = function(e) {
	                    const fileItem = $('<div class="file-preview-item"></div>');
	                    const img = $('<img>').attr('src', e.target.result);
	                    const fileName = $('<span class="file-name"></span>').text(file.name);
	                    fileItem.append(img).append(fileName);
	                    fileListDisplay.append(fileItem);
	                };
	                reader.readAsDataURL(file);
	            });
	        }
	    });
	 	
	    
	    //================================= 폼 전송 & 취소 ===========================================
	    // 폼 전송 시, 태그 데이터를 hidden input에 담아 함께 보냄
	    $('#enrollForm').on('submit', function() {
	        const tagString = tags.join(',');
	        if ($('#tagHiddenInput').length === 0) {
	            form.append('<input type="hidden" id="tagHiddenInput" name="tagStr">');
	        }
	        $('#tagHiddenInput').val(tagString);
	    });
	    
	    // 작성 취소 버튼
	    $('#cancelBtn').on('click', function () {
	        if (confirm('작성을 취소하시겠습니까?')) {
	            history.back(); // 이전 페이지(목록 또는 상세보기)로 이동
	        }
	    });	
	 	
	 	
	    
	});
</script>


</body>
</html>