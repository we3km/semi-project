package com.kh.itda.support.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.itda.admin.service.AdminService;
import com.kh.itda.common.model.vo.File;
import com.kh.itda.common.model.vo.FilePath;
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

		com.kh.itda.user.model.vo.User loginUser = adminService.findUserById(userId);
		model.addAttribute("loginUser", loginUser);

		boolean isAdmin = authentication.getAuthorities().stream()
				.anyMatch(auth -> auth.getAuthority().equals("ROLE_ADMIN"));

		if (isAdmin) {
			// 관리자: 전체 문의글 조회
			model.addAttribute("list", inquiryService.selectAllInquiries());
		} else {
			// 일반 사용자: 본인의 문의글만 조회
			model.addAttribute("list", inquiryService.selectInquiriesByUser(loginUser.getUserNum()));
		}

		return "cs_service/CS_Service";
	}

	@GetMapping("/inquiry")
	public String inquiryForm(Model model) {
		if (!model.containsAttribute("inquiryForm")) {
			model.addAttribute("inquiryForm", new Inquiry());
		}

		return "cs_service/inquiry";
	}

	@PostMapping("/inquiry/insert")
	public String insertInquiry(@ModelAttribute Inquiry inquiry,
			@RequestParam(value = "file", required = false) MultipartFile file, RedirectAttributes redirectAttributes,
			Model model) {

		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		String userId = authentication.getName();
		com.kh.itda.user.model.vo.User loginUser = adminService.findUserById(userId);

		inquiry.setUserNum(loginUser.getUserNum());

		// 필수 입력값 체크
		if (inquiry.getCsTitle() == null || inquiry.getCategoryName() == null || inquiry.getCsContent() == null) {
			model.addAttribute("errorMsg", "모든 항목을 올바르게 입력해주세요.");
			return "cs_service/inquiry";
		}

		// categoryId 설정
		int fileCategoryId = 5; // 기타 기본
		switch (inquiry.getCategoryName()) {
		case "회원정보":
			fileCategoryId = 1;
			break;
		case "거래관련":
			fileCategoryId = 2;
			break;
		case "신고처리":
			fileCategoryId = 3;
			break;
		case "건의사항":
			fileCategoryId = 4;
			break;
		case "기타":
			fileCategoryId = 5;
			break;
		}

		inquiry.setCategoryId("cs");

		// insert
		int result = inquiryService.insertInquiry(inquiry);

		if (result > 0) {
			if (file != null && !file.isEmpty()) {
				inquiryService.saveFile(file, inquiry.getCsNum(), fileCategoryId);
			}

			redirectAttributes.addFlashAttribute("successMsg", "문의가 등록되었습니다.");
			return "redirect:/cs";
		} else {
			model.addAttribute("errorMsg", "문의글 등록에 실패했습니다.");
			return "cs_service/inquiry";
		}
	}

	@GetMapping("/inquiry/detail/{csNum}")
	public String selectInquiryById(@PathVariable int csNum, Model model) {
		Inquiry inquiry = inquiryService.selectInquiryById(csNum);
		model.addAttribute("inquiry", inquiry);

		// 첨부파일 리스트 가져오기
		List<File> files = inquiry.getFileList();

		// 파일과 경로를 Map에 묶어서 리스트로 저장
		List<Map<String, Object>> fileWithPathList = new ArrayList<>();
		for (File file : files) {
			Map<String, Object> map = new HashMap<>();
			map.put("file", file);

			// CATEGORY_ID 기반으로 경로 조회
			String categoryPath = inquiryService.selectCategoryPathByCategoryId(file.getCategoryId());
			map.put("filePath", categoryPath);

			fileWithPathList.add(map);
		}
		model.addAttribute("fileWithPathList", fileWithPathList);

		// 로그인 유저 정보 추가
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		String userId = authentication.getName();
		com.kh.itda.user.model.vo.User loginUser = adminService.findUserById(userId);
		model.addAttribute("loginUser", loginUser);

		return "cs_service/inquiryDetail";
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
	
	@PostMapping("/inquiry/replyAndComplete")
	public String replyAndComplete(@ModelAttribute Inquiry inquiry, RedirectAttributes redirectAttributes) {
	    int result = inquiryService.updateInquiryReply(inquiry);

	    if (result > 0) {
	        inquiry.setStatus("처리완료");
	        inquiryService.updateInquiryStatus(inquiry);
	        redirectAttributes.addFlashAttribute("successMsg", "답변이 성공적으로 등록되었습니다.");
	    } else {
	        redirectAttributes.addFlashAttribute("errorMsg", "답변 등록에 실패했습니다.");
	    }
	    return "redirect:/cs/inquiry/detail/" + inquiry.getCsNum();
	}

}
