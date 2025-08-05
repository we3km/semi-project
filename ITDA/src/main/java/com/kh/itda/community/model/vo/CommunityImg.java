package com.kh.itda.community.model.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class CommunityImg {
	private int communityImgNo;
	private String originName;
	private String changeName;
	private int refCno;	//community 번호의 외래키
	private int imgLevel;
}