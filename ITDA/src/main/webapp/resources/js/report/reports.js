function openReportModal(type, targetId, targetName, targetUserNum) {
  document.getElementById('reportType').value = type;
  document.getElementById('targetId').value = targetId;

  // 신고 대상 작성자 userNum 추가
  document.getElementById('targetUserNum').value = targetUserNum;

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
      <option value="음란">음란</option>
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
      <option value="사기">사기</option>
      <option value="음란">음란</option>
      <option value="허위 정보">허위 정보</option>
    `;
  }

  // 모달 열기
  const modal = document.getElementById('reportModal');
  modal.style.display = 'flex';
  modal.classList.add('active');
}