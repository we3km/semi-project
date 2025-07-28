package com.kh.itda.support.controller;

import java.util.List;

import javax.servlet.ServletContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.multipart.MultipartFile;

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

	@GetMapping
	public String csServiceMain(@AuthenticationPrincipal UserExt loginUser, Model model) {
		boolean isAdmin = loginUser.getAuthorities().stream()
				.anyMatch(auth -> auth.getAuthority().equals("ROLE_ADMIN"));

		if (isAdmin) {
			List<Inquiry> allInquiries = inquiryService.selectAllInquiries();
			model.addAttribute("list", allInquiries);
			model.addAttribute("isAdmin", true);
		} else {
			int userNum = loginUser.getUserNum();
			List<Inquiry> myInquiries = inquiryService.selectInquiriesByUserNum(userNum);
			model.addAttribute("list", myInquiries);
			model.addAttribute("isAdmin", false);
		}
	
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
	        @AuthenticationPrincipal UserExt loginUser,
	        Model model) {

	    Inquiry inquiry = inquiryService.selectInquiryById(csNum);

	    boolean isAdmin = loginUser.getAuthorities().stream()
	            .anyMatch(auth -> auth.getAuthority().equals("ROLE_ADMIN"));

	    int userNum = loginUser.getUserNum();

	    if (!isAdmin && inquiry.getUserNum() != userNum) {
	        model.addAttribute("errorMsg", "권한이 없습니다.");
	        return "error/forbidden";
	    }

	    model.addAttribute("inquiry", inquiry);
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