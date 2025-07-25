package com.kh.itda.chat.model.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.itda.chat.model.dao.ChatDao;
import com.kh.itda.chat.model.vo.ChatMessage;
import com.kh.itda.chat.model.vo.ChatRoom;
import com.kh.itda.chat.model.vo.ChatRoomJoin;
import com.kh.itda.chat.model.vo.SelectBoardInfo;

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
	public int openChatRoom(int userNum, int refNum, int boardId) {
		
		Map<String, Object> map = new HashMap<>();
		map.put("userNum", userNum);
		map.put("refNum", refNum);
		map.put("boardId", boardId);
		
		return dao.openChatRoom(map); // 여기서 chatRoomId가 room에 세팅됨

		/*
		 * // 채팅방 번호 할당 int chatRoomId = room.getChatRoomId();
		 * 
		 * // TransactionChatRoom 세팅 TransactionChatRoom trRoom = new
		 * TransactionChatRoom(); trRoom.setChatRoomId(chatRoomId);
		 * trRoom.setBoardId(room.getRefNum());
		 * 
		 * // ChatRoomJoin 세팅 ChatRoomJoin join = new ChatRoomJoin();
		 * join.setChatRoomId(chatRoomId); join.setUserNum(room.getUserNum());
		 * 
		 * // Dao 처리 dao.openTransactionChatRoom(trRoom); dao.openChatParticipant(join);
		 */
	}

	// 각 채팅방 아이디 별로 메세지 받아옴
	@Override
	public List<ChatMessage> getMessagesByChatRoomId(int chatRoomId) {
		// DAO에서 메시지 리스트 조회
		return dao.selectChatMessage(chatRoomId);
	}

	@Override
	public List<ChatMessage> joinChatRoom(ChatRoomJoin join) {
		// 현재 회원이 해당 채팅방에 참여하고 있는지 확인
		List<ChatMessage> list = null;

		int result = dao.joinCheck(join); // 참여하고 있다면 1, 없다면 0

		if (result == 0) {
			result = dao.joinChatRoom(join);
		}

		if (result > 0) {
			list = dao.selectChatMessage(join.getChatRoomId());
		}
		// 참여자 정보를 Chat_room_join에 Insert
		// Insert성공시, list를 반환, 실패시 null반환

		return list;
	}

	@Override
	public int insertMessage(ChatMessage chatMessage) {
		return dao.insertMessage(chatMessage);
	}

	@Transactional(rollbackFor = Exception.class)
	@Override
	public int exitChatRoom(int chatRoomId) {
		// 채팅방 나가기 처리
		return dao.exitChatRoom(chatRoomId);
	}

	@Override
	public int insertManner(Map<String, Object> map) {
		return dao.insertManner(map);
	}

	@Override
	public String bringLastMessage(int chatRoomId) {
		return dao.bringLastMessage(chatRoomId);
	}

	@Override
	public SelectBoardInfo selectBoardInfo(int boardId) {
		return dao.selectBoardInfo(boardId);
	}
}
