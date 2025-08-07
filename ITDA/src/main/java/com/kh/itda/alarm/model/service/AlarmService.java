package com.kh.itda.alarm.model.service;

import java.util.List;

import com.kh.itda.alarm.model.vo.Alarm;
import com.kh.itda.security.model.vo.UserExt;

public interface AlarmService {

	void sendBoardCommentAlarm(int userNum, int boardId, String boardTitle, String communityCd, String NickName);

	void sendChatAlarm(String chatContent, String nickNameStr, List<Integer> userNums, UserExt loginUser,
			int chatRoomId);

	List<Alarm> getUserAlarms(int userNum);

	int markAsRead(int alarmId);

	int deleteAlarm(int alarmId);

}
