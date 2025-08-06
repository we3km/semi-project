package com.kh.itda.user.model.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.itda.user.model.vo.User;

@Repository
public class UserDaoImpl implements UserDao {

	@Autowired
	private SqlSessionTemplate session;

	@Override
	public int insertUser(User user) {
		return session.insert("user.insertUser", user);
	}

	@Override
	public void insertAuthority(User user) {
		session.insert("user.insertAuthority", user);
	}

	@Override
	public int idCheck(String userId) {
		return session.selectOne("security.idCheck", userId);
	}

	@Override
	public void insertProfile(int userNum, String imageUrl) {
		Map<String, Object> param = new HashMap<>();
		param.put("userNum", userNum);
		param.put("imageUrl", imageUrl);
		session.insert("user.insertProfile", param);
	}

	@Override
	public User findUserById(String userId) {
		return session.selectOne("user.findUserById", userId);
	}

	@Override
	public User findUserByNum(int userNum) {
		return session.selectOne("user.findUserByNum", userNum);
	}

	@Override
	public void updatePassword(String userId, String encodedPwd) {
		Map<String, Object> param = new HashMap<>();
		param.put("userId", userId);
		param.put("encodedPwd", encodedPwd);
		session.update("user.updatePassword", param);

		/*
		 * public void insertUserAndAuthority(User user) { // TODO Auto-generated method
		 * stub
		 * 
		 * 
		 * }
		 */
	}

	@Override
	public String selectUserNickname(String userId) {
		return session.selectOne("user.selectUserNickname", userId);
	}

	@Override
	public String selectUserNum(String userId) {
		return session.selectOne("user.selectUserNum", userId);
	}

	@Override
	public List<String> findAuthoritiesByUserNum(int userNum) {
		return session.selectList("user.findAuthoritiesByUserNum", userNum);
	}

}