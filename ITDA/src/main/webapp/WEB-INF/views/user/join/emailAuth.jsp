<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>본인확인</title>
<style>
.all{
	top: 50px;
	position: relative;
}
.top {
	background-color: #ecebff;
	width: 500px;
	height: 180px;
	font-size: 12px;
	text-align: center;
	margin: auto;
	padding: 10px;
}

.blue {
	color: #5a54ff;
}

.middle {
	background-color: #ecebff;
	width: 500px;
	height: 420px;
	font-size: 20px;
	text-align: center;
	margin: auto;
	padding: 10px;
}

#email {
	width: 320px;
	height: 30px;
	margin-bottom: 20px;
}

#confilm-text {
	width: 300px;
	height: 30px;
}

#send, #confilm {
	background-color: #5a54ff;
	width: 60px;
	height: 30px;
	border: 1px solid #5a54ff;
	color: #fff;
	border-radius: 14px;
	cursor: pointer;
}

.bottom {
	background-color: #ecebff;
	width: 500px;
	height: 100px;
	font-size: 12px;
	margin: auto;
	padding: 10px;
}

#next, #exit {
	width: 160px;
	height: 40px;
	font-size: 20px;
	color: #fff;
	border: 1px solid;
	cursor: pointer;
	position: relative;
}

#next {
	background-color: #5a54ff;
	border-color: #5a54ff;
	left: 12%;
}

#exit {
	background-color: #aeabff;
	border-color: #aeabff;
	color: #000;
	left: 22%;
}
</style>
</head>
<body>
	<!-- form action, method 수정 필요 -->
	<form id="emailAuth">
		<input type="hidden" name="${_csrf.parameterName}"
			value="${_csrf.token}" />
		<div class="all">
			<div class="top">
				<h1>본인확인</h1>
				<h2>
					고객님의 <span class="blue">본인확인</span>을 진행해주세요
				</h2>
				<br> IT다의 다양한 서비스 이용을 위해 본인확인이 필요합니다.<br> 청소년 고객님은 보호자동의가
				필요하니 보호자와 함께 진행해주세요
			</div>
			<div class="middle">
				이메일 <input type="email" id="email" name="email" placeholder="이메일"
					required> <input type="button" id="send" value="전송"><br>

				인증번호 <input type="text" id="confilm-text" name="verificationCode"
					placeholder="인증번호"> <input type="button" id="confilm"
					value="확인" onclick="verifyCode()">
			</div>
			<div class="bottom">
				<input type="button" id="next" value="다음으로" onclick="goNext()">
				<input type="button" id="exit" value="이전" onclick="history.back()">
			</div>
		</div>
	</form>

	<script>
    	let emailVerified = false;
    
    	document.getElementById("send").addEventListener("click", function(e) {
    		e.preventDefault();
    		
            const email = document.getElementById("email").value.trim();
            if (!email) {
                alert("이메일을 입력해주세요.");
                return;
            }
			
            //이메일 중복 여부 확인
            fetch('${pageContext.request.contextPath}/user/join/emailAuth/checkEmail?email='
            		+encodeURIComponent(email))
            		.then(res => res.json())
            		.then(data => {
            			if(data.result === "exists"){
            				alert("이미 가입된 이메일입니다.");
            				return;
            			}	
            			const token = '${_csrf.token}';
            			//인증번호 전송
            			return fetch('${pageContext.request.contextPath}/user/join/emailAuth/sendAuthCode', {
                			method: 'POST',
			                headers: {'Content-Type': 'application/x-www-form-urlencoded',
			                	'X-CSRF-TOKEN': token},
			                body: new URLSearchParams({email: email})
			            });
            		})
			        .then(res => res.json())
			        .then(data => {
			            if (data.result === 'success') {
			                alert("인증번호가 전송되었습니다.");
			            } else {
			                alert("인증번호 발송에 실패했습니다.");
			            }
			        })
			        .catch(err => {
			            alert("오류가 발생했습니다: " + err);
			        });
        });
    	
    	//인증번호 일치 검사(서버에서 검증하도록 위임)
    	function verifyCode() {
    	    const inputCode = document.getElementById('confilm-text').value.trim();
    	    const email = document.getElementById('email').value.trim();
    	    
    	    if (!inputCode) {
    	        alert('인증번호를 입력해주세요.');
    	        return;
    	    }
    	    const token = '${_csrf.token}';
    	 	//서버에 인증번호 검증 요청
    		fetch('${pageContext.request.contextPath}/user/join/emailAuth/verifyCode', {
    			method: 'POST',
    			headers: {
    				'Content-Type': 'application/x-www-form-urlencoded',
    				'X-CSRF-TOKEN': token
    			},
    			body: new URLSearchParams({
    				code: inputCode,
    				email: email
    			})
    		})
    		.then(res => res.json())
    		.then(data => {
    			if (data.result === 'success') {
    				alert("인증에 성공했습니다.");
    				emailVerified = true;
    				const token = '${_csrf.token}';
    				// 이메일 인증 성공 상태를 서버 세션에 저장
    				fetch('${pageContext.request.contextPath}/user/join/emailAuth/verifyEmailSuccess', {
    					method: 'POST',
    					headers: { 'Content-Type': 'application/json',
    						'X-CSRF-TOKEN': token},
    					body: JSON.stringify({ email: email })
    				});
    			} else {
    				alert("인증번호가 일치하지 않습니다.");
    			}
    		})
    		.catch(err => {
    			alert("오류가 발생했습니다: " + err);
    		});
    	}
        
        function goNext() {
            if (!emailVerified) {
                alert("이메일 인증을 먼저 완료해주세요.");
                return;
            }
            // 인증 완료되었으면 회원가입 정보 입력 페이지로 이동
            window.location.href = "${pageContext.request.contextPath}/user/join/enroll";
        }
    </script>
</body>
</html>
