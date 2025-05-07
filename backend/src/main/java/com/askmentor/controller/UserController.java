package com.askmentor.controller;

import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;
import com.askmentor.model.User;
import com.askmentor.service.UserServiceImpl;
import com.askmentor.dto.UserUpdateRequest;

@RestController
@RequestMapping("/api/users")
public class UserController {

	private final UserServiceImpl UserServiceImpl;

	public UserController(UserServiceImpl UserServiceImpl) {
		this.UserServiceImpl = UserServiceImpl;
	}

	@GetMapping("/{user_id}")
	public ResponseEntity<User> getUser(@PathVariable int user_id) {
		User user = UserServiceImpl.getUser(user_id);
		return ResponseEntity.ok(user);
	}

	@PatchMapping("/{user_id}")
	public ResponseEntity<String> updateUser(@PathVariable int user_id, @RequestBody UserUpdateRequest request) {
		String result = UserServiceImpl.updateUser(user_id, request);
		return ResponseEntity.ok(result);
	}
}