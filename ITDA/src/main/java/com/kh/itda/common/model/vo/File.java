package com.kh.itda.common.model.vo;


import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class File {
	private int fileId;
	private int categoryId;
	private String fileName;
	private int refNo; // 첨부된 게시글, 채팅방 번호

}
