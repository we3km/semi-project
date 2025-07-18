package com.kh.itda.security.model.service;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.kh.itda.security.model.dao.SecurityDao;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class SecurityServiceImpl implements SecurityService{
	
	private final SecurityDao dao;
	
	@Override
	public UserDetails loadUserByUsername(String userId) throws UsernameNotFoundException {
		UserDetails user = dao.loadUserByUsername(userId);
		
		if(user==null) {
			throw new UsernameNotFoundException(userId);
		}
		
		return user;
	}

	
}
