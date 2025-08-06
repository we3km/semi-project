package com.kh.itda.user.model.dao;

import java.util.List;

import com.kh.itda.user.model.vo.User;

public interface UserDao {

	int insertUser(User user);

	void insertProfile(int userNum, String imageUrl);
	
	void insertAuthority(User user);
	
	int idCheck(String userId);
	
	int checkNickname(String nickName);
	
	int checkPhone(String newPhone);
	
	User findUserById(String userId);	// 로그인 시 유저 조회
	
    User findUserByNum(int userNum);	// 로그인 외 다른 곳에서 조회
    
    void updatePassword(String userId, String encodedPwd);

    void updateNickname(String userId, String newNickname);

	String selectUserNickname(String userId);

	String selectUserNum(String userId);

	void updatePhone(String userId, String newPhone);

	//void insertUserAndAuthority(User user);
	
	List<String> findAuthoritiesByUserNum(int userNum);

	void updateAddress(String userId, String newAddress);

	void updateProfileImage(int userNum, String imageUrl);

	String getProfileImageUrl(int userNum);

	int getScore(int userNum);

}
