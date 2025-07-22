package com.kh.itda.openchat.model.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

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
	public int createOpenChat(OpenChatRoom room, List<MultipartFile> openImages, List<String> tags,
	                          ServletContext servletContext) {

	    log.debug(">> [START] createOpenChat");

	    // 입력 전처리 (XSS, 개행 처리)
	    room.setChatName(Utils.XSSHandling(room.getChatName()));
	    room.setDescription(Utils.XSSHandling(room.getDescription()));
	    room.setDescription(Utils.newLineHandling(room.getDescription()));

	    // 1. 채팅방 공통/상세 정보 등록
	    int result = dao.insertChatRoom(room);
	    log.debug(">> insertChatRoom 결과: {}, 채팅방 ID: {}", result, room.getChatRoomID());

	    result *= dao.insertOpenChat(room);
	    log.debug(">> insertOpenChat 결과: {}", result);
	    if (result == 0) throw new RuntimeException("채팅방 등록 실패");

	    int chatRoomID = room.getChatRoomID();

	    // 2. 이미지 저장
	    boolean uploadedImageExists = false;

	    if (openImages != null && !openImages.isEmpty()) {
	        for (MultipartFile openImage : openImages) {
	            if (openImage.isEmpty()) continue;
	            uploadedImageExists = true;

	            // 저장 경로 (웹경로)
	            String filePath = "/resources/images/chat/" + chatRoomID + "/";
	            // 실제 저장 및 반환된 파일명만 저장
	            String fileName = Utils.saveOpenChatFile(openImage, servletContext, String.valueOf(chatRoomID));

	            // 경로 등록
	            Map<String, Object> pathMap = new HashMap<>();
	            pathMap.put("path", filePath);  // 🔥 경로만 저장
	            pathMap.put("pathId", null);
	            dao.insertFilePath(pathMap);

	            // 이미지 정보 등록
	            openchatImg img = new openchatImg();
	            img.setFileName(fileName);  // 🔥 파일명만 저장
	            img.setFileAssortment(6);   // 오픈채팅용 코드
	            img.setRefNo(chatRoomID);
	            img.setPathNum((int) pathMap.get("pathId"));

	            int fileResult = dao.insertFile(img);
	            if (fileResult == 0) throw new RuntimeException("이미지 등록 실패");

	            log.debug(">> 파일 저장 완료: {}, pathId: {}", fileName, img.getPathNum());
	        }
	    }

	    // 2-1. 이미지가 하나도 없는 경우 → 기본 이미지 경로 등록
	    if (!uploadedImageExists) {
	        String filePath = "/resources/images/default/";
	        String fileName = "openchat_default.jpg";

	        Map<String, Object> pathMap = new HashMap<>();
	        pathMap.put("path", filePath);
	        pathMap.put("pathId", null);
	        dao.insertFilePath(pathMap);

	        openchatImg img = new openchatImg();
	        img.setFileName(fileName);
	        img.setFileAssortment(6);
	        img.setRefNo(chatRoomID);
	        img.setPathNum((int) pathMap.get("pathId"));

	        int fileResult = dao.insertFile(img);
	        if (fileResult == 0) throw new RuntimeException("기본 이미지 등록 실패");

	        log.debug(">> 기본 이미지 등록 완료");
	    }

	    // 3. 태그 저장
	    if (tags != null && !tags.isEmpty()) {
	        for (String tag : tags) {
	            int tagId = dao.findOrInsertTag(tag);
	            int tagLink = dao.insertOpenChatRoomTag(chatRoomID, tagId);
	            if (tagLink == 0) throw new RuntimeException("태그 연결 실패");

	            log.debug(">> 태그 연결 완료: chatRoomID={}, tagId={}", chatRoomID, tagId);
	        }
	    }

	    log.debug(">> [END] createOpenChat 성공");
	    return result;
	}

	}

