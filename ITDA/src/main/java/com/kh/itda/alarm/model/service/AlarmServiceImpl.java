package com.kh.itda.alarm.model.service;

import java.util.List;

import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import com.kh.itda.security.model.vo.UserExt;

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
		messagingTemplate.convertAndSend(destination, content);
	}

	@Override
	public void sendChatAlarm(String chatContent, String nickNameStr, List<Integer> userNums, UserExt loginUser) {
		String content ="<span style='color:#7f8cff;'>채팅</span><br>"+nickNameStr + " : " + chatContent;

		for (Integer userId : userNums) {
			if (userId.equals(loginUser.getUserNum()))
				continue; // 자기 자신 제외

			String destination = "/topic/alarm/" + userId;
			log.info("🔔 알림 전송 대상: {}, 내용: {}", userId, content);
			log.info("전송 경로: {}", destination);

			messagingTemplate.convertAndSend(destination, content);
		}
	}
}