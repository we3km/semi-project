package com.kh.itda.alarm.model.service;

import java.util.List;

import com.kh.itda.security.model.vo.UserExt;

public interface AlarmService {

	void sendBoardCommentAlarm(int userNum, int boardId, String boardTitle);

	void sendChatAlarm(String chatContent, String nickNameStr, List<Integer> userNums, UserExt loginUser);

}
