package com.kh.itda.security.model.dao;

import org.springframework.security.core.userdetails.UserDetails;

public interface SecurityDao {

	public UserDetails loadUserByUsername(String userId);

	
}
