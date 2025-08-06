package com.kh.itda.support.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.kh.itda.admin.service.AdminService;
import com.kh.itda.security.model.vo.UserExt;
import com.kh.itda.support.model.service.InquiryService;
import com.kh.itda.support.model.vo.Inquiry;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/cs")
public class CustomerServiceController {

	@Autowired
	private InquiryService inquiryService;
	@Autowired
	private AdminService adminService;

	@GetMapping
	public String csServiceMain(Model model) {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		String userId = authentication.getName();

		com.kh.itda.user.model.vo.User user = adminService.findUserById(userId);
		model.addAttribute("loginUser", user);

		return "cs_service/CS_Service";
	}

	@GetMapping("/inquiry")
	public String inquiryPage() {
		return "cs_service/inquiry";
	}

	@PostMapping("/inquiry/insert")
	public String insertInquiry(@ModelAttribute Inquiry inquiry,
			@RequestParam(value = "file", required = false) MultipartFile file, Model model) {

		log.info("Inquiry: {}", inquiry);
		log.info("File: {}", file);

		if (inquiry.getCsTitle() == null || inquiry.getCsTitle().trim().isEmpty() || inquiry.getCsContent() == null
				|| inquiry.getCsContent().trim().isEmpty() || inquiry.getCategoryId() == 0) {
			model.addAttribute("errorMsg", "모든 항목을 올바르게 입력해주세요.");
			return "cs_service/inquiry";
		}

		int result = inquiryService.insertInquiry(inquiry);

		if (result > 0) {
			if (file != null && !file.isEmpty()) {
				inquiryService.saveFile(file, inquiry.getCsNum(), inquiry.getCategoryId());
			}
			return "redirect:/cs?success=문의가 등록되었습니다.";
		} else {
			model.addAttribute("errorMsg", "문의글 등록에 실패했습니다.");
			return "cs_service/inquiry";
		}
	}

	@GetMapping("/inquiry/detail/{csNum}")
	public String selectInquiryById(
	        @PathVariable int csNum,
	        Model model) {

	    Inquiry inquiry = inquiryService.selectInquiryById(csNum);

	    // 인증 정보 가져오기
	    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
	    String userId = authentication.getName();
	    com.kh.itda.user.model.vo.User loginUser = adminService.findUserById(userId);

	    int userNum = loginUser.getUserNum();

	    return "inquiry/detail";
	}

	@PostMapping("/inquiry/reply")
	public String updateInquiryReply(@ModelAttribute Inquiry inquiry) {
		inquiryService.updateInquiryReply(inquiry);
		return "redirect:/cs/inquiry/detail/" + inquiry.getCsNum();
	}

	@PostMapping("/inquiry/updateStatus")
	public String updateInquiryStatus(@ModelAttribute Inquiry inquiry) {
		inquiryService.updateInquiryStatus(inquiry);
		return "redirect:/cs/inquiry/detail/" + inquiry.getCsNum();
	}

}