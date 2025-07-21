package com.kh.itda.community.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class Community {
	private int communityNo;
	private String communityTitle;
	private String communityContent;
	private String communityCd;	//Cd가 머지...
	private String communityWriter; // userNo, userName
	private int count;
	private Date createDate;
	private String status;

}
