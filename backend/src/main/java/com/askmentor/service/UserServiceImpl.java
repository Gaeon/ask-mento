package com.askmentor.service;

import com.askmentor.model.User;
import com.askmentor.dto.UserUpdateRequest;
import com.askmentor.repository.UserRepository;


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
        user.setPassword(request.getPassword());
        userRepository.save(user);
        return "사용자 비밀번호 수정 성공";
    }
}