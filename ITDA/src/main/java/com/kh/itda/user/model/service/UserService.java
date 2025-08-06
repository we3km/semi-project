package com.kh.itda.user.model.service;

import java.util.Optional;

import com.kh.itda.user.model.vo.User;

public interface UserService {

	void register(User user);

	Optional<String> findIdByNameAndEmail(String nickName, String email);

	Optional<String> findPwdByIdAndEmail(String userId, String email);

	String getProfileImageUrl(int userNum);
	
	int idCheck(String userId);

	int updateUser(User user);

	void updatePassword(String userId, String encodedPwd);
	
	void updateNickname(String userId, String newNickname);
	
	void updatePhone(String userId, String newPhone);
	
	void updateAddress(String userId, String newAddress);

	void updateProfileImage(int userNum, String imageUrl);
	
	boolean emailExists(String email);

	int checkNickname(String nickName);
	
	int checkPhone(String newPhone);

	String selectUserNickname(String userId);

	String selectUserNum(String userId);

	User findUserById(String userId);

}
