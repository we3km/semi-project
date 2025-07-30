$(document).ready(function () {


            // 로고
            $('.logo').click(function(){
                alert(`메인페이지로 이동`);
            })


            // 카테고리
            // 카테고리 클릭 시 active
            $('.category-line .category').click(function () {
                $('.category-line .category').removeClass('active');
                $(this).addClass('active');
                const category = $(this).text();
                alert(`${category}`);
            });


            // 로그인-로그아웃 버튼 
            // 로그인 상태 토글
            $('#loginBtn').click(function () {
                $('.unlogin').hide();
                $('.login').show();
            });
            $('#logoutBtn').click(function () {
                $('.login').hide();
                $('.unlogin').show();
            });
            // 초기화 - 무조건 로그인된 상태 숨기기
            $('.login').hide();      // 로그인된 사용자용 버튼 숨김
            $('.unlogin').show();    // 비로그인용 버튼 보이기
            $('.login_effect').hide();  // 유저 인사+알림창 숨기기
            // 로그인 클릭 시
            $('#loginBtn').click(function () {
                //로그인 페이지로 이동
                alert(`로그인창`);

                $('.unlogin').hide();
                $('.login').css('display', 'flex');
                $('.login_effect').show();
            });
            // 로그아웃 클릭 시
            $('#logoutBtn').click(function () {
                //로그아웃으로 바껴랏
                alert(`로그아웃 하였습니다`);

                $('.login').hide();
                $('.login_effect').hide();
                $('.unlogin').css('display', 'flex');
            });
            //회원가입
            $('#joinMembership').click(function(){
                alert(`회원가입 페이지 이동~`);
            });
            //마이페이지
            $('#myPage').click(function(){
                alert(`마이페이지 이동~`);
            });
            //고객센터
            $('#customerService').click(function(){
                alert(`고객센터 페이지 이동~`);
            })


            // 검색창
            // 검색 드롭다운 열기/닫기
            $('.search-category').click(function () {
                $(this).siblings('.search-dropdown').toggle();
            });
            // 카테고리 선택 시 텍스트만 변경 (svg 유지)
            $('.search-dropdown div').click(function () {
                const selectedText = $(this).text();
                $('.search-category div:first-child').text(selectedText);
                $('.search-dropdown').hide();
            });
            // 외부 클릭 시 드롭다운 닫기
            $(document).click(function (e) {
                if (!$(e.target).closest('.search').length) {
                    $('.search-dropdown').hide();
                }
            });
            // 검색 아이콘 클릭
            $('.search img').click(function () {
                const query = $('.search-bar input').val(); //입력된 검색어
                const category = $('.search-category div:first-child').text().trim(); // 선택된 카테고리

                if(query === ""){
                    alert(`검색어를 입력하세요`);
                }else{
                    alert(`카테고리: ${category}\n검색어: ${query}`);
                }
            });
            

            //로그인 상태창
            //채팅버튼
            $('#message-icon').click(function(){
            alert(`채팅 페이지로 이동~`);
            });
            //알람버튼
            $('#alarm-icon').click(function(){
            alert(`채팅 페이지로 이동~`);
            });

           

        });
