package com.kh.itda.support.model.vo;

import java.util.Date;
import java.util.List;

import com.kh.itda.common.model.vo.File;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class Inquiry {
	private int csNum;
	private int userNum;
	private String csTitle;
	private String csContent;
	private Date csDate;
	private String csReply;
	private Date csReplyDate;
	private String status;
	private int categoryId;
	private String categoryName;
	private List<File> fileList;
	
}