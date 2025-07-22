package com.kh.itda.user.model.service;

import java.util.Optional;

import com.kh.itda.user.model.vo.User;

public interface UserService {

	int insertUser(User user);

	int updateUser(User user);

	void insertProfile(int userNum, String imageUrl);

	Optional<String> findIdByNameAndEmail(String name, String email);

	Optional<String> findPwdByIdAndEmail(String id, String email);

	User loginUser(User user);

	
}
