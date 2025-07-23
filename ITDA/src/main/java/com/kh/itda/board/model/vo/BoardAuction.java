package com.kh.itda.board.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class BoardAuction {
	private int boardId;
	private int auctionStartingFee;
	private int bidUnit;
	private Date auctionStartDate;
	private Date auctionEndDate;
}
