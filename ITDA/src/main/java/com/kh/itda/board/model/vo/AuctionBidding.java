package com.kh.itda.board.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class AuctionBidding {
	private String boardId;
	private int biddingUserNum;
	private int bid;
}
