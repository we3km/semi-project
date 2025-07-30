package com.kh.itda.security.model.dao;

import java.util.List;

import org.springframework.security.core.userdetails.UserDetails;

import com.kh.itda.support.model.vo.Report;
import com.kh.itda.user.model.vo.User;

public interface SecurityDao {

	public UserDetails loadUserByUsername(String username);

	User findUserByNum(int userNum);

	List<User> searchUsers(String keyword);

	public List<Report> getAllReports();
	
}