package com.kh.itda.security.handler;

import java.io.IOException;
import java.util.Collection;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import com.kh.itda.security.model.vo.UserExt;

@Component
public class CustomAuthenticationSuccessHandler implements AuthenticationSuccessHandler {

	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication) throws IOException, ServletException {

		System.out.println("로그인 성공 핸들러 시작");

		Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();
		String role = "ROLE_USER"; // 기본값 role('ROLE_USER')
		for (GrantedAuthority authority : authorities) {
			role = authority.getAuthority();
			if ("ROLE_ADMIN".equals(role)) {
				break;
			}
		}
		
		System.out.println("=== 로그인 성공 ===");
		System.out.println("Principal: " + authentication.getPrincipal());
		System.out.println("Authorities: ");
		for (GrantedAuthority authority : authentication.getAuthorities()) {
		    System.out.println(" - " + authority.getAuthority());
		}

		UserExt userDetails = (UserExt) authentication.getPrincipal();

		System.out.println("권한: " + role);
		System.out.println("로그인한 사용자: " + userDetails);

		request.getSession().setAttribute("role", role);
		request.getSession().setAttribute("loginUser", userDetails);

		System.out.println("세션에 role, loginUser 저장 완료");

			response.sendRedirect(request.getContextPath() + "/");
		}
	}