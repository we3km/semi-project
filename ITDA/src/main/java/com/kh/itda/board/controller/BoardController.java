package com.kh.itda.board.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kh.itda.board.model.vo.BoardCommon;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@RequestMapping("/board") // 거래 게시판 공통 URL
@Slf4j
public class BoardController {

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
		return "board/writeBoard";
	}
	
	// 거래 글쓰기 페이지 이동 매핑
	// boardCategory => 각 게시판에서 글쓰기를 누를 시에 저장되는 게시판 유형 값
	@PostMapping("/write/{boardCategory}")
	public String boardInsert(
			@PathVariable("boardCategory") String boardCategory,
			Model model,
			@ModelAttribute BoardCommon board) {
		//model.addAttribute("boardCategory", boardCategory); // JSP로 전달
		return "board/detail"+boardCategory;
	}
	
	@GetMapping("/detailRental")
	public String boardDetail() {
		return "board/detailRental";          
	}
	            
}
