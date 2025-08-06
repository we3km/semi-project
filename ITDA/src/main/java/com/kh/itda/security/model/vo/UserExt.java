package com.kh.itda.security.model.vo;

import java.util.Collection;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import lombok.Data;

@Data
public class UserExt implements UserDetails {
	private int userNum;
	private String userId;
	private String userPwd;
	private String nickName;
	private String email;
	private String birth;
	private String phone;
	private String address;
	private String imageUrl;

	// Spring Security 권한 목록
	private Collection<? extends GrantedAuthority> authorities;

	// 실제 DB에 저장되는 필드는 아님, 권한 목록 중 첫 번째 권한을 반환
	public String getRole() {
		if (authorities != null && !authorities.isEmpty()) {
			// ROLE_ADMIN, ROLE_USER 형태로 들어있음
			return authorities.iterator().next().getAuthority();
		}
		return null;
	}

	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
		return authorities;
	}

	@Override
	public String getPassword() {
		return userPwd;
	}

	@Override
	public String getUsername() {
		return userId;
	}
	
	@Override
	public boolean isAccountNonExpired() {
		return true;
	}

	@Override
	public boolean isAccountNonLocked() {
		return true;
	}

	@Override
	public boolean isCredentialsNonExpired() {
		return true;
	}

	@Override
	public boolean isEnabled() {
		return true;
	}
}