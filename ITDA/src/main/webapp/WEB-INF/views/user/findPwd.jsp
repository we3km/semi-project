<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>비밀번호 찾기</title>
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
            height: 320px;
            font-size: 20px;
        }
        .bottom {
            height: 50px;
            font-size: 12px;
        }
        #find-id {
            width: 100px;
            height: 30px;
        }
        #find-pwd {
        	background-color: #adaaf8;
            width: 100px;
            height: 30px;
            margin-left: 5px;
        }
        #id, #email, #auth-code {
            width: 320px;
            height: 30px;
            margin-bottom: 10px;
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
        <input type="button" id="find-id" value="아이디 찾기"
               onclick="location.href='${pageContext.request.contextPath}/user/findId'">
        <input type="button" id="find-pwd" value="비밀번호 찾기">
        <br>
        비밀번호를 찾기 위한 정보를 입력해 주세요<br>
        아래 정보를 입력하시면 비밀번호를 메일로 발송해 드립니다.<br>
    </div>
    <div class="middle">
        <form>
            아이디 <input type="text" id="id" name="id"><br>
            이메일 <input type="email" id="email" name="email">
            <button type="button" class="send" id="send-auth-btn">전송</button><br>
            인증번호 <input type="text" id="auth-code" name="authCode" disabled><br><br>
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
            const id = document.getElementById('id').value.trim();
            const email = document.getElementById('email').value.trim();

            if (!id || !email) {
                alert('아이디와 이메일을 모두 입력해주세요.');
                return;
            }
            
			// 인증번호 전송
            fetch('${pageContext.request.contextPath}/user/findPwd', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: new URLSearchParams({ id: id, email: email })
            })
            .then(res => res.text())
            .then(data => {
                if (data.result = 'success') {
                    alert('인증번호가 이메일로 발송되었습니다.');
                    authCodeInput.disabled = false;
                    submitBtn.disabled = false;
                    authCodeInput.focus();
                } else {
                    alert('인증번호 발송 실패: ' + data.message);
                }
            })
            .catch(err => alert('오류 발생: ' + err));
        });

        function checkAuthCode(event) {
        	event.preventDefault();
        	
            const inputCode = authCodeInput.value.trim();

            if (!inputCode) {
                alert("인증번호를 입력해주세요.");
                return;
            }

            fetch('${pageContext.request.contextPath}/user/checkVerification', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: new URLSearchParams({ code: inputCode })
            })
            .then(res => res.json())
        .then(data => {
                if (res.ok) {
                    alert("인증에 성공했습니다.");
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