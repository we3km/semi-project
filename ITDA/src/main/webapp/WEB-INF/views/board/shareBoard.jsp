<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>나눔 게시판</title>
<style>

    * {
      box-sizing: border-box;
      font-family: 'Arial', sans-serif;
    }

    body {
      margin: 0;
      display: flex;
      flex-direction:column;      
      background-color: white;
    }
    
    .container{
    	margin: 0;
      display: flex;
      background-color: white;
    }

    .sidebar {
      width: 300px;
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
      padding: 30px 100px;
      position: relative;
    }

    .top {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 20px;
    }

    .top h2 {
      font-size: 28px;
      margin: 0;
    }

    .top .location {
      color: #9d83ff;
      font-weight: bold;
      margin-left: 10px;
    }

    #write-btn {
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
      grid-template-columns: repeat(4, 1fr);
      gap: 20px;
    }

    .card {
      background-color: white;
      padding: 15px;
     	width:250px;
     	height:280px;
      border-radius: 12px;
      text-align: center;
      box-shadow: 0 0 5px rgba(0,0,0,0.1);
      position: relative;
    }

    .card img {
      width: 100%;
      /* max-width: 180px; */
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
	
	#product-name{
		font-size: 20px;
	}
	
    #rental-fee {
      font-weight: bold;
    }
	.date{
		font-size: 10px;
	}

    input[type="range"] {
      width: 100%;
    }

    input[type="date"] {
      width: 100%;
      margin-top: 5px;
      margin-bottom: 5px;
    }
    
    
   .category-large,
.category-middle,
.category-small {
	    flex: 1;
  padding: 8px 12px;
  margin: 5px 5px 0 0;
  border: 1px solid #ccc;
  border-radius: 8px;
  display: inline-block;
  cursor: pointer;
  background-color: #f5f5f5;
  transition: all 0.2s;
}


.category-large.selected,
.category-middle.selected,
.category-small.selected {
  background-color: #007bff;
  color: white;
}

/* 선택된 상태일 때 색상 강조 */
.category-large.active,
.category-middle.active,
.category-small.active {
  background-color: #007bff;
  color: #6657ff;
  border-color: #007bff;
}

.category-wrapper {
    
    gap: 1rem;
    margin-top: 10px;
  }

  .category-column {
  display: flex;
   
    min-height: 100px;
    padding: 10px;
    border: 1px solid #ddd;
    border-radius: 8px;
  }

  .category-column h5 {
    margin-bottom: 10px;
    font-size: 16px;
    color: #555;
  }

  .category-column div {
    margin-bottom: 6px;
    cursor: pointer;
    padding: 5px 8px;
    border-radius: 4px;
    transition: background 0.2s;
  }


  .category-column .active {
    background-color: #007bff;
    color: white;
  }

</style>

<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</head>
<body>

	<div class="wrapper">
		<header class="header">
			<jsp:include page="/WEB-INF/views/common/Header.jsp" />
		</header>
	</div>
	<div class = "container">

	<div class="sidebar">
		<form id="filterForm" method="get"
			action="${pageContext.request.contextPath}/board/share/list">
			<div class="filter-section">
				<h3>정렬 조건</h3>
				<button type="submit" id="filter-btn">정렬</button>
			</div>

			<select name="sort">
				<option value="date">게시일 순</option>
				<option value="views">조회수 순</option>
			</select>

			<div class="filter-section">
			  <div class="category-area">
			    <label>상품 카테고리</label>
			
			    <div class="category-wrapper">
			      <!-- 대분류 -->
			      <div class="category-column">
			        <h5>대분류</h5>
			        <div class="category-list-large">
			          <c:forEach items="${categoryList}" var="productCategory">
			            <c:if test="${productCategory.parentNum == 0}">
			              <div class="category-large" data-id="${productCategory.productCategoryNum}">
			                ${productCategory.categoryName}
			              </div>
			            </c:if>
			          </c:forEach>
			        </div>
			        <input type="hidden" id="categoryLargeHiddenInput" name="boardCommon.productCategoryL" />
			      </div>
			
			      <!-- 중분류 -->
			      <div class="category-column" id="middle" style="display: none;">
			        <h5>중분류</h5>
			        <div id="category-list-middle"></div>
			        <input type="hidden" id="categoryMiddleHiddenInput" name="boardCommon.productCategoryM" />
			      </div>
			
			      <!-- 소분류 -->
			      <div class="category-column" id="small" style="display: none;">
			        <h5>소분류</h5>
			        <div id="category-list-small" ></div>
			        <input type="hidden" id="categorySmallHiddenInput" name="boardCommon.productCategoryS" />
			      </div>
			    </div>
			  </div>
			</div>
			<script>
			  // Helper 함수: 모든 대/중/소 항목에서 active 제거
			  function clearActive(className) {
			    document.querySelectorAll("." + className).forEach(el => el.classList.remove("active"));
			  }
			  const middleCol = document.getElementById("middle");
			  const smallCol = document.getElementById("small");
			  // 대분류 클릭 이벤트
			  document.querySelectorAll('.category-large').forEach(item => {
			    item.addEventListener('click', () => {
			      const parentId = item.dataset.id;
			      const isActive = item.classList.contains("active");
			
			      // 기존 선택 초기화
			      clearActive("category-large");
			      clearActive("category-middle");
			      clearActive("category-small");
			      document.getElementById("category-list-middle").innerHTML = "";
			      document.getElementById("category-list-small").innerHTML = "";
			      document.getElementById("categoryMiddleHiddenInput").value = "";
			      document.getElementById("categorySmallHiddenInput").value = "";
			
			      if (!isActive) {
			        // 활성화
			        item.classList.add("active");
			        document.getElementById("categoryLargeHiddenInput").value = item.textContent.trim();
			        console.log("선택된 대분류: " + item.textContent.trim());
			        middleCol.style.display = "block";     // 중분류 보이기
			        smallCol.style.display = "none";       // 소분류 숨기기
			
			        // 중분류 불러오기
			        fetch("${pageContext.request.contextPath}/board/getSubCategories?parentNum=" + parentId)
			          .then(response => response.json())
			          .then(data => {
			            const middleContainer = document.getElementById("category-list-middle");
			            data.forEach(sub => {
			              const div = document.createElement("div");
			              div.textContent = sub.categoryName;
			              div.classList.add("category-middle");
			              div.setAttribute("data-id", sub.productCategoryNum);
			              middleContainer.appendChild(div);
			            });
			          });
			      } else {
			        // 다시 클릭하면 닫기 (초기화)
			        document.getElementById("categoryLargeHiddenInput").value = "";
			        middleCol.style.display = "none";  // 중분류 숨기기
			        smallCol.style.display = "none";   // 소분류 숨기기
			      }
			    });
			  });
			
			  // 중분류 클릭 이벤트
			  document.getElementById("category-list-middle").addEventListener("click", (e) => {
			    const clicked = e.target;
			    if (!clicked.classList.contains("category-middle")) return;
			
			    const parentId = clicked.dataset.id;
			    const isActive = clicked.classList.contains("active");
			
			    clearActive("category-middle");
			    clearActive("category-small");
			    document.getElementById("category-list-small").innerHTML = "";
			    document.getElementById("categorySmallHiddenInput").value = "";
			
			    if (!isActive) {
			      clicked.classList.add("active");
			      document.getElementById("categoryMiddleHiddenInput").value = clicked.textContent.trim();
			      console.log("선택된 중분류: " + clicked.textContent.trim());
			      smallCol.style.display = "block"; // 소분류 보여주기
			
			      // 소분류 불러오기
			      fetch("${pageContext.request.contextPath}/board/getSubCategories?parentNum=" + parentId)
			        .then(response => response.json())
			        .then(data => {
			          const smallContainer = document.getElementById("category-list-small");
			          data.forEach(sub => {
			            const div = document.createElement("div");
			            div.textContent = sub.categoryName;
			            div.classList.add("category-small");
			            smallContainer.appendChild(div);
			          });
			        });
			    } else {
			      document.getElementById("categoryMiddleHiddenInput").value = "";
			      smallCol.style.display = "none"; // 소분류 숨기기
			    }
			  });
			
			  // 소분류 클릭 이벤트
			  document.getElementById("category-list-small").addEventListener("click", (e) => {
			    const clicked = e.target;
			    if (!clicked.classList.contains("category-small")) return;
			
			    clearActive("category-small");
			
			    clicked.classList.add("active");
			    document.getElementById("categorySmallHiddenInput").value = clicked.textContent.trim();
			    console.log("선택된 소분류: " + clicked.textContent.trim());
			  });
			</script>

			
		</form>
	</div>

	<div class="main">
		<div class="top">
			<div>
				<h2>나눔 게시판</h2>
			</div>
			<!-- 글쓰기를 클릭했을 때의 url에 컨트롤러에서 사용할 boardCategory를 지정해준다 -->
			<button id="write-btn">거래 글 쓰기</button>
		</div>
		<script>
		  document.getElementById('write-btn').addEventListener('click', function() {
		    window.location.href = '${pageContext.request.contextPath}/board/write/share';
		  });
	</script>
		<div class="grid">
			<!-- 카드 반복 -->
			<c:forEach var="board" items="${list }">

				<div class="card"
					onclick="moveDetail(${board.boardCommon.boardId});">
					<c:set var="boardId" value="${board.boardCommon.boardId}" />
					<c:if test="${fn:contains(likedBoardIds, boardId)}">
						<div class="heart liked"
							onclick="event.stopPropagation(); toggleLike(this, ${boardId});">♥</div>
					</c:if>
					<c:if test="${!fn:contains(likedBoardIds, boardId)}">
						<div class="heart"
							onclick="event.stopPropagation(); toggleLike(this, ${boardId});">♡</div>
					</c:if>

					<img
						src="${pageContext.request.contextPath}/${board.filePath.categoryPath}/${board.filePath.fileName}"
						alt="이미지" style="width: 90%; height: auto;" />
					<p id="product-name">${board.boardCommon.productName }</p>

					<p id="sharing-count">나눔 수량 : ${board.boardSharing.sharingCount }</p>
				
					
				</div>
			</c:forEach>
			<script>
	  	function moveDetail(bid){
	  		location.href = "${pageContext.request.contextPath}/board/detail/share/"+bid;
	  	}
	  </script>

			<script>
		function toggleLike(heartEl, boardId) {
        	$.ajax({
              	type: 'POST',
              	url: '${pageContext.request.contextPath}/board/addDibs',
              	data: {
              	  userId: '${userNum}',
              	  boardId: boardId,
              	  boardCategory: 'share'
             	 },
             	 success: function (res) {
             		 console.log(res);
    	       		  const liked = heartEl.classList.contains('liked');
    	      		
    	    		  if (liked) {
    	    		    // 찜 취소
    	    		    heartEl.textContent = '♡';
    	    		    heartEl.classList.remove('liked');
    	    		
    	    		    // TODO: 서버로 찜 취소 요청 (Ajax)
    	    		    console.log(`찜 취소: ${boardId}`);
    	    		  } else {
    	    		    // 찜 등록
    	    		    heartEl.textContent = '♥';
    	    		    heartEl.classList.add('liked');
    	    		
    	    		    // TODO: 서버로 찜 등록 요청 (Ajax)
    	    		    console.log(`찜 등록: ${boardId}`);
    	    		  }
             	 },
             	 error: function (err) {   
             	    console.error(err);
             	  }
               
             	 
               });
		}
		
    	

    	
		
		
		
		</script>

		</div>
	</div>
</div>


<script>
  window.addEventListener('DOMContentLoaded', () => {
    if (window.history.replaceState) {
      const cleanUrl = window.location.protocol + "//" + window.location.host + window.location.pathname;
      window.history.replaceState(null, null, cleanUrl);
    }
  });
</script>

		



</body>
</html>