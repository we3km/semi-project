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

@Service
@RequiredArgsConstructor
@Transactional
public class UserServiceImpl implements UserService{

	/*
	 * @Autowired private UserDao userDao;
	 * 
	 * @Autowired private SqlSessionTemplate sqlSession;
	 * 
	 * @Override public User loginUser(User user) { // 로그인 확인
	 * 
	 * return null; }
	 * 
	 * public void register(User user) { int userNum =
	 * sqlSession.selectOne("user.selectNextUserNo"); // 시퀀스 호출
	 * user.setUserNum(userNum); // VO에 세팅 sqlSession.insert("user.insertUser",
	 * user); // USER_TB sqlSession.insert("user.insertProfile", user); // PROFILE
	 * sqlSession.insert("user.insertAuthority", userNum); // AUTHORITY }
	 * 
	 * @Override public int updateUser(User user) { // 회원정보 수정
	 * 
	 * return 0; }
	 * 
	 * @Override public Optional<String> findIdByNameAndEmail(String nickName,
	 * String email) { String userId = sqlSession.selectOne("user.findId",
	 * Map.of("nickName", nickName, "email", email)); return
	 * Optional.ofNullable(userId); }
	 * 
	 * @Override public Optional<String> findPwdByIdAndEmail(String id, String
	 * email) { return null; }
	 * 
	 * @Override public int idCheck(String userId) { return userDao.idCheck(userId);
	 * }
	 * 
	 * @Override public void updatePassword(String id, String encodedPwd) {
	 * 
	 * }
	 * 
	 * @Override public boolean emailExists(String email) { // TODO Auto-generated
	 * method stub return false; }
	 * 
	 * 	@Override
	public User findByUserId(String username) {
		// TODO Auto-generated method stub
		return null;
	}
	 */
}
