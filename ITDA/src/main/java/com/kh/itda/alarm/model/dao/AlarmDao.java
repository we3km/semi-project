package com.kh.itda.alarm.model.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.kh.itda.alarm.model.vo.Alarm;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class AlarmDao {

	private final SqlSession session;

	public int insertAlarm(Alarm alarm) {
		return session.insert("alarm.insertAlarm", alarm);
	}

	public List<Alarm> selectAlarmsByUser(int userNum) {
		return session.selectList("alarm.selectAlarmsByUser", userNum);
	}

	public int markAlarmAsRead(int alarmId) {
		return session.update("alarm.markAlarmAsRead", alarmId);
	}

	public int deleteAlarm(int alarmId) {
		return session.delete("alarm.deleteAlarm", alarmId);
	}

}
