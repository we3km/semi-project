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
import com.kh.itda.openchat.model.vo.Location;
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
	    int chatRoomID = room.getChatRoomID();
	    int userNum = room.getUserNum();
	    log.debug(">> insertChatRoom 결과: {}, 채팅방 ID: {}", result, room.getChatRoomID());
	    
	    result *= dao.insertOpenChat(room);
	    log.debug(">> insertOpenChat 결과: {}", result);
	    if (result == 0) throw new RuntimeException("채팅방 등록 실패");
	    
	    
	    int p = dao.insertParticipant(chatRoomID, userNum);  // ← 이름 통일
	    log.debug(">> upsertParticipant result={}", p );
	    log.debug("upsertParticipant 결과 roomId={}, userNum={}",chatRoomID, userNum);
	    if (p < 1) throw new RuntimeException("개설자 자동참가 실패");   
	    
	 // 위치 저장 (중복 검사 포함)
	    String[] parts = (room.getAddress() != null) ? room.getAddress().split(" ") : new String[0];

	    String sido = parts.length > 0 ? parts[0] : null;
	    String sigungu = parts.length > 1 ? parts[1] : null;
	    String emd = parts.length > 2 ? parts[2] : null;

	    // 중복된 위치 있는지 검사
	    Long existingLocationId = dao.findLocationIdByRegion(sido, sigungu, emd);

	    Long locationId = null;

	    if (existingLocationId != null) {
	        locationId = existingLocationId;
	        log.debug(">> 기존 위치 존재: locationId={}", locationId);
	    } else {
	        Location location = new Location();
	        location.setLat(room.getLatitude());
	        location.setLng(room.getLongitude());
	        location.setSido(sido);
	        location.setSigungu(sigungu);
	        location.setEmd(emd);

	        int locResult = dao.insertLocation(location);
	        if (locResult == 0) throw new RuntimeException("위치 저장 실패");
	        locationId = location.getLocationId();

	        log.debug(">> 새 위치 등록 완료: locationId={}", locationId);
	    }

	    // LOCATION_LINK 연결
	    int linkResult = dao.insertLocationLink(locationId, chatRoomID);
	    if (linkResult == 0) throw new RuntimeException("위치 연결 실패");

	   
	 // 2. 이미지 저장
	    boolean hasImage = false;

	    // 2-0. 경로(파일_PATH) 1번만 등록/조회
	    String webPath = "/resources/images/chat/";   // ← ASSORTMENT=6 고정 경로
	    Map<String, Object> pathMap = new HashMap<>();
	    pathMap.put("path", webPath);
	    pathMap.put("pathId", null);
	    dao.insertFilePath(pathMap);                      // 이미 있으면 SELECT로 바꿔도 됨
	    int pathId = (int) pathMap.get("pathId");

	    if (openImages != null && !openImages.isEmpty()) {
	        for (MultipartFile openImage : openImages) {
	            if (openImage.isEmpty()) continue;
	            hasImage = true;

	            // 실제 저장 (파일명만 반환)
	            String fileName = Utils.saveOpenChatFile(openImage, servletContext);

	            openchatImg img = new openchatImg();
	            img.setFileName(fileName);
	            img.setFileAssortment(6);   // 채팅방 코드
	            img.setRefNo(chatRoomID);
	            img.setPathNum(pathId);

	            if (dao.insertFile(img) == 0) throw new RuntimeException("이미지 등록 실패");
	            log.debug(">> 파일 저장 완료: {}, pathId: {}", fileName, pathId);
	        }
	    }

	    // 2-1. 업로드가 없으면 기본 이미지
	    if (!hasImage) {
	        openchatImg img = new openchatImg();
	        img.setFileName("openchat_default.jpg");
	        img.setFileAssortment(6);
	        img.setRefNo(chatRoomID);
	        img.setPathNum(pathId);

	        if (dao.insertFile(img) == 0) throw new RuntimeException("기본 이미지 등록 실패");
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

