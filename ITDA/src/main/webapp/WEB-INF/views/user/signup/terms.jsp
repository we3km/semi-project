<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>이용약관 동의</title>
    <style>
        #top{
            margin-top: 10px;
            margin-bottom: 20px;
            font-size:30px;
            text-align: center;
        }
        .top{
            background-color: #e2e0ff;
            width: 500px;
            height: 40px;
            margin: auto;
            padding-top: 10px;
            padding-left: 10px;
            font-size: 20px;
        }
        .middle{
            background-color: #ecebff;
            width: 500px;
            height: 400px;
            margin: auto;
            padding-top: 10px;
            padding-left: 10px;
            font-size: 20px;
        }
        #first, #second, #third{
            background-color: #ecebff;
            border: #e2ebff;
            font-weight: bold;
            font-size: 20px;
            position: relative;
        }
        #first { right: -40%; }
        #second { right: -32%; }
        #third { right: -3%; }
        .bottom{
            background-color: #ecebff;
            width: 500px;
            height: 100px;
            margin: auto;
            padding-top: 10px;
            padding-left: 10px;
        }
        #next{
            background-color: #5a54ff;
            width: 160px;
            height: 40px;
            border: 1px solid #5a54ff;
            position: relative;
            left: 12%;
            font-size: 20px;
            color: #fff;
        }
        #exit{
            background-color: #aeabff;
            width: 160px;
            height: 40px;
            border: 1px solid #aeabff;
            position: relative;
            left: 22%;
            font-size: 20px;
            color: #000;
        }
    </style>
</head>
<body>
    <form action="${pageContext.request.contextPath}/user/signup/terms" method="post" onsubmit="return validateForm()">
        <div id="top">다음 내용에 동의해주세요<br></div>

        <div class="top">
            <input type="checkbox" id="selectAll" onclick="selectAll()">
            모두 동의
        </div>

        <div class="middle">
            <input type="checkbox" name="agreeTerms" class="tos">
            IT다 이용약관에 동의 (필수)
            <input type="button" id="first" value=">"><br><hr>

            <input type="checkbox" name="agreePrivacy" class="tos">
            개인정보 처리 방침에 동의 (필수)
            <input type="button" id="second" value=">"><br><hr>

            <input type="checkbox" name="agreePolicy" class="tos">
            커뮤니티 운영정책 및 신고/제재 규정에 동의 (필수)
            <input type="button" id="third" value=">"><br><hr>
        </div>

        <div class="bottom">
            <input type="submit" id="next" value="다음으로">
            <input type="button" id="exit" value="취소" onclick="location.href='${pageContext.request.contextPath}/'">
        </div>
    </form>

    <script>
        function selectAll() {
            const selectAll = document.getElementById('selectAll');
            const checkboxes = document.querySelectorAll('.tos');
            checkboxes.forEach(cb => cb.checked = selectAll.checked);
        }
        
        function validateForm() {
            const checkboxes = document.querySelectorAll('.tos');
            for (let cb of checkboxes) {
                if (!cb.checked) { //모든 항목에 체크하지 않았을 시
                    alert('모든 필수 항목에 동의해 주세요.');
                    return false;
                }
            }
            return true; // 모두 체크됐으면 다음으로 넘어갈 수 있음
        }
    </script>
</body>
</html>
