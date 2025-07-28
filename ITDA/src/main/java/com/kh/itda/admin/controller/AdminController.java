package com.kh.itda.admin.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kh.itda.user.model.service.UserService;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private UserService userService;  // 회원 검색 서비스

    @GetMapping("/myPage")
    public String adminMyPage(Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        boolean isAdmin = auth.getAuthorities().stream()
            .anyMatch(grantedAuthority -> grantedAuthority.getAuthority().equals("ROLE_ADMIN"));

        if (!isAdmin) {
            return "redirect:/";
        }

        return "adminPage/adminMyPage";
    }


    @GetMapping("/reports")
    public String reportManagement() {
        return "report/report";
    }	

//    @GetMapping("/memberSearch")
//    @ResponseBody
//    public List<User> memberSearch(@RequestParam String keyword) {
//        return adminService.searchMembersByKeyword(keyword);
//    }
}