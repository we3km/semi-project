package com.kh.itda.chat.model.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor

@Data
public class SelectBoardInfo {
	// 채팅방 생성할 때 필요한 거 셀렉트 해오자
	/*
	 * - 구매자 회원 프로필 경로 (회원 접속한) - 게시물사진 - 게시물 제목 - 거래 유형
	 */
	private String imageUrl; // 회원 프로필 경로, FROM PROFILE
	private int boardId; // 게시물 번호, FROM BOARD_COMMON
	private String productName = null; // 상품 이름, FROM BOARD_COMMON
	private String transactionCategory = null; // 거래 유형, FROM BOARD_COMMON
	private int userNum; // 게시물 주인 회원 ID 

	public int getTransactionRefNum() {
		switch (transactionCategory) {
		case "rental":
			return 1;
		case "exchange":
			return 2;
		case "auction":
			return 3;
		case "sharing":
			return 4;
		default:
			return 5;
		}
	}
	/*
	 * 1. rental 대여
	 * 2. exchange 교환
	 * 3. auction 경매
	 * 4. sharing 나눔
	 * */
	
	// 대여
	private int rentalFee = 0; // 대여금액, FROM BOARD_RENTAL
	private int deposit = 0; // 보증금, FROM BOARD_RENTAL

}