package com.kh.itda.user.model.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.itda.user.model.vo.User;

@Repository
public class UserDaoImpl implements UserDao {

	@Autowired
	public SqlSessionTemplate session;
	
	@Override
	public int insertUser(User user) {
		
		return 0;
	}

	@Override
	public void insertAuthority(User user) {
		session.insert("user.insertAuthority", user);
	}

}
