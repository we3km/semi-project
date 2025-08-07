package com.kh.itda.support.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class Report {
	    private int reportNum;
	    private int userNum;		//신고한 userNum
	    private String type;		//신고유형(게시물, 댓글, 채팅)
	    private int targetId;		//신고대상ID(게시글/댓글 번호)
	    private int targetUserNum;	//신고 당한 사람 userNum
	    private String nickName;
	    private String reason;
	    private String detailReason;
	    private String status;
	    private Date createdAt;
	    private Date processedAt;
	    private Date releaseDate;

}