<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>아이디 찾기</title>
    <style>
        .top, .middle, .bottom {
            background-color: #d9d9d9;
            width: 400px;
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
        #name, #email, #auth-code {
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
        <form action="${pageContext.request.contextPath}/user/findId" method="post">
            이름 <input type="text" id="name" name="name"><br>
            이메일 <input type="email" id="email" name="email">
            <button type="button" class="send" id="send-auth-btn">전송</button><br>
            인증번호 <input type="text" id="auth-code" name="auth-code" disabled><br><br>
            <input type="submit" class="check" value="확인" disabled id="submit-btn">
        </form>
    </div>
    <div class="bottom">
        <li>외부계정(페이스북, 구글, 네이버, 애플 등)을 통해 IT다에 로그인하시는 고객님은 해당 서비스에서 아이디/비밀번호 찾기를 이용해주세요.</li>
    </div>
    
    <script>
    let serverCode = null;
    
    const sendBtn = document.getElementById('send-auth-btn');
    const authCodeInput = document.getElementById('auth-code');

    sendBtn.addEventListener('click', function() {
        const name = document.getElementById('name').value.trim();
        const email = document.getElementById('email').value.trim();

        if(!name || !email) {
            alert('이름과 이메일을 모두 입력해주세요.');
            return;
        }

        fetch('${pageContext.request.contextPath}/user/sendAuthCode', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({name, email})
        })
        .then(res => res.json())
        .then(data => {
            if(data.success) {
                alert('인증번호가 이메일로 발송되었습니다.');
                serverCode = data.code;
            } else {
                alert('인증번호 발송에 실패했습니다: ' + data.message);
            }
        })
        .catch(err => alert('오류가 발생했습니다: ' + err));
    });

    function checkAuthCode() {
    	const inputCode = authCodeInput.value.trim();

        if (!inputCode) {
            alert("인증번호를 입력해주세요.");
            return;
        }

        if (inputCode === serverCode) {
            alert("인증에 성공했습니다.");
        } else {
            alert("인증번호가 일치하지 않습니다.");
        }
    }
	</script>
</body>
</html>
