package com.kh.itda.chat.model.service;

import java.util.List;
import java.util.Map;

import com.kh.itda.chat.model.vo.BidWinner;
import com.kh.itda.chat.model.vo.ChatMessage;
import com.kh.itda.chat.model.vo.ChatRoom;
import com.kh.itda.chat.model.vo.ChatRoomJoin;
import com.kh.itda.chat.model.vo.SelectBoardInfo;
import com.kh.itda.user.model.vo.User;

public interface ChatService {

	List<ChatRoom> selectChatRoomList(int userNum);

	int openChatRoom(int userNum, int boardOwnerNum, int refNum, int boardId);

	List<ChatMessage> joinChatRoom(ChatRoomJoin join);

	int sendMessage(ChatMessage chatMessage);

	int exitChatRoom(Map<String, Object> exit);

	List<ChatMessage> getMessagesByChatRoomId(int chatRoomId);

	int insertManner(Map<String, Object> map);

	ChatMessage bringLastMessage(int chatRoomId);

	SelectBoardInfo selectBoardInfo(int boardId);

	User getSenderInfo(int userNum);
	
	ChatRoom selectOpponentProfile( Map<String, Object> opps);


	List<Integer> findParticipantsByChatRoomId(int chatRoomId);

	BidWinner getBiddingWinner(int boardId);

}
