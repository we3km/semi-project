package com.kh.itda.support.controller;

import java.util.Date;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.itda.security.model.vo.UserExt;
import com.kh.itda.support.model.service.ReportService;
import com.kh.itda.support.model.vo.Report;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@RequestMapping("/report")
@Slf4j
public class ReportController {

    private final ReportService reportService;

    @PostMapping(value = "/submit", produces = "text/plain;charset=UTF-8")
    @ResponseBody
    public String submitReport(Report report, Authentication auth) {
        UserExt loginUser = (UserExt) auth.getPrincipal();
		
		if (loginUser == null || loginUser.getUserNum() == 0) {
			return "로그인이 필요합니다.";
		}
		
        report.setUserNum(loginUser.getUserNum());
        
        report.setCreatedAt(new Date());
        report.setStatus("접수");
        
        log.debug("DB로 전달될 신고 정보: " + report);

        int result = reportService.insertReport(report);

        return result > 0 ? "신고완료되었습니다" : "신고에 실패하였습니다.";
    }
    
    @GetMapping("/view")
    public String viewReportPage(Model model) {
        model.addAttribute("report", new Report()); // form:form에 바인딩 객체
        return "report/report"; // 실제 경로: /WEB-INF/views/report/report.jsp
    }
    
}