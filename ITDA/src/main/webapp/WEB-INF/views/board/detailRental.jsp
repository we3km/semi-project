<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>${product.title}</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 0;
      padding: 20px;
      background: #f9f9f9;
    }

    .container {
      max-width: 1200px;
      margin: auto;
      background: #fff;
      padding: 20px;
    }

    .top-section {
      display: flex;
      flex-wrap: wrap;
      gap: 20px;
    }

    .image-preview, .info {
      flex: 1 1 300px;
    }

    .image-preview img {
      width: 100%;
      border-radius: 12px;
    }

    .info h1 {
      font-size: 24px;
      margin-bottom: 10px;
    }

    .price, .date-range, .location {
      margin: 5px 0;
      font-size: 16px;
    }

    .keywords span {
      background: #eef;
      padding: 5px 10px;
      border-radius: 12px;
      margin-right: 5px;
      font-size: 13px;
      display: inline-block;
    }

    .seller-info {
      margin: 20px 0;
      display: flex;
      align-items: center;
    }

    .buttons button {
      margin-right: 10px;
      padding: 8px 14px;
      background: #4a4aff;
      color: #fff;
      border: none;
      border-radius: 5px;
      cursor: pointer;
    }

    .related-products {
      margin-top: 30px;
    }

    .product-list {
      display: flex;
      overflow-x: auto;
      gap: 10px;
    }

    .product-item {
      flex: 0 0 auto;
      width: 150px;
      background: #fdfdfd;
      border: 1px solid #ddd;
      padding: 10px;
      border-radius: 8px;
      text-align: center;
    }

    .product-item img {
      width: 100%;
      border-radius: 6px;
    }

    .description {
      margin-top: 30px;
    }

    .description pre {
      white-space: pre-wrap;
      background: #f1f1f1;
      padding: 16px;
      border-radius: 8px;
    }

    @media screen and (max-width: 768px) {
      .top-section {
        flex-direction: column;
      }
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="top-section">
      <div class="image-preview">
        <img src="${product.imageUrl}" alt="${product.title}" />
      </div>
      <div class="info">
        <h1>${board.boardCommon.productName}</h1>
        <div class="views">조회수:${board.boardCommon.views}</div>
        <div class="dibs">찜 수:<p id="dibCount">${dibsCount}</p></div>
        <div class="product-catrgory">
	        <div class="product-category-large">${board.boardCommon.productCategoryL}</div>
	        >
	        <div class="product-category-middle">${board.boardCommon.productCategoryM}</div>
	        >
	        <div class="product-category-small">${board.boardCommon.productCategoryS}</div>
        </div>
        <div class="create-date">
        게시날짜: <fmt:formatDate value="${board.boardCommon.createDate }" pattern="yyyy/MM/dd"/> 
        </div>
        
        <div class="price">대여금액 : ${board.boardRental.rentalFee}원</div>
        <div class="date-range">대여기간 : <fmt:formatDate value="${board.boardRental.rentalStartDate }" pattern="yyyy/MM/dd"/>~<fmt:formatDate value="${board.boardRental.rentalEndDate }" pattern="yyyy/MM/dd"/></div>
        <div class="location">지역 : ${board.boardCommon.transactionAddress}</div>
        <div class="keywords">
          <c:forEach var="tag" items="${tags}">
            <span>#${tag}</span>
          </c:forEach>
        </div>
        <div class="seller-info">
          <strong>${writer} </strong>
          <p> 매너점수 : ${mannerScore }</p>
        </div>
        <div class="buttons">
          <button>개인 메시지 보내기</button>
          <button>대화하기</button>
          <button id="dibsBtn">찜</button>
        </div>
      </div>
    </div>
    <script>
    	$('#dibsBtn').on('click', function () {
        	$.ajax({
          	type: 'POST',
          	url: '${pageContext.request.contextPath}/board/addDibs',
          	data: {
          	  userId: 1,
          	  boardId: '${boardId}',
          	  boardCategory: 'rental'
         	 },
         	 success: function (res) {
         		 console.log(res);
         	   if (res === 'liked') {
        	      $('#likeBtn').addClass('liked').removeClass('not-liked');
        	    } else {
        	      $('#likeBtn').removeClass('liked').addClass('not-liked');
        	    }
         	// 찜을 누르면 바로 찜수 변경 확인
	             $.ajax({
	               type: 'GET',
	               url: '${pageContext.request.contextPath}/board/dibsCount',
	               data: { boardId: '${boardId}' },
	               success: function (count) {
	                 $('#dibCount').text(count);
	               }
	             });
         	 },
         	 error: function (err) {   
         	    console.error(err);
         	  }
           
         	 
           });
    	});
    </script>

    <div class="related-products">
      <h2>${writer} 님의 다른 상품들</h2>
      <div class="product-list">
        <c:forEach var="item" items="${relatedProducts}">
          <div class="product-item">
            <img src="${item.imageUrl}" alt="${item.title}" />
            <div class="title">${item.title}</div>
            <div class="price">보증금 : ${item.deposit}원</div>
            <div class="date">${item.startDate} ~ ${item.endDate}</div>
          </div>
        </c:forEach>
      </div>
    </div>

    <div class="description">
      <h3>상품정보</h3>
      <pre>${board.boardCommon.productComment}</pre>
    </div>
  </div>
</body>
</html>