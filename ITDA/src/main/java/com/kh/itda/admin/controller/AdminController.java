package com.kh.itda.admin.controller;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.itda.admin.service.AdminService;
import com.kh.itda.support.model.vo.Report;
import com.kh.itda.user.model.vo.User;

@Controller
@RequestMapping("/admin")
public class AdminController {

	@Autowired
	private AdminService adminService;

	/**
	 * 관리자 마이페이지 ROLE_ADMIN 권한 필요
	 */
	@GetMapping("/mypage")
	public String adminMypage(Model model) {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		String userId = authentication.getName();

		User user = adminService.findUserById(userId);
		model.addAttribute("loginuser", user);

		return "adminPage/adminMyPage";
	}

	/**
	 * 신고 관리 페이지
	 */
	@GetMapping("/reports")
	public String reportManagement(Model model) {
		List<Report> reportList = adminService.getAllReports();
		model.addAttribute("reportList", reportList);
		return "adminPage/reportList";
	}

	/**
	 * 회원 검색
	 */
	@ResponseBody
	@GetMapping("/memberSearch")
	public List<User> searchUsers(@RequestParam("keyword") String keyword) {
		try {
			List<User> users = adminService.searchUsers(keyword);
			return users;
		} catch (Exception e) {
			// 예외 처리 로직 추가 가능
			return null; // 필요 시 Collections.emptyList()로 변경 가능
		}
	}

	/**
	 * 신고 상세 조회
	 */
	@GetMapping("/reports/Detail/{reportNum}")
	public String reportDetail(@PathVariable("reportNum") int reportNum, Model model) {
		Report report = adminService.getReportById(reportNum);
		model.addAttribute("report", report);
		return "adminPage/reportDetail";
	}
}