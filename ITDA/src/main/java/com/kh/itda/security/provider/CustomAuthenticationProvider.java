//package com.kh.itda.security.provider;
//
//import java.util.List;
//import java.util.stream.Collectors;
//
//import org.springframework.beans.BeanUtils;
//import org.springframework.security.authentication.AuthenticationProvider;
//import org.springframework.security.authentication.BadCredentialsException;
//import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
//import org.springframework.security.core.Authentication;
//import org.springframework.security.core.AuthenticationException;
//import org.springframework.security.core.GrantedAuthority;
//import org.springframework.security.core.authority.SimpleGrantedAuthority;
//import org.springframework.security.core.userdetails.UsernameNotFoundException;
//import org.springframework.security.crypto.password.PasswordEncoder;
//import org.springframework.stereotype.Component;
//
//import com.kh.itda.security.model.vo.UserExt;
//import com.kh.itda.user.model.dao.UserDao;
//import com.kh.itda.user.model.vo.User;
//
//import lombok.RequiredArgsConstructor;
//
//@Component
//@RequiredArgsConstructor
//public class CustomAuthenticationProvider implements AuthenticationProvider {
//
//	private final UserDao userDao;
//	private final PasswordEncoder passwordEncoder;
//
//	@Override
//	public Authentication authenticate(Authentication authentication) throws AuthenticationException {
//		String userId = authentication.getName();
//		String rawPassword = authentication.getCredentials().toString();
//
//		// 1) 유저 조회
//		User user = userDao.findUserByNum(userId);
//		if (user == null) {
//			throw new UsernameNotFoundException("User not found");
//		}
//
//		// 2) 비밀번호 확인
//		if (!passwordEncoder.matches(rawPassword, user.getUserPwd())) {
//			throw new BadCredentialsException("Bad credentials");
//		}
//
//		// 3) 권한 조회
//		List<String> roles = userDao.findAuthoritiesByUserNum(user.getUserNum());
//
//		// 4) GrantedAuthority 리스트 생성
//		List<GrantedAuthority> authorities = roles.stream().map(SimpleGrantedAuthority::new)
//				.collect(Collectors.toList());
//
//		// 5) UserExt 생성 및 권한 주입
//		UserExt userExt = new UserExt();
//		BeanUtils.copyProperties(user, userExt); // User 필드 복사
//		userExt.setAuthorities(authorities);
//
//		// 6) 인증 토큰 생성 반환
//		return new UsernamePasswordAuthenticationToken(userExt, rawPassword, authorities);
//	}
//
//	@Override
//	public boolean supports(Class<?> authentication) {
//		return UsernamePasswordAuthenticationToken.class.isAssignableFrom(authentication);
//	}
//}
