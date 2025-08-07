package com.kh.itda.chat.model.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class BidWinner {
	private int userNum; // 경매 우승자 회원 번호
	private int boardId; // 게시물 번호
	private int bid; // 낙찰금
}
