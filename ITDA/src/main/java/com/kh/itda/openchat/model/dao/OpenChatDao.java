package com.kh.itda.openchat.model.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.itda.openchat.model.vo.OpenChatRoom;
import com.kh.itda.openchat.model.vo.OpenChatImg;

@Repository
public class OpenChatDao {

	@Autowired
	private SqlSessionTemplate session;

	// 1. 오픈채팅방 전체 목록 조회
	public List<OpenChatRoom> selectOpenChatRoomList() {
		return session.selectList("openchat.selectOpenChatRoomList");
	}

	// 2. 채팅방 공통 테이블 INSERT (CHAT_ROOM)
	public int insertChatRoom(OpenChatRoom room) {
		return session.insert("openchat.insertChatRoom", room);
	}

	// 3. 오픈채팅 상세 테이블 INSERT (OPEN_CHAT)
	public int insertOpenChat(OpenChatRoom room) {
		return session.insert("openchat.insertOpenChat", room);
	}


	// 5. 파일 정보 INSERT (FILE)
	public int insertFile(OpenChatImg img) {
		return session.insert("openchat.insertFile", img);
	}

	// 6. 태그 ID 조회 또는 없으면 INSERT 후 반환
	public int findOrInsertTag(String tagContent) {
		Integer tagId = session.selectOne("openchat.selectTagIdByContent", tagContent);

		if (tagId == null) {
			Map<String, Object> tagMap = new HashMap<>();
			tagMap.put("tagContent", tagContent);
			tagMap.put("tagId", null);

			session.insert("openchat.insertTag", tagMap);
			tagId = (int) tagMap.get("tagId");
		}

		return tagId;
	}

	// 7. OPENCHATROOM_TAG 테이블에 연결 삽입
	public int insertOpenChatRoomTag(int chatRoomID, int tagId) {
		Map<String, Integer> paramMap = new HashMap<>();
		paramMap.put("chatRoomID", chatRoomID);
		paramMap.put("tagId", tagId);
		return session.insert("openchat.insertOpenChatRoomTag", paramMap);
	}

	
	public int insertParticipant(int chatRoomID, int userNum) {
		Map<String, Integer> map = new HashMap<>();
		map.put("chatRoomID", chatRoomID);
		map.put("userNum", userNum);
		return session.insert("openchat.insertParticipant", map);
	}

	public int updateOpenChatCount(int chatRoomID) {
		
		return session.update("openchat.updateOpenChatCount",chatRoomID);
	}

	public OpenChatRoom selectChatRoombyId(int roomId) {
		return session.selectOne("openchat.selectChatRoombyId",roomId);
	}

	public List<OpenChatRoom> selectChatRoomsByUser(int userNum) {
		 return session.selectList("openchat.selectChatRoomsByUser", userNum);	
	}

	public int existsOpenChatRoomTag(Map<String, Object> param) {
		return session.selectOne("openchat.existsOpenChatRoomTag", param);
	}

	/*
	 * public int insertLocation(Location location) { return
	 * session.insert("openchat.insertLocation", location); }
	 * 
	 * public int insertLocationLink(Long locationId, int chatRoomID) { Map<String,
	 * Object> paramMap = new HashMap<>(); paramMap.put("locationId", locationId);
	 * paramMap.put("chatRoomId", chatRoomID); return
	 * session.insert("openchat.insertLocationLink", paramMap); }
	 * 
	 * public Long findLocationIdByRegion(String sido, String sigungu, String emd) {
	 * Map<String, String> paramMap = new HashMap<>(); paramMap.put("sido", sido);
	 * paramMap.put("sigungu", sigungu); paramMap.put("emd", emd); return
	 * session.selectOne("openchat.findLocationIdByRegion", paramMap); }
	 */
}