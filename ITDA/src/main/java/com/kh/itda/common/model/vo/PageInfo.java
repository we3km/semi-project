package com.kh.itda.common.model.vo;

import lombok.Data;

@Data
public class PageInfo {
	private int listCount;
	private int currentPage;
	private int pageLimit;
	private int communityLimit;
	
	private int maxPage;
	private int startPage;
	private int endPage;

}
