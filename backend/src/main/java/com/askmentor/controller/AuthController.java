package com.askmentor.controller;

import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api")
public class AuthController {
    
    @PostMapping("/login")
    public String login(@RequestBody LoginRequest loginRequest) {
        // 로그인 로직 구현
        return "로그인 성공";
    }
    
    public static class LoginRequest {
        private int user_id;
        private String password;
        
        public int getUser_id() {
            return user_id;
        }

        public void setUser_id(int user_id) {
            this.user_id = user_id;
        }

        public String getPassword() {
            return password;
        }

        public void setPassword(String password) {
            this.password = password;
        }
    }
}