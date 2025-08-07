package com.kh.itda.alarm.model.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AlarmMessage {
	private int receiverId;
	private String boardTitle;
	private int boardId;
	private int userNum;
}
