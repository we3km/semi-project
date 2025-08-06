<%@ page language="java" contentType="text/html;charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<style>
body {
	font-family: 'Noto Sans KR', sans-serif;
	background: white;
	display: flex;
	justify-content: center;
	align-items: center;
	height: 100vh;
}
.login-container {
	width: 400px;
	text-align: center;
}
h1 {
	font-size: 48px;
	color: #5A5CFF;
	margin-bottom: 30px;
}
h2 {
	font-size: 24px;
	color: #555;
	margin-bottom: 10px;
}
input[type="text"], input[type="password"] {
	width: 100%;
	padding: 12px;
	margin-bottom: 10px;
	border: 1px solid #ccc;
	box-sizing: border-box;
	font-size: 14px;
}
.checkbox-wrap {
	text-align: left;
	margin: 10px 0;
}
.checkbox-wrap label {
	font-size: 14px;
	color: #333;
}
.badge {
	background-color: gold;
	color: black;
	font-weight: bold;
	padding: 2px 6px;
	border-radius: 3px;
	margin-right: 5px;
}
.login-btn {
	width: 100%;
	background-color: #5A5CFF;
	color: white;
	padding: 12px;
	font-size: 16px;
	border: none;
	cursor: pointer;
	margin-top: 10px;
}
.itda-text {
	color: white;
	margin-right: 4px;
}
.login-text {
	background-color: yellow;
	color: black;
	padding: 2px 6px;
	border-radius: 3px;
}
.links {
	margin-top: 10px;
	font-size: 13px;
}
.links a {
	color: #555;
	text-decoration: none;
	margin: 0 5px;
}
.social-login {
	margin-top: 20px;
}
.social-login button {
	width: 100%;
	padding: 10px;
	margin-top: 8px;
	border: 1px solid #ddd;
	font-size: 14px;
	cursor: pointer;
	background-color: white;
	.
	google
	{
	background-color
	:
	#FFFFFF;
}
.naver {
	background-color: #E5F3E5;
}
</style>
</head>
<body>
<<<<<<< HEAD

=======
	<c:if test="${param.error == 'true'}">
		<script>
			alert("${param.message != null ? param.message : '아이디 또는 비밀번호가 틀렸습니다.'}");
		</script>
	</c:if>
>>>>>>> main
	<div class="login-container">
		<h2>세상을</h2>
		<h1>IT다</h1>

		<form action="${pageContext.request.contextPath}/user/loginprocess"
			method="post">
			<input type=text id="user-id" name="userId" placeholder="아이디 또는 이메일"
				maxlength="12" required autocomplete="username"><br> <input
				type="password" id="user-pwd" name="userPwd" placeholder="비밀번호"
				maxlength="15"><br>
<<<<<<< HEAD

=======
>>>>>>> main
			<div class="checkbox-wrap">
				<input type="checkbox" name="rememberMe" id="rememberMe"> <label
					for="rememberMe"> <span class="badge">로그인</span> 상태 유지
				</label>
			</div>
<<<<<<< HEAD

=======
>>>>>>> main
			<button type="submit" class="login-btn">
				<span class="itda-text">IT다</span><span class="login-text">로그인</span>
			</button>
		</form>
<<<<<<< HEAD

=======
>>>>>>> main
		<div class="links">
			<a href="${pageContext.request.contextPath}/user/join/terms">회원가입</a>
			<a href="${pageContext.request.contextPath}/user/findId">아이디 찾기</a> <a
				href="${pageContext.request.contextPath}/user/findPwd">비밀번호 찾기</a>
		</div>
	</div>
</body>
</html>