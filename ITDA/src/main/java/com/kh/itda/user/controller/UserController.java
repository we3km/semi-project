package com.kh.itda.user.controller;


import javax.servlet.http.HttpServletRequest;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.File;
import java.io.IOException;
import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import com.kh.itda.board.model.service.BoardService;
import com.kh.itda.board.model.vo.BoardRentalFileWrapper;
import com.kh.itda.config.FileConfig;
import com.kh.itda.security.model.vo.UserExt;
import com.kh.itda.support.model.vo.Report;
import com.kh.itda.user.model.service.UserService;
import com.kh.itda.user.model.vo.User;
import com.kh.itda.validator.UserValidator;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

//마이페이지 전용
@Controller
@RequiredArgsConstructor
@Slf4j
public class UserController {

	private final UserService uService;
	private final BoardService boardService;
	private final BCryptPasswordEncoder passwordEncoder;
	  
//	@GetMapping("/user/mypage") public String myPage(@AuthenticationPrincipal UserExt loginUser, Model model) { 
//	int userNum = loginUser.getUserNum();
//	model.addAttribute("user", loginUser);
//	  
//	List<RentalItem> rentalList = bService.getRentalItemByUserNum(userNum);
//
//	return "user/mypage"; 
//	}

	@GetMapping("/user/mypage")
	public String mypage(Model model) {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		
		String userId = authentication.getName();
		User user = uService.findUserById(userId);
		int userNum = user.getUserNum();
		model.addAttribute("user", user);
		
		// 사용자 프로필 이미지 url 조회
		String imageUrl = uService.getProfileImageUrl(user.getUserNum());
	    if (imageUrl == null || imageUrl.isEmpty()) {
	    	imageUrl = "/resources/profile/default.png";
	    }
	    model.addAttribute("imageUrl", imageUrl);
	    
	    // 사용자 매너점수 조회
	    Integer rawScore = uService.getScore(user.getUserNum());
	    int itdaPoint = (rawScore != null) ? rawScore : 80;
	    model.addAttribute("itdaPoint", itdaPoint);
		
	    // 사용자가 작성한 게시물 리스트
		// 사용자가 올린 대여 개시글
		List<BoardRentalFileWrapper> userRentalWrapperList = boardService.selectWriterRentalList(userNum);
		model.addAttribute("userRentalWrapperList", userRentalWrapperList);
		System.out.println("사용자의 대여 상품 : " + userRentalWrapperList);
	    
	    //사용자가 찜해둔 게시물 리스트
	    
	    
		return "user/mypage";
	}

	// 비밀번호 변경
	@PostMapping("/user/mypage/updatePwd")
	public String updatePassword(@RequestParam String newPwd, @RequestParam String confirmPwd, Authentication auth,
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
	
	// 닉네임 중복확인
	@GetMapping("/user/mypage/checkNickname")
	@ResponseBody
	public String checkNickname(String newNickname) {
    	if(!UserValidator.isValidNickName(newNickname)) {
    		return "-1";
    	}
    	int result = uService.checkNickname(newNickname);
    	return String.valueOf(result);
    }

	// 닉네임 변경
	@PostMapping("/user/mypage/updateNickname")
	public String updateNickname(@RequestParam String newNickname, Authentication auth, RedirectAttributes ra) {
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
	
	// 폰번호 중복 검사
	@GetMapping("/user/mypage/checkPhone")
	@ResponseBody
	public String checkPhone(String newPhone) {
    	if(!UserValidator.isValidPhone(newPhone)) {
    		return "-1";
    	}
    	int result = uService.checkPhone(newPhone);
    	return String.valueOf(result);
    }

	// 폰번호 변경
	@PostMapping("/user/mypage/updatePhone")
	public String updatePhone(@RequestParam String newPhone, Authentication auth, RedirectAttributes ra) {
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
	public String updateAddress(@RequestParam("address") String newAddress, Authentication auth,
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
	
	// 프로필 변경
	@PostMapping("/user/mypage/updateProfileImage")
	@ResponseBody
	public Map<String, Object> updateProfileImage(@RequestParam("profileImage") MultipartFile profileImage,
	                                              Authentication auth,
	                                              HttpSession session) {
	    Map<String, Object> response = new HashMap<>();

	    if (profileImage.isEmpty()) {
	        response.put("success", false);
	        response.put("message", "파일이 비어 있습니다.");
	        return response;
	    }

	    try {
	        // 사용자 정보
	        UserExt loginUser = (UserExt) auth.getPrincipal();
	        int userNum = loginUser.getUserNum();

	        String saveDirectory = session.getServletContext().getRealPath(FileConfig.PROFILE_IMAGE_WEB_PATH);
	        System.out.println("Profile 저장 경로: " + saveDirectory); // 경로 확인용
	        File dir = new File(saveDirectory);
	        if (!dir.exists()) {
	            dir.mkdirs();
	        }

	        String originalFilename = profileImage.getOriginalFilename();
	        String fileName = userNum + "_" + System.currentTimeMillis() + "_" + originalFilename;

	        File destFile = new File(saveDirectory + File.separator + fileName);

	        // 기존 이미지 삭제 처리
	        String oldImageUrl = uService.getProfileImageUrl(userNum);
	        if (oldImageUrl != null && !oldImageUrl.contains("default.png")) {
	            String oldFilePath = session.getServletContext().getRealPath(oldImageUrl);
	            File oldFile = new File(oldFilePath);
	            if (oldFile.exists()) {
	                oldFile.delete();
	            }
	        }
	        
	        // 실제 파일 저장
	        profileImage.transferTo(destFile);

	        // DB에 저장할 이미지 URL (웹에서 접근 가능한 경로)
	        String imageUrl = FileConfig.PROFILE_IMAGE_WEB_PATH + fileName;

	        // DB 업데이트
	        uService.updateProfileImage(userNum, imageUrl);

	        // 응답 반환
	        response.put("success", true);
	        response.put("newImageUrl", imageUrl);
	        return response;

	    } catch (IOException e) {
	        e.printStackTrace();
	        response.put("success", false);
	        response.put("message", "파일 저장 중 오류 발생");
	        return response;
	    }
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

	
	// 임시 로그인 (하드코딩된 USER1 정보로 세션에 로그인 유저 저장)
	 @GetMapping("/user/tempLogin") 
	 public String tempLogin(HttpServletRequest request) { 
		User tempUser = new User(); tempUser.setUserId("USER1");
	 
		tempUser.setUserPwd("1234"); tempUser.setUserNum(1); // 적당한 사용자 번호
		tempUser.setNickName("USER1");
	  
		  // 세션에 loginUser 속성으로 저장 
		request.getSession().setAttribute("loginUser", tempUser);
		  
		return "redirect:/"; // 로그인 후 메인 페이지로 이동 
	 }
	 
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

//		 @PostMapping("/login")
//		 public String login(
//		             User user,          // 로그인 페이지 form에서 넘어온 id, pwd 정보
//		             HttpSession session,    // 세션을 사용하기 위한 파라미터
//		             RedirectAttributes ra
//		             ) {
//
//		     // 1. Service를 호출하여 로그인 처리를 요청합니다.
//		     User loginUser = uService.login(user);
//
//		     // 2. 로그인 성공 여부를 판단합니다.
//		     if (loginUser != null) {
//		         // 3. [핵심] 로그인 성공 시, 세션에 사용자 정보를 "loginUser"라는 이름으로 저장합니다.
//		         session.setAttribute("loginUser", loginUser);
//		         
//		         // 메인 페이지로 리다이렉트
//		         return "redirect:/";
//		         
//		     } else {
//		         // 로그인 실패 처리
//		         ra.addFlashAttribute("alertMsg", "아이디 또는 비밀번호가 일치하지 않습니다.");
//		         return "redirect:/login"; // 로그인 페이지로 다시 이동
//		     }
//		 }
//	 

	// 타인 정보 페이지
	@GetMapping("/user/mypageOthers/{userNum}")
	public String mypageOthers(@PathVariable int userNum, Model model) {
		User user = uService.findUserByUserNum(userNum);
		model.addAttribute("user", user);
		
		// 사용자 프로필 이미지 url 조회
		String imageUrl = uService.getProfileImageUrl(userNum);
	    if (imageUrl == null || imageUrl.isEmpty()) {
	    	imageUrl = "/resources/profile/default.png";
	    }
	    model.addAttribute("imageUrl", imageUrl);
	    
	    // 사용자 매너점수 조회
	    Integer rawScore = uService.getScore(userNum);
	    int itdaPoint = (rawScore != null) ? rawScore : 80;
	    model.addAttribute("itdaPoint", itdaPoint);
		model.addAttribute("report", new Report());
		
		return "/user/mypageOthers";
	}
	  
	// 로그아웃 (세션 무효화)
	@GetMapping("/user/logout") 
	public String logout(HttpServletRequest request){ 
		request.getSession().invalidate(); 
		return "redirect:/"; // 로그아웃 후 메인 페이지로 이동
	}
	
	// 회원탈퇴
	@PostMapping("/user/delete")
	public String deleteUser() {
		
		return "redirect:/";
	}
	
}

