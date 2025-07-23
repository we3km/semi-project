package com.kh.itda.board.controller;


import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.core.io.ResourceLoader;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.itda.board.model.service.BoardService;
import com.kh.itda.board.model.vo.BoardAuction;
import com.kh.itda.board.model.vo.BoardAuctionWrapper;
import com.kh.itda.board.model.vo.BoardCommon;
import com.kh.itda.board.model.vo.BoardExchange;
import com.kh.itda.board.model.vo.BoardExchangeWrapper;
import com.kh.itda.board.model.vo.BoardRental;
import com.kh.itda.board.model.vo.BoardRentalWrapper;
import com.kh.itda.board.model.vo.BoardShareWrapper;
import com.kh.itda.board.model.vo.BoardSharing;
import com.kh.itda.board.model.vo.ProductCategory;
import com.kh.itda.common.Utils;
import com.kh.itda.common.model.vo.File;
import com.kh.itda.common.model.vo.FilePath;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@RequestMapping("/board") // 거래 게시판 공통 URL
@Slf4j
public class BoardController {
	
	@Autowired
	private final BoardService boardService;
	
	private final ServletContext application;
	private final ResourceLoader resourceLoader;

	
	@InitBinder
	public void initBinder(WebDataBinder binder) {
	    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
	    dateFormat.setLenient(false);
	    binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, true));
	}

	// 대여게시판 매핑
	@GetMapping("/rental")
	public String rentalBoard(Model model) {
		
		List<BoardRentalWrapper> boardRentalList = boardService.selectBoardRentalList();
		
	
		
		model.addAttribute("list",boardRentalList);
		return "board/rentalBoard";
	}
	
	// 나눔게시판 매핑
	@GetMapping("/share/list")
	public String shareBoard() {
		return "board/shareBoard";
	}
	
	// 교환게시판 매핑
	@GetMapping("/exchange/list")
	public String exchangeBoard() {
		return "board/exchangeBoard";
	}
	
	// 경매게시판 매핑
	@GetMapping("/auction/list")
	public String auctionBoard() {
		return "board/auctionBoard";
	}
	
	// 거래 글쓰기 페이지 이동 매핑
	// boardCategory => 각 게시판에서 글쓰기를 누를 시에 저장되는 게시판 유형 값
	@GetMapping("/write/{boardCategory}")
	public String boardWrite(
			@PathVariable("boardCategory") String boardCategory,
			Model model) {
		//model.addAttribute("boardCategory", boardCategory); // JSP로 전달
		
		switch(boardCategory) {
		case "rental" :
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

		
		List<ProductCategory> list = boardService.selectCategoryList();
		
		model.addAttribute("list",list);
		System.out.println(list);
		
		
		
		return "board/writeBoard";
	}
	
	@GetMapping("/getSubCategories")
	@ResponseBody
	public List<ProductCategory> getSubCategories(@RequestParam("parentNum") int parentNum) {
	    return boardService.getCategoriesByParentNum(parentNum);
	}
	
	// 대여 글쓰기 URL 매핑
	// boardCategory => 각 게시판에서 글쓰기를 누를 시에 저장되는 게시판 유형 값
	@PostMapping("/write/rental")
	public String boardRentalInsert(
			@ModelAttribute BoardRentalWrapper board,
			//@PathVariable("boardCategory") String boardCategory,
			Model model,
			RedirectAttributes ra,
			@RequestParam(value="upfile" , required = false) List<MultipartFile> upfiles
			) {
			/*
			 * 업무로직
			 * 1. 첨부파일(이미지)이 존재하는지 확인
			 *   1) 존재하지 않는다면 게시글 등록 실패
			 * 2. 게시판 정보 등록 및 첨부파일 정보 등록을 위한 서비스 호출
			 *   1) 게시글 정보 등록에 필요한 정보 바인딩
			 *    - 회원 정보에서 가져올 것(테스트에선 임의로 줄것) : 회원번호, 거래장소(글쓰기화면에서 변경 가능)
			 *    - 거래 유형(BoardCategory) - url에서 넘겨줌
			 *    - 상품 카테고리 - DB에 추가해서 화면에 띄워주고 선택하면 선택된 카테고리 아이디가 저장됨(테스트에서 임의로 줄것)
			 *    
			 * 3. 게시글 등록 결과에 따른 페이지 지정
			 * */
			//boardCategory = "rental";
		
			List<File> imgList = new ArrayList<>();
			List<FilePath> pathList = new ArrayList<>();
			System.out.println("이미지:"+upfiles);
			for(MultipartFile upfile : upfiles) {
				if(upfile.isEmpty()) {
					continue;// 업로드한 첨부파일이 존재한다면 저장 진행
				}
				System.out.println(upfile);
				
				String imgPath = Utils.saveFile(upfile, application, "rental"); 
				FilePath fp = new FilePath();
				File f = new File();
				
				fp.setPath(imgPath);
				f.setFileName(upfile.getOriginalFilename());
				pathList.add(fp);
				imgList.add(f);
			}
		
			model.addAttribute("board", board);
			//BoardCommon boardCommon = board.getBoardCommon();
			
			//BoardRental boardRental = board.getBoardRental();
			
			
			// User loginUser = (User) auth.getPrincipal();
//			boardCommon.setUserNum(1); // 테스트용 임의 지정
//			boardCommon.setTransactionAddress("서울특별시 강남구");// 테스트용 임의 지정
//			boardCommon.setTransactionCategory(boardCategory);
			
			board.getBoardCommon().setUserNum(1);
			board.getBoardCommon().setTransactionAddress("서울특별시 강남구");// 테스트용 임의 지정
			board.getBoardCommon().setTransactionCategory("rental");
			
			//System.out.println("태그:"+boardCommon.getTagList());
			
			int result = boardService.insertBoardRental(board, pathList, imgList);
			if(result == 0) {
				throw new RuntimeException("게시글 작성 실패");
				
			}
			
			ra.addFlashAttribute("alertMsg","게시글 작성 성공");
			return "redirect:/board/"+"rental";
	}
	
	// 나눔 글쓰기 페이지 이동 매핑
		// boardCategory => 각 게시판에서 글쓰기를 누를 시에 저장되는 게시판 유형 값
		@PostMapping("/write/share")
		public String boardShareInsert(
				@ModelAttribute BoardShareWrapper board,
				//@PathVariable("boardCategory") String boardCategory,
				Model model,
				RedirectAttributes ra,
				@RequestParam(value="upfile" , required = false) List<MultipartFile> upfiles
				) {
				/*
				 * 업무로직
				 * 1. 첨부파일(이미지)이 존재하는지 확인
				 *   1) 존재하지 않는다면 게시글 등록 실패
				 * 2. 게시판 정보 등록 및 첨부파일 정보 등록을 위한 서비스 호출
				 *   1) 게시글 정보 등록에 필요한 정보 바인딩
				 *    - 회원 정보에서 가져올 것(테스트에선 임의로 줄것) : 회원번호, 거래장소(글쓰기화면에서 변경 가능)
				 *    - 거래 유형(BoardCategory) - url에서 넘겨줌
				 *    - 상품 카테고리 - DB에 추가해서 화면에 띄워주고 선택하면 선택된 카테고리 아이디가 저장됨(테스트에서 임의로 줄것)
				 *    
				 * 3. 게시글 등록 결과에 따른 페이지 지정
				 * */
				//boardCategory = "share";
			
				List<File> imgList = new ArrayList<>();
				List<FilePath> pathList = new ArrayList<>();
				System.out.println("이미지:"+upfiles);
				for(MultipartFile upfile : upfiles) {
					if(upfile.isEmpty()) {
						continue;// 업로드한 첨부파일이 존재한다면 저장 진행
					}
					System.out.println(upfile);
					
					String imgPath = Utils.saveFile(upfile, application, "share"); 
					FilePath fp = new FilePath();
					File f = new File();
					
					fp.setPath(imgPath);
					f.setFileName(upfile.getOriginalFilename());
					pathList.add(fp);
					imgList.add(f);
				}
			
				model.addAttribute("board", board);
				//BoardCommon boardCommon = board.getBoardCommon();
				
				
				
				//BoardSharing boardSharing = board.getBoardSharing();
				// User loginUser = (User) auth.getPrincipal();
//				boardCommon.setUserNum(1); // 테스트용 임의 지정
//				boardCommon.setTransactionAddress("서울특별시 강남구");// 테스트용 임의 지정
//				boardCommon.setTransactionCategory(boardCategory);
				
				board.getBoardCommon().setUserNum(1);
				board.getBoardCommon().setTransactionAddress("서울특별시 강남구");// 테스트용 임의 지정
				board.getBoardCommon().setTransactionCategory("share");
				
				//System.out.println(boardSharing);
				
				//System.out.println("태그:"+boardCommon.getTagList());
				
				int result = boardService.insertBoardShare(board, pathList, imgList);
				if(result == 0) {
					throw new RuntimeException("게시글 작성 실패");
					
				}
				
				ra.addFlashAttribute("alertMsg","게시글 작성 성공");
				return "redirect:/board/"+"share";
		}
		
		// 경매 글쓰기 페이지 이동 매핑
		// boardCategory => 각 게시판에서 글쓰기를 누를 시에 저장되는 게시판 유형 값
		@PostMapping("/write/auction")
		public String boardActionInsert(
				@ModelAttribute BoardAuctionWrapper board,
				//@PathVariable("boardCategory") String boardCategory,
				Model model,
				RedirectAttributes ra,
				@RequestParam(value="upfile" , required = false) List<MultipartFile> upfiles
				) {
				/*
				 * 업무로직
				 * 1. 첨부파일(이미지)이 존재하는지 확인
				 *   1) 존재하지 않는다면 게시글 등록 실패
				 * 2. 게시판 정보 등록 및 첨부파일 정보 등록을 위한 서비스 호출
				 *   1) 게시글 정보 등록에 필요한 정보 바인딩
				 *    - 회원 정보에서 가져올 것(테스트에선 임의로 줄것) : 회원번호, 거래장소(글쓰기화면에서 변경 가능)
				 *    - 거래 유형(BoardCategory) - url에서 넘겨줌
				 *    - 상품 카테고리 - DB에 추가해서 화면에 띄워주고 선택하면 선택된 카테고리 아이디가 저장됨(테스트에서 임의로 줄것)
				 *    
				 * 3. 게시글 등록 결과에 따른 페이지 지정
				 * */
				//boardCategory = "auction";
				List<File> imgList = new ArrayList<>();
				List<FilePath> pathList = new ArrayList<>();
				System.out.println("이미지:"+upfiles);
				for(MultipartFile upfile : upfiles) {
					if(upfile.isEmpty()) {
						continue;// 업로드한 첨부파일이 존재한다면 저장 진행
					}
					System.out.println(upfile);
					
					String imgPath = Utils.saveFile(upfile, application, "auction"); 
					FilePath fp = new FilePath();
					File f = new File();
					
					fp.setPath(imgPath);
					f.setFileName(upfile.getOriginalFilename());
					pathList.add(fp);
					imgList.add(f);
				}
				
				model.addAttribute("board", board);
				//BoardCommon boardCommon = board.getBoardCommon();
				
				
				
				
				// User loginUser = (User) auth.getPrincipal();
//				boardCommon.setUserNum(1); // 테스트용 임의 지정
//				boardCommon.setTransactionAddress("서울특별시 강남구");// 테스트용 임의 지정
//				boardCommon.setTransactionCategory(boardCategory);
				
				board.getBoardCommon().setUserNum(1);
				board.getBoardCommon().setTransactionAddress("서울특별시 강남구");// 테스트용 임의 지정
				board.getBoardCommon().setTransactionCategory("auction");
								
				//System.out.println("태그:"+boardCommon.getTagList());
				
				int result = boardService.insertBoardAuction(board, pathList, imgList);
				if(result == 0) {
					throw new RuntimeException("게시글 작성 실패");
					
				}
				
				ra.addFlashAttribute("alertMsg","게시글 작성 성공");
				return "redirect:/board/"+"auction";
		}
		
		// 대여 글쓰기 페이지 이동 매핑
		// boardCategory => 각 게시판에서 글쓰기를 누를 시에 저장되는 게시판 유형 값
		@PostMapping("/write/exchange")
		public String boardExchangeInsert(
				@ModelAttribute BoardExchangeWrapper board,
				//@PathVariable("boardCategory") String boardCategory,
				Model model,
				RedirectAttributes ra,
				@RequestParam(value="upfile" , required = false) List<MultipartFile> upfiles
				) {
				/*
				 * 업무로직
				 * 1. 첨부파일(이미지)이 존재하는지 확인
				 *   1) 존재하지 않는다면 게시글 등록 실패
				 * 2. 게시판 정보 등록 및 첨부파일 정보 등록을 위한 서비스 호출
				 *   1) 게시글 정보 등록에 필요한 정보 바인딩
				 *    - 회원 정보에서 가져올 것(테스트에선 임의로 줄것) : 회원번호, 거래장소(글쓰기화면에서 변경 가능)
				 *    - 거래 유형(BoardCategory) - url에서 넘겨줌
				 *    - 상품 카테고리 - DB에 추가해서 화면에 띄워주고 선택하면 선택된 카테고리 아이디가 저장됨(테스트에서 임의로 줄것)
				 *    
				 * 3. 게시글 등록 결과에 따른 페이지 지정
				 * */
				//boardCategory = "exchange";
			
				List<File> imgList = new ArrayList<>();
				List<FilePath> pathList = new ArrayList<>();
				System.out.println("이미지:"+upfiles);
				for(MultipartFile upfile : upfiles) {
					if(upfile.isEmpty()) {
						continue;// 업로드한 첨부파일이 존재한다면 저장 진행
					}
					System.out.println(upfile);
					
					String imgPath = Utils.saveFile(upfile, application, "exchange"); 
					FilePath fp = new FilePath();
					File f = new File();
					
					fp.setPath(imgPath);
					f.setFileName(upfile.getOriginalFilename());
					pathList.add(fp);
					imgList.add(f);
				}
			
				model.addAttribute("board", board);
				//BoardCommon boardCommon = board.getBoardCommon();
				
				
//				// User loginUser = (User) auth.getPrincipal();
//				boardCommon.setUserNum(1); // 테스트용 임의 지정
//				boardCommon.setTransactionAddress("서울특별시 강남구");// 테스트용 임의 지정
//				boardCommon.setTransactionCategory(boardCategory);
				
				board.getBoardCommon().setUserNum(1);
				board.getBoardCommon().setTransactionAddress("서울특별시 강남구");// 테스트용 임의 지정
				board.getBoardCommon().setTransactionCategory("exchange");
				
				
				
				//System.out.println("태그:"+boardCommon.getTagList());
				
				int result = boardService.insertBoardExchange(board, pathList, imgList);
				if(result == 0) {
					throw new RuntimeException("게시글 작성 실패");
					
				}
				
				ra.addFlashAttribute("alertMsg","게시글 작성 성공");
				return "redirect:/board/"+"exchange";
		}
	
	@GetMapping("/detailRental")
	public String boardDetail() {
		return "board/detailRental";          
	}
	            
}
