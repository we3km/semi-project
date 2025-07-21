package com.kh.itda.security.controller;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.itda.security.model.vo.UserExt;
import com.kh.itda.user.model.service.UserService;
import lombok.extern.slf4j.Slf4j;

//회원가입, 회원정보 수정, 로그인/로그아웃
@Controller
@Slf4j
public class SecurityController {

	private BCryptPasswordEncoder passwordEncoder;
	private UserService uService;
	
	public SecurityController(BCryptPasswordEncoder passwordEncoder, UserService uService) {
		super();
		this.passwordEncoder = passwordEncoder;
		this.uService = uService;
	}
	
	@PostMapping("/user/update")
	public String update(
			@Validated @ModelAttribute UserExt loginUser,
			BindingResult bindResult,
			Authentication auth,
			RedirectAttributes ra
			) {
		if(bindResult.hasErrors()) {
			return "redirect:/user/myPage";
		}
		// 비밀번호 변경 시 암호화
		if (loginUser.getUserPwd() != null && !loginUser.getUserPwd().isBlank()) {
            loginUser.setUserPwd(passwordEncoder.encode(loginUser.getUserPwd()));
        }
		
		// db의 user객체를 수정
		int result = uService.updateUser(loginUser);
		
		// 변경된 회원정보를 DB에서 얻어온 후 새로운 인증정보 생성하여 스레드로컬에 저장
		// 새로운 Authentication 객체생성
		Authentication newAuth = new UsernamePasswordAuthenticationToken
				(
				loginUser, auth.getCredentials(), auth.getAuthorities()
		);
		SecurityContextHolder.getContext().setAuthentication(newAuth);
		ra.addFlashAttribute("alertMsg", "내 정보 수정 성공");
		
		return "redirect:/user/myPage";
	}
	
}
