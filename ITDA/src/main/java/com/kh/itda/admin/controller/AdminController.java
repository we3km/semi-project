package com.kh.itda.admin.controller;

import java.util.List;

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


	@GetMapping("/memberSearch")
	@ResponseBody
	public List<User> memberSearch(@RequestParam("keyword") String keyword) {
	    return adminService.searchUsers(keyword);   
	}
	
	@GetMapping("/reports")
	public String reportManagement(Model model) {
	    List<Report> reportList = adminService.getAllReports();
	    model.addAttribute("reportList", reportList);
	    return "adminPage/reportList";
	}
	
	@GetMapping("/reports/Detail/{reportNum}")
	public String reportDetail(@PathVariable("reportNum") int reportNum, Model model) {
		Report report = adminService.getReportById(reportNum);
		model.addAttribute("report",report);
		return "adminPage/reportDetail";
	}
	
}