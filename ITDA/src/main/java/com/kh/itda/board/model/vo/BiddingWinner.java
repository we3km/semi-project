package com.kh.itda.board.model.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class BiddingWinner {
	
	private int boardId;
	private int userNum;
	private int bid;
}
