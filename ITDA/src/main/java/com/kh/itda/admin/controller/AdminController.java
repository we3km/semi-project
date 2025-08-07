package com.kh.itda.admin.controller;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.itda.admin.service.AdminService;
import com.kh.itda.common.model.vo.PageInfo;
import com.kh.itda.common.model.vo.template.Pagination;
import com.kh.itda.security.model.dao.SecurityDao;
import com.kh.itda.support.model.service.ReportService;
import com.kh.itda.support.model.vo.Report;
import com.kh.itda.user.model.vo.BanUser;
import com.kh.itda.user.model.vo.User;

@Controller
@RequestMapping("/admin")
public class AdminController {

	@Autowired
	private AdminService adminService;
	
	@Autowired
	private SecurityDao securityDao;
	
	/**
	 * 관리자 마이페이지 ROLE_ADMIN 권한 필요
	 */
	@GetMapping("/mypage")
	public String adminMypage(Model model) {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		String userId = authentication.getName();

		User user = adminService.findUserById(userId);
		model.addAttribute("loginUser", user);

		return "adminPage/adminMyPage";
	}

	/**
	 * 신고 관리 페이지
	 */
	@GetMapping("/reports")
	public String reportList(@RequestParam(value = "currentPage", defaultValue = "1") int currentPage, Model model) {

		List<Report> allReports = adminService.getAllReports();

		int listCount = allReports.size();
		int pageLimit = 10;
		int communityLimit = 10;

		PageInfo pi = Pagination.getPagInfo(listCount, currentPage, pageLimit, communityLimit);

		int start = (currentPage - 1) * communityLimit;
		int end = Math.min(start + communityLimit, listCount);

		List<Report> pageReports = allReports.subList(start, end);

		model.addAttribute("reportList", pageReports);
		model.addAttribute("pi", pi);

		return "adminPage/reportList";
	}

	/**
	 * 회원 검색
	 */
	@ResponseBody
	@GetMapping("/memberSearch")
	public List<User> searchUsers(@RequestParam("keyword") String keyword) {
		try {
			String searchKeyword = "%" + keyword + "%";
			List<User> users = adminService.searchUsers(searchKeyword);
			return users;
		} catch (Exception e) {
			return null;
		}
	}

	/**
	 * 신고 상세 조회
	 */
	@GetMapping("/reports/detail/{reportNum}")
	public String reportDetail(@PathVariable("reportNum") int reportNum, Model model) {
		Report report = adminService.getReportById(reportNum);
		if (report == null) {
			// 없는 신고 번호일 경우, 목록 페이지로 리다이렉트
			return "redirect:/admin/reports";
		}
		model.addAttribute("report", report);
		return "adminPage/reportDetail";
	}

	@PostMapping("/reports/updateStatus")
	public String updateReportStatus(@RequestParam("reportNum") int reportNum, @RequestParam("status") String status,
			RedirectAttributes redirectAttributes) {
		try {
			adminService.updateReportStatus(reportNum, status);
			redirectAttributes.addFlashAttribute("msg", "신고 상태가 성공적으로 변경되었습니다.");
		} catch (Exception e) {
			e.printStackTrace();
			redirectAttributes.addFlashAttribute("msg", "신고 상태 변경 중 오류가 발생했습니다.");
		}
		return "redirect:/admin/reports/detail/" + reportNum; // 상세 페이지로 다시 이동
	}

	@PostMapping("/banUser")
	public String banUser(BanUser banUser, @RequestParam("reportNum") int reportNum,
	                      RedirectAttributes redirectAttributes) {
	    try {
	        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
	        String adminUserName = auth.getName();
	        banUser.setAdminUserName(adminUserName);

	        // 이미 정지 중인지 확인
	        char isBanned = securityDao.getIsBannedByUserNum(banUser.getUserNum());
	        
	        if (isBanned == 'Y') {
	            adminService.updateBanUser(banUser);
	        } else {
	            adminService.banUser(banUser);
	        }

	        Date now = new Date();
	        Date releaseDate = banUser.getReleaseDate();

	        // reports 테이블에 processed_at, user_inf_validity_period 업데이트
	        adminService.updateReportProcessedAndBanUser(reportNum, banUser);

	        adminService.updateReportStatus(reportNum, "완료");
	        redirectAttributes.addFlashAttribute("msg", "제재가 정상 처리되었습니다.");
	    } catch (Exception e) {
	        e.printStackTrace();
	        redirectAttributes.addFlashAttribute("msg", "제재 처리 중 오류가 발생했습니다.");
	    }
	    return "redirect:/admin/reports";
	}

	
//	@GetMapping("/inquiry")
}