package com.kh.itda.security.controller;

import javax.servlet.http.HttpSession;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.itda.user.model.service.UserService;
import com.kh.itda.user.model.vo.User;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/signup")
@RequiredArgsConstructor
@Slf4j
public class SignUpController {
	private final UserService uService;
    private final PasswordEncoder passwordEncoder;

    @GetMapping("/terms")
    public String showTermsPage() {
        return "signup/terms";
    }

    @PostMapping("/terms")
    public String acceptTerms(@RequestParam(value = "agreeAll", required = false) Boolean agreeAll, HttpSession session) {
        if (Boolean.TRUE.equals(agreeAll)) {
            session.setAttribute("termsAccepted", true);
            return "redirect:/signup/email";
        } else {
            return "redirect:/signup/terms?error=notAgreed";
        }
    }

    @GetMapping("/email")
    public String showEmailVerificationPage(HttpSession session) {
        if (session.getAttribute("termsAccepted") == null) {
            return "redirect:/signup/terms";
        }
        return "signup/email";
    }

    @PostMapping("/email")
    public String verifyEmail(@RequestParam("email") String email, HttpSession session) {
        // TODO: 이메일 인증 로직 추가
        boolean emailVerified = true;

        if (emailVerified) {
            session.setAttribute("emailVerified", true);
            session.setAttribute("email", email);
            return "redirect:/signup/form";
        } else {
            return "redirect:/signup/email?error=verifyFailed";
        }
    }

    @GetMapping("/form")
    public String showSignUpForm(Model model, HttpSession session) {
        if (session.getAttribute("emailVerified") == null) {
            return "redirect:/signup/email";
        }
        model.addAttribute("user", new User());
        return "signup/form";
    }

    @PostMapping("/form")
    public String submitSignUpForm(
            @Validated @ModelAttribute("user") User user,
            BindingResult bindingResult,
            HttpSession session,
            RedirectAttributes ra) {

        if (bindingResult.hasErrors()) {
            return "signup/form";
        }

        // 비밀번호 암호화
        String encryptedPassword = passwordEncoder.encode(user.getUserPwd());
        user.setUserPwd(encryptedPassword);

        // DB 저장
        int userNum = uService.insertUserAndGetUserNo(user);

        // 프로필 이미지 URL이 있다면 저장
        if (user.getImageUrl() != null && !user.getImageUrl().isBlank()) {
            uService.insertProfile(userNum, user.getImageUrl());
        }

        // 완료 후 리다이렉트
        ra.addFlashAttribute("alertMsg", "회원가입 완료!");
        session.invalidate();
        return "redirect:/user/login";
    }
}
