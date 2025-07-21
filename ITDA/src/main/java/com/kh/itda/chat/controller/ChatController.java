package com.kh.itda.chat.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.kh.itda.chat.model.service.ChatService;
import com.kh.itda.chat.model.vo.ChatRoom;

import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/chat")
@Slf4j
@SessionAttributes({ "chatRoomNo" }) // model 영역에 추가하는 key값이 chatRoomNo인 데이터를 HttpSession에 저장

public class ChatController {

	@Autowired
	private ChatService chatService;

	@GetMapping("/chatroomlist")
	public String selectChatRoomList(Model model) {

		List<ChatRoom> chatRoomList = chatService.selectChatRoomList();
		model.addAttribute("chatRoomList", chatRoomList);
		// jsp에선 chatRoomList로 쓰자

		return "chat/chatRoomList"; // /WEB-INF/views/chat/chatRoomList.jsp
	}
}