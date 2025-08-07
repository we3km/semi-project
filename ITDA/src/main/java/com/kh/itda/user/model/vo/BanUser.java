package com.kh.itda.user.model.vo;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class BanUser {
	
	private int bannedNum;
	private int userNum;
	private String reason;
	private char isBanned;
    @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
    private Date penaltyDate;
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date releaseDate;
	private String adminUserName;
	private Date getValidityPeriod;
}
