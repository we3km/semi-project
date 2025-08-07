package com.kh.itda.alarm.model.vo;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class Alarm {
    private int alarmId;        // ALARM_ID (시퀀스로 자동 생성)
    private int receiverId;     // USER_TB.USER_NUM
    private String content;     // 알림 내용
    private String alarmType;   // 예: "COMMENT"
    private Integer refId;      // 예: 게시글 번호
    private String isRead;      // 'N' (기본값)
    private Timestamp createdAt; // 생성일시
}