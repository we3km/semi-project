package com.kh.itda.security.handler;

import java.net.URLEncoder;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationFailureHandler;
import org.springframework.stereotype.Component;

@Component
public class CustomAuthenticationFailureHandler extends SimpleUrlAuthenticationFailureHandler {

	@Override
	public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
			AuthenticationException exception) throws IOException, ServletException {

		try {
			String errorMessage = "아이디 또는 비밀번호가 틀렸습니다.";
			String encodedMessage = URLEncoder.encode(errorMessage, "UTF-8");
			setDefaultFailureUrl("/user/login?error=true&message=" + encodedMessage);
		} catch (Exception e) {
			setDefaultFailureUrl("/user/login?error=true");
		}

		super.onAuthenticationFailure(request, response, exception);
	}
}