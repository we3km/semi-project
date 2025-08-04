package com.kh.itda.user.model.service;

import java.util.Map;
import java.util.Optional;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.itda.user.model.dao.UserDao;
import com.kh.itda.user.model.vo.User;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Transactional
@Slf4j
public class UserServiceImpl implements UserService {

	@Autowired
	private UserDao userDao;

	@Autowired
	private SqlSessionTemplate sqlSession;

	public void register(User user) {
		int userNum = sqlSession.selectOne("user.selectNextUserNo"); // 시퀀스 호출
		user.setUserNum(userNum); // VO에 세팅
		sqlSession.insert("user.insertUser", user); // USER_TB
		sqlSession.insert("user.insertProfile", user); // PROFILE
		sqlSession.insert("user.insertAuthority", userNum); // AUTHORITY
	}

	@Override
	public int updateUser(User user) { // 회원정보 수정

		return 0;
	}

	@Override
	public Optional<String> findIdByNameAndEmail(String nickName, String email) {
		log.debug(" findIdByNameAndEmail {},{}", nickName, email);
		String userId = sqlSession.selectOne("user.findId", Map.of("nickName", nickName, "email", email));
		return Optional.ofNullable(userId);
	}

	@Override
	public Optional<String> findPwdByIdAndEmail(String userId, String email) {
		String userpwd = sqlSession.selectOne("user.findPwd", Map.of("userId", userId, "email", email));
		return Optional.ofNullable(userpwd);
	}

	@Override
	public int idCheck(String userId) {
		return userDao.idCheck(userId);
	}

	@Override
	public void updatePassword(String userId, String encodedPwd) {
		userDao.updatePassword(userId, encodedPwd);
	}

	@Override
	public boolean emailExists(String email) {
		// TODO Auto-generated method stub
		return false;
	}
	
	@Override
	public String selectUserNickname(String userId) {
		return userDao.selectUserNickname(userId);
	}

	@Override
	public String selectUserNum(String userId) {
		return userDao.selectUserNum(userId);
	}
}
