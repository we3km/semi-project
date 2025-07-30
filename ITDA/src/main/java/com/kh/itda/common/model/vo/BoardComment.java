package com.kh.itda.common.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class BoardComment {
	private int boardCmtId;
    private int cmtWriterUserNum;	// 유저 넘버
    private String boardCmtContent;
    private int refNo;
    private Date cmtWriteDate;
    private int boardAssortment;
    private int refCommentId; // 부모id
    private String nickName;	//NICK_NAME
	

}
