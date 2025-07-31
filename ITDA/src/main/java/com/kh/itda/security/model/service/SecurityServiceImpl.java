package com.kh.itda.security.model.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.kh.itda.security.model.dao.SecurityDao;
import com.kh.itda.security.model.vo.UserExt;
import com.kh.itda.user.model.vo.User;

import lombok.RequiredArgsConstructor;

@Service("securityServiceImpl")
@RequiredArgsConstructor
public class SecurityServiceImpl implements SecurityService{
	
	private final SecurityDao securityDao;

    @Override
    public UserDetails loadUserByUsername(String userId) throws UsernameNotFoundException {
        User user = securityDao.findUserById(userId); // 객체를 통해 호출
        if (user == null) {
        	throw new UsernameNotFoundException("존재하지 않는 사용자입니다.");
        }

        // 권한 조회
        List<String> roles = securityDao.findAuthoritiesByUserNum(user.getUserNum());
        
        List<GrantedAuthority> authorities = roles.stream()
                .map(SimpleGrantedAuthority::new)
                .collect(Collectors.toList());

//        return org.springframework.security.core.userdetails.User
//                .withUsername(user.getUserId()) // 인증 객체 식별자
//                .password(user.getUserPwd())
//                .authorities(authorities)
//                .build();
        UserExt userExt = new UserExt();
        // User의 필드들을 userExt에 복사 (예: userNum, userId, userPwd 등)
        userExt.setUserNum(user.getUserNum());
        userExt.setUserId(user.getUserId());
        userExt.setUserPwd(user.getUserPwd());
        userExt.setAuthorities(authorities);

        return userExt;
    }
	
}
