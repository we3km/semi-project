package com.kh.itda.user.model.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class USER {
	private int UserNum;
	private String userId;
	private String userPwd;
	private String nickName;

}
