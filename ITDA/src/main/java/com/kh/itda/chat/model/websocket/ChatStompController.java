package com.kh.itda.chat.model.websocket;

import java.util.HashMap;

import javax.servlet.http.HttpSession;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import com.kh.itda.chat.model.service.ChatService;
import com.kh.itda.chat.model.vo.ChatMessage;
import com.kh.itda.user.model.vo.User;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequiredArgsConstructor
public class ChatStompController {
	private final SimpMessagingTemplate messagingTemplate;
	private final ChatService service;

	@MessageMapping("/chat/sendMessage")
	public void sendMessage(@Payload HashMap<String, Object> messageMap) {
		// 태형이 로그인 부문 필요
//		User loginUser = (User) session.getAttribute("loginUser");
//		if (loginUser == null) {
//			log.info("로그인 유저 없음");
//		}

		String chatContent = (String) messageMap.get("chatContent");
		String chatRoomIdStr = (String) messageMap.get("chatRoomId");
		int chatRoomId = Integer.parseInt(chatRoomIdStr);

		// 채팅방 번호, 채팅 내용, 로그인한 회원 번호 할당
		ChatMessage chatMessage = new ChatMessage();

		chatMessage.setChatRoomId(chatRoomId);
		chatMessage.setChatContent(chatContent);

		// chatMessage.setUserNum(loginUser.getUserNum());
		chatMessage.setUserNum(6);

		log.info("채팅방 정보 : {}", chatMessage);

		int result = service.sendMessage(chatMessage);

		if (result > 0) {
			log.info("채팅 정보 : {}", result);
			messagingTemplate.convertAndSend("/topic/room/" + chatRoomId, chatMessage);
		} else {
			log.info("채팅 보내기 실패");
			throw new RuntimeException("채팅 저장 실패");
		}
	}
}