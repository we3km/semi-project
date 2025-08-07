package com.kh.itda.alarm.model.service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.kh.itda.alarm.model.dao.AlarmDao;
import com.kh.itda.alarm.model.vo.Alarm;
import com.kh.itda.security.model.vo.UserExt;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RequiredArgsConstructor
@Service
@Slf4j
public class AlarmServiceImpl implements AlarmService {

	private final SimpMessagingTemplate messagingTemplate;

	private final AlarmDao dao;

	@Override
	public void sendBoardCommentAlarm(int receiverId, int boardId, String boardTitle, String communityCd, String NickName) {
		
		String nicknameStyled = "<span style=\"color:#7f8cff; font-weight:bold;\">"
                + NickName
                + "</span>";
		
		String boardTitleStyled = "<span style=\"color:#90cbfb; font-weight:bold;\">"
                + boardTitle
                + "</span>";
		
		String content = nicknameStyled +" "+"님이"+" "+boardTitleStyled+ " 게시글에 댓글을 달았습니다.";
		String destination = "/topic/alarm/" + receiverId;

		// 알림 객체 생성 및 DB 저장
		Alarm alarm = new Alarm();
		alarm.setReceiverId(receiverId);
		alarm.setContent(content);
		alarm.setAlarmType("COMMENT");
		alarm.setRefId(boardId);
		alarm.setRefType(communityCd);
		alarm.setIsRead("N");
		

		int result = dao.insertAlarm(alarm); 

		log.info("🔔 알림 전송 대상: {}, 제목: {}", receiverId, boardTitle);
		log.info("전송 경로: {}", destination);

		
		Map<String, Object> alarmPayload = new HashMap<>();
		alarmPayload.put("alarmId", alarm.getAlarmId());
		alarmPayload.put("content", alarm.getContent());
		alarmPayload.put("createdAt", alarm.getCreatedAt());
		alarmPayload.put("refId",alarm.getRefId());

		// 웹소켓 전송 (1번만)
		messagingTemplate.convertAndSend(destination, alarmPayload);
	}
	public void sendChatAlarm(String chatContent, String nickNameStr, List<Integer> userNums, UserExt loginUser, int chatRoomId) {
		
		String nicknameStyled = "<span style=\"color:#7f8cff; font-weight:bold;\">"
                + nickNameStr
                + "</span>";
		
		
		String content = "<span style='color:#90cbfb;'>채팅</span><br>" + nicknameStyled + " : " + chatContent;

		for (Integer userId : userNums) {
			if (userId.equals(loginUser.getUserNum()))
				continue;

			String destination = "/topic/alarm/" + userId;

			Alarm alarm = new Alarm();
			alarm.setReceiverId(userId);
			alarm.setContent(content);
			alarm.setAlarmType("CHAT");
			alarm.setRefId(chatRoomId); 
			alarm.setIsRead("N");

			int result = dao.insertAlarm(alarm);

			Map<String, Object> alarmPayload = new HashMap<>();
			alarmPayload.put("alarmId", alarm.getAlarmId());
			alarmPayload.put("content", content);
			alarmPayload.put("createdAt", alarm.getCreatedAt());
			alarmPayload.put("chatRoomId", chatRoomId);

			try {
				String json = new ObjectMapper().writeValueAsString(alarmPayload);
				messagingTemplate.convertAndSend(destination, json);
			} catch (JsonProcessingException e) {
				log.error("❌ JSON 변환 오류", e);
			}
		}
	}


	@Override
	public List<Alarm> getUserAlarms(int userNum) {
		 return dao.selectAlarmsByUser(userNum);
	}

	@Override
	public int markAsRead(int alarmId) {
		return dao.markAlarmAsRead(alarmId);
	}
	@Override
	public int deleteAlarm(int alarmId) {
		return dao.deleteAlarm(alarmId);
	}
}