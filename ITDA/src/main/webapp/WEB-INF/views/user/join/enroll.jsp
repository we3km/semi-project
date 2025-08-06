<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
String email = (String) session.getAttribute("verifiedEmail");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>회원정보 입력</title>
<style>
* {
	box-sizing: border-box;
}

.top {
	background-color: #ecebff;
	width: 800px;
	height: 120px;
	margin: auto;
	padding: 10px;
}

.middle {
	background-color: #ecebff;
	width: 800px;
	height: 1180px;
	margin: auto;
	display: grid;
	grid-template-columns: 140px 660px;
}

.left {
	font-size: 20px;
	text-align: center;
	line-height: 32px;
}

.right {
	font-size: 12px;
}

#id, #nick-name {
	width: 340px;
	height: 30px;
}

#id-check, #nick-name-check {
	background-color: #5A54FF;
	width: 80px;
	height: 30px;
	border: 1px solid #5A54FF;
	color: #fff;
	border-radius: 15px;
	cursor: pointer;
}

#pwd, #pwd-check, #email, #phone, #birth {
	width: 426px;
	height: 30px;
}

#address1, #address2 {
	width: 316px;
	height: 30px;
}

.image-upload-box {
	background-color: #fff;
	width: 316px;
	height: 316px;
	border: 1px solid #aaa;
	display: flex;
	align-items: center;
	justify-content: center;
	cursor: pointer;
	overflow: hidden;
}

.image-upload-box img {
	max-width: 100%;
	max-height: 100%;
	object-fit: contain;
}

.zip-btn {
	background-color: #5A54FF;
	width: 100px;
	height: 30px;
	border: 1px solid #5A54FF;
	color: #fff;
	border-radius: 15px;
	cursor: pointer;
}

.exp-date {
	background-color: #e0e0e0;
	margin-right: 30px;
	padding: 5px;
	font-size: 12px;
}

#next {
	background-color: #5a54ff;
	width: 160px;
	height: 40px;
	border: 1px solid #5a54ff;
	font-size: 20px;
	color: #fff;
	cursor: pointer;
}

#exit {
	background-color: #aeabff;
	width: 160px;
	height: 40px;
	border: 1px solid #aeabff;
	position: relative;
	left: 5%;
	font-size: 20px;
	color: #000;
	cursor: pointer;
}
</style>
</head>
<body>
	<form id="enrollForm"
		action="${pageContext.request.contextPath}/user/join/enroll"
		method="post" enctype="multipart/form-data" onsubmit="return setFullAddress();">
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
		<div class="top">
			<h1>회원정보 입력</h1>
			<hr>
		</div>
		<div class="middle">
			<div class="left">
				아이디<br> <br> 닉네임<br> <br> 비밀번호<br> <br>
				비밀번호 확인<br> <br> 이메일 주소<br> <br> 휴대폰<br> <br>
				생년월일<br> <br> 주소<br> <br> 상세주소<br> <br>
				프로필<br> 이미지<br> <br> <br> <br> <br> <br>
				<br> <br> <br> <br> 회원정보<br> 유효기간
			</div>
			<div class="right">
				<!-- 아이디 -->
				<input type="text" id="id" name="userId" value="${user.userId}"
					required pattern="\w{4,12}"> &nbsp;&nbsp;&nbsp; <input
					type="button" id="id-check" value="중복확인"> <span
					id="id-status"></span><br> 영문 또는 숫자로 4자~12자로 입력해주세요<br>
				<br>

				<!-- 닉네임 -->
				<input type="text" id="nick-name" name="nickName"
					value="${user.nickName}" required
					pattern="^([가-힣a-zA-Z0-9]{2,12})$"> &nbsp;&nbsp;&nbsp; <input
					type="button" id="nick-name-check" value="중복확인"> <span
					id="nick-name-status"></span><br>
				한글, 영문 대소문자, 숫자로 2자~12자로 입력해주세요.<br><br>

				<!-- 비밀번호 -->
				<input type="password" id="pwd" name="userPwd"
					value="${user.userPwd}" required><br> 영문,숫자 혼합하여
				8자~15자로 입력해주세요<br> <br> <input type="password"
					id="pwd-check" name="userPwdCheck" required
					pattern="^(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z0-9]{8,15}$"> <span
					id="pwd-status"></span><br> 영문,숫자 혼합하여 8자~15자로 입력해주세요<br>
				<br>

				<!-- 이메일 -->
				<input type="email" id="email" name="email" value="${user.email}"
					required readonly><br> &nbsp;<br> <br>

				<!-- 폰번호 -->
				<input type="text" id="phone" name="phone" value="${user.phone}"
					required autocomplete="tel" pattern="^010-\d{4}-\d{4}$"><br>
				010-1234-5678 형식으로 입력해주세요.<br> <br>

				<!-- 생일 -->
				<input type="date" id="birth" name="birth" value="${user.birth}" 
					required max="<%= new java.text.SimpleDateFormat("yyyy-MM-dd")
					.format(new java.util.Date()) %>"><br> &nbsp;<br>

				<!-- 주소 -->
				<div class="address">
					<br> <input type="text" id="address1"
						autocomplete="address-line1" required>&nbsp;&nbsp;&nbsp; <input
						type="button" class="zip-btn" value="우편번호 검색"
						onclick="execDaumPostcode()">
				</div>
				<br>
				<div class="address">
					<br> <input type="text" id="address2"
						autocomplete="address-line2" required>
				</div>
				<br> &nbsp; <input type="hidden" id="address" name="address">

				<!-- 프로필 -->
				<div class="image-upload-box"
					onclick="document.getElementById('imageFile').click();">
					<img id="preview" src="" style="display: none;" alt="프로필 이미지 미리보기" />
				</div>
				<input type="file" id="imageFile" name="profileImage"
					accept="image/*" style="display: none;"
					onchange="previewImage(event)" /> <br> <br>

				<!-- 정보 유효 기간 -->
				<div class="exp-date">
					회원정보 유효기간을 선택해주세요<br> <input type="radio" id="1"
						name="validPeriod" value="1년"> 1년 <input type="radio"
						id="2" name="validPeriod" value="2년"> 2년 <input
						type="radio" id="3" name="validPeriod" value="3년"> 3년 <input
						type="radio" id="end" name="validPeriod" value="회원탈퇴시까지">
					회원탈퇴 시 까지 <br> <br> 선택하신 기간 동안 사이트 로그인 기록이 없을 경우, 회원정보가
					분리 보관되어 로그인이 필요한 IT다 서비스를 이용하실 수 없으니 감안하여 필요한 기간으로 선택해 주세요.
				</div>
				<br> <br>&nbsp; <input type="button" id="next"
					value="가입완료" onclick="submitSuccess()"> <input
					type="button" id="exit" value="이전" onclick="history.back()">
			</div>
		</div>
	</form>

	<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script>
    	const contextPath = "${pageContext.request.contextPath}";
    	let idValid = false;
    	let nickNameValid = false;
    	let pwdMatched = false;
    	
    	document.getElementById('id-check').addEventListener('click', function() {
            const id = document.getElementById('id').value.trim();
            if (!id) {
                alert('아이디를 입력해주세요.');
                return;
            }
            else if(id.length < 4 || id.length > 12){
                alert('아이디는 4자 이상 12자 이하로 입력해주세요.');
                return;
            }
            
            const token = '${_csrf.token}';
            // AJAX로 서버에 아이디 중복 체크 요청 가능
            fetch(contextPath + "/user/join/enroll/checkId?userId=" + encodeURIComponent(id), {
                method: "GET",
                headers: {
                    'X-CSRF-TOKEN': '${_csrf.token}'
                }
            })
            .then(res => res.text())
            .then(data => {
                const idStatus = document.getElementById('id-status');
                if (data === "0") { // 사용 가능
                    idValid = true;
                    idStatus.textContent = '사용 가능한 아이디입니다.';
                    idStatus.style.color = 'green';
                } else if (data === "1") { // 중복
                    idValid = false;
                    idStatus.textContent = '이미 사용 중인 아이디입니다.';
                    idStatus.style.color = 'red';
                } else if (data === "-1") { // 사용 불가
                    idValid = false;
                    idStatus.textContent = '아이디 형식이 올바르지 않습니다.';
                    idStatus.style.color = 'orange';
                } else {
                	idValid = false;
                	idStatus.textContent = '오류가 발생했습니다.';
                	idStatus.style.color = 'red';
		        }
            })
            .catch(err => alert('오류 발생: ' + err));
        });
    	
    	// 닉네임 중복 체크
    	document.getElementById('nick-name-check').addEventListener('click', function () {
		    const nickName = document.getElementById('nick-name').value.trim();
		    if (!nickName) {
		        alert('닉네임을 입력해주세요.');
		        return;
		    } else if (nickName.length < 2 || nickName.length > 10) {
		        alert('닉네임은 2자 이상 10자 이하로 입력해주세요.');
		        return;
		    }
		
		    const token = '${_csrf.token}';
		
		    fetch(contextPath + "/user/join/enroll/checkNickname?nickname=" + encodeURIComponent(nickName), {
		        method: "GET"
		    })
		    .then(res => res.text())
		    .then(data => {
		        const nickNameStatus = document.getElementById('nick-name-status');
		        if (data === "0") { // 사용 가능
		            nickNameValid = true;
		            nickNameStatus.textContent = '사용 가능한 닉네임입니다.';
		            nickNameStatus.style.color = 'green';
		        } else if (data === "1") { // 중복
		            nickNameValid = false;
		            nickNameStatus.textContent = '이미 사용 중인 닉네임입니다.';
		            nickNameStatus.style.color = 'red';
		        } else if (data === "-1") { // 유효하지 않은 닉네임
		            nickNameValid = false;
		            nickNameStatus.textContent = '유효하지 않은 닉네임입니다.';
		            nickNameStatus.style.color = 'orange';
		        } else {
		            nickNameValid = false;
		            nickNameStatus.textContent = '오류가 발생했습니다.';
		            nickNameStatus.style.color = 'red';
		        }
		    })
		    .catch(err => alert('오류 발생: ' + err));
		});
    	
    	// 비밀번호 유효성 검사용
    	function isValidPassword(pwd) {
            const regex = /^(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z0-9]{8,15}$/;
            return regex.test(pwd);
        }
    	
    	document.getElementById('pwd-check').addEventListener('blur', function() {
    		const pwd = document.getElementById('pwd').value.trim();
    		const check = document.getElementById('pwd-check').value.trim();
    		const pwdStatus = document.getElementById('pwd-status')
    		
    		if(isValidPassword(pwd)){
    			if(pwd && check && pwd === check) {
        			pwdMatched = true;
        			pwdStatus.textContent = '비밀번호가 일치합니다.';
        			pwdStatus.style.color = 'green';
    		    } else {
    		    	pwdMatched = false;
    		    	pwdStatus.textContent = '비밀번호가 불일치합니다.';
    		    	pwdStatus.style.color = 'red';
    		    }
    		} else {
                pwdMatched = false;
                pwdStatus.textContent = '유효하지 않은 비밀번호입니다.';
                pwdStatus.style.color = 'red';
            }
    	});
    	
    	document.getElementById('pwd').addEventListener('blur', function () {
    	    const check = document.getElementById('pwd-check').value.trim();
    	    if (check !== "") {
    	        // 비밀번호를 바꿨는데 확인란이 이미 입력되어 있으면 다시 blur 이벤트 트리거
    	        document.getElementById('pwd-check').dispatchEvent(new Event('blur'));
    	    }
    	});
    	
    	function isValidPhone() {
			const testPhone = /^010-\d{4}-\d{4}$/;
			const checkPhone = document.getElementById('phone').value.trim();
			
			if (!checkPhone) {
		        alert("휴대폰 번호를 입력해주세요.");
		        return false;
		    }
			
			if (!testPhone.test(checkPhone)) {
		        alert("휴대폰 번호 형식이 올바르지 않습니다. 예: 010-1234-5678");
		        return false;
		    }
			
			return true;
		}
    	
    	function isValidBirth() {
    	    const birthStr = document.getElementById('birth').value;
    	    if (!birthStr) {
    	        alert("생년월일을 입력해주세요.");
    	        return false;
    	    }

    	    const birthDate = new Date(birthStr);
    	    const today = new Date();

    	    // 미래 날짜 입력 불가
    	    if (birthDate > today) {
    	        alert("생년월일은 미래 날짜로 입력할 수 없습니다.");
    	        return false;
    	    }

    	    // 만 14세 이상 체크
    	    const fourteenYearsAgo = new Date();
    	    fourteenYearsAgo.setFullYear(today.getFullYear() - 14);

    	    if (birthDate > fourteenYearsAgo) {
    	        alert("만 14세 이상만 가입할 수 있습니다.");
    	        return false;
    	    }

    	    return true;
    	}
    	
    	function previewImage(event) {
            const file = event.target.files[0];
            const preview = document.getElementById('preview');
            if (!file) {
                preview.style.display = 'none';
                preview.src = '';
                return;
            }

            const reader = new FileReader();
            reader.onload = function (e) {
                const preview = document.getElementById('preview');
                preview.src = e.target.result;
                preview.style.display = "block";
            };
            reader.readAsDataURL(file);
        }
		
    	// 도로명 주소와 상세 주소 받아서
    	function execDaumPostcode() {
            new daum.Postcode({
                oncomplete: function(data) {
                    // 도로명 주소
                    console.log( data.roadAddress);
                    document.getElementById('address1').value = data.roadAddress;
                    // 상세 주소
                    document.getElementById('address2').focus();
                }
            }).open();
        }
    	
    	// 전체 주소로 합쳐 제출
    	function setFullAddress() {
    	    const addr1 = document.getElementById('address1').value.trim();
    	    const addr2 = document.getElementById('address2').value.trim();

    	    if (!addr1 || addr1.replace(/\s/g, '') === '') {
    	        alert('도로명 주소를 정확히 입력해주세요.');
    	        return false; 	// 제출 막기
    	    }
    	    
    	    if (!addr2 || addr2.replace(/\s/g, '') === '') {
    	        alert('상세 주소를 정확히 입력해주세요.');
    	        return false;	// 제출 막기
    	    }
    	    
    	    const fullAddress = `\${addr1} \${addr2}`.trim(); // 이스케이핑 처리
    	    document.getElementById('address').value = fullAddress;
    	    
    	    console.log("address1:", addr1);
    	    console.log("address2:", addr2);
    	    console.log("Full address:", fullAddress);

    	    return true;	// 폼 제출 계속 진행
    	}
    	
    	function submitSuccess() {
    		if (!idValid) {
    	        alert("아이디 중복 확인을 완료해주세요.");
    	        return;
    	    }

    	    if (!pwdMatched) {
    	        alert("비밀번호가 일치하지 않습니다.");
    	        return;
    	    }
    	    
    	    if (!nickNameValid) {
    	    	alert("닉네임 중복 확인을 완료해주세요.");
    	        return;
    	    }
    	    
    	    if (!setFullAddress()) {
    	    	alert("주소를 정확히 입력해주세요.");
    	        return;
    	    }
    	    
    	    if(!isValidPhone()) {
    	    	alert("휴대폰 번호를 입력해주세요.");
    	        return;
    	    }
    	    
    	    if (!isValidBirth()) {
    	    	alert("생일을 입력해주세요.");
    	        return;
    	    }
    	    
    	    // 모든 조건이 만족하고 가입완료 버튼 누를 시 가입성공
    	    document.getElementById("enrollForm").submit();
		}
    </script>
</body>
</html>
