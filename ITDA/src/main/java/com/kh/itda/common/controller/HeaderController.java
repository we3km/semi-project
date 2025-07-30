package com.kh.itda.common.controller;

import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import com.kh.itda.common.model.vo.boardCategory;
import com.kh.itda.common.service.HeaderService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@ControllerAdvice
@RequiredArgsConstructor
@Slf4j
public class HeaderController {
	
	private final HeaderService headerService;
	
	@ModelAttribute
    public void addCommonHeaderData(Model model, HttpSession session) {
		/*
		 * // 로그인 유저 정보 User loginUser = (User) session.getAttribute("loginUser");
		 * 
		 * if (loginUser != null) { Long userId = loginUser.getUserId();
		 * 
		 * // 유저 요약 정보 조회 model.addAttribute("userSummary",
		 * headerService.getUserSummary(userId));
		 * 
		 * // 채팅 알림 수, 알림 개수, 권한 등 
		 * int unreadMessages = headerService.getUnreadMessageCount(userId); 
		 * int unreadNotifications = headerService.getUnreadNotificationCount(userId); 
		 * String userRole = headerService.getUserRole(userId); // ex) USER, ADMIN
		 * 
		 * model.addAttribute("unreadMessages", unreadMessages);
		 * model.addAttribute("unreadNotifications", unreadNotifications);
		 * model.addAttribute("userRole", userRole); }
		 */
		
        // 드롭다운용 거래유형
        Map<Integer, boardCategory> TypeMap = headerService.getTypeMap();
	    model.addAttribute("CategoryType", TypeMap);
	    
	    log.debug("categoryType:{}",TypeMap);
    }

}
