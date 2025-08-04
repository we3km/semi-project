package com.kh.itda.user.model.service;

import java.util.Optional;

import com.kh.itda.user.model.vo.User;

public interface UserService {
	
	void register(User user);

	Optional<String> findIdByNameAndEmail(String nickName, String email);

	Optional<String> findPwdByIdAndEmail(String userId, String email);

	int idCheck(String userId);

	int updateUser(User user);

	void updatePassword(String id, String encodedPwd);

	boolean emailExists(String email);
<<<<<<< Updated upstream
	
	String selectUserNickname(String userId);

	String selectUserNum(String userId);

=======
>>>>>>> Stashed changes

}
