<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>본인확인</title>
    <style>
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
    <form action="${pageContext.request.contextPath}/signup/email" method="post">
        <div class="top">
            <h1>본인확인</h1>
            <h2>고객님의 <span class="blue">본인확인</span>을 진행해주세요</h2>
            <br>
            IT다의 다양한 서비스 이용을 위해 본인확인이 필요합니다.<br>
            청소년 고객님은 보호자동의가 필요하니 보호자와 함께 진행해주세요
        </div>
        <div class="middle">
            이메일 
            <input type="email" id="email" name="email" placeholder="이메일" required>
            <input type="submit" id="send" value="전송"><br>

            인증번호 
            <input type="text" id="confilm-text" name="verificationCode" placeholder="인증번호">
            <input type="button" id="confilm" value="확인" onclick="verifyCode()">
        </div>
        <div class="bottom">
            <input type="submit" id="next" value="다음으로" onclick="goNext()">
            <input type="button" id="exit" value="이전" onclick="history.back()">
        </div>
    </form>

    <script>
    	let serverCode = null;
    	let emailVerified = false;
    
    	document.getElementById("send").addEventListener("click", function() {
            const email = document.getElementById("email").value.trim();
            if (!email) {
                alert("이메일을 입력해주세요.");
                return;
            }

            fetch('${pageContext.request.contextPath}/signup/sendAuthCode', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ email })
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    alert("인증번호가 이메일로 발송되었습니다.");
                    serverCode = data.code;
                } else {
                    alert("인증번호 발송에 실패했습니다: " + data.message);
                }
            })
            .catch(err => {
                alert("오류가 발생했습니다: " + err);
            });
        });
    	
        function verifyCode() {
            const inputCode = document.getElementById('confilm-text').value.trim();
            if (!inputCode) {
                alert('인증번호를 입력해주세요.');
                return;
            }
            if (inputCode === serverCode) {
                alert("인증에 성공했습니다.");
                emailVerified = true;
            } else {
                alert("인증번호가 일치하지 않습니다.");
            }
        }
        
        function goNext() {
            if (!emailVerified) {
                alert("이메일 인증을 먼저 완료해주세요.");
                return;
            }
            // 인증 완료되었으면 회원가입 정보 입력 페이지로 이동
            window.location.href = "${pageContext.request.contextPath}/signup/enroll";
        }
    </script>
</body>
</html>
