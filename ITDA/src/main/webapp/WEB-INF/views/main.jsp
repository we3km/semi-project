<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>잇다 메인화면</title>
<style>
	body {
		font-family: Arial, sans-serif;
		background-color: #f7f7f7;
		text-align: center;
		padding-top: 100px;
	}
	h1 {
		color: #333;
	}
	.btn {
		padding: 10px 20px;
		margin: 10px;
		background-color: #4CAF50;
		color: white;
		border: none;
		border-radius: 5px;
		cursor: pointer;
		text-decoration: none;
	}
	.btn:hover {
		background-color: #45a049;
	}
</style>
</head>
<body>

	<h1>잇다 메인화면</h1>

	<c:choose>
		<c:when test="${not empty loginUser}">
			<p><strong>${loginUser.nickName}</strong>님 환영합니다!</p>
			<p><strong>${loginUser.userNum}</strong> 회원 번호</p>
			<p><strong>${loginUser.userId}</strong> 회원 아이디</p>
			<a href="${pageContext.request.contextPath}/user/logout" class="btn">로그아웃</a>
			<a href="${pageContext.request.contextPath}/chat/chatroomlist" class="btn">채팅방 리스트</a>
		</c:when>
		<c:otherwise>
			<p>로그인이 필요합니다.</p>
			<a href="${pageContext.request.contextPath}/user/login" class="btn">로그인</a>
		</c:otherwise>
	</c:choose>

</body>
</html>
