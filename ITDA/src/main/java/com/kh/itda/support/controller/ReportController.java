package com.kh.itda.support.controller;

import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.itda.common.model.vo.Report;
import com.kh.itda.security.model.vo.UserExt;
import com.kh.itda.support.model.service.ReportService;

@Controller
public class ReportController {

    @Autowired
    private ReportService reportService;

    @PostMapping("/report/submit")
    @ResponseBody
    public String submitReport(Report report, @AuthenticationPrincipal UserExt loginUser) {
        if (loginUser == null) {
            return "로그인이 필요합니다.";
        }
        
        report.setUserNum(loginUser.getUserNum());
        report.setCreatedAt(LocalDateTime.now());
        report.setStatus("대기중");

        int result = reportService.insertReport(report);

        return result > 0 ? "신고완료되었습니다" : "신고에 실패하였습니다.";
    }
}