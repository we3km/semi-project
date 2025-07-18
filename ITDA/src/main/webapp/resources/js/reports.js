function openReportModal(type, targetId) {
  document.getElementById("reportType").value = type;
  document.getElementById("targetId").value = targetId;
  document.getElementById("reportModal").style.display = "flex";
}

function closeReportModal() {
  document.getElementById("reportModal").style.display = "none";
}

function openReportModal(type, id) {
  document.getElementById('reportType').value = type;
  document.getElementById('targetId').value = id;

  const modal = document.getElementById('reportModal');
  modal.classList.add('active');
}

function closeReportModal() {
  const modal = document.getElementById('reportModal');
  modal.classList.remove('active');
}