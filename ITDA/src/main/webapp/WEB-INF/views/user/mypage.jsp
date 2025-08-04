<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="utf-8" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/myPage.css" />
</head>
<body>
<div class="element">
    <div class="div">
        <!-- 헤더 -->
        <div class="overlap-15">
            <div class="itda-point-text">온도</div>
            <div class="degree">🔥</div>
        </div>
        <div class="itda-point">
            <div class="gauge-fill" id="gauge-fill"></div>
        </div>
        <div class="view">
            <div class="logo">logo</div>
            <div class="view-2">
                <div class="search">돋</div>
                <input type="text" class="search-input" value="교환 게시판 검색">
                <div class="view-3">
                    <div class="overlap-group-3">
                        <div class="group-32"><div class="category">카테고리</div></div>
                        <div class="arrow-drop-down">▽</div>
                    </div>
                </div>
            </div>
            <div class="view-wrapper">
                <div class="view-4">
                    <div class="overlap-group-4">
                        <div class="group-33">
                            <div class="text-wrapper-30">
                                닉네임님 반갑습니다!
                            </div>
                        </div>
                        <div class="bell">벨</div>
                        <div class="chat-bubble">말풍</div>
                    </div>
                </div>
            </div>
            <div class="navbar">
                <div class="text-wrapper-31">대여</div>
                <div class="text-wrapper-32">경매</div>
                <div class="text-wrapper-33">교환</div>
                <div class="text-wrapper-34">나눔</div>
                <div class="text-wrapper-35">커뮤니티</div>
            </div>
            <div class="text-wrapper-36">로그아웃</div>
            <div class="mainPage">마이페이지</div>
            <div class="text-wrapper-38">고객센터</div>
        </div>

        <!-- 대여 목록: 반복이 필요한 영역은 JSTL 사용 -->
        <div class="overlap">
            <div class="text-wrapper-3">대여 중인 물품</div>

            <%-- 반복 예시 (JSTL 활용 가능) --%>
            <c:forEach var="item" items="${rentalList}">
                <div class="rental-group-1">
                    <div class="group">
                        <div class="rental-image">${item.image}</div>
                        <div class="text-wrapper">${item.title}</div>
                    </div>
                    <div class="text-wrapper-4">기간 임박!!</div>
                    <div class="extension-1">
                        <div class="group-2">
                            <div class="group-3">
                                <div class="text-wrapper-2">대여 연장 요청</div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- 정보 수정 -->
        <div class="text-wrapper-8">내 정보</div>
        <div class="text-wrapper-9">나의 it 점수</div>
        <div class="update-pwd" onclick="openModal('password')">비밀번호 변경</div>
        <div class="update-nick" onclick="openModal('nickName')">닉네임 변경</div>
        <div class="update-phone" onclick="openModal('phone')">휴대폰 번호 변경</div>
        <div class="update-address" onclick="openModal('address')">주소 변경</div>

        <div class="info-box" style="top: 460px;">아이디</div>
		<div class="info-box" style="top: 519px;">(비밀번호 비공개)</div>
		<div class="info-box" style="top: 578px;">닉넴</div>
		<div class="info-box" style="top: 637px;">메일</div>
		<div class="info-box" style="top: 696px;">생일</div>
		<div class="info-box" style="top: 755px;">폰</div>
		<div class="info-box" style="top: 815px;">주소</div>
		<div class="text-wrapper-12" style="top: 459px;">아이디</div>
        <div class="text-wrapper-12" style="top: 518px;">비밀번호</div>
        <div class="text-wrapper-12" style="top: 577px;">닉네임</div>
        <div class="text-wrapper-12" style="top: 636px;">이메일</div>
        <div class="text-wrapper-12" style="top: 695px;">생일</div>
        <div class="text-wrapper-12" style="top: 754px;">휴대폰 번호</div>
        <div class="text-wrapper-12" style="top: 814px;">주소</div>
        <div class="profile-change">프로필 변경</div>
        <div class="profile-image">
            <img src="${pageContext.request.contextPath}/resources/profile/default.png" 
            	alt="프로필 이미지" width="300" height="300">
        </div>
        
        <div id="modal-overlay" class="modal hidden">
        	<div class="modal-content">
        		<h3 id="modal-title"></h3>
        		<form id="modal-form" autocomplete="off">
        			<div id="modal-body">
        				<!-- 비밀번호, 닉네임, 폰번호, 주소 변경 -->
        			</div>
        			<input type="button" id="cancel" name="cancel" value="취소" onclick="closeModal()">
        			<input type="button" id="change" name="change" value="변경" onclick="submitModal()">
        		</form>
        	</div>
        </div>

        <!-- 관심글 및 내가 쓴 글 등 반복 영역은 JSTL로 -->
        <div class="group-20">
            <c:forEach var="board" items="${boardList}">
                <div class="group-21">
                    <div class="red"><img class="likes" src="resources/EmptyHeart.png" /></div>
                    <div class="overlap-3"><div class="board-title">${board.title}</div></div>
                    <div class="overlap-4"><div class="board-terms">보증금 : ${board.deposit}원</div></div>
                    <div class="overlap-group-2"><div class="board-period">${board.period}</div></div>
                </div>
            </c:forEach>

            <div class="text-wrapper-22">내가 등록한 게시글</div>
            <div class="text-wrapper-23">거래 기록</div>
            <div class="text-wrapper-24">찜 목록</div>
            <div class="see-more1">더보기 &gt;</div>
            <div class="see-more2">더보기 &gt;</div>
            <div class="see-more3">더보기 &gt;</div>
        </div>
    </div>
</div>

<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
	const contextPath = "${pageContext.request.contextPath}";
	let value = 36; // 값 범위: 0 ~ 100 사이 임의의 값
	
	// 잇다점수 시각적 표시
	const gaugeFill = document.getElementById('gauge-fill');
	
	function updateGauge(val) {
	  const clampedVal = Math.max(0, Math.min(val, 100)); // 0~100으로 제한
	  gaugeFill.style.width = clampedVal + '%';
	}
	
	// 초기값 설정
	updateGauge(value);
	
	// 회원 정보 변경 모달 ON/OFF
	function openModal(type) {
		document.getElementById("modal-overlay").classList.remove("hidden");
		const form = document.getElementById("modal-form");
		const title = document.getElementById("modal-title");
		const body = document.getElementById("modal-body");
		body.innerHTML = "";
		
		// 비밀번호
		if(type === "password"){
			form.action = "${pageContext.request.contextPath}/user/mypage/updatePwd";
			form.method = "post";
			title.innerText = "비밀번호 변경";
			body.innerHTML = 
				`<input type="password" name="newPwd" id="newPwd" placeholder="새 비밀번호 입력"
					pattern="^(?=.*[a-zA-Z])(?=.*\\d)[a-zA-Z\\d]{8,15}$" required>
				<input type="password" name="confirmPwd" id="confirmPwd" placeholder="비밀번호 확인" required>`
		}
		
		//닉네임
		if(type === "nickName"){
			form.action = "${pageContext.request.contextPath}/user/mypage/updateNickName";
			form.method = "post";
			title.innerText = "닉네임 변경";
			body.innerHTML = 
				`<input type="text" name="newNickName" id="newNickName" placeholder="새 닉네임 입력"
					pattern="^(([가-힣]{2,8})|([a-zA-Z]{4,16})|([가-힣a-zA-Z]{2,10}))$" required>
				<input type="button" onclick="checkNickname()" value="중복 확인">`
		}
		
		// 폰 번호
		if(type === "phone"){
			form.action = "${pageContext.request.contextPath}/user/mypage/updatePhone";
			form.method = "post";
			title.innerText = "휴대폰 번호 변경";
			body.innerHTML = 
			    `<input type="text" name="newPhone" id="newPhone" placeholder="새 휴대폰 번호 입력"
			    pattern="^010-\d{4}-\d{4}$" required>
				<input type="button" onclick="checkPhone()" value="중복 확인">`
		}
		
		// 주소
		if(type === "address"){
			form.action = "${pageContext.request.contextPath}/user/mypage/updateAddress";
			form.method = "post";
			title.innerText = "주소 변경";
			body.innerHTML = 
			      `<input type="button" onclick="execDaumPostcode()" value="주소검색">
			      <input type="text" name="addr1" id="addr1" placeholder="기본주소" >
			      <input type="text" name="addr2" id="addr2" placeholder="상세주소" >
			      <input type="hidden" id="address" name="address" />`
		}
	}
	
	function closeModal() {
		document.getElementById("modal-overlay").classList.add("hidden");
	}
	
	function submitModal() {
		const title = document.getElementById("modal-title").innerText;
		const form = document.getElementById("modal-form");
		
		// 닉네임
		if (title.includes("닉네임")) {
			const nicknameInput = document.getElementById("newNickName");
			if (!nicknameInput.value.trim()) {
				alert("닉네임을 입력해주세요.");
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
			form.submit();
			
		// 주소
		} else if (title.includes("주소")) {
			const addr1 = document.getElementById("addr1").value.trim();
			const addr2 = document.getElementById("addr2").value.trim();

			if (!addr1 || addr1.replace(/\s/g, '') === '') {
		        alert("기본 주소를 정확히 입력해주세요.");
		        return;
		    }
		    if (!addr2 || addr2.replace(/\s/g, '') === '') {
		        alert("상세 주소를 정확히 입력해주세요.");
		        return;
		    }

		    // 합친 전체 주소를 hidden 필드나 별도 input에 세팅 (필요하면)
		    const fullAddress = addr1 + " " + addr2;
		    
		    let hiddenFullAddr = document.getElementById('fullAddress');
		    if (!hiddenFullAddr) {
		        hiddenFullAddr = document.createElement('input');
		        hiddenFullAddr.type = 'hidden';
		        hiddenFullAddr.name = 'fullAddress';
		        hiddenFullAddr.id = 'fullAddress';
		        form.appendChild(hiddenFullAddr);
		    }
		    hiddenFullAddr.value = fullAddress;
		    
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
	
	
	document.querySelector('.logo').addEventListener('click', function () {
		window.location.href = contextPath + "/";
	});
	
</script>
</body>
</html>
