<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>회원정보 입력</title>
    <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <style>
        * {
            box-sizing: border-box;
        }
        .top{
            background-color: #ecebff;
            width: 600px;
            height: 120px;
            margin: auto;
            padding: 10px;
        }
        .middle{
            background-color: #ecebff;
            width: 600px;
            height: 930px;
            margin: auto;
            display: grid;
            grid-template-columns: 140px 460px;
        }
        .left{
            font-size: 20px;
            text-align: center;
            line-height: 26.2px;
        }
        .right{
            font-size: 12px;
        }
        #id{
            width: 340px;
            height: 30px;
        }
        #id-check{
            background-color: #5A54FF;
            width: 80px;
            height: 30px;
            border: 1px solid #5A54FF;
            color: #fff;
            border-radius: 15px;
            cursor: pointer;
        }
        #nick-name, #pwd, #pwd-check, #email, #phone, #birth, #zipcode {
            width: 426px;
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
        .exp-date{
            background-color: #e0e0e0;
            margin-right: 30px;
            padding: 5px;
            font-size: 12px;
        }
        #next{
            background-color: #5a54ff;
            width: 160px;
            height: 40px;
            border: 1px solid #5a54ff;
            font-size: 20px;
            color: #fff;
            cursor: pointer;
        }
        #exit{
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
    <form action="${pageContext.request.contextPath}/signup/enroll" method="post" enctype="multipart/form-data">
        <div class="top">
            <h1>회원정보 입력</h1>
            <hr>
        </div>
        <div class="middle">
            <div class="left">
                아이디<br><br>
                닉네임<br><br>
                비밀번호<br><br>
                비밀번호 확인<br><br>
                이메일 주소<br><br>
                휴대폰<br><br>
                생년월일<br><br>
                주소<br><br>
                프로필<br>
                이미지<br><br><br><br><br><br><br><br><br><br><br><br>
                회원정보<br>
                유효기간
            </div>
            <div class="right">
                <input type="text" id="id" name="username" required>
                &nbsp;&nbsp;&nbsp;
                <input type="button" id="id-check" value="중복확인" onclick="checkId()"><br>
                영문 또는 숫자로 4자~12자로 입력해 주세요<br><br>

                <input type="text" id="nick-name" name="nickname" required><br>
                한글기준 2자~8자, 영문기준 4자~16자로 입력해주세요.<br><br>

                <input type="password" id="pwd" name="password" required><br>
                영문,숫자 혼합하여 8자~15자로 입력해주세요<br><br>

                <input type="password" id="pwd-check" name="passwordConfirm" required><br>
                영문,숫자 혼합하여 8자~15자로 입력해주세요<br><br>

                <input type="email" id="email" name="email" required><br>
                &nbsp;<br><br>

                <input type="text" id="phone" name="phone" required><br>
                010-1234-5678 형식으로 입력해주세요.<br><br>

                <input type="date" id="birth" name="birth" required><br>
                &nbsp;<br>

                <div class="address"><br>
                    <input type="text" class="input" id="zipcode" name="zipcode" required />&nbsp;&nbsp;&nbsp;
                    <button type="button" class="zip-btn" onclick="execDaumPostcode()">우편번호 검색</button>
                </div><br>
                &nbsp;

                <div class="image-upload-box" onclick="document.getElementById('imageFile').click();">
                    <img id="preview" src="${pageContext.request.contextPath}/images/default.png" alt="프로필 이미지 미리보기" />
                </div>
                <input type="file" id="imageFile" name="profileImage" accept="image/*" style="display: none;" onchange="uploadImage()" /><br>
                &nbsp;

                <div class="exp-date">
                    회원정보 유효기간을 선택해주세요<br>
                    <input type="checkbox" id="1" name="validPeriod" value="1년"> 1년 
                    <input type="checkbox" id="2" name="validPeriod" value="2년"> 2년 
                    <input type="checkbox" id="3" name="validPeriod" value="3년"> 3년 
                    <input type="checkbox" id="end" name="validPeriod" value="회원탈퇴시까지"> 회원탈퇴 시 까지
                    <br><br>
                    선택하신 기간 동안 사이트 로그인 기록이 없을 경우,
                    회원정보가 분리 보관되어 로그인이 필요한 IT다 서비스를 이용하실 수 없으니 감안하여 필요한 기간으로 선택해 주세요.
                </div>
                <br><br>&nbsp;

                <input type="submit" id="next" value="가입완료">
                <input type="button" id="exit" value="이전" onclick="history.back()">
            </div>
        </div>
    </form>

    <script>
        function checkId(){
            const id = document.getElementById('id').value.trim();
            if(id.length < 4 || id.length > 12){
                alert('아이디는 4자 이상 12자 이하로 입력해주세요.');
                return;
            }
            // AJAX로 서버에 아이디 중복 체크 요청 가능
            alert('아이디 중복 체크 요청 (예시)');
        }

        function uploadImage() {
            const fileInput = document.getElementById("imageFile");
            const file = fileInput.files[0];
            if (!file) return;

            const formData = new FormData();
            formData.append("file", file);

            fetch("${pageContext.request.contextPath}/profile/upload-image", {
                method: "POST",
                body: formData
            })
            .then(res => res.text())  // 서버에서 이미지 URL을 응답한다고 가정
            .then(url => {
                document.getElementById("preview").src = url;
                saveImageUrlToServer(url);
            })
            .catch(err => alert("업로드 실패: " + err));
        }

        function saveImageUrlToServer(imageUrl) {
            fetch("${pageContext.request.contextPath}/profile/save-url", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({ imageUrl })
            });
        }

        function execDaumPostcode() {
            new daum.Postcode({
                oncomplete: function(data) {
                    document.getElementById('zipcode').value = data.zonecode;
                    // 추가 주소 정보도 넣고 싶으면 여기서 처리
                }
            }).open();
        }
    </script>
</body>
</html>
