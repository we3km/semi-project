package com.kh.itda.user.model.service;

import com.kh.itda.user.model.vo.USER;

public interface UserService {
	USER login(String userId, String userPwd);
}
