package com.kh.itda.chat.model.websocket;

import java.util.HashMap;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;

import com.kh.itda.chat.model.service.ChatService;
import com.kh.itda.chat.model.vo.ChatMessage;
import com.kh.itda.security.model.vo.UserExt;
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
	public void sendMessage(@Payload HashMap<String, Object> messageMap, Authentication authentication) {

		String chatContent = (String) messageMap.get("chatContent");
		String chatRoomIdStr = (String) messageMap.get("chatRoomId");
		String nickNameStr = (String) messageMap.get("nickName");
		String imageUrlStr = (String) messageMap.get("imageUrl");
		
		int chatRoomId = Integer.parseInt(chatRoomIdStr);

		// 채팅방 번호, 채팅 내용, 로그인한 회원 번호 할당
		ChatMessage chatMessage = new ChatMessage();

		chatMessage.setChatRoomId(chatRoomId);
		chatMessage.setChatContent(chatContent);
		chatMessage.setNickName(nickNameStr);
		chatMessage.setImageUrl(imageUrlStr);

		UserExt loginUser = (UserExt) authentication.getPrincipal();
		chatMessage.setUserNum(loginUser.getUserNum());
		
		log.info("보내는 채팅메세지 속성 : {}", chatMessage);

		// DB에 메세지 저장
		int result = service.sendMessage(chatMessage);
		
		if (result > 0) {
			messagingTemplate.convertAndSend("/topic/room/" + chatRoomId, chatMessage);
		} else {
			log.info("채팅 보내기 실패");
			throw new RuntimeException("채팅 저장 실패");
		}
	}
}