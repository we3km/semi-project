function openReportModal(type, targetId, targetName) {
  document.getElementById('reportType').value = type;
  document.getElementById('targetId').value = targetId;

  // 신고 대상 이름 표시
  document.getElementById('targetInfo').textContent = `${type} 신고 대상: ${targetName}`;

  // 신고 사유 카테고리 동적 생성
  const categorySelect = document.querySelector('select[name="category"]');
  categorySelect.innerHTML = ''; // 초기화

  // 기본 옵션
  categorySelect.innerHTML = `<option value="">-- 신고 사유를 선택하세요 --</option>`;

  if(type === 'BOARD') {
    categorySelect.innerHTML += `
      <option value="부적절한 게시물">부적절한 게시물</option>
      <option value="허위 정보">허위 정보</option>
      <option value="사기">사기</option>
    `;
  } else if(type === 'COMMENT') {
    categorySelect.innerHTML += `
      <option value="욕설">욕설</option>
      <option value="부적절한 게시물">부적절한 게시물</option>
    `;
  } else if(type === 'USER') {
    categorySelect.innerHTML += `
      <option value="욕설">욕설</option>
      <option value="사기">사기</option>
      <option value="허위 정보">허위 정보</option>
    `;
  } else if(type === 'OPENCHAT') {
    categorySelect.innerHTML += `
      <option value="부적절한 게시물">부적절한 게시물</option>
      <option value="욕설">욕설</option>
    `;
  } else {
    // 기본 공통 옵션 (혹시 모를 타입 대비)
    categorySelect.innerHTML += `
      <option value="허위 정보">허위 정보</option>
      <option value="욕설">욕설</option>
      <option value="사기">사기</option>
      <option value="음란">음란</option>
      <option value="부적절한 게시물">부적절한 게시물</option>
    `;
  }

  // 모달 열기
  const modal = document.getElementById('reportModal');
  modal.style.display = 'flex';
  modal.classList.add('active');
}

function closeReportModal() {
  const modal = document.getElementById('reportModal');
  modal.classList.remove('active');
  modal.style.display = 'none';

  // 초기화
  document.getElementById('reportForm').reset();
  document.getElementById('targetInfo').textContent = '';
}

// 제출 이벤트에 기본 제출 막기와 fetch 요청
document.getElementById('reportForm').addEventListener('submit', function(e) {
  e.preventDefault(); // 기본 제출 막기

  const form = e.target;
  const formData = new FormData(form);

  fetch('/report/submit', {
    method: 'POST',
    body: formData
  })
  .then(response => {
    if (!response.ok) throw new Error('서버 응답 오류'); // 네트워크 문제 등
    return response.text(); // 여기서 서버에서 받은 문자열값을 text로 저장
  })
  .then(text => {
    if (text.includes('신고완료')) {
      alert(text); // 서버에서 보내준 텍스트값 그대로 입력 
      closeReportModal();
    } else {
      alert(text); // 서버에서 보내준 텍스트값 그대로 입력 
    }
  })
  .catch(error => {
    alert('신고 중 오류가 발생했습니다: ' + error.message);
    console.error('신고 실패:', error);
  });
});