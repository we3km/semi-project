package com.kh.itda.security.model.dao;

import java.util.List;

import org.springframework.security.core.userdetails.UserDetails;

import com.kh.itda.user.model.vo.User;

public interface SecurityDao {

	public UserDetails loadUserByUsername(String username);

	User findUserById(String userId);
	
	User findUserByNum(int userNum);
	
	List<String> findAuthoritiesByUserNum(int userNum);
	
}
