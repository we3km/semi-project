package com.kh.itda.community.model.vo;

import java.util.List;

import lombok.Data;
import lombok.ToString;

@Data
@ToString(callSuper = true)
public class CommunityExt extends Community{
	private List<CommunityImg> imgList;
	private String userName;
	private List<communityTag> tags;

}
