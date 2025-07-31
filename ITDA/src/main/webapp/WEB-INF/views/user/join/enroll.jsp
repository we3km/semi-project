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

#id {
	width: 340px;
	height: 30px;
}

#id-check {
	background-color: #5A54FF;
	width: 80px;
	height: 30px;
	border: 1px solid #5A54FF;
	color: #fff;
	border-radius: 15px;
	cursor: pointer;
}

#nick-name, #pwd, #pwd-check, #email, #phone, #birth {
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
					id="id-status"></span><br> 영문 또는 숫자로 4자~12자로 입력해 주세요<br>
				<br>

				<!-- 닉네임 -->
				<input type="text" id="nick-name" name="nickName"
					value="${user.nickName}" required
					pattern="^(([가-힣]{2,8})|([a-zA-Z]{4,16})|([가-힣a-zA-Z]{2,10}))$"><br>
				한글기준 2자~8자, 영문기준 4자~16자로 입력해주세요.<br> <br>

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
					required><br> &nbsp;<br>

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

	<script
		src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script>
    	const contextPath = "${pageContext.request.contextPath}";
    	let idValid = false;
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
                } else {
                    idValid = false;
                    idStatus.textContent = '이미 사용 중인 아이디입니다.';
                    idStatus.style.color = 'red';
                }
            })
            .catch(err => alert('오류 발생: ' + err));
        });
    	
    	document.getElementById('pwd-check').addEventListener('blur', function() {
    		const pwd = document.getElementById('pwd').value.trim();
    		const check = document.getElementById('pwd-check').value.trim();
    		const pwdStatus = document.getElementById('pwd-status')
    		
    		if(pwd && check && pwd === check) {
    			pwdMatched = true;
    			pwdStatus.textContent = '비밀번호가 일치합니다.';
    			pwdStatus.style.color = 'green';
		    } else {
		    	pwdMatched = false;
		    	pwdStatus.textContent = '비밀번호가 불일치합니다.';
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
    	    
    	    if (!setFullAddress()) {
    	        return;
    	    }

    	    // 모든 조건이 만족하고 가입완료 버튼 누를 시 가입성공
    	    document.getElementById("enrollForm").submit();
		}
    </script>
</body>
</html>
