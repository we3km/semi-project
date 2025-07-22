package com.kh.itda.security.controller;

import java.util.Optional;

import javax.servlet.http.HttpSession;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.itda.security.model.vo.UserExt;
import com.kh.itda.user.model.service.EmailService;
import com.kh.itda.user.model.service.UserService;

import lombok.extern.slf4j.Slf4j;

//회원정보 수정, 로그인/로그아웃
@Controller
@Slf4j
public class SecurityController {

	private BCryptPasswordEncoder passwordEncoder;
	private UserService uService;
	private final UserService userService;
    private final EmailService emailService;
    private final HttpSession session;
	
	public SecurityController(BCryptPasswordEncoder passwordEncoder, UserService uService, UserService userService, HttpSession session, EmailService emailService) {
		super();
		this.passwordEncoder = passwordEncoder;
		this.uService = uService;
		this.userService = userService;
		this.emailService = emailService;
		this.session = session;
	}
	
	//로그인
	@GetMapping("/user/login")
	public String login() {
	    return "user/login";
	}
	
	//아이디 찾기
	@GetMapping("/user/findId")
	public String findId() {
	    return "user/findId";
	}

	//비밀번호 찾기
	@GetMapping("/user/findPwd")
	public String findPwd() {
	    return "user/findPwd";
	}
	
	//인증번호 전송
    @PostMapping("/user/sendVerification")
    @ResponseBody
    public ResponseEntity<String> sendVerification(@RequestParam String email) {
        String code = emailService.generateVerificationCode();
        emailService.sendEmail(email, "인증번호 발송", "인증번호는 " + code + "입니다.");
        session.setAttribute("authCode", code);
        return ResponseEntity.ok("전송 완료");
    }

    //인증번호 확인
    @PostMapping("/user/checkVerification")
    @ResponseBody
    public ResponseEntity<String> checkVerification(@RequestParam String code) {
        String stored = (String) session.getAttribute("authCode");
        if (stored != null && stored.equals(code)) {
            session.setAttribute("verified", true);
            return ResponseEntity.ok("success");
        } else {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("fail");
        }
    }

    //아이디 찾기
    @PostMapping("/user/findId")
    public String findIdProcess(@RequestParam String name,
                                @RequestParam String email,
                                Model model) {
        Boolean verified = (Boolean) session.getAttribute("verified");
        if (verified == null || !verified) {
            model.addAttribute("error", "이메일 인증을 먼저 완료해주세요.");
            return "user/findId";
        }

        Optional<String> userId = userService.findIdByNameAndEmail(name, email);
        if (userId.isPresent()) {
            emailService.sendEmail(email, "아이디 찾기", "회원님의 아이디는: " + userId.get());
            model.addAttribute("msg", "이메일로 아이디를 전송했습니다.");
        } else {
            model.addAttribute("error", "일치하는 회원이 없습니다.");
        }

        session.removeAttribute("verified");
        return "user/findId";
    }

    //비밀번호 찾기
    @PostMapping("/user/findPwd")
    public String findPwdProcess(@RequestParam String id,
                                 @RequestParam String email,
                                 Model model) {
        Boolean verified = (Boolean) session.getAttribute("verified");
        if (verified == null || !verified) {
            model.addAttribute("error", "이메일 인증을 먼저 완료해주세요.");
            return "user/findPwd";
        }

        Optional<String> userPwd = userService.findPwdByIdAndEmail(id, email);
        if (userPwd.isPresent()) {
            emailService.sendEmail(email, "비밀번호 찾기", "회원님의 비밀번호는: " + userPwd.get());
            model.addAttribute("msg", "이메일로 비밀번호를 전송했습니다.");
        } else {
            model.addAttribute("error", "일치하는 회원이 없습니다.");
        }

        session.removeAttribute("verified");
        return "user/findPwd";
    }
	
    //회원정보 업데이트
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
