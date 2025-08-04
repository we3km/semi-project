package com.kh.itda.user.model.dao;

import java.util.HashMap;
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
		// System.out.println("비밀번호 변경 시도: " + userId); // 디버그용
		Map<String, Object> param = new HashMap<>();
	    param.put("userId", userId);
	    param.put("encodedPwd", encodedPwd);
	    
	    int result = session.update("user.updatePassword", param);
	    // System.out.println("업데이트 결과: " + result + "행");
	}

	@Override
	public void updateNickname(String userId, String newNickname) {
		Map<String, Object> param = new HashMap<>();
	    param.put("userId", userId);
	    param.put("newNickname", newNickname);
	    
	    int result = session.update("user.updateNickname", param);
	}
	
	@Override
	public void updatePhone(String userId, String newPhone) {
		Map<String, Object> param = new HashMap<>();
	    param.put("userId", userId);
	    param.put("newPhone", newPhone);
	    
	    int result = session.update("user.updatePhone", param);
	}
	
	@Override
	public void updateAddress(String userId, String newAddress) {
		Map<String, Object> param = new HashMap<>();
	    param.put("userId", userId);
	    param.put("newAddress", newAddress);
	    
	    int result = session.update("user.updateAddress", param);
	}

/*	public void insertUserAndAuthority(User user) {
		// TODO Auto-generated method stub
		

	}*/

	@Override
	public String selectUserNickname(String userId) {
		return session.selectOne("user.selectUserNickname", userId); 
	}
	

	@Override
	public String selectUserNum(String userId) {
		return session.selectOne("user.selectUserNum", userId); 
	}
}
