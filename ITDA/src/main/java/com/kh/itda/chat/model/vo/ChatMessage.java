package com.kh.itda.chat.model.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class ChatMessage {
	private int MessageId; // 메세지 번호
	private String chatContent = null; // 메세지 내용
	private String sentAt; // 채팅 보낸 시간
	private int chatRoomId; // 채팅방 고유 번호
	
	// 채팅방안에서 보여주자
	private int userNum; // 채팅친 회원 번호
	private String nickName; // 채팅친 회원의 닉네임
	private String imageUrl; // 채팅친 회원의 이미지 
	
	private String chatImg; // 채팅 내에서 주고 받을 이미지 파일 저장 URL
}