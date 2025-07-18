package com.kh.itda.user.model.dao;

import com.kh.itda.user.model.vo.User;

public interface UserDao {

	int insertUser(User user);

	void insertAuthority(User user);

}
