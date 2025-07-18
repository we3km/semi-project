package com.kh.itda.openchat.controller;

import java.util.List;
import java.util.stream.Collectors;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.itda.openchat.model.service.FileService;
import com.kh.itda.openchat.model.service.OpenChatService;
import com.kh.itda.openchat.model.vo.OpenChatRoom;
import com.kh.itda.user.model.vo.User;

import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/openchat")
@Slf4j
@SessionAttributes({"chatRoomID"})
public class OpenChatController {
	
	@Autowired
	private OpenChatService openChatService;
	
	@Autowired
	private FileService fileService;
	
	@GetMapping("/openChatList")
	public String selectOpenChatList(@RequestParam(defaultValue = "1") int page, Model model) {
	    int pageSize = 8;
	    int offset = (page - 1) * pageSize;

	    List<OpenChatRoom> allList = openChatService.selectOpenChatRoomList();
	    int total = allList.size();

	    List<OpenChatRoom> pagedList = allList.stream()
	        .skip(offset)
	        .limit(pageSize)
	        .collect(Collectors.toList());

	    int totalPage = (int) Math.ceil((double) total / pageSize);

	    model.addAttribute("openlist", pagedList);
	    model.addAttribute("currentPage", page);
	    model.addAttribute("totalPage", totalPage);

	    return "openchat/openChatList";
	}
	
	@PostMapping("/createOpenChat")
	public String createChatList(
			@ModelAttribute OpenChatRoom room,
			RedirectAttributes ra,
			HttpSession session
			) {
		User u = (User) session.getAttribute("loginUser");
		room.setUserNum(u.getUserNum());
		
		int result = openChatService.createOpenChat(room);
		
		if(result == 0) {
			throw new RuntimeException("채팅방 등록 실패");
		}
		
		
		ra.addFlashAttribute("alertMsg","채팅방 생성 성공");
		return "redirect:/openchat/openChatList";
	}
	

}
