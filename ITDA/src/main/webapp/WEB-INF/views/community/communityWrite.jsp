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
				        <div id="file-list-display" class="file-list-display">
				        	 <c:if test="${isUpdate and not empty c.imgList}">
		                        <c:forEach items="${c.imgList}" var="img">
		                            <div class="file-preview-item existing">
		                                <img src="${pageContext.request.contextPath}/resources/images/community/${c.communityCd}/${img.changeName}">
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
	    	<c:forEach var="tag" items="${c.tags}">
		        (function() {
		            tags.push("${fn:escapeXml(tag.tagContent)}");
		            const tagName = "${fn:escapeXml(tag.tagContent)}";
		            const $removeBtn = $('<span class="remove-tag">&times;</span>').attr('data-tag', tagName);
		            const $tag = $('<span class="tag"></span>').text('#' + tagName).append($removeBtn);
		            $tagList.append($tag);
		        })();
		    </c:forEach>
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
	            const $newTagElement = $('<span class="tag"></span>');
	            const $removeBtn = $('<span class="remove-tag">&times;</span>').attr('data-tag', newTag);
	            $newTagElement.text('#' + newTag).append($removeBtn);
	            $tagList.append($newTagElement);
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
	 		
 		const MAX_FILES = 5;
	 	
		let newFiles = []; // 새로 추가된 파일들을 관리하는 배열
		const fileListDisplay = $('#file-list-display');
		const fileInput = $('#fileInput');
		
		//파일 선택시 파일 개수 체트
		 $('.file-label').on('click', function(e) {
	        const existingImgCount = $('.file-preview-item.existing').length;
	        const newImgCount = newFiles.length;
	        if (existingImgCount + newImgCount >= MAX_FILES) {
	            alert('이미지는 최대 ' + MAX_FILES + '개까지 첨부할 수 있습니다.');
	            e.preventDefault(); // 파일 선택창이 열리는 것을 막음
	        }
	    });
		
	 	// 기존 이미지 삭제 (수정 모드일 때만)
	    fileListDisplay.on('click', '.remove-existing-file', function() {
		    var imgNo = $(this).data('img-no');
		    // 화면에서 미리보기 제거
		    $(this).parent('.file-preview-item').remove();
		    // 서버에 삭제할 이미지 번호를 보내기 위해 hidden input 추가
		    form.append('<input type="hidden" name="deleteImgNos" value="' + imgNo + '">');
		});
	
	    // 새 파일 선택 시 미리보기
	    $('#fileInput').on('change', function(event) {
	    	
	    	// 사용자가 선택한 파일들 (읽기 전용 FileList)
	        var selectedFiles = event.target.files;
	        if (!selectedFiles.length) {
	            return;
	        }

	        // 현재 화면의 파일 개수 계산
	        var existingImgCount = $('.file-preview-item.existing').length;
	        var currentNewFilesCount = newFiles.length;

	        // 최대 개수 초과 확인
	        if (existingImgCount + currentNewFilesCount + selectedFiles.length > MAX_FILES) {
	            alert('이미지는 최대 ' + MAX_FILES + '개까지 첨부할 수 있습니다.');
	            fileInput.val(''); // 파일 선택 초기화
	            return;
	        }

	        // 선택된 파일들을 순회
	        for (var i = 0; i < selectedFiles.length; i++) {
	            var file = selectedFiles[i];
	            
	            // 이미지 파일인지 확인
	            if (!file.type.startsWith('image/')) {
	                continue; // 이미지 파일이 아니면 다음 파일로 넘어감
	            }

	            // 파일 장바구니(배열)에 파일 추가
	            newFiles.push(file);

	            // FileReader를 사용해 이미지 미리보기 생성
	            var reader = new FileReader();
	            reader.onload = function(e) {
	                // 미리보기 HTML 문자열 생성 (백틱 대신 + 연산자 사용)
	                var previewItemHtml = 
	                    '<div class="file-preview-item new-file">' +
	                        '<img src="' + e.target.result + '">' +
	                        '<span class="file-name">' + file.name + '</span>' +
	                        '<span class="remove-new-file" title="삭제">&times;</span>' +
	                    '</div>';
	                
	                // 생성된 미리보기를 화면에 추가
	                fileListDisplay.append(previewItemHtml);
	            };
	            // 파일을 읽어 Data URL로 변환 (onload 이벤트 발생)
	            reader.readAsDataURL(file);
	        }

	        // 사용자가 동일한 파일을 다시 선택할 수 있도록 input의 값을 초기화
	        fileInput.val('');
	    });
	    fileListDisplay.on('click', '.remove-new-file', function() {
	        // 클릭된 'x' 버튼의 부모 div (미리보기 아이템)
	        var itemToRemove = $(this).parent('.file-preview-item');
	        
	        // 화면의 '새로운 파일' 목록 중에서 몇 번째 아이템인지 인덱스 찾기
	        var itemIndex = itemToRemove.index('.file-preview-item.new-file');
	        
	        // 인덱스를 찾았을 경우
	        if (itemIndex > -1) {
	            // 파일 장바구니(배열)에서 해당 인덱스의 파일 제거
	            newFiles.splice(itemIndex, 1);
	        }
	        
	        // 화면에서 미리보기 아이템 제거
	        itemToRemove.remove();
	    });
	 	
	    
	    //================================= 폼 전송 & 취소 ===========================================
	    // 폼 전송 시, 태그 데이터를 hidden input에 담아 함께 보냄
	    $('#enrollForm').on('submit', function() {
	    	// --- 1. 태그(Tag) 최종 처리 (기존 로직) ---
	        var tagString = tags.join(','); // 'tags' 배열은 스크립트 상단에 정의되어 있어야 합니다.
	        // form에 hidden input이 없으면 새로 추가
	        if ($('#tagHiddenInput').length === 0) {
	            form.append('<input type="hidden" id="tagHiddenInput" name="tagStr">');
	        }
	        // hidden input에 최종 태그 목록을 값으로 설정
	        $('#tagHiddenInput').val(tagString);


	        // --- 2. 이미지(Image) 최종 처리 (새로 추가된 로직) ---
	        // DataTransfer 객체 생성 (파일을 담는 임시 컨테이너)
	        var dataTransfer = new DataTransfer();

	        // 파일 장바구니(newFiles 배열)에 있는 모든 파일을 dataTransfer에 추가
	        // 'newFiles' 배열은 이미지 스크립트 부분에 정의되어 있어야 합니다.
	        newFiles.forEach(function(file) {
	            dataTransfer.items.add(file);
	        });

	        // 최종 정리된 파일 목록을 원래의 <input type="file">의 files 속성에 할당
	        $('#fileInput')[0].files = dataTransfer.files;

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