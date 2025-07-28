package com.kh.itda.common.model.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class BoardTag {
	private int tagId;
	private int boardId;
	private String boardCategory;
}
