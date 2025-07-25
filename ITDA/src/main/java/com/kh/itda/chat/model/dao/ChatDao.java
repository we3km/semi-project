package com.kh.itda.chat.model.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.itda.chat.model.vo.ChatMessage;
import com.kh.itda.chat.model.vo.ChatRoom;
import com.kh.itda.chat.model.vo.ChatRoomJoin;
import com.kh.itda.chat.model.vo.SelectBoardInfo;
import com.kh.itda.chat.model.vo.TransactionChatRoom;

@Repository
public class ChatDao {

	@Autowired
	private SqlSessionTemplate session;

	public List<ChatRoom> selectChatRoomList(int userNum) {
		return session.selectList("chat.selectChatRoomList", userNum);
	}

	// 채팅방 OpenChatRoom, TransactionChatRoom, ChatParticipant 생성
	public int openChatRoom(Map<String, Object> map) {
		int result = session.insert("chat.openChatRoom", map);
		session.insert("chat.openTransactionChatRoom", map);
		session.insert("chat.openChatParticipant", map);
		
		return result;
	}

	public int openChatRoom(ChatRoom chatRoom) {
	    return session.insert("chat.openChatRoom", chatRoom);
	}
	public int openTransactionChatRoom(TransactionChatRoom transactionChatRoom) {
	    return session.insert("chat.openTransactionChatRoom", transactionChatRoom);
	}
	public int openChatParticipant(ChatRoomJoin chatRoomJoin) {
	    return session.insert("chat.openChatParticipant", chatRoomJoin);
	}
	
	
	
	public int joinCheck(ChatRoomJoin join) {
		return session.selectOne("chat.joinCheck", join);
	}

	public int joinChatRoom(ChatRoomJoin join) {
		return session.insert("chat.joinChatRoom", join);
	}

	public List<ChatMessage> selectChatMessage(int chatRoomId) {
		return session.selectList("chat.selectChatMessage", chatRoomId);
	}

	public int insertMessage(ChatMessage chatMessage) {
		return session.insert("chat.insertMessage", chatMessage);
	}

	public int exitChatRoom(int chatRoomId) {
		return session.update("chat.exitChatRoom", chatRoomId);
	}

	public int countChatRoomMember(ChatMessage chatMessage) {
		return session.selectOne("chat.countChatRoomMember", chatMessage);
	}

	public int closeChatRoom(ChatMessage chatMessage) {
		return session.update("chat.closeChatRoom", chatMessage);
	}

	public int insertManner(Map<String, Object> map) {
		return session.insert("chat.insertManner", map);
	}
	
	public String bringLastMessage(int chatRoomId) {
		return session.selectOne("chat.selectLastMessage", chatRoomId);
	}
	
	// 게시물 정보 객체 하나만 불러오기
	public SelectBoardInfo selectBoardInfo(int boardId) {
		return session.selectOne("chat.selectBoardInfo", boardId);
	}
}
