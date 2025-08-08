<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>이용약관 동의</title>
    <style>
    	.all{
    		top: 80px;
    		position: relative;
    	}
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
    <form action="${pageContext.request.contextPath}/user/join/terms" method="post" onsubmit="return validateForm()">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
    	<div class="all">
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
	            		<h3>이용 약관</h3>
	            		<p>
	            			제1조 (목적)<br>
							이 약관은 이용자(이하 “회원”)가 본 서비스(이하 “서비스”)를 이용함에 있어 필요한 권리, 의무 및 책임사항을 규정하는 것을 목적으로 합니다.
							<br><br>
							제2조 (서비스의 내용)<br>
							본 서비스는 회원 간 대여, 경매, 나눔을 포함한 거래 기능과 커뮤니티를 통한 정보 공유 및 소통 기능을 제공합니다.
							<br><br>
							제3조 (회원가입)<br>
							회원은 본 약관에 동의하고 필요한 정보를 입력함으로써 가입할 수 있습니다.
							<br>
							허위 정보 제공 시 서비스 이용이 제한될 수 있습니다.
							<br><br>
							제4조 (서비스 이용)<br>
							회원은 타인의 권리를 침해하지 않는 범위 내에서 자유롭게 서비스를 이용할 수 있습니다.
							<br>
							불법 물품의 거래, 허위 게시글, 사기 행위 등은 엄격히 금지됩니다.
							<br><br>
							제5조 (책임의 한계)<br>
							서비스는 회원 간 거래의 중개자 또는 보증자가 아니며, 거래 과정에서 발생하는 분쟁에 대해 법적 책임을 지지 않습니다.
	            		</p>
	            		<input type="button" class="close" value="확인하였습니다" onclick="closeModal1()">
	            	</div>
	            </div>
	
	            <input type="checkbox" name="agreePrivacy" class="tos">
	            개인정보 처리 방침에 동의 (필수)
	            <input type="button" id="second" value=">" onclick="openModal2()"><br><hr>
	            
	            <div id="modal2" class="modal">
	            	<div class="terms-content">
	            		<h3>개인정보 처리 방침</h3>
	            		<p>
	            			제1조 (수집 항목)<br>
							서비스 이용을 위해 다음과 같은 정보를 수집할 수 있습니다:
							<br>
							필수: 이름, 이메일, 연락처, 비밀번호
							<br>
							선택: 프로필 사진, 주소 등 거래에 필요한 추가 정보
							<br><br>
							제2조 (이용 목적)<br>
							수집한 개인정보는 다음의 목적을 위해 사용됩니다:
							<br>
							회원가입 및 본인확인
							<br>
							서비스 제공 및 사용자 간 거래 지원
							<br>
							커뮤니티 활동 관리
							<br>
							고객 문의 대응 및 서비스 개선
							<br><br>
							제3조 (보관 기간)<br>
							회원 탈퇴 시 개인정보는 관련 법령에 따라 일정 기간 보관 후 즉시 파기됩니다.
							<br><br>
							제4조 (제3자 제공)<br>
							원칙적으로 회원의 동의 없이 개인정보를 제3자에게 제공하지 않습니다. 단, 법령에 의한 경우 예외로 합니다.
	            		</p>
	            		<input type="button" class="close" value="확인하였습니다" onclick="closeModal2()">
	            	</div>
	            </div>
	
	            <input type="checkbox" name="agreePolicy" class="tos">
	            커뮤니티 운영정책 및 신고/제재 규정에 동의 (필수)
	            <input type="button" id="third" value=">" onclick="openModal3()"><br><hr>
	            
	            <div id="modal3" class="modal">
	            	<div class="terms-content">
	            		<h3>커뮤니티 운영정책 및 신고/제재 규정</h3>
	            		<p>
	            			제1조 (운영 원칙)<br>
							커뮤니티는 자유로운 소통을 위한 공간으로, 회원은 타인을 존중하고 예의를 지켜야 합니다.
							<br>
							다음과 같은 게시글은 금지되며 사전 통보 없이 삭제될 수 있습니다:
							<br>
							욕설, 비방, 혐오 표현
							<br>
							불법 행위 조장
							<br>
							광고 및 홍보 목적의 글
							<br>
							거래 사기 관련 글
							<br><br>
							제2조 (신고 및 제재)<br>
							회원은 부적절한 게시글이나 행동을 신고할 수 있으며, 운영자는 해당 내용을 검토 후 조치합니다.
							<br>
							제재는 경고, 일정 기간 이용 제한, 영구 이용 정지 등의 수위로 나뉘며, 사안에 따라 즉시 적용될 수 있습니다.
							<br>
							제3조 (이의제기)<br>
							회원은 제재에 대해 이의신청을 할 수 있으며, 운영자는 신속히 재검토 후 결과를 통보합니다.
	            		</p>
	            		<input type="button" class="close" value="확인하였습니다" onclick="closeModal3()">
	            	</div>
	            </div>
	        </div>
	
	        <div class="bottom">
	            <input type="submit" id="next" value="다음으로">
	            <input type="button" id="exit" value="취소" onclick="location.href='${pageContext.request.contextPath}/'">
	        </div>
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
