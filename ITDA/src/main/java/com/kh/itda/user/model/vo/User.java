package com.kh.itda.user.model.vo;


import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class User {
	private int userNum;
	private String userId;
	private String userPwd;
	private String nickName;

}
