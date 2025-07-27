<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<title>Insert title here</title>
<style>
body {
	font-family: 'Noto Sans KR', sans-serif;
	background: #fefefe;
	margin: 0;
	padding: 0;
}

.container {
	max-width: 1000px;
	margin: 30px auto;
	padding: 20px;
}

header {
	display: flex;
	align-items: center;
	justify-content: space-between;
	border-bottom: 1px solid #ccc;
	padding-bottom: 10px;
}

h1 {
	font-size: 28px;
}

.highlight {
	color: #6B63FF;
}

.region {
	font-size: 16px;
	color: #666;
}

.region-name {
	color: #6B63FF;
	font-weight: bold;
}

.buttons button {
	margin-left: 10px;
	padding: 8px 16px;
	border: none;
	border-radius: 20px;
	font-size: 14px;
	cursor: pointer;
}

.cancel {
	background-color: #eee;
}

.submit {
	background-color: #6B63FF;
	color: white;
}

main {
	display: flex;
	flex-wrap: wrap;
	gap: 20px;
	margin-top: 30px;
}

.image-upload {
	flex: 1;
	min-width: 280px;
}

.image-upload .main-image img {
	width: 100%;
	max-width: 200px;
	border-radius: 12px;
}

.thumbnail-list {
	display: flex;
	gap: 10px;
	margin-top: 10px;
}

.thumbnail-list img {
	width: 50px;
	height: 50px;
	border-radius: 8px;
	object-fit: cover;
}

.add-thumbnail {
	width: 50px;
	height: 50px;
	border: 2px dashed #ccc;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 24px;
	border-radius: 8px;
	cursor: pointer;
}

.info-input {
	flex: 2;
	display: flex;
	flex-direction: column;
	gap: 10px;
}

.title-input {
	font-size: 18px;
	padding: 10px;
	border-radius: 6px;
	border: 1px solid #ccc;
}

.tag-input {
	display: flex;
	align-items: center;
	gap: 10px;
}

.tag-input input {
	flex: 1;
	padding: 8px;
	border-radius: 6px;
	border: 1px solid #ccc;
}

.tag {
	background-color: #6B63FF;
	color: white;
	padding: 5px 10px;
	border-radius: 20px;
	font-size: 14px;
}

.description {
	height: 150px;
	padding: 10px;
	font-size: 14px;
	border-radius: 6px;
	border: 1px solid #ccc;
	resize: none;
}

.price-date-category {
	width: 100%;
	display: flex;
	gap: 20px;
	margin-top: 20px;
}

.price-area, .date-area, .category-area {
	flex: 1;
	display: flex;
	flex-direction: column;
	gap: 10px;
}

.price-area input, .date-area input {
	padding: 8px;
	border-radius: 6px;
	border: 1px solid #ccc;
}

.category-list {
	font-size: 14px;
	color: #6B63FF;
}

#board-category {
	width: 100px;
	background: #ADAAF8;
	border-radius: 20px;
	font-size: 14px;
	cursor: pointer;
}

img {
	width: 100px;
}
</style>

</head>

<body>
	<div class="container">
		<form:form modelAttribute="board"
			action="${pageContext.request.contextPath}/board/write/${boardCategory}"
			method="post" enctype="multipart/form-data">
			<header>
				<c:choose>
					<c:when test="${boardCategory eq 'rental'}">
						<h1>
							<span class="highlight">대여</span> 글쓰기
						</h1>
					</c:when>
					<c:when test="${boardCategory eq 'auction'}">
						<h1>
							<span class="highlight">경매</span> 글쓰기
						</h1>
					</c:when>
					<c:when test="${boardCategory eq 'exchange'}">
						<h1>
							<span class="highlight">교환</span> 글쓰기
						</h1>
					</c:when>
					<c:when test="${boardCategory eq 'share'}">
						<h1>
							<span class="highlight">나눔</span> 글쓰기
						</h1>
					</c:when>
				</c:choose>
				<select id="board-category" name="board-category">
					<option value="rental"
						${boardCategory == 'rental' ? 'selected' : ''}>대여</option>
					<option value="auction"
						${boardCategory == 'auction' ? 'selected' : ''}>경매</option>
					<option value="exchange"
						${boardCategory == 'exchange' ? 'selected' : ''}>교환</option>
					<option value="share" ${boardCategory == 'share' ? 'selected' : ''}>나눔</option>
				</select>

				<div class="region">
					거래지역 &gt; <span class="region-name">서울특별시 강남구 📍</span>
				</div>

				<div class="buttons">
					<button id="cancel-btn" type="button" class="cancel" onclick="history.back()">작성 취소</button>

					<button id="submit-btn" type="submit">작성 완료</button>
				</div>

				<script>
					document.getElementById('submit-btn').addEventListener('click', function(event) {
					  const productName = document.getElementById('product-name').value.trim();
					  const productComment = document.getElementById('product-comment').value.trim();
					  const rentalFee = document.getElementById('rental-fee').value;
					  const deposit = document.getElementById('deposit').value;
					  const startDate = document.getElementById('start-date').value;
					  const endDate = document.getElementById('end-date').value;
					  const categorySmall = document.getElementById('categorySmallHiddenInput').value;
					  if (!productName || !productComment || !rentalFee || !deposit
							  || !startDate || !endDate || !categorySmall ) {
					    event.preventDefault(); // 폼 제출 막기
					    alert("모든 항목을 입력해 주세요.");
					    //openModal();
					  }
					});
					

				</script>

			</header>

			<main>
				<section class="image-upload">
					<p>상품 이미지 (<span id="imageCount">0</span>/10)</p>
					  <div id="fileInputs">
					    <!-- input 10개 미리 만들어놓기 -->
					    <input type="file" class="inputImage" name="upfile" accept="image/*" style="display: block;">
					    <input type="file" class="inputImage" name="upfile" accept="image/*" style="display: none;">
					    <input type="file" class="inputImage" name="upfile" accept="image/*" style="display: none;">
					    <input type="file" class="inputImage" name="upfile" accept="image/*" style="display: none;">
					    <input type="file" class="inputImage" name="upfile" accept="image/*" style="display: none;">
					    <input type="file" class="inputImage" name="upfile" accept="image/*" style="display: none;">
					    <input type="file" class="inputImage" name="upfile" accept="image/*" style="display: none;">
					    <input type="file" class="inputImage" name="upfile" accept="image/*" style="display: none;">
					    <input type="file" class="inputImage" name="upfile" accept="image/*" style="display: none;">
					    <input type="file" class="inputImage" name="upfile" accept="image/*" style="display: none;">
					  </div>
					
					<div id="previewContainer">
						
					</div>
					

<script>
const inputImages = document.querySelectorAll('.inputImage');
const previewContainer = document.getElementById('previewContainer');
const imageCountDisplay = document.getElementById('imageCount');

let currentCount = 0;

// 초기: input 중 첫 번째만 보이게
inputImages.forEach((input, i) => {
  input.style.display = i === 0 ? 'block' : 'none';
});

inputImages.forEach((input, index) => {
  input.addEventListener('change', function () {
    const file = this.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = function (e) {
        // 미리보기 wrapper 생성
        const wrapper = document.createElement('div');
        wrapper.className = 'preview-wrapper';
        wrapper.style.display = 'inline-block';
        wrapper.style.position = 'relative';
        wrapper.style.margin = '5px';

        // 이미지
        const img = document.createElement('img');
        img.src = e.target.result;
        img.style.width = '100px';
        img.style.height = '100px';
        img.style.objectFit = 'cover';

        // 삭제 버튼
        const delBtn = document.createElement('button');
        delBtn.innerText = 'X';
        delBtn.type = 'button';
        delBtn.style.position = 'absolute';
        delBtn.style.top = '0';
        delBtn.style.right = '0';
        delBtn.style.background = 'red';
        delBtn.style.color = 'white';
        delBtn.style.border = 'none';
        delBtn.style.borderRadius = '50%';
        delBtn.style.width = '20px';
        delBtn.style.height = '20px';
        delBtn.style.cursor = 'pointer';

        // 미리보기에 input 인덱스 저장
        wrapper.dataset.inputIndex = index;

        // 삭제 로직
        delBtn.addEventListener('click', () => {
          // 미리보기 삭제
          previewContainer.removeChild(wrapper);

          // input 초기화 및 다시 보이게
          const targetInput = inputImages[index];
          targetInput.value = '';
          targetInput.style.display = 'block';

          // 현재 보이는 input 숨기기
          for (let i = 0; i < inputImages.length; i++) {
            if (i !== index) inputImages[i].style.display = 'none';
          }

          currentCount--;
          updateCount();
        });

        // 구성 추가
        wrapper.appendChild(img);
        wrapper.appendChild(delBtn);
        previewContainer.appendChild(wrapper);

        // 현재 input 숨기기
        input.style.display = 'none';

        // 다음 input 보이기 (없으면 아무것도 안 보이게)
        if (index + 1 < inputImages.length) {
          inputImages[index + 1].style.display = 'block';
        }

        currentCount++;
        updateCount();
      };
      reader.readAsDataURL(file);
    }
  });
});

function updateCount() {
  imageCountDisplay.textContent = currentCount;
}
</script>
				</section>

				<section class="info-input">
					<form:input id="product-name" path="boardCommon.productName" type="text"
						placeholder="상품명" cssClass="title-input" />


					<div class="tag-input">
						<input type="text" id="tagInput" placeholder="태그 입력 후 추가를 누르세요." />
						<div id="addTag">추가</div>

						<div id="tagContainer"></div>

						<!-- 태그 리스트를 저장할 hidden input (여러 개 생성됨) -->
						<div id="tagsHiddenInput"></div>
					</div>
					<script>
					const tagInput = document.getElementById("tagInput");
					const addTag = document.getElementById("addTag");
				    const tagContainer = document.getElementById("tagContainer");
				    const hiddenTags = document.getElementById("tagsHiddenInput");
				    
				    const tags = new Set(); // 중복 방지를 위한 Set

				    addTag.addEventListener("click", () => {
				           
				            const tag = tagInput.value.trim();
				            if (tag === "") return;
				            if (tags.has(tag)) {
				                alert("이미 추가된 태그입니다.");
				                tagInput.value = "";
				                return;
				            }
				            tags.add(tag);
				            if (tag) {
				                // 태그 UI 추가
				                const span = document.createElement("span");
				                span.className = "tag";
				                span.innerText = "#" + tag;
				                tagContainer.appendChild(span);

				                // hidden input 추가sde34
				                const hidden = document.createElement("input");
				                hidden.type = "hidden";
				                hidden.name = "boardCommon.tagList"; 
				                hidden.value = tag;
				               
				                hiddenTags.appendChild(hidden);

				                // 입력창 초기화
				                tagInput.value = "";
				            }
				        
				    });
				    
					</script>


					<form:textarea id="product-comment" path="boardCommon.productComment"
						placeholder="상품 설명" cssClass="description" />
				</section>


			</main>

			<c:choose>
				<c:when test="${boardCategory eq 'rental'}">
					<section class="price-date-category">
						<div class="price-area">
							<label>대여 가격</label>
							<form:input id="rental-fee" path="boardRental.rentalFee" type="text" />
							원 <label>보증금</label>
							<form:input id="deposit" path="boardRental.deposit" type="text" />
							원
						</div>

						<div class="date-area">
							<label>대여 기간</label>
							<div class="dates">
								<form:input id="start-date" path="boardRental.rentalStartDate" type="date" />
								부터
								<form:input id="end-date" path="boardRental.rentalEndDate" type="date" />
								까지
							</div>
						</div>
						<script>
						const startInput = document.getElementById('start-date');
						const endInput = document.getElementById('end-date');
						
						// 시작일 선택 시 → 종료일 최소값 설정
						startInput.addEventListener('change', function () {
						  const startDate = new Date(this.value);
						  if (startDate.toString() !== "Invalid Date") {
						    // 종료일은 시작일 +1일부터 가능
						    const minEndDate = new Date(startDate);
						    minEndDate.setDate(minEndDate.getDate() + 1);
						
						    // yyyy-mm-dd 형식으로 설정
						    endInput.min = minEndDate.toISOString().split("T")[0];
						  }
						});
						
						// 종료일 선택 시 → 시작일 최대값 설정
						endInput.addEventListener('change', function () {
						  const endDate = new Date(this.value);
						  if (endDate.toString() !== "Invalid Date") {
						    const maxStartDate = new Date(endDate);
						    maxStartDate.setDate(maxStartDate.getDate() - 1);
						
						    startInput.max = maxStartDate.toISOString().split("T")[0];
						  }
						});
						
			
						</script>
						
						

						<div class="category-area">
							<label>상품 카테고리</label>
							<div class="category-list-large">
								<c:forEach items="${list}" var="productCategory">
									<c:if test="${productCategory.parentNum == 0 }">
										<div class="category-large"
											data-id="${productCategory.productCategoryNum}">
											${productCategory.categoryName }</div>
									</c:if>
								</c:forEach>
								<input type="hidden" id="categoryLargeHiddenInput" name="boardCommon.productCategoryL" />
							</div>
							<div id="category-list-middle">
							</div>
								<input type="hidden" id="categoryMiddleHiddenInput" name="boardCommon.productCategoryM" />
							<div id="category-list-small">
							</div>
								<input type="hidden" id="categorySmallHiddenInput" name="boardCommon.productCategoryS" />
						</div>
						<script>
							  // 대분류 클릭 이벤트
							  document.querySelectorAll('.category-large').forEach(item => {
							    item.addEventListener('click', () => {
							      const parentId = item.dataset.id;
							      
							 
					              
							      fetch("${pageContext.request.contextPath}/board/getSubCategories?parentNum=" + parentId)
							        .then(response => response.json())
							        .then(data => {
							          const middleContainer = document.getElementById("category-list-middle");
							          middleContainer.innerHTML = ""; // 기존 중분류 초기화
							          const smallContainer = document.getElementById("category-list-small");
							          smallContainer.innerHTML = ""; // 기존 소분류 초기화
							          data.forEach(sub => {
							            const div = document.createElement("div");
							            div.textContent = sub.categoryName;
							            div.classList.add("category-middle");
							            div.setAttribute("data-id", sub.productCategoryNum);
							            middleContainer.appendChild(div);
							          });
							        })
							        .catch(err => {
							          console.error("중분류 불러오기 실패:", err);
							        });
							    });
							  });
							  document.addEventListener("click", function(e) {
									if (e.target.classList.contains("category-large")) {
										const categoryName = e.target.textContent.trim();
										document.getElementById("categoryLargeHiddenInput").value = categoryName;
										console.log("선택된 대분류: "+categoryName);
									}
								});

							
							  document.getElementById("category-list-middle").addEventListener("click", (e) => {
							    const clicked = e.target;
							
							    if (clicked.classList.contains("category-middle")) {
							      const parentId = clicked.dataset.id;
							      const middleName = clicked.textContent.trim();
							      console.log(middleName);
							   
							      document.getElementById("categoryMiddleHiddenInput").value = middleName;
							      console.log("선택된 중분류: " + middleName);
							      
							      
							      fetch("${pageContext.request.contextPath}/board/getSubCategories?parentNum=" + parentId)
							        .then(response => response.json())
							        .then(data => {
							          const smallContainer = document.getElementById("category-list-small");
							          smallContainer.innerHTML = ""; // 기존 소분류 초기화
							
							          data.forEach(sub => {
							            const div = document.createElement("div");
							            div.textContent = sub.categoryName;
							            div.classList.add("category-small");
							            smallContainer.appendChild(div);
							          });
							        })
							        .catch(err => {
							          console.error("소분류 불러오기 실패:", err);
							        });
							    }
							  });
							  
							  document.getElementById("category-list-small").addEventListener("click", (e) => {
								  const clicked = e.target;

								  if (clicked.classList.contains("category-small")) {
								    const smallName = clicked.textContent.trim();

								  
								    document.getElementById("categorySmallHiddenInput").value = smallName;
								    console.log("선택된 소분류: " + smallName);
								  }
							  });
							  
						</script>
					</section>
				</c:when>
				<c:when test="${boardCategory eq 'auction'}">
					<jsp:include page="/WEB-INF/views/board/writeAuction.jsp"></jsp:include>
				</c:when>
				<c:when test="${boardCategory eq 'exchange'}">
					<jsp:include page="/WEB-INF/views/board/writeExchange.jsp"></jsp:include>
				</c:when>
				<c:when test="${boardCategory eq 'share'}">
					<jsp:include page="/WEB-INF/views/board/writeShare.jsp"></jsp:include>
				</c:when>
			</c:choose>

		</form:form>
	</div>

						

	<script>
		$(function() {

			$("#board-category").on(
					"change",
					function() {
						const selectedCategory = this.value;
						var contextPath = "${pageContext.request.contextPath}";
						window.location.href = contextPath + "/board/write/"
								+ selectedCategory;

					})
		})
	</script>
</body>
</html>