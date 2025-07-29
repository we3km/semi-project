package com.kh.itda.user.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.itda.user.model.service.UserService;
import com.kh.itda.user.model.vo.User;

@Controller
@RequestMapping("/user")
public class LoginController {

    @Autowired
    private UserService userService;

    // 로그인 폼 요청
    @GetMapping("/login")
    public String showLoginForm() {
        return "user/login"; // /WEB-INF/views/user/login.jsp
    }

    // 로그인 처리
    @PostMapping("/login")
    public String login(@RequestParam String userId,
                        @RequestParam String userPwd,
                        HttpSession session,
                        RedirectAttributes ra) {

        User loginUser = userService.login(userId, userPwd);

        if (loginUser == null) {
            ra.addFlashAttribute("msg", "아이디 또는 비밀번호가 일치하지 않습니다.");
            return "redirect:/user/login";
        }

        // 세션에 로그인 사용자 정보 저장
        session.setAttribute("loginUser", loginUser);

        return "redirect:/"; // 로그인 성공 시 메인 페이지로 이동
    }

    // 로그아웃 처리
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate(); // 세션 무효화 (모든 세션 데이터 삭제)
        return "redirect:/";
    }
}
