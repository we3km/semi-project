package com.kh.itda.board.model.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class BoardShareWrapper {

	private BoardCommon boardCommon;
	private BoardSharing boardSharing;
}
