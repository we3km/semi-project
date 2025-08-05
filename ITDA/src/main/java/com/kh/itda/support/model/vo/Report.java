package com.kh.itda.support.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class Report {
	    private int reportNum;
	    private int userNum;
	    private String type;
	    private String targetName;
	    private String reason;
	    private String detailReason;
	    private String status;
	    private Date createdAt;
	    private Date processedAt;

}
