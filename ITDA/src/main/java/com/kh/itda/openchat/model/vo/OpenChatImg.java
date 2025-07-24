package com.kh.itda.openchat.model.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class OpenChatImg {
	private int fileId;
	private int categoryId;
	private String fileName;
	private int refNo;
}
