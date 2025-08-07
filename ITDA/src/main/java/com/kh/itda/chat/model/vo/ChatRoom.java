package com.kh.itda.chat.model.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class ChatRoom {
	private int chatRoomId; // 채팅방 고유 번호
	private int userNum; // 채팅하는 회원 번호
	
	// 거래채팅방용
	private int boardId; // 게시판 번호
	private String status = "Y"; // 채팅방의 상태
	private int refNum; // 거래 유형
	private String nickName; // 유저 닉네임(ex.나는야 현이)
	private String imageUrl; // 프로필 사진 경로
		
	// 오픈채팅방용
	private String openChatRoomName; // 오픈 채팅방 제목
	private int openChatCount; // 현재 참여하고 있는 인원수
	private String fileName; // 오픈 대표 프로필 사진 경로
		
	/*
	 * 1. 대여 2. 교환 3. 경매 4. 나눔 5. 오픈채팅
	 */
	public String getRefName() {
		switch (refNum) {
			case 1: return "대여";
			case 2: return "교환";
			case 3: return "경매";
			case 4: return "나눔";
			case 5: return "오픈채팅방"; 
			default: return "기타";
		}
	}
}