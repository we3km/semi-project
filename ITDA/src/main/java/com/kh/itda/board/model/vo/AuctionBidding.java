package com.kh.itda.board.model.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class AuctionBidding {
	private int boardId;
	private int biddingUserNum;
	private int bid;
	
	private String nickName;
}
