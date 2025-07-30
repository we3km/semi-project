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
	public void insertProfile(int userNum, String imageUrl) {
		Map<String, Object> param = new HashMap<>();
	    param.put("userNum", userNum);
	    param.put("imageUrl", imageUrl);
		session.insert("user.insertProfile", param);
	}

	@Override
	public void insertUserAndAuthority(User user) {
		// TODO Auto-generated method stub
		
	}
}
