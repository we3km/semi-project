package com.kh.itda.user.model.service;

import com.kh.itda.user.model.vo.User;

public interface UserService {

	int insertUser(User user);

	int updateUser(User user);

	User loginUser(User user);

	int insertUserAndGetUserNo(User user);

	void insertProfile(int userNum, String imageUrl);

	
}
