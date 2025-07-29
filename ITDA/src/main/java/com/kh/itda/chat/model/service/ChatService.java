package com.kh.itda.chat.model.service;

import java.util.List;
import java.util.Map;

import com.kh.itda.chat.model.vo.ChatMessage;
import com.kh.itda.chat.model.vo.ChatRoom;
import com.kh.itda.chat.model.vo.ChatRoomJoin;
import com.kh.itda.chat.model.vo.SelectBoardInfo;

public interface ChatService {

	List<ChatRoom> selectChatRoomList(int userNum);

	int openChatRoom(int userNum, int refNum, int boardId);

	List<ChatMessage> joinChatRoom(ChatRoomJoin join);

	int sendMessage(ChatMessage chatMessage);

	int exitChatRoom(int chatRoomId);

	List<ChatMessage> getMessagesByChatRoomId(int chatRoomId);

	int insertManner(Map<String, Object> map);
	
	String bringLastMessage(int chatRoomId);
	
	SelectBoardInfo selectBoardInfo(int boardId);
}
