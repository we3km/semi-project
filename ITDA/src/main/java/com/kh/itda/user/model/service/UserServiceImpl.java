package com.kh.itda.user.model.service;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.itda.mapper.UserMapper;
import com.kh.itda.user.model.dao.UserDao;
import com.kh.itda.user.model.vo.User;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService{

	@Autowired
	private UserDao userDao;
	
	private final UserMapper userMapper;
	
	@Override
	public User loginUser(User user) { // 로그인 확인
		
		return null;
	}
	
	@Transactional
    public void register(User user) {
        int userNum = userMapper.selectNextUserNo();  // 시퀀스 호출
        user.setUserNum(userNum);                     // VO에 세팅

        userMapper.insertUser(user);			// USER_TB
        userMapper.insertProfile(user);			// PROFILE
        userMapper.insertAuthority(userNum);	// AUTHORITY
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

	@Override
	public int idCheck(String userId) {
		// TODO Auto-generated method stub
		return 0;
	}

}
