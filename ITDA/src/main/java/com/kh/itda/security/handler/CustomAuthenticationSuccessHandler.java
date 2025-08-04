package com.kh.itda.security.handler;
<<<<<<< Updated upstream
import java.io.IOException;
import java.util.Collection;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
=======

import java.io.IOException;
import java.util.Collection;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

>>>>>>> Stashed changes
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;
<<<<<<< Updated upstream
@Component
public class CustomAuthenticationSuccessHandler implements AuthenticationSuccessHandler {
	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
	                                    Authentication authentication) throws IOException, ServletException {
=======

@Component
public class CustomAuthenticationSuccessHandler implements AuthenticationSuccessHandler {

	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
	                                    Authentication authentication) throws IOException, ServletException {

>>>>>>> Stashed changes
	    // 현재 권한 저장 코드 유지
	    Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();
	    String role = "ROLE_USER"; // 기본값 role('ROLE_USER')
	    for (GrantedAuthority authority : authorities) {
	        role = authority.getAuthority();
	        if ("ROLE_ADMIN".equals(role)) {
	            break;
	        }
	    }
<<<<<<< Updated upstream
	    // 사용자 정보 가져오기
	    Object principal = authentication.getPrincipal();
	    // 세션에 저장
	    request.getSession().setAttribute("role", role);
	    request.getSession().setAttribute("loginuser", principal);  // 사용자 정보도 저장
	    System.out.println("로그인 성공: " + authentication.getName() + " / 권한: " + role);
=======

	    // 사용자 정보 가져오기
	    Object principal = authentication.getPrincipal();

	    // 세션에 저장
	    request.getSession().setAttribute("role", role);
	    request.getSession().setAttribute("loginuser", principal);  // 사용자 정보도 저장

	    System.out.println("로그인 성공: " + authentication.getName() + " / 권한: " + role);

>>>>>>> Stashed changes
	    response.sendRedirect(request.getContextPath() + "/");
	}
}