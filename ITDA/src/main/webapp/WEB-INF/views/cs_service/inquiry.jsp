<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html lang="ko">

<head>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<meta charset="utf-8" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/cs_service/inquiry.css" />
<title>1:1 문의</title>
</head>

<body>
	<main class="box">
		<section class="group">
			<div class="overlap">
				<h1 class="element">
					<span class="text-wrapper">1:1 </span> <span class="span">문의</span>
				</h1>

				<form:form
					action="${pageContext.request.contextPath}/cs/inquiry/insert"
					method="post" enctype="multipart/form-data"
					modelAttribute="inquiryForm">
					<form:hidden path="userNum" value="2" />

					<label for="title" class="div">제목</label>
					<form:input path="csTitle" id="title" cssClass="rectangle"
						required="required" />

					<label for="category" class="text-wrapper-2">카테고리</label>
					<div class="overlap-group-wrapper">
						<div class="overlap-group">
							<form:select path="categoryId" id="category"
								cssClass="rectangle-2" required="required">
								<form:option value="" label="문의 카테고리를 선택해주세요" disabled="true" />
								<form:option value="1" label="회원정보" />
								<form:option value="2" label="거래관련" />
								<form:option value="3" label="신고처리" />
								<form:option value="4" label="건의사항" />
								<form:option value="5" label="기타" />
							</form:select>
						</div>
					</div>

					<label for="content">내용</label>
					<form:textarea path="csContent" id="content" cssClass="content"
						required="required" />

					<label for="file" class="text-wrapper-3">첨부파일</label>
					<div class="overlap-2">
						<input type="file" id="file" name="file" class="rectangle-3"
							accept=".pdf,.doc,.docx,.jpg,.png" />
					</div>

					<button type="submit" class="overlap-wrapper">
						<span>제출</span>
					</button>
					<button type="button" class="overlap-wrapper-1"
						onclick="location.href='${pageContext.request.contextPath}/cs'">뒤로가기
					</button>
				</form:form>
				<c:if test="${not empty errorMsg or not empty successMsg}">
					<script>
						window.onload = function() {
							var errorMsg = '${errorMsg}';
							var successMsg = '${successMsg}';

							if (errorMsg) {
								alert("에러: " + errorMsg);
							} else if (successMsg) {
								alert("성공: " + successMsg);
							}
						};
					</script>
				</c:if>
		</section>
	</main>
</body>

</html>