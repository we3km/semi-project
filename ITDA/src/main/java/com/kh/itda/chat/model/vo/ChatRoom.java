package com.kh.itda.chat.model.vo;
import lombok.Data;
import lombok.NoArgsConstructor;
@NoArgsConstructor
@Data
public class ChatRoom {
	private int chatRoomNo; // 채팅방 고유 번호
	// private String title = null; // 채팅방의 제목 -> 오픈 채팅방에만 해당
	private String status = "Y"; // 채팅방의 상태
	private int userNo; // 채팅하는 회원 번호
	
	private String userName; // 유저 닉네임 (ex.나는야 현이) 
	private String profileImg; // 채팅 내에서 주고 받을 이미지 파일 저장  
	
	// private int cnt = 0; // 참여자 수, 0으로 초기화
	// private static int maxChatRoomCount = 30; // 채팅방 참여할 인원 수 제한=30
}
