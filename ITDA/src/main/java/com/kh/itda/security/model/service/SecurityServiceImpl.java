package com.kh.itda.security.model.service;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.kh.itda.security.model.dao.SecurityDao;
import com.kh.itda.user.model.vo.User;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class SecurityServiceImpl implements SecurityService{
	
	private final SecurityDao securityDao;

    @Override
    public UserDetails loadUserByUsername(String userId) throws UsernameNotFoundException {
        User user = (User) securityDao.loadUserByUsername(userId); // 객체를 통해 호출

        if (user == null) {
            throw new UsernameNotFoundException("존재하지 않는 사용자입니다.");
        }

        return org.springframework.security.core.userdetails.User
                .withUsername(String.valueOf(user.getUserNum())) // 인증 객체 식별자
                .password(user.getUserPwd())
                .build();
    }
	
}