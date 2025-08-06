<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <meta charset="utf-8" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/mypageOther.css" />
</head>
<body>
  <div class="div-wrapper">
    <div class="div">
      <!-- 상단 뷰 -->
      <div class="view">
        <img class="chain" src="${pageContext.request.contextPath}/resources/img/chain.png" />
        <div class="view-2">
          <div class="search">
            <img class="icon" src="${pageContext.request.contextPath}/resources/img/icon.svg" />
          </div>
          <div class="text-wrapper-12">교환 게시판 검색</div>
          <div class="overlap-group-wrapper">
            <div class="overlap-group-3">
              <div class="group-21"><div class="text-wrapper-13">카테고리</div></div>
              <img class="arrow-drop-down" src="${pageContext.request.contextPath}/resources/img/arrow-drop-down.svg" />
            </div>
          </div>
        </div>
        <div class="view-wrapper">
          <div class="view-3">
            <div class="overlap-group-4">
              <div class="group-22"><div class="text-wrapper-14">${nickname}님 반갑습니다!</div></div>
              <img class="bell" src="${pageContext.request.contextPath}/resources/img/bell.svg" />
              <img class="chat-bubble" src="${pageContext.request.contextPath}/resources/img/chat-bubble.svg" />
            </div>
          </div>
        </div>
        <div class="navbar">
          <div class="text-wrapper-15">대여</div>
          <div class="text-wrapper-16">경매</div>
          <div class="text-wrapper-17">교환</div>
          <div class="text-wrapper-18">나눔</div>
          <div class="text-wrapper-19">커뮤니티</div>
        </div>
        <div class="text-wrapper-20">로그아웃</div>
        <div class="text-wrapper-21">마이페이지</div>
        <div class="text-wrapper-22">고객센터</div>
      </div>

      <div class="overlap-22">
        <div class="text-wrapper-23">
          닉네임
          <text style="font-weight: 500; color: #5a54ff; font-size: 35px; text-shadow: 0px 2px 2px #00000040;">
            ${nickname}님의 프로필
          </text>
        </div>
      </div>

      <img class="img" src="${pageContext.request.contextPath}/resources/img/vector-157.svg" />

      <!-- 대여 게시글 -->
      <p class="rnrdj">
        <span class="span">${nickname}</span> <span class="text-wrapper-4"> 님이 등록한 대여게시글</span>
      </p>

      <c:forEach var="rental" items="${rentalPosts}" varStatus="loop">
        <div class="group-5" style="left: ${loop.index * 233}px;">
          <div class="overlap"><img class="vector" src="${pageContext.request.contextPath}/resources/img/${rental.image}" /></div>
          <div class="overlap-group">
            <div class="text-wrapper">${rental.title}</div>
          </div>
          <div class="overlap-2">
            <div class="text-wrapper-2">보증금 : ${rental.deposit}원</div>
          </div>
          <div class="overlap-group-2">
            <div class="text-wrapper-3">${rental.period}</div>
          </div>
        </div>
      </c:forEach>

      <!-- 경매 게시글 -->
      <p class="p">
        <span class="span">${nickname}</span> <span class="text-wrapper-4"> 님이 등록한 경매게시글</span>
      </p>

      <c:forEach var="auction" items="${auctionPosts}" varStatus="loop">
        <div class="group-10" style="left: ${loop.index * 233}px;">
          <div class="overlap"><img class="vector" src="${pageContext.request.contextPath}/resources/img/${auction.image}" /></div>
          <div class="overlap-group">
            <div class="text-wrapper">${auction.title}</div>
          </div>
          <div class="overlap-2">
            <div class="text-wrapper-2">보증금 : ${auction.deposit}원</div>
          </div>
          <div class="overlap-group-2">
            <div class="text-wrapper-3">${auction.period}</div>
          </div>
        </div>
      </c:forEach>

      <!-- 나눔 게시글 -->
      <p class="rnrdj-2">
        <span class="span">${nickname}</span> <span class="text-wrapper-4"> 님이 등록한 나눔게시글</span>
      </p>

      <c:forEach var="share" items="${sharePosts}" varStatus="loop">
        <div class="group-15" style="left: ${loop.index * 233}px;">
          <div class="overlap"><img class="vector" src="${pageContext.request.contextPath}/resources/img/${share.image}" /></div>
          <div class="overlap-group">
            <div class="text-wrapper">${share.title}</div>
          </div>
          <div class="overlap-2">
            <div class="text-wrapper-2">보증금 : ${share.deposit}원</div>
          </div>
          <div class="overlap-group-2">
            <div class="text-wrapper-3">${share.period}</div>
          </div>
        </div>
      </c:forEach>

    </div>
  </div>
</body>
</html>
