package com.kh.itda.chat.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.itda.openchat.model.service.OpenChatService;
import com.kh.itda.openchat.model.vo.OpenChatRoom;
import com.kh.itda.user.model.vo.User;

import lombok.extern.slf4j.Slf4j;


@Controller
@RequestMapping("/chat")
@Slf4j
@SessionAttributes({"chatRoomID"})
public class ChatController {
	
	@Autowired
	private OpenChatService openChatService;
	
	@GetMapping("/enter")
	public String joinChatRoom(@RequestParam("roomId") int roomId,
	                           HttpSession session,
	                           RedirectAttributes ra) {
	    User u = (User) session.getAttribute("loginUser");
	    if (u == null) {
	        ra.addFlashAttribute("alertMsg", "로그인이 필요합니다.");
	        return "redirect:/member/login";
	    }

	    openChatService.joinChatRoom(roomId, u.getUserNum());
	    return "redirect:/chat/chatRoomList"; // 📌 여기서는 roomId 넘기지 않음
	}
	
	@GetMapping("/chatRoomList")
	public String showChatRoomList(HttpSession session, Model model) {
	    User u = (User) session.getAttribute("loginUser");
	    if (u == null) return "redirect:/member/login";

	    List<OpenChatRoom> chatRoomList = openChatService.getUserChatRooms(u.getUserNum());
	    model.addAttribute("chatRoomList", chatRoomList);

	    return "chat/chatRoomList"; // 📄 chatRoomList.jsp
	}

}
