package com.kh.itda.security.handler;

import java.net.URLEncoder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationFailureHandler;
import org.springframework.stereotype.Component;

@Component
public class CustomAuthenticationFailureHandler extends SimpleUrlAuthenticationFailureHandler {

	@Override
	public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
			AuthenticationException exception) {

		try {
			String errorMessage = "아이디 또는 비밀번호가 틀렸습니다.";
			String encodedMessage = URLEncoder.encode(errorMessage, "UTF-8");
			setDefaultFailureUrl("/user/login?error=true&message=" + encodedMessage);
		} catch (Exception e) {
			setDefaultFailureUrl("/user/login?error=true");
		}

		try {
			super.onAuthenticationFailure(request, response, exception);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}