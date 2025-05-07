package com.askmentor.controller;

import org.springframework.web.bind.annotation.*;
import com.askmentor.model.User;

@RestController
@RequestMapping("/api/users")
public class UserController {
    
    @GetMapping("/{user_id}")
    public User getUser(@PathVariable int user_id) {
        // 사용자 정보 조회 로직 구현
        return new User();
    }
    
    @PatchMapping("/{user_id}")
    public String updateUser(@PathVariable int user_id, @RequestBody UserUpdateRequest request) {
        // 사용자 정보 수정 로직 구현
        return "사용자 정보 수정 성공";
    }
    
    public static class UserUpdateRequest {
        private String name;
        private String password;
        private int department_id;
        private String join_year;
        
        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getPassword() {
            return password;
        }

        public void setPassword(String password) {
            this.password = password;
        }

        public int getDepartment_id() {
            return department_id;
        }

        public void setDepartment_id(int department_id) {
            this.department_id = department_id;
        }

        public String getJoin_year() {
            return join_year;
        }

        public void setJoin_year(String join_year) {
            this.join_year = join_year;
        }
    }
}