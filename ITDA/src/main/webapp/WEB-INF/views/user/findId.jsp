<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>아이디 찾기</title>
    <style>
        .top, .middle, .bottom {
            background-color: #d9d9d9;
            width: 480px;
            margin: auto;
            padding: 10px;
        }
        .top {
            height: 100px;
            font-size: 12px;
        }
        .middle {
            height: 400px;
            font-size: 20px;
        }
        .bottom {
            height: 50px;
            font-size: 12px;
        }
        #find-id {
            background-color: #adaaf8;
            width: 100px;
            height: 30px;
        }
        #find-pwd {
            width: 100px;
            height: 30px;
            margin-left: 5px;
        }
        #nickName, #email, #auth-code {
            width: 340px;
            height: 30px;
            margin-bottom: 20px;
        }
        .send {
            background-color: #5a54ff;
            width: 60px;
            height: 28px;
            border: 1px solid #5a54ff;
            color: #fff;
            border-radius: 14px;
        }
        .check {
            width: 80px;
            height: 30px;
            position: relative;
            left: 38%;
        }
    </style>
</head>
<body>
    <div class="top">
        <input type="button" id="find-id" value="아이디 찾기">
        <input type="button" id="find-pwd" value="비밀번호 찾기"
               onclick="location.href='${pageContext.request.contextPath}/user/findPwd'">
        <br>
        아이디를 찾기 위한 정보를 입력해 주세요<br>
        아래 정보를 입력하시면 아이디를 메일로 발송해 드립니다.<br>
    </div>
    <div class="middle">
        <form>
            닉네임&nbsp;<input type="text" id="nickName" name="nickName"><br>
            이메일&nbsp;<input type="email" id="email" name="email">
            <button type="button" id="send-auth-btn" class="send">전송</button><br>
            인증번호 <input type="text" id="auth-code" name="auth-code" disabled><br><br>
            <input type="button" id="submit-btn" class="check" value="확인" disabled onclick="checkAuthCode(event)">
        </form>
    </div>
    <div class="bottom">
        <li>외부계정(페이스북, 구글, 네이버, 애플 등)을 통해 IT다에 로그인하시는 고객님은 해당 서비스에서 아이디/비밀번호 찾기를 이용해주세요.</li>
    </div>
    
    <script>
    const sendBtn = document.getElementById('send-auth-btn');
    const authCodeInput = document.getElementById('auth-code');
    const submitBtn = document.getElementById('submit-btn');

    sendBtn.addEventListener('click', function() {
        const nickName = document.getElementById('nickName').value.trim();
        const email = document.getElementById('email').value.trim();

        if(!nickName || !email) {
            alert('닉네임과 이메일을 모두 입력해주세요.');
            return;
        }

        // 인증번호 전송
        fetch('${pageContext.request.contextPath}/user/sendVerification', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: new URLSearchParams({ nickName: nickName, email: email })
        })
        .then(res => res.json())
        .then(data => {
            if(data.success === true) {
                alert('인증번호가 이메일로 발송되었습니다.');
                authCodeInput.disabled = false;
                submitBtn.disabled = false;
                authCodeInput.focus();
            } else {
                alert('인증번호 발송에 실패했습니다: ' + data.message);
            }
        })
        .catch(err => alert('오류가 발생했습니다: ' + err));
    });

    function checkAuthCode(event) {
    	event.preventDefault();
    	
    	const inputCode = authCodeInput.value.trim();

        if (!inputCode) {
            alert("인증번호를 입력해주세요.");
            return;
        }

        fetch('${pageContext.request.contextPath}/user/findId', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: new URLSearchParams({ 
            	nickName: nickName,
                email: email,
                authCode: authCodeInput.value.trim()
            })
        })
        .then(res => res.json())
        .then(data => {
            if (data.success === true) {
                alert("인증에 성공했습니다. 아이디가 이메일로 전송되었습니다.");
                window.location.href = '${pageContext.request.contextPath}/user/login';
            } else {
                alert("인증번호가 일치하지 않습니다.");
            }
        })
        .catch(err => alert("서버 오류: " + err));
    }
	</script>
</body>
</html>
