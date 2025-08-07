package com.kh.itda.security.model.vo;

import java.util.Collection;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import lombok.Data;

@Data
public class UserExt implements UserDetails {
    private static final long serialVersionUID = 8050194209742105906L;

	private int userNum;
	private String userId;
	private String userPwd;
	private String nickName;
	private String email;
	private String birth;
	private String phone;
	private String address;
	private String imageUrl;
	private char isBanned;

	// Spring Security 권한 목록
	private Collection<? extends GrantedAuthority> authorities;

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
	    boolean enabled = isBanned != 'Y' && isBanned != 'y';
	    System.out.println(">>> isEnabled() 호출됨. isBanned: " + isBanned + ", 결과: " + enabled);
	    return enabled;
	}
}