package com.kh.itda.user.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class User {
	private int userNum;
	private String userId;
	private String userPwd;
	private String nickName;
	private String email;
    private String birth;
    private String phone;
    private String address;
    private String imageUrl;
    private String validPeriod = "";
    private Date createDate;
}
