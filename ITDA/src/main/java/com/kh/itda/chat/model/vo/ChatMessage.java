package com.kh.itda.chat.model.vo;
import lombok.Data;
import lombok.NoArgsConstructor;
@NoArgsConstructor
@Data
public class ChatMessage {
	private int cmNo; // 메세지 번호
	private String message; // 메세지 내용
	private String createDate; // 메세지 작성 시간
	private int chatRoomNo; // 채팅방 고유 번호
	private int userNo; // 채팅친 회원 번호

	private String chattingImg; // 채팅 내에서 주고 받을 이미지 파일 저장
	
	// 클라이언트의 메세지 유형을 관리할 속성
	public enum MessageType{
		ENTER, EXIT, TALK
	}
	private MessageType type;
	
	private String userName;
}