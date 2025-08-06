package com.kh.itda.user.controller;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import com.kh.itda.user.model.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
//마이페이지 전용
@Controller
@RequiredArgsConstructor
@Slf4j
public class UserController {
	
	@GetMapping("/user/myPage")
	public String myPage() {
		return "user/myPage";
	}
}