package com.kh.itda.user.model.vo;


import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class User {
	private int userNum;
	private String userId;
	private String userPwd;
	private String nickName;	//nickName
	private String profileImg;	//아직 없음.
	private String email;
	private String phone;
	private Date birthday;
	private char isQuit;
	private String address;
	private String userInfValidityPeriod;	//유지기간u
}
