package com.askmentor.controller;

import org.springframework.web.bind.annotation.*;

import com.askmentor.dto.LoginRequest;
import com.askmentor.model.User;
import com.askmentor.service.UserService;

@RestController
@RequestMapping("/api")
public class AuthController {

	private final UserService userService ;

	public AuthController(UserService userService) {
		this.userService = userService;
	}

	@PostMapping("/login")
	public String login(@RequestBody LoginRequest loginRequest) {
		System.out.println("\u001B[32m로그인 요청 들어옴\u001B[0m");
		User user = userService.getUser(loginRequest.getUser_id());
		System.out.println("\u001B[32m사용자 찾기\u001B[0m");

		if (user == null) {
			return "사용자를 찾을 수 없습니다.";
		}
		if (!user.getPassword().equals(loginRequest.getPassword())) {
			return "비밀번호가 일치하지 않습니다.";
		}
		return "로그인 성공";
	}
}