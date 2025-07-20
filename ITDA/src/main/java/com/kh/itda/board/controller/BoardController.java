package com.kh.itda.board.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.itda.board.model.service.BoardService;
import com.kh.itda.board.model.vo.BoardCommon;
import com.kh.itda.board.model.vo.BoardRental;
import com.kh.itda.board.model.vo.BoardRentalWrapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@RequestMapping("/board") // 거래 게시판 공통 URL
@Slf4j
public class BoardController {
	
	@Autowired
	private final BoardService boardService;

	// 대여게시판 매핑
	@GetMapping("/rental")
	public String rentalBoard() {
		return "board/rentalBoard";
	}
	
	// 나눔게시판 매핑
	@GetMapping("/share")
	public String shareBoard() {
		return "board/shareBoard";
	}
	
	// 교환게시판 매핑
	@GetMapping("/exchange")
	public String exchangeBoard() {
		return "board/exchangeBoard";
	}
	
	// 경매게시판 매핑
	@GetMapping("/auction")
	public String auctionBoard() {
		return "board/auctionBoard";
	}
	
	// 거래 글쓰기 페이지 이동 매핑
	// boardCategory => 각 게시판에서 글쓰기를 누를 시에 저장되는 게시판 유형 값
	@GetMapping("/write/{boardCategory}")
	public String boardWrite(@PathVariable("boardCategory") String boardCategory, Model model) {
		//model.addAttribute("boardCategory", boardCategory); // JSP로 전달
		BoardRentalWrapper board = new BoardRentalWrapper();
		board.setBoardCommon(new BoardCommon());
		board.setBoardRental(new BoardRental());
		
		
		model.addAttribute("board", board);
		return "board/writeBoard";
	}
	
	// 거래 글쓰기 페이지 이동 매핑
	// boardCategory => 각 게시판에서 글쓰기를 누를 시에 저장되는 게시판 유형 값
	@PostMapping("/write/{boardCategory}")
	public String boardInsert(
			@ModelAttribute BoardRentalWrapper board,
			@PathVariable("boardCategory") String boardCategory,
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
			model.addAttribute("board", board);
			BoardCommon boardCommon = board.getBoardCommon();
			BoardRental boardRental = board.getBoardRental();
			// User loginUser = (User) auth.getPrincipal();
			
			boardCommon.setUserNum(1); // 테스트용 임의 지정
			boardCommon.setTransactionAddress("서욽특별시 강남구");// 테스트용 임의 지정
			boardCommon.setTransactionCategory(boardCategory);
			boardCommon.setProductCategory("전자기기"); // 테스트용 임의 지정
			System.out.println(boardRental);
			
			int result = boardService.insertBoard(boardCommon, boardRental);
			if(result == 0) {
				throw new RuntimeException("게시글 작성 실패");
				
			}
			
			ra.addFlashAttribute("alertMsg","게시글 작성 성공");
			return "redirect:/board/"+boardCategory;
	}
	
	@GetMapping("/detailRental")
	public String boardDetail() {
		return "board/detailRental";          
	}
	            
}
