<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<meta charset="utf-8" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/myPage.css" />
<%-- report css --%>
<link
	href="${pageContext.request.contextPath}/resources/css/report/reports.css"
	rel="stylesheet">

<%-- jQuery --%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
	<div class="wrapper">
		<header class="header">
			<jsp:include page="/WEB-INF/views/common/Header.jsp" />
		</header>
	</div>

	<div class="container">
		<div class="element">
			<div class="div">
				<!-- 헤더 -->
				<div class="text-wrapper-9">나의 it 점수</div>
				<div class="overlap-15">
					<div class="itda-point-text">${itdaPoint}℃</div>
					<div class="degree">🔥</div>
				</div>
				<div class="itda-point">
					<div class="gauge-fill" id="gauge-fill"></div>
				</div>
				<!-- 정보 수정 -->
				<div class="text-wrapper-8">내 정보</div>
				<div class="update-pwd" onclick="openModal('password')">비밀번호
					변경</div>
				<div class="update-nick" onclick="openModal('nickName')">닉네임
					변경</div>
				<div class="update-phone" onclick="openModal('phone')">휴대폰 번호
					변경</div>
				<div class="update-address" onclick="openModal('address')">주소
					변경</div>

				<div class="info-box" style="top: 400px;">${user.userId}</div>
				<div class="info-box" style="top: 460px;">(비밀번호 비공개)</div>
				<div class="info-box" style="top: 520px;">${user.nickName}</div>
				<div class="info-box" style="top: 580px;">${user.email}</div>
				<div class="info-box" style="top: 640px;">${fn:substring(user.birth, 0, 10)}</div>
				<div class="info-box" style="top: 700px;">${user.phone}</div>
				<div class="info-box" style="top: 760px;">${user.address}</div>
				<div class="text-wrapper-12" style="top: 400px;">아이디</div>
				<div class="text-wrapper-12" style="top: 460px;">비밀번호</div>
				<div class="text-wrapper-12" style="top: 520px;">닉네임</div>
				<div class="text-wrapper-12" style="top: 580px;">이메일</div>
				<div class="text-wrapper-12" style="top: 640px;">생일</div>
				<div class="text-wrapper-12" style="top: 700px;">휴대폰 번호</div>
				<div class="text-wrapper-12" style="top: 760px;">주소</div>
				<div class="profile-change" id="changeProfile">프로필 변경</div>
				<input type="file" id="profileInput" accept="image/*"
					style="display: none" />
				<div class="profile-image">
					<img id="preview"
						src="${pageContext.request.contextPath}${imageUrl}" alt="프로필 이미지"
						width="356" height="356" style="display: block;">
				</div>
				<div class="delete-user" id="delete">회원탈퇴</div>

				<div id="modal-overlay" class="modal hidden">
					<div class="modal-content">
						<h3 id="modal-title"></h3>
						<form id="modal-form" autocomplete="off">
							<div id="modal-body">
								<!-- 비밀번호, 닉네임, 폰번호, 주소 변경 -->
							</div>
							<input type="button" id="cancel" name="cancel" value="취소"
								onclick="closeModal()"> <input type="button" id="change"
								name="change" value="변경" onclick="submitModal()">
						</form>
					</div>
				</div>
			</div>
		</div>
		
	<button id="writeBtn" class="active" onclick="showWriteList()">작성 게시글 보기</button>
	<button id="likedBtn" onclick="showLikedList()">찜한 게시글 보기</button>
	<div class="user-board-list">	
		<div class="user-write-list">
			<div class="related-products">
				<h2>회원님이 게시한 대여 게시글</h2>
				<div class="product-list">
					<!-- 카드 반복 -->
					<c:forEach var="userRentalWrapper"
						items="${userRentalWrapperList }">
						<div class="card"
							onclick="moveRentalDetail(${userRentalWrapper.boardCommon.boardId});">
							<img
								src="${pageContext.request.contextPath}/${userRentalWrapper.filePath.categoryPath}/${userRentalWrapper.filePath.fileName}"
								alt="이미지" />
							<p id="product-name">${userRentalWrapper.boardCommon.productName }</p>
							<p id="rental-fee">대여료:${userRentalWrapper.boardRental.rentalFee }원</p>
							<p class="date">
								<fmt:formatDate
									value="${userRentalWrapper.boardRental.rentalStartDate }"
									pattern="yyyy/MM/dd" />
								~
								<fmt:formatDate value="${userRentalWrapper.boardRental.rentalEndDate }"
									pattern="yyyy/MM/dd" />
							</p>
						</div>
					</c:forEach>
					<!-- 클릭시 상세보기로 이동 -->
					<script>
						function moveRentalDetail(bid){
							location.href = "${pageContext.request.contextPath}/board/detail/rental/"+bid;
						}
					</script>

				</div>
			</div>
			<div class="related-products">
				<h2>회원님이 게시한 나눔 게시글</h2>
				<div class="product-list">
					<!-- 카드 반복 -->
					<c:forEach var="userShareWrapper"
						items="${userShareWrapperList }">
						<div class="card"
							onclick="moveShareDetail(${userShareWrapper.boardCommon.boardId});">
							<img
								src="${pageContext.request.contextPath}/${userShareWrapper.filePath.categoryPath}/${userShareWrapper.filePath.fileName}"
								alt="이미지" />
							<p id="product-name">${userShareWrapper.boardCommon.productName }</p>
							<p class="count">나눔수량:${userShareWrapper.boardSharing.sharingCount }개</p>
						</div>
					</c:forEach>
					<!-- 클릭시 상세보기로 이동 -->
					<script>
						function moveShareDetail(bid){
							location.href = "${pageContext.request.contextPath}/board/detail/share/"+bid;
						}
					</script>

				</div>
			</div>
			
			<div class="related-products">
				<h2>회원님이 게시한 경매 게시글</h2>
				<div class="product-list">
					<!-- 카드 반복 -->
					<c:forEach var="userAuctionWrapper"
						items="${userAuctionWrapperList }">
						<div class="card"
							onclick="moveAuctionDetail(${userAuctionWrapper.boardCommon.boardId});">
							<img
								src="${pageContext.request.contextPath}/${userAuctionWrapper.filePath.categoryPath}/${userAuctionWrapper.filePath.fileName}"
								alt="이미지" />
							<p id="product-name">${userAuctionWrapper.boardCommon.productName }</p>
													<p id="auction-fee">경매시작금:${userAuctionWrapper.boardAuction.auctionStartingFee }</p>
							<c:if test="${userAuctionWrapper.highestBid ne 0}">
								<p id="highest-bid">최고입찰가 :
									${userAuctionWrapper.highestBid}</p>
							</c:if>
	
							<c:if test="${userAuctionWrapper.highestBid eq 0}">
								<p id="highest-bid">최고입찰가 :
									${userAuctionWrapper.boardAuction.auctionStartingFee}</p>
							</c:if>
							<p class="date">
								<fmt:formatDate
									value="${userAuctionWrapper.boardAuction.auctionStartDate }"
									pattern="yyyy/MM/dd" />
								~						
								<fmt:formatDate
									value="${userAuctionWrapper.boardAuction.auctionEndDate }"
									pattern="yyyy/MM/dd" />
							</p>
						</div>
					</c:forEach>
					<!-- 클릭시 상세보기로 이동 -->
					<script>
						function moveAuctionDetail(bid){
							location.href = "${pageContext.request.contextPath}/board/detail/auction/"+bid;
						}
					</script>

				</div>
			</div>
		</div>
		<div class="user-liked-list" style="display: none;">
			<div class="related-products">
				<h2>회원님이 찜한 대여 게시글</h2>
				<div class="product-list">
					<!-- 카드 반복 -->
					<c:forEach var="likedRentalWrapper"
						items="${likedRentalWrapperList }">
						<div class="card"
							onclick="moveRentalDetail(${likedRentalWrapper.boardCommon.boardId});">
							<img
								src="${pageContext.request.contextPath}/${likedRentalWrapper.filePath.categoryPath}/${likedRentalWrapper.filePath.fileName}"
								alt="이미지" />
							<p id="product-name">${likedRentalWrapper.boardCommon.productName }</p>
							<p id="rental-fee">대여료:${likedRentalWrapper.boardRental.rentalFee }원</p>
							<p class="date">
								<fmt:formatDate
									value="${likedRentalWrapper.boardRental.rentalStartDate }"
									pattern="yyyy/MM/dd" />
								~
								<fmt:formatDate value="${likedRentalWrapper.boardRental.rentalEndDate }"
									pattern="yyyy/MM/dd" />
							</p>
						</div>
					</c:forEach>
					<!-- 클릭시 상세보기로 이동 -->
					<script>
						function moveRentalDetail(bid){
							location.href = "${pageContext.request.contextPath}/board/detail/rental/"+bid;
						}
					</script>

				</div>
			</div>
			
			<div class="related-products">
				<h2>회원님이 찜한 나눔 게시글</h2>
				<div class="product-list">
					<!-- 카드 반복 -->
					<c:forEach var="likedShareWrapper"
						items="${likedShareWrapperList }">
						<div class="card"
							onclick="moveShareDetail(${likedShareWrapper.boardCommon.boardId});">
							<img
								src="${pageContext.request.contextPath}/${likedShareWrapper.filePath.categoryPath}/${likedShareWrapper.filePath.fileName}"
								alt="이미지" />
							<p id="product-name">${likedShareWrapper.boardCommon.productName }</p>
							<p class="count">나눔수량:${likedShareWrapper.boardSharing.sharingCount }개</p>
						</div>
					</c:forEach>
					<!-- 클릭시 상세보기로 이동 -->
					<script>
						function moveShareDetail(bid){
							location.href = "${pageContext.request.contextPath}/board/detail/share/"+bid;
						}
					</script>

				</div>
			</div>
			
			
			<div class="related-products">
				<h2>회원님이 찜한 경매 게시글</h2>
				<div class="product-list">
					<!-- 카드 반복 -->
					<c:forEach var="likedAuctionWrapper"
						items="${likedAuctionWrapperList }">
						<div class="card"
							onclick="moveAuctionDetail(${likedAuctionWrapper.boardCommon.boardId});">
							<img
								src="${pageContext.request.contextPath}/${likedAuctionWrapper.filePath.categoryPath}/${likedAuctionWrapper.filePath.fileName}"
								alt="이미지" />
							<p id="product-name">${likedAuctionWrapper.boardCommon.productName }</p>
													<p id="auction-fee">경매시작금:${likedAuctionWrapper.boardAuction.auctionStartingFee }</p>
							<c:if test="${likedAuctionWrapper.highestBid ne 0}">
								<p id="highest-bid">최고입찰가 :
									${likedAuctionWrapper.highestBid}</p>
							</c:if>
	
							<c:if test="${likedAuctionWrapper.highestBid eq 0}">
								<p id="highest-bid">최고입찰가 :
									${likedAuctionWrapper.boardAuction.auctionStartingFee}</p>
							</c:if>
							<p class="date">
								<fmt:formatDate
									value="${likedAuctionWrapper.boardAuction.auctionStartDate }"
									pattern="yyyy/MM/dd" />
								~						
								<fmt:formatDate
									value="${likedAuctionWrapper.boardAuction.auctionEndDate }"
									pattern="yyyy/MM/dd" />
							</p>
						</div>
					</c:forEach>
					<!-- 클릭시 상세보기로 이동 -->
					<script>
						function moveAuctionDetail(bid){
							location.href = "${pageContext.request.contextPath}/board/detail/auction/"+bid;
						}
					</script>

				</div>
			</div>
		</div>
	</div>
			
	<script>
	 const writeBtn = document.getElementById('writeBtn');
	  const likedBtn = document.getElementById('likedBtn');
	  const writeList = document.querySelector('.user-write-list');
	  const likedList = document.querySelector('.user-liked-list');

	  function showWriteList() {
		document.querySelector('.user-write-list').style.display = 'block';
		document.querySelector('.user-liked-list').style.display = 'none';

	    writeBtn.classList.add('active');
	    likedBtn.classList.remove('active');
	  }

	  function showLikedList() {
		document.querySelector('.user-write-list').style.display = 'none';
		document.querySelector('.user-liked-list').style.display = 'block';

	    likedBtn.classList.add('active');
	    writeBtn.classList.remove('active');
	  }
	</script>		
			
			
			
		
	</div>

	<script
		src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script>
	const contextPath = "${pageContext.request.contextPath}";
	let score = ${itdaPoint};
	
	// 잇다점수 시각적 표시
	const gaugeFill = document.getElementById('gauge-fill');
	
	function updateGauge(score) { // 0~100으로 제한
		const clampedScore = Math.max(0, Math.min(score, 100));
		gaugeFill.style.width = clampedScore + '%';
	}
	
	updateGauge(score);
	
	// 회원 정보 변경 모달 ON/OFF
	function openModal(type) {
		document.getElementById("modal-overlay").classList.remove("hidden");
		const form = document.getElementById("modal-form");
		const title = document.getElementById("modal-title");
		const body = document.getElementById("modal-body");
		body.innerHTML = "";
		
		// 비밀번호
		if(type === "password"){
			form.action = contextPath + "/user/mypage/updatePwd";
			form.method = "post";
			title.innerText = "비밀번호 변경";
			body.innerHTML = 
				`<input type="password" name="newPwd" id="newPwd" placeholder="새 비밀번호 입력"
					pattern="^(?=.*[a-zA-Z])(?=.*\\d)[a-zA-Z\\d]{8,15}$" required><br>
				<input type="password" name="confirmPwd" id="confirmPwd" placeholder="비밀번호 확인" required>`
		}
		
		//닉네임
		if(type === "nickName"){
			form.action = contextPath + "/user/mypage/updateNickname";
			form.method = "post";
			title.innerText = "닉네임 변경";
			body.innerHTML = 
				`<input type="text" name="newNickname" id="newNickname" placeholder="새 닉네임 입력"
					pattern="^([가-힣a-zA-Z0-9]{2,12})$" required>
				<input type="button" id="checkNickname" onclick="checkNickname()" value="중복 확인">`
		}
		
		// 폰 번호
		if(type === "phone"){
			form.action = contextPath + "/user/mypage/updatePhone";
			form.method = "post";
			title.innerText = "휴대폰 번호 변경";
			body.innerHTML = 
			    `<input type="text" name="newPhone" id="newPhone" placeholder="새 휴대폰 번호 입력"
			    pattern="^010-\d{4}-\d{4}$" required>
				<input type="button" id="checkPhone" onclick="checkPhone()" value="중복 확인">`
		}
		
		// 주소
		if(type === "address"){
			form.action = contextPath + "/user/mypage/updateAddress";
			form.method = "post";
			title.innerText = "주소 변경";
			body.innerHTML = 
			      `<input type="text" name="addr1" id="addr1" placeholder="기본주소" readonly>
			      <input type="button" id="searchAddr" onclick="execDaumPostcode()" value="주소검색">
			      <input type="text" name="addr2" id="addr2" placeholder="상세주소">
			      <input type="hidden" id="address" name="address" />`
		}
	}
	
	function closeModal() {
		document.getElementById("modal-overlay").classList.add("hidden");
	}
	
	// 닉네임 체크
	let nickNameValid = false;
	function checkNickname() {
		const newNickname = document.getElementById("newNickname").value;
		fetch(contextPath + "/user/mypage/checkNickname?newNickname=" + encodeURIComponent(newNickname), {
	        method: "GET"
	    })
	    .then(res => res.text())
	    .then(data => {
	        if (data === "0") { // 사용 가능
	            alert("사용 가능한 닉네임입니다");
	        	nickNameValid = true;
	        } else if (data === "1") { // 중복
	        	alert("중복된 닉네임입니다");
	        	nickNameValid = false;
	        } else if (data === "-1") { // 유효하지 않은 닉네임
	        	alert("유효하지 않은 닉네임입니다");
	        	nickNameValid = false;
	        } else {
	        	alert("사용 불가능한 닉네임입니다");
	        	nickNameValid = false;
	        }
	    })
	    .catch(err => alert('오류 발생: ' + err));
	}
	
	// 폰번호 체크
	let phoneValid = false;
	function checkPhone() {
		const newPhone = document.getElementById("newPhone").value;
		fetch(contextPath + "/user/mypage/checkPhone?newPhone=" + encodeURIComponent(newPhone), {
	        method: "GET"
	    })
	    .then(res => res.text())
	    .then(data => {
	        if (data === "0") { // 사용 가능
	            alert("수정 가능합니다");
	            phoneValid = true;
	        } else if (data === "1") { // 중복
	        	alert("이미 사용중인 휴대폰 번호입니다");
	        	phoneValid = false;
	        } else if (data === "-1") { // 유효하지 않음
	        	alert("다시 입력해주세요");
	        	phoneValid = false;
	        } else {
	        	alert("오류가 발생했습니다");
	        	phoneValid = false;
	        }
	    })
	    .catch(err => alert('오류 발생: ' + err));
	}
	
	// 기본 주소 검색
	function execDaumPostcode() {
		new daum.Postcode({
            oncomplete: function(data) {
                // 도로명 주소
                console.log( data.roadAddress);
                document.getElementById('addr1').value = data.roadAddress;
                // 상세 주소
                document.getElementById('addr2').focus();
            }
        }).open();
	}
	
	function submitModal() {
		const title = document.getElementById("modal-title").innerText;
		const form = document.getElementById("modal-form");
		
		// 닉네임
		if (title.includes("닉네임")) {
			const nicknameInput = document.getElementById("newNickname");
			if (!nicknameInput.value.trim()) {
				alert("닉네임을 입력해주세요.");
				return;
			}
			if (!nickNameValid) {
				alert("닉네임 중복 확인을 해주세요.");
				return;
			}
			
			form.submit();

		// 휴대폰 번호
		} else if (title.includes("휴대폰")) {
			const phoneInput = document.getElementById("newPhone");
			if (!phoneInput.value.trim()) {
				alert("휴대폰 번호를 입력해주세요.");
				return;
			}
			const phonePattern = /^010-\d{4}-\d{4}$/;
			if (!phonePattern.test(phoneInput.value)) {
				alert("휴대폰 번호 형식이 올바르지 않습니다.");
				return;
			}
			if (!phoneValid) {
				alert("휴대폰 번호 중복 확인을 해주세요.");
				return;
			}
			form.submit();
			
		// 주소
		} else if (title.includes("주소")) {
			const addr1 = document.getElementById("addr1").value.trim();
			const addr2 = document.getElementById("addr2").value.trim();

			if (!addr1) {
		        alert("기본 주소를 입력해주세요.");
		        return;
		    }
		    if (!addr2 || addr2.replace(/\s/g, '') === '') {
		        alert("상세 주소를 정확히 입력해주세요.");
		        return;
		    }

		    // 합친 전체 주소를 hidden 필드나 별도 input에 세팅 (필요하면)
		    const address = addr1 + " " + addr2;
		    const hiddenFullAddr = document.getElementById('address');
		    hiddenFullAddr.value = address;
		    
			form.submit();
			
		// 비밀번호
		} else if (title.includes("비밀번호")) {
			const newPwd = document.getElementById("newPwd").value;
			const confirmPwd = document.getElementById("confirmPwd").value;

			if (!newPwd || !confirmPwd) {
				alert("비밀번호를 입력해주세요.");
				return;
			}
			if (newPwd !== confirmPwd) {
				alert("비밀번호가 일치하지 않습니다.");
				return;
			}
			// 유효성 검사
			const pwdPattern = /^(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]{8,15}$/;
			if (!pwdPattern.test(newPwd)) {
				alert("비밀번호는 영문+숫자 조합 8~15자리여야 합니다.");
				return;
			}
			form.submit();
		}
		
		closeModal();
	}
	
	// 프로필 변경
	document.getElementById('changeProfile').addEventListener('click', function () {
		document.getElementById('profileInput').click();
	});
	
	document.getElementById('profileInput').addEventListener('change', function (event) {
		const file = event.target.files[0];
		if (!file) return;
		
		const reader = new FileReader();
	    reader.onload = function (e) {
	        const preview = document.getElementById('preview');
	        preview.src = e.target.result;
	    };
	    reader.readAsDataURL(file);
	    
		const formData = new FormData();
		formData.append("profileImage", file);

		fetch(contextPath + "/user/mypage/updateProfileImage", {
			method: "POST",
			body: formData
		})
		.then(res => res.json())
		.then(data => {
			if (data.success) {
			    alert("프로필 이미지가 변경되었습니다.");
				document.getElementById("preview").src = contextPath + data.newImageUrl;
			} else {
			    alert("이미지 변경 실패: " + data.message);
			}
		})
		.catch(error => {
			console.error("에러 발생:", error);
			alert("서버 오류");
		});
	});
	
	/* function submitPassword() {
		const newPwd = document.getElementById("newPwd").value;
		const confirmPwd = document.getElementById("confirmPwd").value;
	
		if (!newPwd || !confirmPwd) {
		    alert("비밀번호를 입력해주세요.");
		    return;
		}
		if (newPwd !== confirmPwd) {
	    	alert("비밀번호가 일치하지 않습니다.");
	    	return;
		}
		document.getElementById("pwdForm").submit();
		alert("비밀번호가 변경되었습니다.");
	  	closeModal(); // 성공 후 닫기
	} */	
	
	document.querySelector('.delete-user').addEventListener('click', function () {
		if(confirm("정말 탈퇴하시겠습니까?")){
			fetch(contextPath + "/user/delete", {
				method: "POST"
			})
			.then(res => res.text())
		    .then(data => {
		        alert("회원 탈퇴 처리 완료");
		    })
		    .catch(err => alert('오류 발생: ' + err));	
		}
	});
	
</script>
</body>
</html>
