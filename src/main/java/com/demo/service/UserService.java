package com.demo.service;

import com.demo.entity.User;

public interface UserService {

    int addUser(User user);

    User queryUserByUsername(String username);
}
