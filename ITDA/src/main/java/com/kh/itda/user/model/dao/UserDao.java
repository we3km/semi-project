package com.kh.itda.user.model.dao;

import org.springframework.stereotype.Repository;

import com.kh.itda.user.model.vo.User;

@Repository
public interface UserDao {
    User login(String userId, String userPwd);
}
