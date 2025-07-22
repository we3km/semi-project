package com.kh.itda.user.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.itda.user.model.service.UserService;
import com.kh.itda.user.model.vo.User;

import lombok.extern.slf4j.Slf4j;

//마이페이지 전용
@Controller
@Slf4j
public class UserController {

	@Autowired
	private UserService uService;
	
	@PostMapping("/user/login")
	public ModelAndView login(
			@ModelAttribute User user, 
			ModelAndView mv, 
			Model model, 
			HttpSession session, // 로그인 성공시, 사용자의 정보를 보관할 객체
			RedirectAttributes ra
			) {
		
		// 로그인 요청 처리
		User loginUser = uService.loginUser(user);
		
		if(loginUser != null) {
			model.addAttribute("loginUser", loginUser);
			ra.addFlashAttribute("alertMsg", "로그인 성공");
		}else {
			ra.addFlashAttribute("alertMsg", "로그인 실패");
		}
		
		// 메인페이지로 리다이렉트
		mv.setViewName("redirect:/");
		
		return mv;
	}
	
	@GetMapping("/user/myPage")
	public String myPage() {
		return "user/myPage";
	}
	
}
