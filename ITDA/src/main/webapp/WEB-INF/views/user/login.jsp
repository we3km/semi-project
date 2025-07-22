<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>로그인</title>
    <style>
        .image1 {
            width: 300px;
            height: 200px;
            margin: auto;
            margin-top: 60px;
            border: 1px solid black;
        }
        .main {
            width: 300px;
            height: 500px;
            margin: auto;
            font-size: 12px;
        }
        #user-id, #user-pwd, #login-try {
            width: 300px;
            height: 30px;
            margin-bottom: 5px;
        }
    </style>
</head>
<body>
    <div class="image1"></div>
    <br>
    <div class="main">
        <form action="${pageContext.request.contextPath}/user/login" method="post">
            <input id="user-id" name="username" placeholder="아이디 또는 이메일" maxlength="12" required><br>
            <input type="password" id="user-pwd" name="password" placeholder="비밀번호" maxlength="15"><br>
            <input type="checkbox" id="login-keep" name="remember-me"> 로그인 상태 유지<br>
            <input type="submit" id="login-try" value="IT다 로그인"><br>
        </form>
        <a href="${pageContext.request.contextPath}/signup/terms">회원가입</a>
        <a href="${pageContext.request.contextPath}/user/findId">아이디 찾기</a>
        <a href="${pageContext.request.contextPath}/user/findPwd">비밀번호 찾기</a>
        <br><br>
        <input type="button" id="from-google" value="Google로 로그인"><br><br>
        <input type="button" id="from-naver" value="Naver로 로그인">
    </div>
</body>
</html>
