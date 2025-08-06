package com.kh.itda.common.model.vo;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class BoardComment {
	private int boardCmtId;
    private int cmtWriterUserNum;	// 유저 넘버
    private String boardCmtContent;
    private int refNo;
    
    @JsonFormat(shape = JsonFormat.Shape.NUMBER)
    private Date cmtWriteDate;
    
    private int boardAssortment;
    private int refCommentId; // 부모id
    private String nickName;	//NICK_NAME
    
    private String imageUrl;
	

}
