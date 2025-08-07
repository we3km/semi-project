package com.kh.itda.chat.model.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.itda.chat.model.vo.BidWinner;
import com.kh.itda.chat.model.vo.ChatMessage;
import com.kh.itda.chat.model.vo.ChatRoom;
import com.kh.itda.chat.model.vo.ChatRoomJoin;
import com.kh.itda.chat.model.vo.SelectBoardInfo;
import com.kh.itda.user.model.vo.User;

@Repository
public class ChatDao {

	@Autowired
	private SqlSessionTemplate session;

	public List<ChatRoom> selectChatRoomList(int userNum) {
		return session.selectList("chat.selectChatRoomList", userNum);
	}

	// 채팅방 OpenChatRoom, TransactionChatRoom, ChatParticipant 생성
	public int openChatRoom(Map<String, Object> map) {		
		// 톡 거는 사람(구매자) 기준으로 채팅방 만듬
		int result = session.insert("chat.openChatRoom", map);
		session.insert("chat.openTransactionChatRoom", map);
		session.insert("chat.openChatParticipantBuyer", map);
		
		// 게시물 주인도 CHAT_PARTICIPANT에 넣어주자
		session.insert("chat.openChatParticipantSeller", map);
		
		return result;
	}
	
	public int joinCheck(ChatRoomJoin join) {
		return session.selectOne("chat.joinCheck", join);
	}

	public int joinChatRoom(ChatRoomJoin join) {
		return session.insert("chat.joinChatRoom", join);
	}

	public List<ChatMessage> getMessagesByChatRoomId(int chatRoomId) {
		return session.selectList("chat.getMessagesByChatRoomId", chatRoomId);
	}
	
	public int insertMessage(ChatMessage chatMessage) {
		return session.insert("chat.insertMessage", chatMessage);
	}

	public int exitChatRoom(Map<String, Object> exit) {
		return session.update("chat.exitChatRoom", exit);
	}

	public int countChatRoomMember(ChatMessage chatMessage) {
		return session.selectOne("chat.countChatRoomMember", chatMessage);
	}

	public int closeChatRoom(ChatMessage chatMessage) {
		return session.update("chat.closeChatRoom", chatMessage);
	}

	public int insertManner(Map<String, Object> map) {
		session.update("chat.updateBoardCommon", map); // 게시물 상태 업데이트
		session.insert("chat.insertTransactionEnd", map); // 종료된 게시물 첨가 
		return session.insert("chat.insertManner", map); // 매너 업데이트
	}
	
	public ChatMessage bringLastMessage(int chatRoomId) {
		return session.selectOne("chat.selectLastMessage", chatRoomId);
	}
	
	public SelectBoardInfo selectBoardInfo(int boardId) {
		return session.selectOne("chat.selectBoardInfo", boardId);
	}

	public User getSenderInfo(int userNum) {
		return session.selectOne("chat.getSenderInfo", userNum);
	}

	public ChatRoom selectOpponentProfile(Map<String, Object> opps) {
		return session.selectOne("chat.selectOpponentProfile", opps);
	
	}

	public List<Integer> findParticipantsByChatRoomId(int chatRoomId) {
		return session.selectList("chat.findParticipantsByChatRoomId",chatRoomId);
	}
	public BidWinner getBiddingWinner(int boardId) {
		return session.selectOne("chat.getBiddingWinner", boardId);
	}
}
