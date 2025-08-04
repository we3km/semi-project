package com.kh.itda.user.model.dao;

import java.util.HashMap;

import com.kh.itda.user.model.vo.User;

public interface UserDao {

	int insertUser(User user);
	
	void insertAuthority(User user);

	void insertUserAndAuthority(User user);
	
	int idCheck(String userId);

	String selectUserNickname(String userId);


	String selectUserNum(String userId);


	HashMap<String, Object> selectOne(String userId);

	void updatePassword(String userId, String encodedPwd);

	void insertProfile(int userNum, String imageUrl);

}
