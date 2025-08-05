package com.kh.itda.admin.controller;

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
		model.addAttribute("loginUser", user);

		return "adminPage/adminMyPage";
	}

	/**
	 * 신고 관리 페이지
	 */
	@GetMapping("/reports")
	public String reportList(
	        @RequestParam(value = "currentPage", defaultValue = "1") int currentPage,
	        Model model) {

	    // 전체 신고글 수
	    int listCount = adminService.getAllReports().size();

	    // 페이징 관련 변수 설정
	    int pageLimit = 10;       // 페이지 번호 갯수
	    int communityLimit = 10;  // 한 페이지에 보여줄 글 개수

	    // PageInfo 객체 생성 (페이징 정보)
	    PageInfo pi = com.kh.itda.common.model.vo.template.Pagination.getPagInfo(listCount, currentPage, pageLimit, communityLimit);

	    // 전체 신고글 리스트
	    List<Report> allReports = adminService.getAllReports();

	    // 현재 페이지에 맞는 리스트 서브셋 추출
	    int start = (currentPage - 1) * communityLimit;
	    int end = Math.min(start + communityLimit, listCount);

	    List<Report> pageReports = allReports.subList(start, end);

	    // 모델에 데이터 넣기
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
    public String updateReportStatus(@RequestParam("reportNum") int reportNum,
                                     @RequestParam("status") String status,
                                     RedirectAttributes redirectAttributes) {
        try {
            adminService.updateReportStatus(reportNum, status);
            redirectAttributes.addFlashAttribute("msg", "신고 상태가 성공적으로 변경되었습니다.");
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("msg", "신고 상태 변경 중 오류가 발생했습니다.");
        }
        return "redirect:/admin/reports/detail/" + reportNum;  // 상세 페이지로 다시 이동
    }
}