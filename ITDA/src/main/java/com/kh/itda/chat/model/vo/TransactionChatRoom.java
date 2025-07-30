package com.kh.itda.chat.model.vo;
import lombok.Data;
import lombok.NoArgsConstructor;
@NoArgsConstructor

@Data
public class TransactionChatRoom {
	private int boardId; // 참조할 게시판 번호 
	private int chatRoomId; // 참여할 채팅방 번호
//	private String profileImg; // 참여하는 회원의 프로필 사진
}