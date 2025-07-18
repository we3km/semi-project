package com.kh.itda.user.model.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.itda.user.model.dao.UserDao;
import com.kh.itda.user.model.vo.User;

@Service
public class UserServiceImpl implements UserService{

	@Autowired
	private UserDao userDao;

	@Override
	public int insertUser(User user) {
		int result = userDao.insertUser(user);
		userDao.insertAuthority(user);
		return result;
	}

	@Override
	public int updateUser(User user) {
		
		return 0;
	}

	@Override
	public User loginUser(User user) {
		
		return null;
	}

	@Override
	public int insertUserAndGetUserNo(User user) {
		
		return 0;
	}

	@Override
	public void insertProfile(int userNum, String imageUrl) {
		// TODO Auto-generated method stub
		
	}
}
