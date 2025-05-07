package com.askmentor.controller;

import org.springframework.web.bind.annotation.*;

import com.askmentor.dto.LoginRequest;
import com.askmentor.model.User;
import com.askmentor.service.UserServiceImpl;

@RestController
@RequestMapping("/api")
public class AuthController {

	private final UserServiceImpl UserServiceImpl;

	public AuthController(UserServiceImpl UserServiceImpl) {
		this.UserServiceImpl = UserServiceImpl;
	}

	@PostMapping("/login")
	public String login(@RequestBody LoginRequest loginRequest) {
		User user = UserServiceImpl.getUser(loginRequest.getUser_id());
		if (user == null) {
			return "사용자를 찾을 수 없습니다.";
		}
		if (!user.getPassword().equals(loginRequest.getPassword())) {
			return "비밀번호가 일치하지 않습니다.";
		}
		return "로그인 성공";
	}
}