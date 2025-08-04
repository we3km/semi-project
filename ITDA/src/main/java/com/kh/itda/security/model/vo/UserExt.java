package com.kh.itda.security.model.vo;

import java.util.Collection;
import java.util.List;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import com.kh.itda.user.model.vo.User;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@NoArgsConstructor
@ToString(callSuper = true)
public class UserExt extends User implements UserDetails{
	private List<GrantedAuthority> authorities;

	
	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
		return authorities;
	}

	// 스프링 시큐리티에서 비밃번호, 아이디를 가져올때 사용할 메서드
	@Override
	public String getPassword() {
		return getUserPwd();
	}
	
	@Override
	public String getNickName() {
		return super.getNickName();
	}

	@Override
	public String getUsername() {
		return getUserId();
	}

	public int getUserNum() {
	    return super.getUserNum();
	}

	public void setAuthorities(List<GrantedAuthority> authorities) {
		this.authorities = authorities;
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
