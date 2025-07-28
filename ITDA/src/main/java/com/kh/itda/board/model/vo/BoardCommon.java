package com.kh.itda.board.model.vo;

import java.util.Date;
import java.util.List;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class BoardCommon {
	private int boardId;
	private int userNum;
	private String productName;
	private String productComment;
	private String transactionAddress;
	private String transactionCategory;
	private Date createDate;
	private int views;
	private char transactionStatus;
	private String productCategoryL;
	private String productCategoryM;
	private String productCategoryS;
	
	
	private List<String> tagList; // db는 따로
}
