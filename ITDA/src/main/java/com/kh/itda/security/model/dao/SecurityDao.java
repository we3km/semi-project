package com.kh.itda.security.model.dao;

import java.util.List;

import org.springframework.security.core.userdetails.UserDetails;

import com.kh.itda.support.model.vo.Report;
import com.kh.itda.user.model.vo.User;

public interface SecurityDao {

	List<User> searchUsers(String keyword);

	public List<Report> getAllReports();
	
	public UserDetails loadUserByUsername(String username); // 아이디로 조회(프로필 포함)

	User findUserById(String userId); // 아이디로 조회(프로필 미포함)
	
	User findUserByNum(int userNum); // 유저 번호로 조회
	
	List<String> findAuthoritiesByUserNum(int userNum); // 유저 권한 조회
	
}
