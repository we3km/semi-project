package com.kh.itda.common.model.vo;


import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class File {
	private int fileId;
	private int pathNum;
	private String fileName;
	private int refNo; // 첨부된 게시글, 채팅방 번호
	private int fileAssortment; // 파일이 첨부된 유형
}
