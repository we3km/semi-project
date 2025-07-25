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
        .modal {
        display: none;
        position: fixed;
        z-index: 999;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        overflow: auto;
        background-color: rgba(0,0,0,0.4); /* 어두운 배경 */
    	}

    	.terms-content {
	        background-color: #fff;
	        margin: 15% auto;
	        padding: 20px;
	        border: 1px solid #888;
	        width: 400px;
	        font-size: 16px;
	        text-align: center;
	        border-radius: 10px;
	    }
	    .terms-content .close {
	        margin-top: 15px;
	        background-color: #5a54ff;
	        color: white;
	        border: none;
	        padding: 8px 16px;
	        cursor: pointer;
	        border-radius: 5px;
	    }
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
            <input type="button" id="first" value=">" onclick="openModal1()"><br><hr>
            
            <div id="modal1" class="modal">
            	<div class="terms-content">
            		<p>이용약관 내용 주절주절</p>
            		<input type="button" class="close" value="확인하였습니다" onclick="closeModal1()">
            	</div>
            </div>

            <input type="checkbox" name="agreePrivacy" class="tos">
            개인정보 처리 방침에 동의 (필수)
            <input type="button" id="second" value=">" onclick="openModal2()"><br><hr>
            
            <div id="modal2" class="modal">
            	<div class="terms-content">
            		<p>개인정보 처리방침이 어쩌구 저쩌구</p>
            		<input type="button" class="close" value="확인하였습니다" onclick="closeModal2()">
            	</div>
            </div>

            <input type="checkbox" name="agreePolicy" class="tos">
            커뮤니티 운영정책 및 신고/제재 규정에 동의 (필수)
            <input type="button" id="third" value=">" onclick="openModal3()"><br><hr>
            
            <div id="modal3" class="modal">
            	<div class="terms-content">
            		<p>커뮤 운영정책 및 신고/제재 규정 머시기</p>
            		<input type="button" class="close" value="확인하였습니다" onclick="closeModal3()">
            	</div>
            </div>
        </div>

        <div class="bottom">
            <input type="submit" id="next" value="다음으로">
            <input type="button" id="exit" value="취소" onclick="location.href='${pageContext.request.contextPath}/'">
        </div>
    </form>

    <script>
    	let confirmed1 = false;
    	let confirmed2 = false;
    	let confirmed3 = false;
    
        function selectAll() {
            const selectAll = document.getElementById('selectAll');
            const checkboxes = document.querySelectorAll('.tos');
            checkboxes.forEach(cb => cb.checked = selectAll.checked);
        }
        
     	// 개별 약관 체크박스 클릭 시
        function updateSelectAll() {
            const selectAll = document.getElementById('selectAll');
            const checkboxes = document.querySelectorAll('.tos');
            const allChecked = Array.from(checkboxes).every(cb => cb.checked);
            selectAll.checked = allChecked;
     	}
     	
        window.onload = function() {
            document.getElementById('selectAll').addEventListener('change', selectAll);
            document.querySelectorAll('.tos').forEach(cb => {
                cb.addEventListener('change', updateSelectAll);
            });
        };
        
        // 이용약관
        function openModal1() {
            document.getElementById('modal1').style.display = 'block';
        }
        function closeModal1() {
            document.getElementById('modal1').style.display = 'none';
            confirmed1 = true;
        }

        // 개인정보 처리방침
        function openModal2() {
            document.getElementById('modal2').style.display = 'block';
        }
        function closeModal2() {
            document.getElementById('modal2').style.display = 'none';
            confirmed2 = true;
        }

        // 커뮤니티 운영정책 및 신고/제재 규정
        function openModal3() {
            document.getElementById('modal3').style.display = 'block';
        }
        function closeModal3() {
            document.getElementById('modal3').style.display = 'none';
            confirmed3 = true;
        }
        
        function validateForm() {
            const checkboxes = document.querySelectorAll('.tos');
            for (let cb of checkboxes) {
                if (!cb.checked) { //모든 항목에 체크하지 않았을 시
                    alert('모든 필수 항목에 동의해 주세요.');
                    return false;
                }
            }
            if (!confirmed1 || !confirmed2 || !confirmed3) {
                alert('모든 약관 내용을 확인해주세요.');
                return false;
            }
            return true; // 모두 체크 및 내용 확인 후 넘어가기
        }
    </script>
</body>
</html>
