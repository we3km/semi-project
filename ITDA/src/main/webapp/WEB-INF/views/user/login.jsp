<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
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
        <form action="${pageContext.request.contextPath}/user/loginprocess" method="post">
            <input id="user-id" name="userId" placeholder="아이디 또는 이메일" maxlength="12" required autocomplete="username"><br>
            <input type="password" id="user-pwd" name="userPwd" placeholder="비밀번호" maxlength="15"><br>
            <input type="checkbox" id="login-keep" name="remember-me"> 로그인 상태 유지<br>
            <input type="submit" id="login-try" value="IT다 로그인"><br>
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        </form>
        <a href="${pageContext.request.contextPath}/user/join/terms">회원가입</a>
        <a href="${pageContext.request.contextPath}/user/findId">아이디 찾기</a>
        <a href="${pageContext.request.contextPath}/user/findPwd">비밀번호 찾기</a>
        <br><br>
        <input type="button" id="from-google" value="Google로 로그인"><br><br>
        <input type="button" id="from-naver" value="Naver로 로그인">
    </div>
</body>
</html>
