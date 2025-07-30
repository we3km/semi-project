package com.kh.itda.user.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import com.kh.itda.user.model.vo.User;

import lombok.extern.slf4j.Slf4j;

//마이페이지 전용
@Controller
@Slf4j
public class UserController {

	/*
	 * @Autowired private UserService uService;
	 * 
	 * @PostMapping("/user/login") public ModelAndView login(
	 * 
	 * @ModelAttribute User user, ModelAndView mv, Model model, HttpSession session,
	 * // 로그인 성공시, 사용자의 정보를 보관할 객체 RedirectAttributes ra ) {
	 * 
	 * // 로그인 요청 처리 User loginUser = uService.loginUser(user);
	 * 
	 * if(loginUser != null) { model.addAttribute("loginUser", loginUser);
	 * ra.addFlashAttribute("alertMsg", "로그인 성공"); }else {
	 * ra.addFlashAttribute("alertMsg", "로그인 실패"); }
	 * 
	 * // 메인페이지로 리다이렉트 mv.setViewName("redirect:/");
	 * 
	 * return mv; }
	 * 
	 * @GetMapping("/user/myPage") public String myPage() { return "user/myPage"; }
	 */

	// 임시 로그인 (하드코딩된 USER1 정보로 세션에 로그인 유저 저장)

	@GetMapping("/user/tempLogin")
	public String tempLogin(HttpServletRequest request) {
		User tempUser = new User();
		tempUser.setUserId("USER1");

		tempUser.setUserPwd("1234");
		tempUser.setUserNum(1); // 적당한 사용자 번호
		tempUser.setNickName("USER1");

		// 세션에 loginUser 속성으로 저장
		request.getSession().setAttribute("loginUser", tempUser);

		return "redirect:/"; // 로그인 후 메인 페이지로 이동
	}

	// 로그아웃 (세션 무효화)
	@GetMapping("/user/logout")
	public String logout(HttpServletRequest request) {
		request.getSession().invalidate();
		return "redirect:/"; // 로그아웃 후 메인 페이지로 이동
	}

}
