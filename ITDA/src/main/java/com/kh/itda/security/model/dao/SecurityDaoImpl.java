package com.kh.itda.security.model.dao;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Repository;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class SecurityDaoImpl implements SecurityDao{@Override
	public UserDetails loadUserByUsername(String userId) {
		
		return null;
	}

	
}
