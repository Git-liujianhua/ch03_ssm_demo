package com.demo.dao;

import com.demo.entity.User;

public interface UserDao {

    int insertUser(User user);

    User selectUserByUsername(String username);

}
