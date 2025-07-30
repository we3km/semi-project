$(document).ready(function () {
    // 드롭다운 클릭 열기
    $('.dropbtn_click').on('click', function (e) {
      e.stopPropagation();
      const dropdown = $(this).closest('.dropdown');
      $('.dropdown-content').not(dropdown.find('.dropdown-content')).removeClass('show');
      dropdown.find('.dropdown-content').toggleClass('show');
    });

    // 항목 클릭 시 텍스트 설정
    $('.dropdown .category').on('click', function () {
      const value = $(this).text();
      const dropdown = $(this).closest('.dropdown');
      dropdown.find('.dropbtn_content').text(value).css('color', '#252525');
      dropdown.find('.dropdown-content').removeClass('show');
    });

    // 외부 클릭 시 닫기
    $(window).on('click', function () {
      $('.dropdown-content').removeClass('show');
    });
  });

  // 아이콘 클릭
  $('.search img').click(function () {
    alert('검색 아이콘 클릭!');
  });

  $(document).ready(function () {
    // 로그인 클릭 핸들러
    function loginClickHandler() {
      alert('로그인창');
      // 버튼 텍스트 변경
      $('#login-btn').text('로그아웃');
      $('#signup-btn').text('마이페이지');

      // 로그아웃 클릭 핸들러로 변경
      $('#login-btn').off('click').on('click', logoutClickHandler);
      // 마이페이지 클릭 핸들러로 변경
      $('#signup-btn').off('click').on('click', function () {
        alert('마이페이지');
      });
    }

    // 로그아웃 클릭 핸들러
    function logoutClickHandler() {
      alert('로그아웃');
      // 버튼 원래대로 돌리기
      $('#login-btn').text('로그인');
      $('#signup-btn').text('회원가입');

      // 다시 로그인/회원가입 클릭 이벤트 연결
      $('#login-btn').off('click').on('click', loginClickHandler);
      $('#signup-btn').off('click').on('click', function () {
        alert('회원가입');
      });
    }

    // 초기 이벤트 연결
    $('#login-btn').on('click', loginClickHandler);
    $('#signup-btn').on('click', function () {
      alert('회원가입');
    });
    // 검색 버튼 클릭 이벤트
    $('#search-btn').on('click', function () {
      const dealType = $('#deal-type-dropdown .dropbtn_content').text().trim();
      const productType = $('#product-type-dropdown .dropbtn_content').text().trim();
      const searchText = $('#search-input').val().trim();

      alert(`거래유형: ${dealType}\n상품유형: ${productType}\n검색어: ${searchText}`);
    });

    $('.card').click(function () {
      const title = $(this).find('.card-title').text().trim();
      alert(title);
    })

  });