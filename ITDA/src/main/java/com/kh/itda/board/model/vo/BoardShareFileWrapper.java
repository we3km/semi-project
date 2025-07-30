package com.kh.itda.board.model.vo;

import com.kh.itda.common.model.vo.FilePath;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class BoardShareFileWrapper {
	private BoardCommon boardCommon;
	private BoardSharing boardSharing;
	private FilePath filePath;
}
