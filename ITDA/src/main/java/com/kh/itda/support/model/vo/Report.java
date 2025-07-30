package com.kh.itda.support.model.vo;

import java.time.LocalDateTime;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class Report {
	    private int reportNum;
	    private int userNum;
	    private String type;
	    private int targetId;
	    private String reason;
	    private String detailReason;
	    private String status;
	    private LocalDateTime createdAt;
	    private LocalDateTime processedAt;

}
