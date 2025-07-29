<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<title>잇다 로그인</title>
	<style>
		body {
			font-family: Arial, sans-serif;
			margin: 50px;
		}
		form {
			border: 1px solid #ccc;
			padding: 20px;
			width: 300px;
		}
		input {
			width: 100%;
			padding: 8px;
			margin-top: 10px;
		}
		button {
			width: 100%;
			margin-top: 20px;
			padding: 10px;
			background-color: #4CAF50;
			color: white;
			border: none;
		}
		p.error {
			color: red;
			margin-top: 10px;
		}
	</style>
</head>
<body>
	<h2>잇다 로그인</h2>
	<form action="${pageContext.request.contextPath}/user/login" method="post">
		<label for="userId">아이디</label>
		<input type="text" id="userId" name="userId" autocomplete="username" required>

		<label for="userPwd">비밀번호</label>
		<input type="password" id="userPwd" name="userPwd" autocomplete="current-password" required>

		<button type="submit">로그인</button>

		<c:if test="${not empty msg}">
			<p class="error">${msg}</p>
		</c:if>
	</form>
</body>
</html>
