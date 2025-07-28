package com.kh.itda.board.model.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class Dibs {
	private int boardId;
	private int likesUserId;
	private String boardCategory;
}
