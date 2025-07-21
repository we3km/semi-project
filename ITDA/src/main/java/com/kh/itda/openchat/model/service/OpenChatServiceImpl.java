package com.kh.itda.openchat.model.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.itda.common.Utils;
import com.kh.itda.openchat.model.dao.OpenChatDao;
import com.kh.itda.openchat.model.vo.OpenChatRoom;
import com.kh.itda.openchat.model.vo.openchatImg;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class OpenChatServiceImpl implements OpenChatService {
	
	@Autowired
	private OpenChatDao dao;
	
	@Override
	public List<OpenChatRoom> selectOpenChatRoomList() {
		
		return dao.selectOpenChatRoomList();
	}

	@Override
	@Transactional(rollbackFor = Exception.class)
	public int createOpenChat(OpenChatRoom room, List<openchatImg> imgList, List<String> tags) {

	    log.debug(">> [START] createOpenChat");
	    log.debug(">> 입력받은 room: {}", room);
	    log.debug(">> 입력받은 이미지 리스트 수: {}", (imgList != null ? imgList.size() : 0));
	    log.debug(">> 입력받은 태그 목록: {}", tags);

	    // 0. 유효성 및 전처리
	    room.setChatName(Utils.XSSHandling(room.getChatName()));
	    room.setDescription(Utils.XSSHandling(room.getDescription()));
	    room.setDescription(Utils.newLineHandling(room.getDescription()));

	    log.debug(">> 전처리 완료 후 room: {}", room);

	    // 1. 채팅방 공통/상세 정보 등록
	    int result = dao.insertChatRoom(room);   // CHAT_ROOM
	    log.debug(">> insertChatRoom 결과: {}, 채팅방 ID: {}", result, room.getChatRoomID());

	    result *= dao.insertOpenChat(room);      // OPEN_CHAT
	    log.debug(">> insertOpenChat 결과: {}", result);

	    if (result == 0) {
	        throw new RuntimeException("채팅방 등록 실패");
	    }

	    // 2. 이미지 등록
	    if (imgList != null && !imgList.isEmpty()) {
	        for (openchatImg img : imgList) {
	            img.setRefNo(room.getChatRoomID()); // 채팅방 참조

	            // 🔧 경로 정보 Map으로 넘기기
	            Map<String, Object> pathMap = new HashMap<>();
	            pathMap.put("path", "/resources/images/openchatimg/");
	            pathMap.put("pathId", null);

	            dao.insertFilePath(pathMap); // insert 후 pathId selectKey 주입됨
	            int pathId = (int) pathMap.get("pathId");
	            img.setPathNum(pathId);

	            int fileResult = dao.insertFile(img);
	            log.debug(">> 이미지 등록 결과: {}", fileResult);
	            log.debug(">> 파일명: {}", img.getFileName());
	            log.debug(">> pathId: {}, fileId: {}", pathId, img.getFileId());

	            if (fileResult == 0) {
	                throw new RuntimeException("이미지 등록 실패");
	            }
	        }
	    }

	    // 3. 태그 등록
	    if (tags != null && !tags.isEmpty()) {
	        for (String tag : tags) {
	            tag = tag.trim();
	            if (tag.isEmpty()) continue;

	            int tagId = dao.findOrInsertTag(tag); // 존재하면 반환, 없으면 삽입 후 반환
	            log.debug(">> 태그 처리: {}, 태그 ID: {}", tag, tagId);

	            int tagLink = dao.insertOpenChatRoomTag(room.getChatRoomID(), tagId);
	            log.debug(">> 태그 연결 결과: {}", tagLink);
	            log.debug(">> 연결된 chatRoomID: {}, tagId: {}", room.getChatRoomID(), tagId);

	            if (tagLink == 0) {
	                throw new RuntimeException("태그 연결 실패");
	            }
	        }
	    }

	    log.debug(">> [END] createOpenChat - 성공적으로 완료됨");
	    return result;
	}

	
}