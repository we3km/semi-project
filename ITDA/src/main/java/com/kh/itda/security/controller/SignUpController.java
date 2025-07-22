package com.kh.itda.security.controller;

import com.kh.itda.user.model.service.EmailService;
import com.kh.itda.user.model.service.UserService;
import com.kh.itda.user.model.vo.User;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.util.Random;

@Controller
@RequestMapping("/signup")
@RequiredArgsConstructor
@Slf4j
public class SignUpController {

    private final UserService uService;
    private final EmailService emailService;
    private final PasswordEncoder passwordEncoder;

    // 1단계: 이용약관
    @GetMapping("/terms")
    public String showTermsPage() {
        return "signup/terms";
    }

    @PostMapping("/terms")
    public String acceptTerms(
    		@RequestParam(value = "agreeTerms", required = false) String terms1,
            @RequestParam(value = "agreePrivacy", required = false) String terms2,
            @RequestParam(value = "agreePolicy", required = false) String terms3,
            HttpSession session) {
        if (terms1 != null && terms2 != null && terms3 != null) {
            session.setAttribute("termsAccepted", true);
            return "redirect:/signup/emailAuth";
        } else {
            return "redirect:/signup/terms?error=notAgreed";
        }
    }

    // 2단계: 이메일 인증 페이지
    @GetMapping("/emailAuth")
    public String showEmailVerificationPage(HttpSession session) {
        if (session.getAttribute("termsAccepted") == null) {
            return "redirect:/signup/terms";
        }
        return "signup/emailAuth";
    }

    // 이메일로 인증번호 발송
    @PostMapping("/emailAuth/sendCode")
    @ResponseBody
    public String sendAuthCode(
    		@RequestParam("email") String email, 
    		HttpSession session) {
        String code = generateAuthCode();
        session.setAttribute("authCode", code);
        session.setAttribute("email", email);

        boolean result = emailService.sendEmail(email, "이메일 인증번호", "인증번호: " + code);
        return result ? "success" : "fail";
    }

    // 인증번호 확인
    @PostMapping("/emailAuth/verifyCode")
    @ResponseBody
    public String verifyCode(
    		@RequestParam("code") String code, 
    		HttpSession session) {
        String sessionCode = (String) session.getAttribute("authCode");
        if (sessionCode != null && sessionCode.equals(code)) {
            session.setAttribute("emailVerified", true);
            return "success";
        } else {
            return "fail";
        }
    }

    // 3단계: 회원정보 입력 페이지
    @GetMapping("/enroll")
    public String showSignUpForm(Model model, HttpSession session) {
        if (session.getAttribute("emailVerified") == null) {
            return "redirect:/signup/emailAuth";
        }
        model.addAttribute("user", new User());
        return "signup/enroll";
    }

    @PostMapping("/enroll")
    public String submitSignUpForm(
            @Validated @ModelAttribute("user") User user,
            BindingResult bindingResult,
            HttpSession session,
            RedirectAttributes ra) {

        if (bindingResult.hasErrors()) {
            return "signup/enroll";
        }

        // 비밀번호 암호화
        String encryptedPassword = passwordEncoder.encode(user.getUserPwd());
        user.setUserPwd(encryptedPassword);

        // DB 저장
        int userNum = uService.insertUser(user);

        // 프로필 이미지 URL이 있다면 저장
        if (user.getImageUrl() != null && !user.getImageUrl().isBlank()) {
            uService.insertProfile(userNum, user.getImageUrl());
        }

        // 완료 후 리다이렉트
        ra.addFlashAttribute("alertMsg", "회원가입 완료!");
        session.invalidate();
        return "redirect:/user/login";
    }

    //인증코드 생성
    private String generateAuthCode() {
        Random rand = new Random();
        StringBuilder code = new StringBuilder();
        for (int i = 0; i < 6; i++) {
            code.append(rand.nextInt(10));
        }
        return code.toString();
    }
}
