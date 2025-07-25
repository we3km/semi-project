package com.kh.itda.user.model.service;

import com.kh.itda.user.model.vo.User;

public interface UserService {
	User login(String userId, String userPwd);
}
