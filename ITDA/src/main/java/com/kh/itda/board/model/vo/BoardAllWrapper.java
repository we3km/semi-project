package com.kh.itda.board.model.vo;

import com.kh.itda.common.model.vo.FilePath;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class BoardAllWrapper {
	private BoardCommon boardCommon;
	private BoardRental boardRental;
	private BoardAuction boardAuction;
	private BoardSharing boardSharing;
	private FilePath filePath;
}
