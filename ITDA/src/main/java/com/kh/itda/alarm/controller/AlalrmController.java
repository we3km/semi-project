package com.kh.itda.alarm.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.itda.alarm.model.service.AlarmService;
import com.kh.itda.alarm.model.vo.Alarm;
import com.kh.itda.security.model.vo.UserExt;

@Controller
public class AlalrmController {
	
	@Autowired
	private AlarmService service;

	@GetMapping("/alarm/list")
	@ResponseBody
	public List<Alarm> getAlarmList(Authentication auth) {
	    UserExt loginUser = (UserExt) auth.getPrincipal();
	    return service.getUserAlarms(loginUser.getUserNum());
	}
	@PostMapping("/alarm/read")
	@ResponseBody
	public ResponseEntity<?> markAsRead(@RequestParam int alarmId) {
	    int result = service.markAsRead(alarmId);
	    return result > 0 ? ResponseEntity.ok().build() : ResponseEntity.badRequest().build();
	}
	@PostMapping("/alarm/delete")
	@ResponseBody
	public ResponseEntity<?> deleteAlarm(@RequestParam int alarmId) {
	    int result = service.deleteAlarm(alarmId);
	    return result > 0 ? ResponseEntity.ok().build() : ResponseEntity.badRequest().build();
	}
	
}
