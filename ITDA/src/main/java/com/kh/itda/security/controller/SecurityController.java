package com.kh.itda.security.controller;

import javax.servlet.http.HttpSession;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.itda.security.model.vo.UserExt;
import com.kh.itda.user.model.service.UserService;
import com.kh.itda.user.model.vo.User;

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
	
	// 회원가입 페이지 이동
	@GetMapping("/user/insert")
	public String enroll(@ModelAttribute User user
			) {
		return "user/userEnrollForm";
	}
	
	@PostMapping("/user/insert")
	public String register(
			@Validated @ModelAttribute User user,
			BindingResult bindingResult,
			RedirectAttributes ra) {
		// 유효성 검사
		if(bindingResult.hasErrors()) {
			return "user/userEnrollForm";
		}
		// 회원가입 진행
		String encryptedPassword = passwordEncoder.encode(user.getUserPwd());
		user.setUserPwd(encryptedPassword);

		int userNum = uService.insertUserAndGetUserNo(user); // USER_TB INSERT 후 userNum 반환
		if(user.getImageUrl() != null && !user.getImageUrl().isBlank()) {
			uService.insertProfile(userNum, user.getImageUrl());
		}
		// 회원가입 완료 후 로그인 페이지로 리다이렉트
		ra.addFlashAttribute("alertMsg", "회원가입 완료!");
		return "redirect:/user/login";
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
