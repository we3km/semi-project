package com.kh.itda.user.controller;

import java.util.List;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.itda.board.model.service.BoardService;
import com.kh.itda.security.model.vo.UserExt;
import com.kh.itda.user.model.service.UserService;
import com.kh.itda.user.model.vo.RentalItem;
import com.kh.itda.validator.UserValidator;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

//마이페이지 전용
@Controller
@RequiredArgsConstructor
@Slf4j
public class UserController {

	private final UserService uService;
	private final BoardService bService;
	private final BCryptPasswordEncoder passwordEncoder;
	
	@GetMapping("/user/mypage")
	public String myPage(@AuthenticationPrincipal UserExt loginUser, Model model) {
		String userId = loginUser.getUserId();
	    int userNum = loginUser.getUserNum();
	    
	    List<RentalItem> rentalList = bService.getRentalItemByUserNum(userNum);
	    
	    
	    model.addAttribute("userId", userId);
	    model.addAttribute("userNum", userNum);
		return "user/mypage";
	}
	
	// 비밀번호 변경
	@PostMapping("/user/mypage/updatePwd")
	public String updatePassword(@RequestParam String newPwd,
	                             @RequestParam String confirmPwd,
	                             Authentication auth,
	                             RedirectAttributes ra) {
	    if (!newPwd.equals(confirmPwd)) {
	        ra.addFlashAttribute("error", "비밀번호가 일치하지 않습니다.");
	        return "redirect:/user/mypage";
	    }
	    
	    if (!UserValidator.isValidPassword(newPwd)) {
	    	ra.addFlashAttribute("error", "비밀번호 형식이 유효하지 않습니다.");
	    	return "redirect:/user/mypage";
	    }

	    UserExt loginUser = (UserExt) auth.getPrincipal();
	    String userId = loginUser.getUserId();
	    String encodedPwd = passwordEncoder.encode(newPwd);
	    uService.updatePassword(userId, encodedPwd);

	    ra.addFlashAttribute("message", "비밀번호가 변경되었습니다.");
	    return "redirect:/user/mypage";
	}
	
	// 닉네임 변경
	@PostMapping("/user/mypage/updateNickname")
	public String updateNickname(@RequestParam String newNickname,
	                             Authentication auth,
	                             RedirectAttributes ra) {
	    if (newNickname.isEmpty()) {
	        ra.addFlashAttribute("error", "닉네임을 입력해주세요.");
	        return "redirect:/user/mypage";
	    }
	    
	    if (!UserValidator.isValidNickName(newNickname)) {
	    	ra.addFlashAttribute("error", "닉네임 형식이 유효하지 않습니다.");
	    	return "redirect:/user/mypage";
	    }

	    UserExt loginUser = (UserExt) auth.getPrincipal();
	    String userId = loginUser.getUserId();
	    uService.updateNickname(userId, newNickname);

	    ra.addFlashAttribute("message", "닉네임이 변경되었습니다.");
	    return "redirect:/user/mypage";
	}
	
	// 폰번호 변경
	@PostMapping("/user/mypage/updatePhone")
	public String updatePhone(@RequestParam String newPhone,
	                             Authentication auth,
	                             RedirectAttributes ra) {
	    if (newPhone.isEmpty()) {
	        ra.addFlashAttribute("error", "휴대폰 번호를 입력해주세요..");
	        return "redirect:/user/mypage";
	    }
	    
	    if (!UserValidator.isValidPhone(newPhone)) {
	    	ra.addFlashAttribute("error", "휴대폰 번호 형식이 유효하지 않습니다.");
	    	return "redirect:/user/mypage";
	    }

	    UserExt loginUser = (UserExt) auth.getPrincipal();
	    String userId = loginUser.getUserId();
	    uService.updatePhone(userId, newPhone);

	    ra.addFlashAttribute("message", "휴대폰 번호가 변경되었습니다.");
	    return "redirect:/user/mypage";
	}
	
	// 주소 변경
	@PostMapping("/user/mypage/updateAddress")
	public String updateAddress(@RequestParam String newAddress,
	                             Authentication auth,
	                             RedirectAttributes ra) {
	    if (newAddress.isEmpty()) {
	        ra.addFlashAttribute("error", "주소를 입력해주세요.");
	        return "redirect:/user/mypage";
	    }
	    
	    UserExt loginUser = (UserExt) auth.getPrincipal();
	    String userId = loginUser.getUserId();
	    uService.updateAddress(userId, newAddress);

	    ra.addFlashAttribute("message", "주소가 변경되었습니다.");
	    return "redirect:/user/mypage";
	}

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
//	 @GetMapping("/user/tempLogin") 
//	 public String tempLogin(HttpServletRequest request) { 
//		  User tempUser = new User(); tempUser.setUserId("USER1");
//	 
//		  tempUser.setUserPwd("1234"); tempUser.setUserNum(1); // 적당한 사용자 번호
//		  tempUser.setNickName("USER1");
//	  
//		  // 세션에 loginUser 속성으로 저장 
//		  request.getSession().setAttribute("loginUser", tempUser);
//		  
//		  return "redirect:/"; // 로그인 후 메인 페이지로 이동 
//	  }
	 
//	 @GetMapping("/user/login") 
//	 public String login(HttpServletRequest request) { 
//		 User loginUser = uService.loginUser(user);
//	 
//		  
//		  // 세션에 loginUser 속성으로 저장 
//		  request.getSession().setAttribute("loginUser", tempUser);
//		  
//		  return "redirect:/"; // 로그인 후 메인 페이지로 이동 
//	  }
	 
	  
//	  // 로그아웃 (세션 무효화)
//	  @GetMapping("/user/logout") 
//	  public String logout(HttpServletRequest request){ request.getSession().invalidate(); return "redirect:/"; // 로그아웃 후 메인 페이지로 이동
//	  }
}



