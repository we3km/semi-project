package com.kh.itda.user.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import com.kh.itda.user.model.vo.User;

@Controller
public class UserController {

    // 임시 로그인 (하드코딩된 USER1 정보로 세션에 로그인 유저 저장)
    @GetMapping("/user/tempLogin")
    public String tempLogin(HttpServletRequest request) {
        User tempUser = new User();
        tempUser.setUserId("USER1");
        tempUser.setUserPwd("1234");
        tempUser.setUserNo(1);      // 적당한 사용자 번호
        tempUser.setUserName("USER1");

        // 세션에 loginUser 속성으로 저장
        request.getSession().setAttribute("loginUser", tempUser);

        return "redirect:/";  // 로그인 후 메인 페이지로 이동
    }

    // 로그아웃 (세션 무효화)
    @GetMapping("/user/logout")
    public String logout(HttpServletRequest request) {
        request.getSession().invalidate();
        return "redirect:/";  // 로그아웃 후 메인 페이지로 이동
    }
}
