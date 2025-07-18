package com.kh.itda.support.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/cs")
public class CustomerCenterController {

    // 고객센터 메인 페이지
    @GetMapping
    public String csServiceMain() {
        return "report/CS_Service";
    }

    // 1:1 문의 페이지
    @GetMapping("/inquiry")
    public String inquiryPage() {
        return "report/inquiry";
    }
}