package com.kh.itda.community.model.vo;

import java.util.Date;
import java.util.List;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class Community {
	private int communityNo; //COMMUNITY_BOARD_ID
	private String communityTitle;	//TITLE
	private String communityContent;	//CONTENT
	
	private String communityCd;		//COMMUNITY_CD
	private String communityCdName;	//카테고리명
	
	private String communityNickname;	//nickname
	private int communityWriter; // userNo,
	
	private int views;	//VIEWS
	private Date writeDate;	//WRITE_DATE
//	private String status;
	
	private String tagStr;	//태그
	private int recommendCount;	//좋아요수
	private int recommendDiscount;	//싫어요수
	private int commentCount;	//댓글수
	

}