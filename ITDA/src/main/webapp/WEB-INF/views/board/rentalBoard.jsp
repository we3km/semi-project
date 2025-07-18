<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<head>
  <meta charset="UTF-8">
  <title>대여 게시판</title>
  <style>
    * {
      box-sizing: border-box;
      font-family: 'Arial', sans-serif;
    }

    body {
      margin: 0;
      display: flex;
      background-color: #f9f9f9;
    }

    .sidebar {
      width: 250px;
      background-color: white;
      padding: 20px;
      border-right: 1px solid #ddd;
    }

    .sidebar h3 {
      margin-bottom: 10px;
      font-size: 16px;
    }

    .filter-section {
      margin-bottom: 25px;
    }

    .filter-section label {
      display: block;
      margin-bottom: 5px;
    }

    .main {
      flex: 1;
      padding: 30px;
      position: relative;
    }

    .header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 20px;
    }

    .header h2 {
      font-size: 28px;
      margin: 0;
    }

    .header .location {
      color: #9d83ff;
      font-weight: bold;
      margin-left: 10px;
    }

    .write-btn {
      background-color: #6657ff;
      color: white;
      padding: 10px 18px;
      border: none;
      border-radius: 12px;
      font-weight: bold;
      cursor: pointer;
    }

    .grid {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 20px;
    }

    .card {
      background-color: white;
      padding: 15px;
      border-radius: 12px;
      text-align: center;
      box-shadow: 0 0 5px rgba(0,0,0,0.1);
      position: relative;
    }

    .card img {
      width: 100%;
      max-width: 180px;
      height: auto;
    }

    .card .heart {
      position: absolute;
      top: 10px;
      right: 10px;
      font-size: 20px;
      cursor: pointer;
    }

    .card p {
      margin: 5px 0;
    }

    .price {
      font-weight: bold;
    }

    input[type="range"] {
      width: 100%;
    }

    input[type="date"] {
      width: 100%;
      margin-top: 5px;
      margin-bottom: 5px;
    }

  </style>
</head>
<body>

  <div class="sidebar">
    <div class="filter-section">
      <h3>정렬 조건</h3>
    </div>

    <div class="filter-section">
      <h4>지역</h4>
      <label><input type="checkbox"> 강남</label>
      <label><input type="checkbox"> 강서</label>
      <label><input type="checkbox"> 강동</label>
      <label><input type="checkbox"> 강북</label>
    </div>

    <div class="filter-section">
      <h4>상품유형</h4>
      <label><input type="checkbox"> 의류</label>
      <label><input type="checkbox"> 전자기기</label>
      <label><input type="checkbox"> 생활가전</label>
      <label><input type="checkbox"> 가구</label>
      <label><input type="checkbox"> 도서</label>
      <label><input type="checkbox"> 뷰티</label>
      <label><input type="checkbox"> 식품</label>
      <label><input type="checkbox"> 스포츠</label>
    </div>

    <div class="filter-section">
      <h4>가격</h4>
      <label>5,000원 ~ 30,000원</label>
      <input type="range" min="5000" max="30000" value="15000">
    </div>

    <div class="filter-section">
      <h4>대여 기간</h4>
      <input type="date" value="2025-07-01">
      <input type="date" value="2025-07-10">
    </div>
  </div>

  <div class="main">
    <div class="header">
      <div>
        <h2>대여 게시판</h2>
        <span class="location">서울특별시 강남구 📍</span>
      </div>
      <!-- 글쓰기를 클릭했을 때의 url에 컨트롤러에서 사용할 boardCategory를 지정해준다 -->
      <button class="write-btn"><a href="write/rental">거래 글 쓰기</a></button>
    </div>

    <div class="grid">
      <!-- 카드 반복 -->
      <div class="card">
        <div class="heart">♡</div>
        <img src="https://via.placeholder.com/180x120.png?text=DSLR" alt="DSLR">
        <p>DSLR 대여해드립니다</p>
        <p class="price">보증금 : 40,000원</p>
        <p>2025/07/05~2025/08/06</p>
      </div>

      <!-- 동일한 카드 복사 -->
      <div class="card">
        <div class="heart">♡</div>
        <img src="https://via.placeholder.com/180x120.png?text=DSLR" alt="DSLR">
        <p>DSLR 대여해드립니다</p>
        <p class="price">보증금 : 40,000원</p>
        <p>2025/07/05~2025/08/06</p>
      </div>

      <div class="card">
        <div class="heart">♡</div>
        <img src="https://via.placeholder.com/180x120.png?text=DSLR" alt="DSLR">
        <p>DSLR 대여해드립니다</p>
        <p class="price">보증금 : 40,000원</p>
        <p>2025/07/05~2025/08/06</p>
      </div>

      <div class="card">
        <div class="heart">♡</div>
        <img src="https://via.placeholder.com/180x120.png?text=DSLR" alt="DSLR">
        <p>DSLR 대여해드립니다</p>
        <p class="price">보증금 : 40,000원</p>
        <p>2025/07/05~2025/08/06</p>
      </div>

      <div class="card">
        <div class="heart">♡</div>
        <img src="https://via.placeholder.com/180x120.png?text=DSLR" alt="DSLR">
        <p>DSLR 대여해드립니다</p>
        <p class="price">보증금 : 40,000원</p>
        <p>2025/07/05~2025/08/06</p>
      </div>

      <div class="card">
        <div class="heart">♡</div>
        <img src="https://via.placeholder.com/180x120.png?text=DSLR" alt="DSLR">
        <p>DSLR 대여해드립니다</p>
        <p class="price">보증금 : 40,000원</p>
        <p>2025/07/05~2025/08/06</p>
      </div>
    </div>
  </div>



</body>
</html>