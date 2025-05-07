package com.askmentor.service;

import com.askmentor.model.User;
import com.askmentor.controller.UserController.UserUpdateRequest;
import com.askmentor.repository.UserRepository;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import org.springframework.stereotype.Service;

@Service
public class UserServiceImpl implements UserService {
    
    private final UserRepository userRepository;
    
    public UserServiceImpl(UserRepository userRepository) {
        this.userRepository = userRepository;
    }
    
    @Override
    public User getUser(int user_id) {
        return userRepository.findById(user_id).orElseThrow();
    }
    
    @Override
    public String updateUser(int user_id, UserUpdateRequest request) {
        User user = userRepository.findById(user_id).orElseThrow();
        user.setName(request.getName());
        user.setPassword(request.getPassword());
        user.setDepartmentId(request.getDepartment_id());
        
        // String을 LocalDate로 변환
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy");
        LocalDate joinDate = LocalDate.parse(request.getJoin_year(), formatter);
        user.setJoinYear(joinDate);
        
        userRepository.save(user);
        return "사용자 정보 수정 성공";
    }
}