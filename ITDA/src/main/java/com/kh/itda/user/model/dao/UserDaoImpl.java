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
	public int checkNickname(String nickName) {
		return session.selectOne("security.checkNickname", nickName);
	}
	
	@Override
	public int checkPhone(String newPhone) {
		return session.selectOne("security.checkPhone", newPhone);
	}
	
	@Override
	public void insertProfile(int userNum, String imageUrl) {
		Map<String, Object> param = new HashMap<>();
		param.put("userNum", userNum);
		param.put("imageUrl", imageUrl);
		session.insert("user.insertProfile", param);
	}

	@Override
	public User findUserByNum(int userNum) {
		return session.selectOne("user.findUserByNum", userNum);
	}

	@Override
	public void updatePassword(String userId, String encodedPwd) {
		// System.out.println("비밀번호 변경 시도: " + userId); // 디버그용
		Map<String, Object> param = new HashMap<>();
	    param.put("userId", userId);
	    param.put("encodedPwd", encodedPwd);
	    
	    session.update("user.updatePassword", param);
	    // System.out.println("업데이트 결과: " + result + "행");
	}

	@Override
	public void updateNickname(String userId, String newNickname) {
		Map<String, Object> param = new HashMap<>();
	    param.put("userId", userId);
	    param.put("newNickname", newNickname);
	    
	    session.update("user.updateNickname", param);
	}
	
	@Override
	public void updatePhone(String userId, String newPhone) {
		Map<String, Object> param = new HashMap<>();
	    param.put("userId", userId);
	    param.put("newPhone", newPhone);
	    
	    session.update("user.updatePhone", param);
	}
	
	@Override
	public void updateAddress(String userId, String newAddress) {
		Map<String, Object> param = new HashMap<>();
	    param.put("userId", userId);
	    param.put("newAddress", newAddress);
	    
	    session.update("user.updateAddress", param);
	}
	
	@Override
	public void updateProfileImage(int userNum, String imageUrl) {
		Map<String, Object> param = new HashMap<>();
	    param.put("userNum", userNum);
	    param.put("imageUrl", imageUrl);
	    
	    session.update("user.updateProfile", param);
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

	public String getProfileImageUrl(int userNum) {
		return session.selectOne("user.getProfileImageUrl", userNum);
	}

	@Override
	public User findUserById(String userId) {
		return session.selectOne("security.findUserById", userId);
	}

	@Override
	public int getScore(int userNum) {
		Integer score = session.selectOne("board.selectMannerScore", userNum);
	    return (score != null) ? score : 80;
	}
}
