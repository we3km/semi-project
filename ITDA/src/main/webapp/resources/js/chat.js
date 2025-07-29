// ============================ 각 모달 scipt구문 ============================

    // 배송 정보 저장
    document.getElementById('submitShippingInfo').addEventListener('click', function () {
        var deliveryCompany = document.getElementById('deliveryCompany').value;
        var trackingNumber = document.getElementById('trackingNumber').value.trim();

        console.log('택배사:', deliveryCompany);
        console.log('운송장 번호:', trackingNumber);

        if (!deliveryCompany) {
            alert('택배사를 선택해주세요.');
            return;
        }
        if (!trackingNumber) {
            alert('운송장 번호를 입력해주세요.');
            return;
        }

        const chatContent = document.querySelector('.chat-content2');

        const shippingMessage = document.createElement('div');
        shippingMessage.className = 'chat-message sent';
        shippingMessage.innerHTML = `<배송 정보><br><br>택배사: ${deliveryCompany}<br>운송장 번호: ${trackingNumber}`;

        chatContent.appendChild(shippingMessage);
        chatContent.scrollTop = chatContent.scrollHeight;

        closeModal('shipping_Inform_Input');
    });

    // 주소 정보 입력
    function execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function (data) {
                document.getElementById('zipcode').value = data.zonecode;
                document.getElementById('address').value = data.roadAddress;
                document.getElementById('detailAddress').focus();
            }
        }).open();
    }

    document.getElementById("nextButton").addEventListener("click", function () {
        const name = document.getElementById("name").value.trim();
        const zipcode = document.getElementById("zipcode").value.trim();
        const address = document.getElementById("address").value.trim();
        const detailAddress = document.getElementById("detailAddress").value.trim();
        const rawPhone = document.getElementById("phone").value.trim();
        const phone = rawPhone.replace(/-/g, "");

        const phoneRegex = /^01[016789][0-9]{7,8}$/;
        if (!phoneRegex.test(phone)) {
            alert("휴대폰 번호 형식이 올바르지 않습니다. n(예: 01012345678)");
            return;
        }

        if (!name || !zipcode || !address || !detailAddress) {
            alert("모든 정보를 입력해주세요.");
            return;
        }

        // 채팅창에 출력
        const chatContent = document.querySelector('.chat-content2');

        const message = document.createElement('div');

        message.className = 'chat-message sent';
        message.innerHTML = `<배송지 정보><br><br>수령인: ${name}<br>주소: ${address} ${detailAddress}<br>우편번호: ${zipcode}<br>연락처:
		${phone}
		<br><br>해당 주소로 상품 발송 바랍니다.`;
        chatContent.appendChild(message);
        chatContent.scrollTop = chatContent.scrollHeight;

        // 모달 닫기
        closeModal('shipping_Address_Modal');
    });

	// 모달 열고 닫기
    function closeModal(id) {
        document.getElementById(id).style.display = "none";
    }

    function openModal(id) {
        const modal = document.getElementById(id); // ← 이 줄 추가해야 함
        modal.style.display = "flex"; // 중앙 정렬 위해 flex
    }




    // 계좌 정보 전송
    function submitAccountInfo() {
        const price = document.getElementById("price").value.trim();
        const account = document.getElementById("bank").value.trim();
        const bank = document.getElementById("account").value.trim();

        const chatContent = document.querySelector('.chat-content2');

        const accountMessage = document.createElement('div');
        accountMessage.className = 'chat-message sent';
        accountMessage.innerHTML = `<계좌 정보><br><br>계좌번호: ${bank}<br>은행: ${account} <br>가격: ${price}`;

        chatContent.appendChild(accountMessage);
        chatContent.scrollTop = chatContent.scrollHeight;

        const confirmAccount = confirm(
            `📄 계좌 정보 확인\n\n계좌번호: ${account}\n은행: ${bank}\n가격: ${price}\n\n해당 계좌정보가 맞습니까?`
        );
        if (confirmAccount) {
            alert("계좌 정보가 제출되었습니다!");
            closeModal('accountInfoModal');
        }
    }

    
// ============================ 모달 끝 ============================

// 왼쪽 채팅방 기술
// 왼쪽 햄버거 버튼 눌렀을때
    function toggleActionMenu(el) {
        const menu = el.nextElementSibling;
        menu.classList.toggle('hidden');
    }

    function reportChat() {
        alert("신고가 접수되었습니다.");
        // 실제 신고 처리 로직 추가 가능
    }


// 왼쪽 채팅방 헤더 채팅방 선택 버튼 눌렀을 때 거래 유형에 맞게 채팅방 보여줌
	function chatRoomType() {
	        const menu = document.getElementById('chatMenu');
	        menu.classList.toggle('hidden');
	}
	


    