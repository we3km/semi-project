package com.kh.itda.user.model.service;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.itda.user.model.dao.UserDao;
import com.kh.itda.user.model.vo.User;

@Service
public class UserServiceImpl implements UserService{

	@Autowired
	private UserDao userDao;
	
	@Override
	public User loginUser(User user) { // 로그인 확인
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int insertUser(User user) { // 회원가입 정보 추가
		int result = userDao.insertUser(user);
		userDao.insertAuthority(user);
		return result;
	}

	@Override
	public int updateUser(User user) { // 회원정보 수정
		
		return 0;
	}

	@Override
	public void insertProfile(int userNum, String imageUrl) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public Optional<String> findIdByNameAndEmail(String name, String email) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Optional<String> findPwdByIdAndEmail(String id, String email) {
		// TODO Auto-generated method stub
		return null;
	}

}
