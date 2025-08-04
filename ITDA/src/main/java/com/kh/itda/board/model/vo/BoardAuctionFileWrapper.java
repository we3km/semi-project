package com.kh.itda.board.model.vo;

import com.kh.itda.common.model.vo.FilePath;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class BoardAuctionFileWrapper {
	private BoardCommon boardCommon;
	private BoardAuction boardAuction;
	private FilePath filePath;
	
	private int highestBid;
}
