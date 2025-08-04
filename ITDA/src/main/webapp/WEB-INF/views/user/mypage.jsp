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
            <div class="text-wrapper-37">마이페이지</div>
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
        <div class="update-pwd" onclick="openModal()">비밀번호 변경</div>
        <div class="update-nick">닉네임 변경</div>
        <div class="update-phone">휴대폰 번호 변경</div>
        <div class="update-address">주소 변경</div>

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
            <img src="./resources/profile/default.png" alt="프로필 이미지" width="100" height="100">
        </div>
        
        <!-- 회원 정보 수정 모달 -->
        <div id="modal-overlay" class="modal hidden" autocomplete="off">
        	<div class="modal-content">
        		<h3>비밀번호 변경</h3>
        		<form id="pwdForm" action="${pageContext.request.contextPath}/user/mypage/updatePwd" method="post">
        			<input type="password" name="newPwd" id="newPwd" placeholder="새 비밀번호 입력" />
        			<input type="password" name="confirmPwd" id="confirmPwd" placeholder="비밀번호 확인" />
        			<div class="modal-buttons">
        				<input type="button" value="취소" onclick="closeModal()" />
						<input type="button" value="변경" onclick="submitPassword()" />
        			</div>
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
<script>
	let value = 36; // 값 범위: 0 ~ 100 사이 임의의 값
	
	// 잇다점수 시각적 표시
	const gaugeFill = document.getElementById('gauge-fill');
	
	function updateGauge(val) {
	  const clampedVal = Math.max(0, Math.min(val, 100)); // 0~100으로 제한
	  gaugeFill.style.width = clampedVal + '%';
	}
	
	// 초기값 설정
	updateGauge(value);
	
	// 회원 정보 변경 모달
	// 비밀번호
	function openModal() {
		document.getElementById("modal-overlay").classList.remove("hidden");
	}
	
	function closeModal() {
		document.getElementById("modal-overlay").classList.add("hidden");
	}
	
	function submitPassword() {
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
	}
	
</script>
</body>
</html>
