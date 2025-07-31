package com.kh.itda.user.model.dao;

import com.kh.itda.user.model.vo.User;

public interface UserDao {

	int insertUser(User user);
	

	void insertProfile(int userNum, String imageUrl);
	
	void insertAuthority(User user);
	
	int idCheck(String userId);
	
	User findUserById(String userId);	// 로그인 시 유저 조회
	
    User findUserByNum(int userNum);	// 로그인 외 다른 곳에서 조회
    
    void updatePassword(String userId, String encodedPwd);

	//void insertUserAndAuthority(User user);
	


}
