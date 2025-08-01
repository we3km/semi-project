package com.kh.itda.user.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import com.kh.itda.user.model.service.UserService;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import com.kh.itda.user.model.vo.User;

import lombok.extern.slf4j.Slf4j;

//마이페이지 전용
@Controller
@Slf4j
public class UserController {

	@Autowired
	private UserService uService;

	@GetMapping("/user/myPage")
	public String myPage() {
		return "user/myPage";
	}
	
}
