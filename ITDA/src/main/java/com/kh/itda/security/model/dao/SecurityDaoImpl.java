package com.kh.itda.security.model.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Repository;

<<<<<<< HEAD
import com.kh.itda.support.model.vo.Report;
=======
>>>>>>> main
import com.kh.itda.user.model.vo.User;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
<<<<<<< HEAD
public class SecurityDaoImpl implements SecurityDao {

=======
public class SecurityDaoImpl implements SecurityDao{
	
>>>>>>> main
	private final SqlSessionTemplate session;

	@Override
	public UserDetails loadUserByUsername(String username) {
<<<<<<< HEAD
		return session.selectOne("security.loadUserByUsername", username);
	}

	@Override
	public List<User> searchUsers(String keyword) {
		return session.selectList("security.searchUsers", keyword);
=======
		return session.selectOne("security.loadUserByUsername",username);
	}

	@Override
	public User findUserById(String userId) {
		return session.selectOne("security.findUserById", userId);
>>>>>>> main
	}

	@Override
	public User findUserByNum(int userNum) {
		return session.selectOne("security.findUserByNum", userNum);
	}
<<<<<<< HEAD
	
    @Override
    public List<Report> getAllReports() {
        return session.selectList("security.getAllReports");
    }
    
	
}
=======

	@Override
	public List<String> findAuthoritiesByUserNum(int userNum) {
		return session.selectList("security.findAuthoritiesByUserNum", userNum);
	}

	
}
>>>>>>> main
