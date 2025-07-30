package com.kh.itda.user.model.dao;


import org.springframework.stereotype.Repository;

import com.kh.itda.user.model.vo.User;

import com.kh.itda.user.model.vo.User;

public interface UserDao {

	int insertUser(User user);
	
	void insertAuthority(User user);

	void insertUserAndAuthority(User user);
	
	int idCheck(String userId);

	void insertProfile(int userNum, String imageUrl);

}
