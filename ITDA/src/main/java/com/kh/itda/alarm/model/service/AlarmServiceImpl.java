package com.kh.itda.alarm.model.service;

import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RequiredArgsConstructor
@Service
@Slf4j
public class AlarmServiceImpl implements AlarmService {
	
    private final SimpMessagingTemplate messagingTemplate;

    @Override
    public void sendBoardCommentAlarm(int receiverId, int boardId, String boardTitle) {
		
		  String content = boardTitle + " 게시글에 댓글이 달렸습니다."; 
		  String destination = "/topic/alarm/" + receiverId; 
		  log.info("🔔 알림 전송 대상: {}, 제목: {}", receiverId, boardTitle);
		  log.info("전송 경로: {}", destination);
		  messagingTemplate.convertAndSend(destination,content);
    }
}