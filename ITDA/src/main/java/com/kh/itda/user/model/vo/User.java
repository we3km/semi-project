package com.kh.itda.user.model.vo;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
@Builder
public class User {
	private int userNo;
	private String userId;
	private String userPwd;
	private String userName;	//nickName
	private String profileImg;	//아직 없음.
	private String email;
	private String phone;
	private Date birthday;
	private char isQuit;
	private String address;
	private String userInfValidityPeriod;	//유지기간
}
