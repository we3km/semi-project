package com.kh.itda.chat.model.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.itda.chat.model.dao.ChatDao;
import com.kh.itda.chat.model.vo.BidWinner;
import com.kh.itda.chat.model.vo.ChatMessage;
import com.kh.itda.chat.model.vo.ChatRoom;
import com.kh.itda.chat.model.vo.ChatRoomJoin;
import com.kh.itda.chat.model.vo.SelectBoardInfo;
import com.kh.itda.user.model.vo.User;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class ChatServiceImpl implements ChatService {

	@Autowired
	private ChatDao dao;

	@Override
	public List<ChatRoom> selectChatRoomList(int userNum) {
		return dao.selectChatRoomList(userNum);
	}

	@Transactional
	@Override
	public int openChatRoom(int userNum, int boardOwnerNum, int refNum, int boardId) {
		
		Map<String, Object> map = new HashMap<>();
		map.put("userNum", userNum); // 현재 로그인한 회원정보
		map.put("boardOwnerNum", boardOwnerNum); // 게시물 주인
		map.put("refNum", refNum);
		map.put("boardId", boardId);
		
		return dao.openChatRoom(map); // 여기서 chatRoomId가 room에 세팅됨
	}

	// 각 채팅방 아이디 별로 메세지 받아옴
	@Override
	public List<ChatMessage> getMessagesByChatRoomId(int chatRoomId) {
		// DAO에서 메시지 리스트 조회
		return dao.getMessagesByChatRoomId(chatRoomId);
	}

	@Override
	public int sendMessage(ChatMessage chatMessage) {
		return dao.insertMessage(chatMessage);
	}

	@Transactional(rollbackFor = Exception.class)
	@Override
	public int exitChatRoom(Map<String, Object> exit) {
		return dao.exitChatRoom(exit);
	}

	@Override
	public int insertManner(Map<String, Object> map) {
		return dao.insertManner(map);
	}

	@Override
	public ChatMessage bringLastMessage(int chatRoomId) {
		return dao.bringLastMessage(chatRoomId);
	}

	@Override
	public SelectBoardInfo selectBoardInfo(int boardId) {
		return dao.selectBoardInfo(boardId);
	}

	@Override
	public User getSenderInfo(int userNum) {
		return dao.getSenderInfo(userNum);
	}

	@Override
	public ChatRoom selectOpponentProfile(Map<String, Object> opps) {
		return dao.selectOpponentProfile(opps);
	}

	@Override

	public List<Integer> findParticipantsByChatRoomId(int chatRoomId) {
		return dao.findParticipantsByChatRoomId(chatRoomId);
	}
	public BidWinner getBiddingWinner(int boardId) {
		return dao.getBiddingWinner(boardId);

	}

	@Override
	public int joinCheck(int userNum, int boardOwnerNum, int boardId) {
		Map<String, Object> map = new HashMap<>();
		map.put("userNum", userNum); // 현재 로그인한 회원정보
		map.put("boardOwnerNum", boardOwnerNum); // 게시물 주인
		map.put("boardId", boardId);
		
		return dao.joinCheck(map);
	}
}
