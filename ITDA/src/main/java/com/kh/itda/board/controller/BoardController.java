package com.kh.itda.board.controller;



import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.itda.board.model.service.BoardService;
import com.kh.itda.board.model.vo.AuctionBidding;
import com.kh.itda.board.model.vo.BoardAuction;
import com.kh.itda.board.model.vo.BoardAuctionFileWrapper;
import com.kh.itda.board.model.vo.BoardAuctionWrapper;
import com.kh.itda.board.model.vo.BoardCommon;
import com.kh.itda.board.model.vo.BoardExchange;
import com.kh.itda.board.model.vo.BoardExchangeWrapper;
import com.kh.itda.board.model.vo.BoardRental;
import com.kh.itda.board.model.vo.BoardRentalFileWrapper;
import com.kh.itda.board.model.vo.BoardRentalWrapper;
import com.kh.itda.board.model.vo.BoardShareFileWrapper;
import com.kh.itda.board.model.vo.BoardShareWrapper;
import com.kh.itda.board.model.vo.BoardSharing;
import com.kh.itda.board.model.vo.Dibs;
import com.kh.itda.board.model.vo.ProductCategory;
import com.kh.itda.common.Utils;
import com.kh.itda.common.model.vo.File;
import com.kh.itda.common.model.vo.FilePath;
import com.kh.itda.support.model.vo.Report;
import com.kh.itda.user.model.service.UserService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@RequestMapping("/board") // 거래 게시판 공통 URL
@Slf4j
public class BoardController {

	@Autowired
	private final BoardService boardService;
	private final UserService userService;

	private final ServletContext application;

	@InitBinder
	public void initBinder(WebDataBinder binder) {
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		dateFormat.setLenient(false);
		binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, true));
	}

	// 대여게시판 매핑
	// 리스트를 정렬할 조건들을 선택해서 정렬버튼을 눌렀을 시 파라미터를 받아와서 해시맵에 저장
	@GetMapping("/rental/list")
	public String rentalBoard(Model model, @RequestParam(defaultValue = "date") String sort,
			@RequestParam(value = "boardCommon.productCategoryL", required = false) String productCategoryL,
			@RequestParam(value = "boardCommon.productCategoryM", required = false) String productCategoryM,
			@RequestParam(value = "boardCommon.productCategoryS", required = false) String productCategoryS,
			@RequestParam(value = "searchProductCategoryL", required = false) String searchProductCategoryL,			
			@RequestParam(value = "keyword", required = false) String keyword,			
			@RequestParam(required = false) Integer minRentalFee, @RequestParam(required = false) Integer maxRentalFee,
			@RequestParam(required = false) Date startDate, @RequestParam(required = false) Date endDate) {
		Map<String, Object> filterMap = new HashMap<>();
		filterMap.put("sort", sort);
		filterMap.put("productCategoryL", productCategoryL);
		filterMap.put("productCategoryM", productCategoryM);
		filterMap.put("productCategoryS", productCategoryS);
		filterMap.put("searchProductCategoryL", searchProductCategoryL);
		filterMap.put("keyword", keyword);
		filterMap.put("minRentalFee", minRentalFee);
		filterMap.put("maxRentalFee", maxRentalFee);
		filterMap.put("startDate", startDate);
		filterMap.put("endDate", endDate);
		System.out.println("searchProductCategoryL파라미터 잘 받아왔나?"+searchProductCategoryL);
		System.out.println("keyword키워드 잘 받아왔나?"+keyword);
		System.out.println("filterMapㅍ필터맵?"+filterMap);
		// 로그인한 유저 정보
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		Object principal = auth.getPrincipal();
		String userId = ((UserDetails) principal).getUsername();
		int userNum = Integer.parseInt(userService.selectUserNum(userId));
		model.addAttribute("userNum", userNum);
		
		// 선택한 정렬조건에 따른 리스트 출력
		List<BoardRentalFileWrapper> boardRentalList = boardService.selectBoardRentalList(filterMap);
		model.addAttribute("list", boardRentalList);

		// 로그인한 회원이 찜한 게시글 목록
		// userNum을 로그인 세션에서 받아올것임(지금은 임의 데이터)
		List<Integer> likedBoardIds = boardService.getLikedBoardIdsByUser(userNum);
		model.addAttribute("likedBoardIds", likedBoardIds);

		// 상품카테고리 가져오기
		List<ProductCategory> categoryList = boardService.selectCategoryList();

		model.addAttribute("categoryList", categoryList);

		return "board/rentalBoard";
	}

	// 나눔게시판 매핑
	@GetMapping("/share/list")
	public String shareBoard(
			Model model, @RequestParam(defaultValue = "date") String sort,
			@RequestParam(value = "boardCommon.productCategoryL", required = false) String productCategoryL,
			@RequestParam(value = "boardCommon.productCategoryM", required = false) String productCategoryM,
			@RequestParam(value = "boardCommon.productCategoryS", required = false) String productCategoryS,
			@RequestParam(value = "searchProductCategoryL", required = false) String searchProductCategoryL,			
			@RequestParam(value = "keyword", required = false) String keyword		
			) {
				Map<String, Object> filterMap = new HashMap<>();
				filterMap.put("sort", sort);
				filterMap.put("productCategoryL", productCategoryL);
				filterMap.put("productCategoryM", productCategoryM);
				filterMap.put("productCategoryS", productCategoryS);
				filterMap.put("searchProductCategoryL", searchProductCategoryL);
				filterMap.put("keyword", keyword);
				
				// 로그인한 유저 정보
				Authentication auth = SecurityContextHolder.getContext().getAuthentication();
				Object principal = auth.getPrincipal();
				String userId = ((UserDetails) principal).getUsername();
				int userNum = Integer.parseInt(userService.selectUserNum(userId));
				model.addAttribute("userNum", userNum);
				
				
				// 선택한 정렬조건에 따른 리스트 출력
				List<BoardShareFileWrapper> boardShareList = boardService.selectBoardShareList(filterMap);
				model.addAttribute("list", boardShareList);
				
				// 로그인한 회원이 찜한 게시글 목록
				// userNum을 로그인 세션에서 받아올것임(지금은 임의 데이터)
				List<Integer> likedBoardIds = boardService.getLikedBoardIdsByUser(userNum);
				model.addAttribute("likedBoardIds", likedBoardIds);

				// 상품카테고리 가져오기
				List<ProductCategory> categoryList = boardService.selectCategoryList();

				model.addAttribute("categoryList", categoryList);
				System.out.println("필터링:" + categoryList);
		
		return "board/shareBoard";
	}


	// 경매게시판 매핑
	// 리스트를 정렬할 조건들을 선택해서 정렬버튼을 눌렀을 시 파라미터를 받아와서 해시맵에 저장
	@GetMapping("/auction/list")
	public String auctionBoard(Model model, @RequestParam(defaultValue = "date") String sort,
				@RequestParam(value = "boardCommon.productCategoryL", required = false) String productCategoryL,
				@RequestParam(value = "boardCommon.productCategoryM", required = false) String productCategoryM,
				@RequestParam(value = "boardCommon.productCategoryS", required = false) String productCategoryS,
				@RequestParam(value = "searchProductCategoryL", required = false) String searchProductCategoryL,			
				@RequestParam(value = "keyword", required = false) String keyword,		
				@RequestParam(required = false) Integer minBid, @RequestParam(required = false) Integer maxBid,
				@RequestParam(required = false) Date startDate, @RequestParam(required = false) Date endDate) {
			Map<String, Object> filterMap = new HashMap<>();
			filterMap.put("sort", sort);
			filterMap.put("productCategoryL", productCategoryL);
			filterMap.put("productCategoryM", productCategoryM);
			filterMap.put("productCategoryS", productCategoryS);
			filterMap.put("searchProductCategoryL", searchProductCategoryL);
			filterMap.put("keyword", keyword);
			filterMap.put("minBid", minBid);
			filterMap.put("maxBid", maxBid);
			filterMap.put("startDate", startDate);
			filterMap.put("endDate", endDate);
			
			// 로그인한 유저 정보
			Authentication auth = SecurityContextHolder.getContext().getAuthentication();
			Object principal = auth.getPrincipal();
			String userId = ((UserDetails) principal).getUsername();
			int userNum = Integer.parseInt(userService.selectUserNum(userId));
			model.addAttribute("userNum", userNum);
			
			// 선택한 정렬조건에 따른 리스트 출력
			List<BoardAuctionFileWrapper> boardAuctionList = boardService.selectBoardAuctionList(filterMap);
			System.out.println("경매글"+boardAuctionList);
			model.addAttribute("list", boardAuctionList);

			// 로그인한 회원이 찜한 게시글 목록
			// userNum을 로그인 세션에서 받아올것임(지금은 임의 데이터)
			List<Integer> likedBoardIds = boardService.getLikedBoardIdsByUser(userNum);
			model.addAttribute("likedBoardIds", likedBoardIds);

			// 상품카테고리 가져오기
			List<ProductCategory> categoryList = boardService.selectCategoryList();

			model.addAttribute("categoryList", categoryList);
			System.out.println("필터링:" + categoryList);

			return "board/auctionBoard";
		}

	
	// 글쓰기들은 로그인된 사용자만 가능하도록 시큐리티 적용 해야함
	// 글쓰기 버튼 자체를 로그인을 해야지만 보이게 하면 될듯
	// 거래 글쓰기 페이지 이동 매핑
	// boardCategory => 각 게시판에서 글쓰기를 누를 시에 저장되는 게시판 유형 값
	@GetMapping("/write/{boardCategory}")
	public String boardWrite(@PathVariable("boardCategory") String boardCategory, Model model) {
		// 글쓰기 버틀을 클릭했을시 주소에 담겨지는 게시판 카테고리별로 다른 정보를 담을수 있도록
		switch (boardCategory) {
		case "rental":
			BoardRentalWrapper rentalBoard = new BoardRentalWrapper();
			rentalBoard.setBoardCommon(new BoardCommon());
			rentalBoard.setBoardRental(new BoardRental());
			model.addAttribute("board", rentalBoard);
			break;
		case "share":
			BoardShareWrapper sharingBoard = new BoardShareWrapper();
			sharingBoard.setBoardCommon(new BoardCommon());
			sharingBoard.setBoardSharing(new BoardSharing());
			model.addAttribute("board", sharingBoard);
			break;
		case "auction":
			BoardAuctionWrapper auctionBoard = new BoardAuctionWrapper();
			auctionBoard.setBoardCommon(new BoardCommon());
			auctionBoard.setBoardAuction(new BoardAuction());
			model.addAttribute("board", auctionBoard);
			break;
		case "exchange":
			BoardExchangeWrapper exchangeBoard = new BoardExchangeWrapper();
			exchangeBoard.setBoardCommon(new BoardCommon());
			exchangeBoard.setBoardExchange(new BoardExchange());
			model.addAttribute("board", exchangeBoard);
			break;

		}
		// 상품 카테고리 추출
		List<ProductCategory> list = boardService.selectCategoryList();
		model.addAttribute("list", list);
		
		// 회원의 위치 정보 추출
		// 로그인한 유저 정보
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		Object principal = auth.getPrincipal();
		String userId = ((UserDetails) principal).getUsername();
		int userNum = Integer.parseInt(userService.selectUserNum(userId));
		model.addAttribute("userNum", userNum);
		
		String userAddress = boardService.selectUserAddress(userNum);
		
		System.out.println("사용자의 주소"+userAddress);
		String[] userAddressParts = userAddress.split("\\s+");
		System.out.println("사용자의 주소"+userAddressParts);

		String address;
		if(userAddressParts.length >=2 ) {
			address = userAddressParts[0] + " " + userAddressParts[1];
		} else {
			address = userAddress;
		}
		System.out.println("사용자의 주소"+address);
		model.addAttribute("userAddress", address);
		return "board/writeBoard";
	}

	// 상위 분류 카테고리를 선택시에 해당하는 하위 분류 카테고리를 추출 
	@GetMapping("/getSubCategories")
	@ResponseBody
	public List<ProductCategory> getSubCategories(@RequestParam("parentNum") int parentNum) {
		return boardService.getCategoriesByParentNum(parentNum);
	}

	// 대여 글쓰기 URL 매핑
	@PostMapping("/write/rental")
	public String boardRentalInsert(@ModelAttribute BoardRentalWrapper board,
			// @PathVariable("boardCategory") String boardCategory,
			Model model, RedirectAttributes ra,
			@RequestParam(value = "upfile", required = false) List<MultipartFile> upfiles
			) {
		/*
		 * 업무로직 1. 첨부파일(이미지)이 존재하는지 확인 1) 존재하지 않는다면 게시글 등록 실패 2. 게시판 정보 등록 및 첨부파일 정보 등록을
		 * 위한 서비스 호출 1) 게시글 정보 등록에 필요한 정보 바인딩 - 회원 정보에서 가져올 것(테스트에선 임의로 줄것) : 회원번호,
		 * 거래장소(글쓰기화면에서 변경 가능) - 거래 유형(BoardCategory) - url에서 넘겨줌 - 상품 카테고리 - DB에 추가해서
		 * 화면에 띄워주고 선택하면 선택된 카테고리 아이디가 저장됨(테스트에서 임의로 줄것)
		 * 
		 * 3. 게시글 등록 결과에 따른 페이지 지정
		 */
		// boardCategory = "rental";
		
		// 로그인한 유저 정보
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		Object principal = auth.getPrincipal();
		String userId = ((UserDetails) principal).getUsername();
		int userNum = Integer.parseInt(userService.selectUserNum(userId));
		
		

		List<File> imgList = new ArrayList<>();

		System.out.println("이미지:" + upfiles);
		for (MultipartFile upfile : upfiles) {

			System.out.println("현재 저장중인 이미지 : " + upfile);
			if (upfile.isEmpty()) {
				continue;// 업로드한 첨부파일이 존재한다면 저장 진행
			}

			String imgPath = Utils.saveFileToCategoryFolder(upfile, application, "board/rental");
			File f = new File();

			f.setFileName(imgPath);

			imgList.add(f);

			System.out.println("저장된이미지리스트:" + imgList);
		}

		model.addAttribute("board", board);

		String userAddress = boardService.selectUserAddress(userNum);
		
		String[] userAddressParts = userAddress.split("\\s+");
		String address;
		if(userAddressParts.length >=2 ) {
			address = userAddressParts[0] + " " + userAddressParts[1];
		} else {
			address = userAddress;
		}
		

		board.getBoardCommon().setUserNum(userNum);
		board.getBoardCommon().setTransactionAddress(address);// 테스트용 임의 지정
		board.getBoardCommon().setTransactionCategory("rental");

		int result = boardService.insertBoardRental(board, imgList);
		if (result == 0) {
			throw new RuntimeException("게시글 작성 실패");

		}
		
		ra.addFlashAttribute("alertMsg", "게시글 작성 성공");
		return "redirect:/board/detail/rental/" +board.getBoardCommon().getBoardId();
	}

	// 나눔 글쓰기 URL 매핑
	// boardCategory => 각 게시판에서 글쓰기를 누를 시에 저장되는 게시판 유형 값
	@PostMapping("/write/share")
	public String boardShareInsert(@ModelAttribute BoardShareWrapper board,
			// @PathVariable("boardCategory") String boardCategory,
			Model model, RedirectAttributes ra,
			@RequestParam(value = "upfile", required = false) List<MultipartFile> upfiles) {
		
		// 로그인한 유저 정보
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		Object principal = auth.getPrincipal();
		String userId = ((UserDetails) principal).getUsername();
		int userNum = Integer.parseInt(userService.selectUserNum(userId));

		List<File> imgList = new ArrayList<>();

		System.out.println("이미지:" + upfiles);
		for (MultipartFile upfile : upfiles) {

			System.out.println("현재 저장중인 이미지 : " + upfile);
			if (upfile.isEmpty()) {
				continue;// 업로드한 첨부파일이 존재한다면 저장 진행
			}

			String imgPath = Utils.saveFileToCategoryFolder(upfile, application, "board/share");
			File f = new File();

			f.setFileName(imgPath);

			imgList.add(f);

			System.out.println("저장된이미지리스트:" + imgList);
		}

		model.addAttribute("board", board);
		
		String userAddress = boardService.selectUserAddress(userNum);
		
		String[] userAddressParts = userAddress.split("\\s+");
		String address;
		if(userAddressParts.length >=2 ) {
			address = userAddressParts[0] + " " + userAddressParts[1];
		} else {
			address = userAddress;
		}

		board.getBoardCommon().setUserNum(userNum);
		board.getBoardCommon().setTransactionAddress(address);
		board.getBoardCommon().setTransactionCategory("share");

		
		int result = boardService.insertBoardShare(board, imgList);
		if (result == 0) {
			throw new RuntimeException("게시글 작성 실패");

		}
		
		ra.addFlashAttribute("alertMsg", "게시글 작성 성공");
		
		
		
		
		return "redirect:/board/detail/share/" +board.getBoardCommon().getBoardId();
	}

	// 경매 글쓰기 페이지 이동 매핑
	// boardCategory => 각 게시판에서 글쓰기를 누를 시에 저장되는 게시판 유형 값
	@PostMapping("/write/auction")
	public String boardAuctionInsert(@ModelAttribute BoardAuctionWrapper board,
			// @PathVariable("boardCategory") String boardCategory,
			Model model, RedirectAttributes ra,
			@RequestParam(value = "upfile", required = false) List<MultipartFile> upfiles) {
				Authentication auth = SecurityContextHolder.getContext().getAuthentication();
				Object principal = auth.getPrincipal();
				String userId = ((UserDetails) principal).getUsername();
				String userNum = userService.selectUserNum(userId);
		
		
				List<File> imgList = new ArrayList<>();
		
				System.out.println("이미지:" + upfiles);
				for (MultipartFile upfile : upfiles) {
		
					System.out.println("현재 저장중인 이미지 : " + upfile);
					if (upfile.isEmpty()) {
						continue;// 업로드한 첨부파일이 존재한다면 저장 진행
					}
		
					String imgPath = Utils.saveFileToCategoryFolder(upfile, application, "board/auction");
					File f = new File();
		
					f.setFileName(imgPath);
		
					imgList.add(f);
		
					System.out.println("저장된이미지리스트:" + imgList);
				}
		
				model.addAttribute("board", board);
				
				String userAddress = boardService.selectUserAddress(Integer.parseInt(userNum));
				
				String[] userAddressParts = userAddress.split("\\s+");
				String address;
				if(userAddressParts.length >=2 ) {
					address = userAddressParts[0] + " " + userAddressParts[1];
				} else {
					address = userAddress;
				}
		
				board.getBoardCommon().setUserNum(Integer.parseInt(userNum));
				board.getBoardCommon().setTransactionAddress(address);// 테스트용 임의 지정
				board.getBoardCommon().setTransactionCategory("auction");
		
				// System.out.println("태그:"+boardCommon.getTagList());
				// System.out.println("저장된이미지리스트:"+imgList);
				int result = boardService.insertBoardAuction(board, imgList);
				if (result == 0) {
					throw new RuntimeException("게시글 작성 실패");
		
				}
				
				ra.addFlashAttribute("alertMsg", "게시글 작성 성공");
				return "redirect:/board/detail/auction/" +board.getBoardCommon().getBoardId();
			}
		
			// 교환 글쓰기 페이지 이동 매핑
			// boardCategory => 각 게시판에서 글쓰기를 누를 시에 저장되는 게시판 유형 값
			@PostMapping("/write/exchange")
			public String boardExchangeInsert(@ModelAttribute BoardExchangeWrapper board,
					// @PathVariable("boardCategory") String boardCategory,
					Model model, RedirectAttributes ra,
					@RequestParam(value = "upfile", required = false) List<MultipartFile> upfiles) {
		
				return "redirect:/board/" + "exchange";
			}

	// 대여 게시글 상세보기
	// 게시물 목록에서 게시물을 클릭하면 클릭한 게시물의 아이디가 boardId로 바인딩
	@GetMapping("/detail/rental/{boardId}")
	public String boardDetailRental(@PathVariable("boardId") int boardId, Model model,
			@CookieValue(value = "readBoardNo", required = false) String readBoardNoCookie, HttpServletRequest req,
			HttpServletResponse res) {
		// 로그인한 유저 정보
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		Object principal = auth.getPrincipal();
		String userId = ((UserDetails) principal).getUsername();
		int userNum = Integer.parseInt(userService.selectUserNum(userId));
		model.addAttribute("userNum", userNum);
		model.addAttribute("report", new Report());
		// 대여 게시글 정보 추출
		BoardRentalWrapper board = boardService.selectBoardRental(boardId);
		model.addAttribute("board", board);
		if (board == null) {
			throw new RuntimeException("게시글이 존재하지 않습니다.");
		}
		int writerUserNum = board.getBoardCommon().getUserNum();

		// 조회수 증가
		if(userNum != board.getBoardCommon().getUserNum()) {
			boolean increase = false; // 조회수 증가를 위한 체크변수
	
			// readBoardNo라는 이름의 쿠키가 있는지 조사.
			if (readBoardNoCookie == null) {
				// 첫 조회
				increase = true;
				readBoardNoCookie = boardId + "";
			} else {
				// 쿠키가 있는 경우
				List<String> list = Arrays.asList(readBoardNoCookie.split("/"));
				// 기존 쿠키값들 중 게시글번호와 일치하는 값이 하나도 없는 경우
				if (list.indexOf(boardId + "") == -1) {
					increase = true;
					readBoardNoCookie += "/" + boardId;
				}
			}
	
			if (increase) {
				int result = boardService.increaseViews(boardId);
				if (result > 0) {
					board.getBoardCommon().setViews(board.getBoardCommon().getViews() + 1);
	
					// 새 쿠키 생성하여 클라이언트에게 전달
					Cookie newCookie = new Cookie("readBoardNo", readBoardNoCookie);
					newCookie.setPath(req.getContextPath());
					newCookie.setMaxAge(1 * 60 * 60); // 1시간
					res.addCookie(newCookie);
				}
			}
		}

		// 게시물의 이미지
		List<FilePath> imgList = boardService.selectImgList(boardId);
		System.out.println(imgList);
		model.addAttribute("imgList", imgList);

		// 조회한 게시글의 게시자가 올린 다른 대여 상품들
		List<BoardRentalFileWrapper> writerRentalWrapperList = boardService.selectWriterRentalList(writerUserNum);
		model.addAttribute("writerRentalWrapperList", writerRentalWrapperList);
		System.out.println("게시자의 다른 상품 : " + writerRentalWrapperList);

		// 조회한 게시글과 소분류 카테고리가 같은 대여 상품들
		String smallCategory = board.getBoardCommon().getProductCategoryS();
		List<BoardRentalFileWrapper> equalsCategoryList = boardService.selectEqualsCategoryList(smallCategory);
		model.addAttribute("equalsCategoryList", equalsCategoryList);

		// 선택한 대여 게시물의 게시자 닉네임 추출
		String writer = boardService.selectWriterNickname(writerUserNum);
		model.addAttribute("writer", writer);
		System.out.println(writerUserNum);

		// 선택한 대여 게시물의 게시자 매너점수 추출
		int mannerScore = boardService.selectMannerScore(writerUserNum);
		model.addAttribute("mannerScore", mannerScore);

		// 선택한 대여 게시물의 태그 추출
		List<String> tags = boardService.selectTags(boardId);
		model.addAttribute("tags", tags);

		// 선택한 대여 게시물의 찜 수 추출
		Dibs dibs = new Dibs();
		dibs.setBoardId(boardId);
		dibs.setBoardCategory("rental");
		int dibsCount = boardService.countDibs(dibs);
		model.addAttribute("dibsCount", dibsCount);
		
		// 접속한 회원아이디
		dibs.setLikesUserId(userNum);
		
		
		boolean exists = boardService.isLiked(dibs);
		System.out.println();
		if (exists) {
			
			model.addAttribute("isDibs", exists);
		} else {
			model.addAttribute("isDibs", exists);
		}

		// 게시자의 프로필 이미지
		String profileImage = boardService.getProfileImage(writerUserNum);
		model.addAttribute("profileImage", profileImage);

		return "board/detailRental";
	}
	
	// 나눔 게시글 상세보기
	// 게시물 목록에서 게시물을 클릭하면 클릭한 게시물의 아이디가 boardId로 바인딩
	@GetMapping("/detail/share/{boardId}")
	public String boardDetailShare(@PathVariable("boardId") int boardId, Model model,
			@CookieValue(value = "readBoardShareNo", required = false) String readBoardShareNoCookie, HttpServletRequest req,
			HttpServletResponse res) {
		
				// 로그인한 유저 정보
				Authentication auth = SecurityContextHolder.getContext().getAuthentication();
				Object principal = auth.getPrincipal();
				String userId = ((UserDetails) principal).getUsername();
				int userNum = Integer.parseInt(userService.selectUserNum(userId));
				model.addAttribute("userNum", userNum);
				model.addAttribute("report", new Report());
				// 대여 게시글 정보 추출
				BoardShareWrapper board = boardService.selectBoardShare(boardId);
				model.addAttribute("board", board);
				if (board == null) {
					throw new RuntimeException("게시글이 존재하지 않습니다.");
				}
				int writerUserNum = board.getBoardCommon().getUserNum();

				// 조회수 증가
				if(userNum != board.getBoardCommon().getUserNum()) {
					boolean increase = false; // 조회수 증가를 위한 체크변수
	
					// readBoardNo라는 이름의 쿠키가 있는지 조사.
					if (readBoardShareNoCookie == null) {
						// 첫 조회
						increase = true;
						readBoardShareNoCookie = boardId + "";
					} else {
						// 쿠키가 있는 경우
						List<String> list = Arrays.asList(readBoardShareNoCookie.split("/"));
						// 기존 쿠키값들 중 게시글번호와 일치하는 값이 하나도 없는 경우
						if (list.indexOf(boardId + "") == -1) {
							increase = true;
							readBoardShareNoCookie += "/" + boardId;
						}
					}
					System.out.println("조회수"+increase);
					if (increase) {
						System.out.println("조회수"+increase);
						System.out.println("boardId"+boardId);
						int result = boardService.increaseViews(boardId);
						System.out.println("조회수증가결과:"+result);
						if (result > 0) {
							board.getBoardCommon().setViews(board.getBoardCommon().getViews() + 1);
	
							// 새 쿠키 생성하여 클라이언트에게 전달
							Cookie newCookie = new Cookie("readBoardShareNo", readBoardShareNoCookie);
							System.out.println("쿠키"+readBoardShareNoCookie);
							System.out.println("새쿠키"+newCookie);
							newCookie.setPath("req.getContextPath()");
							newCookie.setMaxAge(1 * 60 * 60); // 1시간
							res.addCookie(newCookie);
						}
					}
				}

				// 게시물의 이미지
				List<FilePath> imgList = boardService.selectShareImgList(boardId);
				System.out.println(imgList);
				model.addAttribute("imgList", imgList);

				// 조회한 게시글의 게시자가 올린 다른 대여 상품들
				List<BoardShareFileWrapper> writerShareWrapperList = boardService.selectWriterShareList(writerUserNum);
				model.addAttribute("writerShareWrapperList", writerShareWrapperList);
				System.out.println("게시자의 다른 상품 : " + writerShareWrapperList);

				// 조회한 게시글과 소분류 카테고리가 같은 대여 상품들
				String smallCategory = board.getBoardCommon().getProductCategoryS();
				List<BoardShareFileWrapper> equalsCategoryList = boardService.selectEqualsCategoryShareList(smallCategory);
				model.addAttribute("equalsCategoryList", equalsCategoryList);

				// 선택한 대여 게시물의 게시자 닉네임 추출
				String writer = boardService.selectWriterNickname(writerUserNum);
				model.addAttribute("writer", writer);
				System.out.println(writerUserNum);

				// 선택한 대여 게시물의 게시자 매너점수 추출
				int mannerScore = boardService.selectMannerScore(writerUserNum);
				model.addAttribute("mannerScore", mannerScore);

				// 선택한 대여 게시물의 태그 추출
				List<String> tags = boardService.selectTags(boardId);
				model.addAttribute("tags", tags);

				// 선택한 대여 게시물의 찜 수 추출
				Dibs dibs = new Dibs();
				dibs.setBoardId(boardId);
				dibs.setBoardCategory("share");
				int dibsCount = boardService.countDibs(dibs);
				model.addAttribute("dibsCount", dibsCount);
				
				// 접속한 회원아이디
				dibs.setLikesUserId(userNum);
				
				boolean exists = boardService.isLiked(dibs);
				System.out.println();
				if (exists) {
					
					model.addAttribute("isDibs", exists);
				} else {
					model.addAttribute("isDibs", exists);
				}

				// 게시자의 프로필 이미지
				String profileImage = boardService.getProfileImage(writerUserNum);
				model.addAttribute("profileImage", profileImage);
				return "board/detailShare";
			}

		// 경매 게시글 상세보기
		// 게시물 목록에서 게시물을 클릭하면 클릭한 게시물의 아이디가 boardId로 바인딩
		@GetMapping("/detail/auction/{boardId}")
		public String boardDetailAuction(@PathVariable("boardId") int boardId, Model model,
				@CookieValue(value = "readBoardShareNo", required = false) String readBoardShareNoCookie, HttpServletRequest req,
				HttpServletResponse res) {
					//boardService.insertBiddingWinner();
					Authentication auth = SecurityContextHolder.getContext().getAuthentication();
					Object principal = auth.getPrincipal();
					String userId = ((UserDetails) principal).getUsername();
					String userNickname = userService.selectUserNickname(userId);
					String userNum = userService.selectUserNum(userId);
					model.addAttribute("report", new Report());
					
					System.out.println("회원번호"+userNum);
					model.addAttribute("userNickname", userNickname);
					model.addAttribute("userNum", userNum);
					
					// 입찰금 목록 가져오기
					List<AuctionBidding> bidList = boardService.selectBidList(boardId);
				
					model.addAttribute("bidList", bidList);
					
					
					
					// 경매 게시글 정보 추출
					BoardAuctionWrapper board = boardService.selectBoardAuction(boardId);
					model.addAttribute("board", board);
					if (board == null) {
						throw new RuntimeException("게시글이 존재하지 않습니다.");
					}
					int writerUserNum = board.getBoardCommon().getUserNum();

					// 조회수 증가
					if(Integer.parseInt(userNum) != board.getBoardCommon().getUserNum()) {
						boolean increase = false; // 조회수 증가를 위한 체크변수
	
						// readBoardNo라는 이름의 쿠키가 있는지 조사.
						if (readBoardShareNoCookie == null) {
							// 첫 조회
							increase = true;
							readBoardShareNoCookie = boardId + "";
						} else {
							// 쿠키가 있는 경우
							List<String> list = Arrays.asList(readBoardShareNoCookie.split("/"));
							// 기존 쿠키값들 중 게시글번호와 일치하는 값이 하나도 없는 경우
							if (list.indexOf(boardId + "") == -1) {
								increase = true;
								readBoardShareNoCookie += "/" + boardId;
							}
						}
						if (increase) {
							int result = boardService.increaseViews(boardId);
							if (result > 0) {
								board.getBoardCommon().setViews(board.getBoardCommon().getViews() + 1);
	
								// 새 쿠키 생성하여 클라이언트에게 전달
								Cookie newCookie = new Cookie("readBoardShareNo", readBoardShareNoCookie);
								System.out.println("쿠키"+readBoardShareNoCookie);
								System.out.println("새쿠키"+newCookie);
								newCookie.setPath("req.getContextPath()");
								newCookie.setMaxAge(1 * 60 * 60); // 1시간
								res.addCookie(newCookie);
							}
						}
					}
					
					// 경매 종료일자와 현재 날짜 비교해서 입찰 제시 버튼 활성화/비활성화
					Date endDate = board.getBoardAuction().getAuctionEndDate();
					
					Calendar cal = Calendar.getInstance();
					cal.setTime(endDate);
					cal.add(Calendar.DATE, 1); // DB에는 날짜만 저장되서 시간이 00시임 하루 더하기
					Date endDatePlusOne = cal.getTime();
					
					Date today = new Date();

					if(today.compareTo(endDatePlusOne) > 0) {
						 // today가 endDate보다 나중임
						// 경매끝
						model.addAttribute("auctionEnd", "end");
					} else if(today.compareTo(endDatePlusOne) < 0) {
						 // today가 endDate보다 이전임
						// 경매중
						model.addAttribute("auctionEnd", "doing");
					} else {
						model.addAttribute("auctionEnd", "doing");
						
					}
					
					// 게시물의 이미지
					List<FilePath> imgList = boardService.selectAuctionImgList(boardId);
					System.out.println("경매이미지리스트"+imgList);
					model.addAttribute("imgList", imgList);

					// 조회한 게시글의 게시자가 올린 다른 경매 상품들
					List<BoardAuctionFileWrapper> writerAuctionWrapperList = boardService.selectWriterAuctionList(writerUserNum);
					model.addAttribute("writerAuctionWrapperList", writerAuctionWrapperList);
					System.out.println("게시자의 다른 상품 : " + writerAuctionWrapperList);

					// 조회한 게시글과 소분류 카테고리가 같은 경매 상품들
					String smallCategory = board.getBoardCommon().getProductCategoryS();
					List<BoardAuctionFileWrapper> equalsCategoryList = boardService.selectEqualsCategoryAuctionList(smallCategory);
					model.addAttribute("equalsCategoryList", equalsCategoryList);

					// 선택한 경매 게시물의 게시자 닉네임 추출
					String writer = boardService.selectWriterNickname(writerUserNum);
					model.addAttribute("writer", writer);
					System.out.println(writerUserNum);

					// 선택한 경매 게시물의 게시자 매너점수 추출
					int mannerScore = boardService.selectMannerScore(writerUserNum);
					model.addAttribute("mannerScore", mannerScore);
					
					

					// 선택한 경매 게시물의 태그 추출
					List<String> tags = boardService.selectTags(boardId);
					model.addAttribute("tags", tags);

					// 선택한 경매 게시물의 찜 수 추출
					Dibs dibs = new Dibs();
					dibs.setBoardId(boardId);
					dibs.setBoardCategory("auction");
					int dibsCount = boardService.countDibs(dibs);
					model.addAttribute("dibsCount", dibsCount);
					
					// 접속한 회원아이디
					dibs.setLikesUserId(Integer.parseInt(userNum));
					
					boolean exists = boardService.isLiked(dibs);
					System.out.println();
					if (exists) {
						model.addAttribute("isDibs", exists);
					} else {
						model.addAttribute("isDibs", exists);
					}
					
					// 게시자의 프로필 이미지
					String profileImage = boardService.getProfileImage(writerUserNum);
					model.addAttribute("profileImage", profileImage);

					return "board/detailAuction";
				}

	
	


	// 로그인한 사용자만 가능하게 시큐리티 적용 예정
	// 로그인한 사용자가 찜한 게시글인지 아닌지도 확인가능
	@PostMapping("/addDibs")
	@ResponseBody
	public ResponseEntity<?> toggleDibs(@RequestParam("userId") int userNum, @RequestParam("boardId") int boardId,
			@RequestParam("boardCategory") String boardCategory

	) {
		Dibs dibs = new Dibs();
		dibs.setBoardId(boardId);
		dibs.setLikesUserId(userNum);
		dibs.setBoardCategory(boardCategory);
		System.out.println(boardId);
		boolean exists = boardService.isLiked(dibs);

		if (exists) {
			boardService.removeLike(dibs);
			return ResponseEntity.ok("unliked");
		} else {
			boardService.addLike(dibs);
			return ResponseEntity.ok("liked");
		}
	}
	
	

	// 해당 게시글의 찜수 반환
	@GetMapping("/dibsCount")
	@ResponseBody
	public int getLikeCount(@RequestParam("boardId") int boardId,
			@RequestParam("boardCategory") String boardCategory) {
		Dibs dibs = new Dibs();
		dibs.setBoardId(boardId);
		dibs.setBoardCategory(boardCategory);

		return boardService.countDibs(dibs);
	}

	
	// 입력한 입찰 제시금 저장
	@PostMapping("/auction/bid")
	@ResponseBody
	public ResponseEntity<?> registerBid(@RequestBody AuctionBidding bid) {
	    try {
	    	System.out.println("입찰금:"+bid);
	    	
	    	AuctionBidding existingBid = boardService.findBidByUserAndBoard(bid.getBiddingUserNum(), bid.getBoardId());
	    	
	    	if(existingBid !=null) {
	    		boardService.updateBid(bid);
	    	} else {
	    		boardService.saveBid(bid); // DB 저장 처리
	    	}
	    	
	    	return ResponseEntity.ok().body("success");
	    } catch (Exception e) {
	    	e.printStackTrace();
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("fail");
	    }
	}
	
	
	@GetMapping("/bidding/check")
	@ResponseBody
	public Map<String, Object> checkBid(
	        @RequestParam("userNum") int userNum,
	        @RequestParam("boardId") int boardId) {

	    AuctionBidding existingBid = boardService.findBidByUserAndBoard(userNum, boardId);
	    
	    Map<String, Object> result = new HashMap<>();
	    if (existingBid != null) {
	        result.put("hasBid", true);
	        result.put("bid", existingBid.getBid());
	    } else {
	        result.put("hasBid", false);
	    }
	    
	    return result;
	}
	
	@PostMapping("/auction/winner")
	@ResponseBody
	public ResponseEntity<?> saveAuctionWinner(@RequestParam int boardId) {
	    try {
	    	
	    	boardService.insertBiddingWinner(boardId);
	    	
	    	return ResponseEntity.ok().body("success");
	    } catch (Exception e) {
	    	e.printStackTrace();
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("fail");
	    }
	}
	
	
	@PostMapping("delete/{boardCategory}/{boardId}")
	public String deleteBoard(
			@PathVariable int boardId,
			@PathVariable String boardCategory,
			RedirectAttributes redirectAttributes
			) {
	    try {
	        boardService.deleteBoard(boardId);
	        redirectAttributes.addFlashAttribute("message", "게시물이 삭제되었습니다.");
	    } catch (Exception e) {
	        redirectAttributes.addFlashAttribute("message", "삭제 중 오류가 발생했습니다.");
	    }
	    return "redirect:/board/"+boardCategory+"/list";
	}
	
}
