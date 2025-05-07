package com.askmentor.service;

import com.askmentor.model.User;
import com.askmentor.controller.UserController.UserUpdateRequest;

public interface UserService {
    User getUser(int user_id);
    String updateUser(int user_id, UserUpdateRequest request);
}