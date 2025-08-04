package com.kh.itda.security.model.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Repository;

import com.kh.itda.support.model.vo.Report;
import com.kh.itda.user.model.vo.User;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
<<<<<<< Updated upstream
public class SecurityDaoImpl implements SecurityDao{
	
=======
public class SecurityDaoImpl implements SecurityDao {

>>>>>>> Stashed changes
	private final SqlSessionTemplate session;

	@Override
	public UserDetails loadUserByUsername(String username) {
		return session.selectOne("security.loadUserByUsername", username);
	}

	@Override
<<<<<<< Updated upstream
	public List<User> searchUsers(String keyword) {
		return session.selectList("security.searchUsers", keyword);
	}

	@Override
=======
>>>>>>> Stashed changes
	public User findUserById(String userId) {
		return session.selectOne("security.findUserById", userId);
	}

	@Override
	public User findUserByNum(int userNum) {
		return session.selectOne("security.findUserByNum", userNum);
	}
<<<<<<< Updated upstream
	
    @Override
    public List<Report> getAllReports() {
        return session.selectList("security.getAllReports");
    }
    
	
=======

	@Override
	public List<Report> getAllReports() {
		return session.selectList("security.getAllReports");
	}
>>>>>>> Stashed changes

	@Override
	public List<String> findAuthoritiesByUserNum(int userNum) {
		return session.selectList("security.findAuthoritiesByUserNum", userNum);
	}

	@Override
	public List<User> searchUsers(String keyword) {
		return session.selectList("security.searchUsers", keyword);
	}

}
