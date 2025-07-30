$(document).ready(function () {
      // 더미 게시글 데이터
      const posts = Array.from({ length: 50 }, (_, i) => ({
        id: i + 1,
        title: `게시글 제목 ${i + 1}`,
        writer: 'windsky01',
        date: '25.07.09 13:45',
        views: Math.floor(Math.random() * 1000),
        likes: Math.floor(Math.random() * 100),
        region: ['서울특별시', '경기도', '인천'][i % 3],
        category: ['운동', '문화/예술', '동네친구'][i % 3],
      }));

      let currentPage = 1;
      const postsPerPage = 10;

      function getFilteredPosts() {
        const selectedRegions = $('input[name="region"]:checked').map((_, el) => el.value).get();
        const selectedCategories = $('input[name="category"]:checked').map((_, el) => el.value).get();
        const sortBy = $('input[name="sort"]:checked').val();

        let filtered = posts.slice();

        if (selectedRegions.length > 0) {
          filtered = filtered.filter(p => selectedRegions.includes(p.region));
        }

        if (selectedCategories.length > 0) {
          filtered = filtered.filter(p => selectedCategories.includes(p.category));
        }

        if (sortBy === 'views') {
          filtered.sort((a, b) => b.views - a.views);
        } else if (sortBy === 'likes') {
          filtered.sort((a, b) => b.likes - a.likes);
        } else {
          filtered.sort((a, b) => b.id - a.id); // 최신순은 id 기준
        }

        return filtered;
      }

      function renderPosts(page = 1) {
        const filteredPosts = getFilteredPosts();
        const start = (page - 1) * postsPerPage;
        const end = start + postsPerPage;
        const pagePosts = filteredPosts.slice(start, end);

        $('#postList').empty();
        pagePosts.forEach(post => {
          $('#postList').append(`
            <tr class="post-row" data-id="${post.id}">
              <td>${post.id}</td>
              <td>${post.title}</td>
              <td>${post.writer}</td>
              <td>${post.date}</td>
              <td>${post.views}</td>
              <td>${post.likes}</td>
            </tr>
          `);
        });

        renderPagination(filteredPosts.length);
      }

      function renderPagination(totalPosts) {
        const totalPages = Math.ceil(totalPosts / postsPerPage);
        $('#pagination').empty();
        for (let i = 1; i <= totalPages; i++) {
          $('#pagination').append(`<span class="page-btn ${i === currentPage ? 'active' : ''}" data-page="${i}">${i}</span>`);
        }
      }

      $(document).on('click', '.page-btn', function () {
        currentPage = parseInt($(this).data('page'));
        renderPosts(currentPage);
      });

    //   // 필터 변경 시 렌더링
    //   $('input[name="region"], input[name="sort"], input[name="category"]').on('change', function () {
    //     currentPage = 1;
    //     renderPosts(currentPage);
    //   });
      //필터 변경시 적용
      $('#applyFilterBtn').on('click',function(){
        currentPage = 1;
        renderPosts(currentPage);
      })

      // 초기 렌더링
      renderPosts(currentPage);

      $('#openListBtn').click(() => {
        alert("오픈채팅방 리스트 연결");
      });
    });